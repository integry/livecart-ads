<?php

ClassLoader::import("application.controller.backend.abstract.ActiveGridController");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("module.ads.application.model.AdAdvertiser");
ClassLoader::import("module.ads.application.model.AdCampaignCondition");
ClassLoader::import("application.model.category.Category");
ClassLoader::import("application.model.product.Product");
ClassLoader::import("application.model.product.Manufacturer");

/**
 *
 * @package module.ads.application.controller.backend
 * @author Integry Systems
 */
class AdCampaignController extends ActiveGridController
{
	public function init()
	{
		$this->loadLanguageFile('backend/Discount');
		parent::init();
	}

	public function index()
	{
		return $this->getGridResponse();
	}

	public function add()
	{
		$advertiser = ActiveRecordModel::getInstanceByID('AdAdvertiser', $this->request->get('id'), true);
		$campaign = AdCampaign::getNewInstance($advertiser);
		$campaign->name->set($this->translate('_new_campaign'));
		$campaign->save();

		return new JSONResponse($campaign->toArray());
	}

	public function edit()
	{
		$campaign = ActiveRecordModel::getInstanceById('AdCampaign', $this->request->get('id'), true, array('AdAdvertiser'));

		$response = new ActionResponse('campaign', $campaign->toArray());
		$form = $this->buildForm();

		$array = $campaign->toArray();
		if ($array['validTo'])
		{
			$array['validTo'] = ARSerializableDateTime::createFromTimeStamp(strtotime($array['validTo'] . ' -1 day'));
		}

		$form->setData($array);

		$response->set('form', $form);

		$filter = new ARSelectFilter(new IsNullCond(f('AdCampaignCondition.productID')));
		$records = $campaign->getRelatedRecordSetArray('AdCampaignCondition', $filter, array('Manufacturer', 'Category'));

		$filter = new ARSelectFilter(new IsNotNullCond(f('AdCampaignCondition.productID')));
		$records = array_merge($records, $campaign->getRelatedRecordSetArray('AdCampaignCondition', $filter, array('Product')));

		foreach ($records as $key => $record)
		{
			foreach (array('Product', 'Category', 'Manufacturer') as $k)
			{
				$id = strtolower($k) . 'ID';
				if (!empty($record[$id]))
				{
					$records[$key] = array_intersect_key($record, array_flip(array('ID', $k)));
					break;
				}
			}
		}

		$response->set('records', @json_encode($records));

		return $response;
	}

	public function save()
	{
		$campaign = ActiveRecordModel::getInstanceById('AdCampaign', $this->request->get('id'), true, array('AdAdvertiser'));
		$validator = $this->buildValidator();

		if ($validator->isValid())
		{
			if ($this->request->get('validTo'))
			{
				$this->request->set('validTo', ARSerializableDateTime::createFromTimeStamp(strtotime($this->request->get('validTo') . ' +1 day')));
			}

			$campaign->loadRequestData($this->request);
			$campaign->save();
			return new JSONResponse(array('campaign' => $campaign->toArray()), 'success', $this->translate('_campaign_was_successfully_saved'));
		}
		else
		{
			return new JSONResponse(array('errors' => $validator->getErrorList()), 'failure');
		}
	}

	public function addRecord()
	{
		$campaign = ActiveRecordModel::getInstanceByID('AdCampaign', $this->request->get('id'), true);
		$object = ActiveRecordModel::getInstanceByID($this->request->get('class'), $this->request->get('recordID'), true);

		$cond = AdCampaignCondition::getNewInstance($campaign, $object);
		$cond->save();

		return new JSONResponse(array('className' => get_class($object), 'data' => $cond->toArray()));
	}

	public function deleteRecord()
	{
		$record = ActiveRecordModel::getInstanceByID('AdCampaignCondition', $this->request->get('id'), true);
		$record->delete();

		return new JSONResponse(true);
	}

	public function changeColumns()
	{
		parent::changeColumns();
		return $this->getGridResponse();
	}

	private function getGridResponse()
	{
		$this->loadLanguageFile('backend/Product');

		$response = new ActionResponse();
		$this->setGridResponse($response);
		$response->set('id', $this->request->get('id'));
		return $response;
	}

	protected function getClassName()
	{
		return 'AdCampaign';
	}

	protected function getCSVFileName()
	{
		return 'campaigns.csv';
	}

	protected function getDefaultColumns()
	{
		return array('AdCampaign.ID', 'AdCampaign.name', 'AdCampaign.isEnabled', 'AdCampaign.validFrom', 'AdCampaign.validTo');
	}

	protected function getSelectFilter()
	{
		$id = $this->request->get("id");
		if (!is_numeric($id))
		{
			$id = array_pop(explode('_', $id));
		}
		$f = new ARSelectFilter();

		if ($id != -1)
		{
			$f->mergeCondition(eq('AdCampaign.advertiserID', $id));
		}

		return $f;
	}

	protected function setDefaultSortOrder(ARSelectFilter $filter)
	{
		$filter->setOrder(new ARFieldHandle($this->getClassName(), 'ID'), 'ASC');
	}

	public function autoComplete()
	{
	  	$f = new ARSelectFilter();
	  	$c = new LikeCond(new ARFieldHandle('Manufacturer', 'name'), $this->request->get('manufacturer') . '%');
	  	$f->setCondition($c);

	  	$results = ActiveRecordModel::getRecordSetArray('Manufacturer', $f);

		$resp = array();
	  	foreach ($results as $value)
	  	{
			$resp[$value['ID']] = $value['name'];
		}

		return new AutoCompleteResponse($resp);
	}

	private function buildValidator()
	{
		$validator = $this->getValidator("adCampaign", $this->request);
		$validator->addCheck("name", new IsNotEmptyCheck($this->translate("_campaign_name_empty")));

		return $validator;
	}

	/**
	 * Builds a category form instance
	 *
	 * @return Form
	 */
	private function buildForm()
	{
		return new Form($this->buildValidator());
	}
}

?>