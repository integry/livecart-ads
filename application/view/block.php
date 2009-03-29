<?php

ClassLoader::import('module.ads.application.model.AdManager');

$out = array();
foreach (AdManager::getZoneArray() as $zone)
{
	$out[$zone['block']] = array('*' => 'banner->banner');
}

return $out;

?>