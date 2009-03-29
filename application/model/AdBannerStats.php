<?php

ClassLoader::import("application.model.ActiveRecordModel");
ClassLoader::import("module.ads.application.model.AdBanner");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdBannerStats extends ActiveRecordModel
{
	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("bannerID", "AdBanner", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARField("views", ARInteger::instance()));
		$schema->registerField(new ARField("clicks", ARInteger::instance()));
		$schema->registerField(new ARField("time", ARDateTime::instance()));
	}
}

?>