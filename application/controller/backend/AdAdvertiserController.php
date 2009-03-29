<?php

ClassLoader::import("application.controller.backend.abstract.StoreManagementController");
ClassLoader::import("module.ads.application.model.AdAdvertiser");

/**
 * Manage advertisers
 *
 * @package module.ads.application.controller.backend
 * @author Integry Systems
 */
class AdAdvertiserController extends StoreManagementController
{
	public function index()
	{
		$advertiser = ActiveRecordModel::getInstanceById('AdAdvertiser', $this->request->get('id'), true)->toArray();

		$form = $this->buildForm();
		$form->setData($advertiser);

		return new ActionResponse('form', $form,
		 						  'advertiser', $advertiser
								);
	}

	public function update()
	{
		if (!$this->buildValidator()->isValid())
		{
			return false;
		}

		$advertiser = ActiveRecordModel::getInstanceById('AdAdvertiser', $this->request->get('id'), true);
		$advertiser->loadRequestData($this->request);
		$advertiser->save();

		return new JSONResponse($advertiser->toArray());
	}

	public function add()
	{
		$advertiser = AdAdvertiser::getNewInstance($this->translate('_new_advertiser'));
		$advertiser->save();

		return new JSONResponse($advertiser->toArray());
	}

	public function delete()
	{
		$advertiser = ActiveRecordModel::getInstanceById('AdAdvertiser', $this->request->get('id'), true);
		$advertiser->delete();
	}

	/**
	 * Builds a category form validator
	 *
	 * @return RequestValidator
	 */
	private function buildValidator()
	{
		$validator = $this->getValidator("advertiser", $this->request);
		$validator->addCheck("name", new IsNotEmptyCheck($this->translate('_err_adv_name')));
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