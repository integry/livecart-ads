<?php

ClassLoader::import("module.ads.application.model.AdZone");
ClassLoader::import("module.ads.application.model.AdCampaign");
ClassLoader::import("module.ads.application.model.AdBanner");

/**
 * @author Integry Systems <http://integry.com>
 */
class AdManager
{
	private static $zones;

	private static $isInitialized = false;

	private static $params = array();

	private static $banners;

	private static $events;

	// ad targeting tuning
	const POINTS_MANUFACTURER = 10;
	const POINTS_PRODUCT = 5;
	const POINTS_CATEGORY = 1;

	public static function getZoneArray()
	{
		if (is_null(self::$zones))
		{
			self::$zones = ActiveRecordModel::getRecordSetArray('AdZone', new ARSelectFilter());
		}

		return self::$zones;
	}

	public static function getBlockZone($blockName)
	{
		foreach (self::getZoneArray() as $zone)
		{
			if ($zone['block'] == $blockName)
			{
				return $zone;
			}
		}
	}

	public static function getBannerByZone($zone)
	{
		if (is_null(self::$banners))
		{
			self::fetchBanners();
		}

		if (!empty(self::$banners[$zone['ID']]))
		{
			return array_shift(self::$banners[$zone['ID']]);
		}
	}

	public static function fetchBanners()
	{
		$f = select(eq('AdCampaign.isEnabled', true), eq('AdBanner.isEnabled', true));

		$date = eq(f('AdCampaign.validFrom'), 0);
		$date->addOr(lt(f('AdCampaign.validFrom'), f('NOW()')));
		$f->mergeCondition($date);

		$date = eq(f('AdCampaign.validTo'), 0);
		$date->addOr(gt(f('AdCampaign.validTo'), f('NOW()')));
		$f->mergeCondition($date);

		$targeting = array();
		if (!empty(self::$params['category']))
		{
			$cat = Category::getInstanceById(self::$params['category'], true);
			$targeting[] = 'IF(Category.lft >= ' . $cat->lft->get() . ' AND Category.rgt <= ' . $cat->rgt->get() . ', ' . self::POINTS_CATEGORY . ', 0)';
		}

		foreach (array('product' => self::POINTS_PRODUCT, 'manufacturer' => self::POINTS_MANUFACTURER) as $field => $points)
		{
			if (!empty(self::$params[$field]))
			{
				$targeting[] = 'IF(' . $field . 'ID=' . self::$params[$field] . ', ' . $points . ', 0)';
			}
		}

		if ($targeting)
		{
			$f->setOrder(new ARExpressionHandle('(SELECT SUM(' . implode('+', $targeting) . ') FROM AdCampaignCondition ' . (!empty(self::$params['category']) ? ' LEFT JOIN Category ON Category.ID=AdCampaignCondition.categoryID ' : '') . ' WHERE AdCampaignCondition.campaignID=AdCampaign.ID)'), 'DESC');
		}

		self::$banners = array();
		foreach (ActiveRecordModel::getRecordSetArray('AdBanner', $f, array('AdCampaign')) as $banner)
		{
			self::$banners[$banner['zoneID']][] = $banner;
		}
	}

	public static function isInitialized()
	{
		return self::$isInitialized;
	}

	public static function initialize()
	{
		self::$isInitialized = true;
	}

	public function setCategoryId($id)
	{
		self::$params['category'] = $id;
	}

	public function setProductId($id)
	{
		self::$params['product'] = $id;
	}

	public function setManufacturerId($id)
	{
		self::$params['manufacturer'] = $id;
	}

	public static function registerEvent($eventType, $bannerID)
	{
		self::$events[] = array('type' => $eventType, 'id' => $bannerID);
	}

	public static function saveBatch()
	{
		if (!self::$events)
		{
			return;
		}

		$app = ActiveRecordModel::getApplication();
		$ip = $app->getRequest()->getIPLong();
		$cache = $app->getCache();
		foreach (self::$events as $event)
		{
			$cache->set(array('banner_' . $event['id'] . '_' . $event['type'], $ip), true);
		}
	}
}

?>