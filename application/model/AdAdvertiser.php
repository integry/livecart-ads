<?php

ClassLoader::import("application.model.ActiveRecordModel");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdAdvertiser extends ActiveRecordModel
{
	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARField("name", ARVarchar::instance(100)));
	}

	/*####################  Static method implementations ####################*/

	/**
	 * Create new advertiser
	 */
	public static function getNewInstance($name)
	{
		$instance = parent::getNewInstance(__CLASS__);
		$instance->name->set($name);

		return $instance;
	}
}

?>