<?php

ClassLoader::import("application.model.ActiveRecordModel");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("module.ads.application.model.AdBanner");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdZone extends ActiveRecordModel
{
	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARField("maxCount", ARInteger::instance(2)));
		$schema->registerField(new ARField("position", ARInteger::instance(2)));
		$schema->registerField(new ARField("name", ARVarchar::instance(100)));
		$schema->registerField(new ARField("block", ARVarchar::instance(100)));
	}

	/*####################  Static method implementations ####################*/

	/**
	 * Create new advertiser
	 */
	public static function getNewInstance()
	{
		$instance = parent::getNewInstance(__CLASS__);
		return $instance;
	}
}

?>