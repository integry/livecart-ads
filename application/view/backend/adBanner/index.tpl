<ul class="menu">
	<li><a href="{link controller=backend.adBanner action=add id=$id}" onclick="Backend.AdBanner.prototype.add(event);">{t _add_banner}</a></li>
</ul>

<div class="bannerGrid" class="maxHeight h--50">

	{include file="module/ads/backend/adBanner/grid.tpl"}

</div>