<?php

ClassLoader::import("application.model.ActiveRecordModel");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("module.ads.application.model.AdZone");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdBanner extends ActiveRecordModel
{
	const TYPE_IMAGE = 0;
	const TYPE_FLASH = 1;
	const TYPE_HTML = 2;

	private $newFile = null;

	public static function defineSchema($className = __CLASS__)
	{
		$schema = self::getSchemaInstance($className);
		$schema->setName(__CLASS__);

		$schema->registerField(new ARPrimaryKeyField("ID", ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("campaignID", "AdCampaign", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARForeignKeyField("zoneID", "AdZone", "ID", null, ARInteger::instance()));
		$schema->registerField(new ARField("type", ARInteger::instance()));
		$schema->registerField(new ARField("isEnabled", ARBool::instance()));
		$schema->registerField(new ARField("name", ARVarchar::instance(100)));
		$schema->registerField(new ARField("url", ARVarchar::instance(255)));
		$schema->registerField(new ARField("fileName", ARVarchar::instance(255)));
		$schema->registerField(new ARField("html", ARText::instance()));
		$schema->registerField(new ARField("width", ARInteger::instance()));
		$schema->registerField(new ARField("height", ARInteger::instance()));
	}

	/*####################  Static method implementations ####################*/

	/**
	 * Create new campaign
	 */
	public static function getNewInstance(AdCampaign $campaign)
	{
		$instance = parent::getNewInstance(__CLASS__);
		$instance->campaign->set($campaign);
		return $instance;
	}

	public function setFile($file, $realName = null)
	{
		$this->newFile = $file;
		if (!$realName)
		{
			$realName = basename($file);
		}

		$this->realName = $realName;
	}

	public function save()
	{
		if ($this->getID() && $this->newFile)
		{
			$this->saveFile();
		}

		parent::save();

		if ($this->newFile)
		{
			$this->saveFile();
		}
	}

	public function isValid()
	{
		$campaign = $this->campaign->get();
		$campaign->load();

		$from = $campaign->validFrom->get()->getTimeStamp();
		$to = $campaign->validTo->get()->getTimeStamp();

		return $this->isEnabled->get() &&
			   $campaign->isEnabled->get() &&
			   (!$from || $from <= time()) &&
			   (!$to || $to >= time());
	}

	private function getFilePath($file = null)
	{
		$file = $file ? $file : $this->fileName->get();
		return ClassLoader::getRealPath('public.upload.banner.') . $file;
	}

	public function deleteFile()
	{
		$filePath = $this->getFilePath();
		if ($this->fileName->get() && file_exists($filePath))
		{
			unlink($filePath);
		}
	}

	private function saveFile()
	{
		$this->deleteFile();

		$fileName = $this->getID() . '_' . rand(1, 10000) . '_' . $this->realName;
		$path = $this->getFilePath($fileName);

		$dir = dirname($path);
		if (!file_exists($dir))
		{
			mkdir($dir, 0777, true);
		}

		if (is_uploaded_file($this->newFile))
		{
			move_uploaded_file($this->newFile, $path);
		}
		else
		{
			copy($this->newFile, $path);
		}

		$this->fileName->set($fileName);
		$this->newFile = null;
		$this->save();
	}
}

?>