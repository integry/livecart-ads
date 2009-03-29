<?php

ClassLoader::import('module.ads.application.model.AdManager');
ClassLoader::import('module.ads.application.model.AdBanner');

/**
 * Save banner stats data to database
 *
 * @package module.ads.plugin.cron.hourly
 * @author Integry Systems
 */
class AdProcessLog extends CronPlugin
{
	public function process()
	{
		$cache = $this->application->getCache();
		$res = array();
		foreach (AdBanner::getRecordSetArray('AdBanner', new ARSelectFilter()) as $banner)
		{
			foreach (array('view', 'click') as $type)
			{
				$ns = 'banner_' . $banner['ID'] . '_' . $type;
				if ($data = $cache->getNamespace($ns))
				{
					$res[$banner['ID']][$type] = count($data);
				}

				$cache->clearNamespace($ns);
			}
		}

		if (!$res)
		{
			return;
		}

		$inserts = array();
		foreach ($res as $id => $data)
		{
			$inserts[] = '(' . $id . ',' . (empty($data['view']) ? 0 : $data['view']) . ',' . (empty($data['click']) ? 0 : $data['click']) . ', NOW())';
		}

		ActiveRecord::executeUpdate('INSERT INTO AdBannerStats (bannerID, views, clicks, time) VALUES ' .implode(',', $inserts));
	}
}

?>