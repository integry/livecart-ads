<?php

/**
 * Log banner view/click data
 *
 * @package module.ads.plugin.shutdown
 * @author Integry Systems
 */
class AdRegisterLog extends ProcessPlugin
{
	public function process()
	{
		if (!class_exists('AdManager', false))
		{
			return;
		}

		AdManager::saveBatch();
	}
}

?>