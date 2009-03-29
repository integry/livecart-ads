<?php

ClassLoader::import("application.model.ActiveRecordModel");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("application.model.category.Category");
ClassLoader::import("application.model.product.Product");
ClassLoader::import("application.model.product.Manufacturer");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdCampaignCondition extends ActiveRecordModel
{
	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("campaignID", "AdCampaign", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("productID", "Product", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("categoryID", "Category", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("manufacturerID", "Manufacturer", "ID", null, ARInteger::instance()));
	}

	/*####################  Static method implementations ####################*/

	/**
	 * Create new advertiser
	 */
	public static function getNewInstance(AdCampaign $campaign, ActiveRecordModel $record)
	{
		$instance = parent::getNewInstance(__CLASS__);
		$instance->campaign->set($campaign);
		$instance->setFieldValue(self::getRecordVar($record), $record);
		return $instance;
	}

	private function getRecordVar(ActiveRecordModel $record)
	{
		$class = get_class($record);
		$class[0] = strtolower($class[0]);
		return $class . 'ID';
	}

	protected function insert()
	{
		parent::insert();
		$this->updateConditionCount();
	}

	public function delete()
	{
		parent::delete();
		$this->updateConditionCount();
	}

	private function updateConditionCount()
	{
		$campaign = $this->campaign->get();
		$campaign->condCount->set(self::getAggregate(__CLASS__, 'COUNT', f(__CLASS__ . '.ID'), select(eq(__CLASS__ . '.ID', $this->getID()))));
		$campaign->save();
	}
}

?>