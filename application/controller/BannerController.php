<?php

ClassLoader::import('module.ads.application.model.AdZone');
ClassLoader::import('module.ads.application.model.AdBanner');
ClassLoader::import('module.ads.application.model.AdManager');

/**
 *  Displays banners and tracks click stats
 *
 *  @author Integry Systems
 *  @package module.ads.application.controller
 */
class BannerController extends BaseController
{
	public function click()
	{
		$banner = AdBanner::getInstanceById('AdBanner', $this->request->get('id'), true, array('AdCampaign'));
		if (!$banner->isValid())
		{
			return null;
		}

		AdManager::registerEvent('click', $banner->getID());

		return new RedirectResponse($banner->url->get());
	}

	public function bannerBlock()
	{
		// set up ad targeting
		if (!AdManager::isInitialized())
		{
			$this->initializeAds();
		}

		if ($banner = AdManager::getBannerByZone(AdManager::getBlockZone($this->getBlockName())))
		{
			AdManager::registerEvent('view', $banner['ID']);
			return new BlockResponse('banner', $banner);
		}
	}

	private function initializeAds()
	{
		$parent = $this->getParentController();

		if ($parent instanceof CategoryController)
		{
			AdManager::setCategoryId($parent->getCategoryId());

			foreach ((array)$parent->getAppliedFilters() as $filter)
			{
				if ($filter instanceof ManufacturerFilter)
				{
					AdManager::setManufacturerId($filter->getManufacturerID());
				}
			}
		}

		if ($parent instanceof ProductController)
		{
			$product = Product::getInstanceById($this->request->get('id'), true);
			AdManager::setProductId($product->getID());
			AdManager::setCategoryId($product->getCategory()->getID());

			if ($product->manufacturer->get())
			{
				AdManager::setManufacturerId($product->manufacturer->get()->getID());
			}
		}

		AdManager::initialize();
	}
}

?>