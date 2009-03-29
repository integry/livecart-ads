{if $id != -1}
	<ul class="menu">
		<li><a href="{link controller=backend.adCampaign action=add id=$id}" onclick="Backend.AdCampaign.prototype.add(event);">{t _add_campaign}</a></li>
	</ul>
{/if}

<div class="campaignGrid" id="campaignGrid" class="maxHeight h--50">

	{include file="module/ads/backend/adCampaign/grid.tpl"}

</div>