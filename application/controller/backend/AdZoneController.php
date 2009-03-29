<?php

ClassLoader::import("application.controller.backend.abstract.StoreManagementController");
ClassLoader::import("module.ads.application.model.AdZone");

/**
 * Manage banner display zones
 *
 * @package module.ads.application.controller.backend
 * @author Integry Systems
 */
class AdZoneController extends StoreManagementController
{
	public function index()
	{
		$filter = new ARSelectFilter();
		$filter->setOrder(f('AdZone.name'));

		$response = new ActionResponse('zones', ActiveRecordModel::getRecordSetArray('AdZone', $filter));
		$response->set('form', $this->buildForm());
		return $response;
	}

	public function edit()
	{
		$zone = ActiveRecordModel::getInstanceById('AdZone', $this->request->get('id'), true)->toArray();
		$form = $this->buildForm();
		$form->setData($zone);

		$response = new ActionResponse('zone', $zone);
		$response->set('form', $form);
		return $response;
	}

	public function save()
	{
		if (!$this->buildValidator()->isValid())
		{
			return false;
		}

		$zone = ActiveRecordModel::getInstanceById('AdZone', $this->request->get('id'), true);
		$zone->loadRequestData($this->request);
		$zone->save();

		return new JSONResponse($zone->toArray());
	}

	public function add()
	{
		$zone = AdZone::getNewInstance();
		$zone->loadRequestData($this->request);
		$zone->save();

		return new ActionResponse('zone', $zone->toArray());
	}

	public function delete()
	{
		ActiveRecordModel::getInstanceById('AdZone', $this->request->get('id'), true)->delete();
	}

	/**
	 * Builds a category form validator
	 *
	 * @return RequestValidator
	 */
	private function buildValidator()
	{
		$validator = $this->getValidator("adZone", $this->request);
		$validator->addCheck("name", new IsNotEmptyCheck($this->translate('_err_zone_name')));
		$validator->addCheck("block", new IsNotEmptyCheck($this->translate('_err_block_name')));
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