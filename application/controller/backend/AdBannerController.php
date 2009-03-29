<?php

ClassLoader::import("application.controller.backend.abstract.ActiveGridController");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("module.ads.application.model.AdBanner");
ClassLoader::import("module.ads.application.model.AdZone");

/**
 *
 * @package module.ads.application.controller.backend
 * @author Integry Systems
 */
class AdBannerController extends ActiveGridController
{
	public function index()
	{
		return $this->getGridResponse();
	}

	public function add()
	{
		$campaign = ActiveRecordModel::getInstanceByID('AdCampaign', $this->request->get('id'), true);
		$banner = AdBanner::getNewInstance($campaign);
		$banner->name->set($this->translate('_new_banner'));
		$banner->save();

		return new JSONResponse($banner->toArray());
	}

	public function edit()
	{
		$banner = ActiveRecordModel::getInstanceById('AdBanner', $this->request->get('id'), true, array('AdCampaign', 'AdZone'));

		$response = new ActionResponse('banner', $banner->toArray());
		$form = $this->buildForm($banner);
		$form->setData($banner->toFlatArray());
		$response->set('form', $form);

		// banner zones
		$zones = array();
		$f = new ARSelectFilter();
		$f->setOrder(f('AdZone.name'));
		$zones[''] = '';
		foreach (ActiveRecordModel::getRecordSetArray('AdZone', $f) as $zone)
		{
			$zones[$zone['ID']] = $zone['name'];
		}
		$response->set('zones', $zones);

		// banner types
		$response->set('types', array(AdBanner::TYPE_IMAGE => $this->translate('_type_image'),
									  AdBanner::TYPE_FLASH => $this->translate('_type_flash'),
									  AdBanner::TYPE_HTML => $this->translate('_type_html')));

		return $response;
	}

	public function save()
	{
		$banner = ActiveRecordModel::getInstanceById('AdBanner', $this->request->get('id'), true, array('AdCampaign'));
		$validator = $this->buildValidator($banner);

		if ($validator->isValid())
		{
			$banner->loadRequestData($this->request);
			$banner->zone->set(ActiveRecordModel::getInstanceById('AdZone', $this->request->get('AdZone')));

			if ($this->request->get('type') != AdBanner::TYPE_HTML)
			{
				$file = $_FILES[$this->request->get('type') == AdBanner::TYPE_IMAGE ? 'image' : 'flash'];
				$banner->setFile($file['tmp_name'], $file['name']);
			}
			else
			{
				$banner->deleteFile();
			}

			$banner->save();
			$data = array('banner' => $banner->toArray(), 'status' => 'success', 'message' => $this->translate('_banner_was_successfully_saved'));
		}
		else
		{
			$data = array('errors' => $validator->getErrorList(), 'status' => 'failure');
		}

		return new ActionResponse('data', $data);
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
		return 'AdBanner';
	}

	protected function getCSVFileName()
	{
		return 'banners.csv';
	}

	protected function getDefaultColumns()
	{
		return array('AdBanner.ID', 'AdBanner.name', 'AdBanner.isEnabled');
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
			$f->mergeCondition(eq('AdBanner.campaignID', $id));
		}

		return $f;
	}

	protected function setDefaultSortOrder(ARSelectFilter $filter)
	{
		$filter->setOrder(new ARFieldHandle($this->getClassName(), 'ID'), 'ASC');
	}

	private function buildValidator(AdBanner $banner)
	{
		$validator = $this->getValidator("AdBanner", $this->request);
		$validator->addCheck("name", new IsNotEmptyCheck($this->translate("_banner_name_empty")));
		$validator->addCheck("AdZone", new IsNotEmptyCheck($this->translate("_err_zone")));
		$validator->addCheck("type", new IsNotEmptyCheck($this->translate("_err_banner_type")));
		$validator->addCheck("html", new OrCheck(array('html', 'type'), array(new IsNotEmptyCheck($this->translate("_err_html_empty")), new IsNotEqualCheck('', AdBanner::TYPE_HTML)), $this->request));

		if (!$banner->fileName->get() || ($banner->type->get() != $this->request->get('type')) || !empty($_FILES['image']['tmp_name']))
		{
			$imgCheck = new IsImageUploadedCheck($this->translate("_err_image"));
			$imgCheck->setFieldName('image');
			$validator->addCheck("image", new OrCheck(array('image', 'type'), array($imgCheck, new IsNotEqualCheck('', AdBanner::TYPE_IMAGE)), $this->request));
		}

		if (!$banner->fileName->get() || ($banner->type->get() != $this->request->get('type')) || !empty($_FILES['flash']['tmp_name']))
		{
			$flashCheck = new IsFileUploadedCheck($this->translate("_err_flash"));
			$flashCheck->setFieldName('flash');
			$validator->addCheck("flash", new OrCheck(array('flash', 'type'), array($flashCheck, new IsNotEqualCheck('', AdBanner::TYPE_FLASH)), $this->request));
		}

		return $validator;
	}

	/**
	 * Builds a form instance
	 *
	 * @return Form
	 */
	private function buildForm(AdBanner $banner)
	{
		return new Form($this->buildValidator($banner));
	}
}

?>