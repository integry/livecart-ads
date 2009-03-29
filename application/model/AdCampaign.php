<?php

ClassLoader::import("application.model.ActiveRecordModel");
ClassLoader::import("module.ads.application.model.AdAdvertiser");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdCampaign extends ActiveRecordModel
{
	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("advertiserID", "AdAdvertiser", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARField("isEnabled", ARBool::instance()));
		$schema->registerField(new ARField("isAllConditions", ARBool::instance()));
		$schema->registerField(new ARField("condCount", ARInteger::instance(11)));
		$schema->registerField(new ARField("validFrom", ARDateTime::instance()));
		$schema->registerField(new ARField("validTo", ARDateTime::instance()));
		$schema->registerField(new ARField("name", ARVarchar::instance(100)));
	}

	/*####################  Static method implementations ####################*/

	/**
	 * Create new advertiser
	 */
	public static function getNewInstance(AdAdvertiser $advertiser)
	{
		$instance = parent::getNewInstance(__CLASS__);
		$instance->advertiser->set($advertiser);
		return $instance;
	}
}

?>