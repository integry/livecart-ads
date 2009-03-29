{includeJs file="library/livecart.js"}
{includeJs file="library/KeyboardEvent.js"}
{includeJs file="library/ActiveGrid.js"}
{includeJs file="library/ActiveList.js"}
{includeJs file="library/form/ActiveForm.js"}
{includeJs file="library/form/State.js"}
{includeJs file="library/form/Validator.js"}
{includeJs file="library/dhtmlxtree/dhtmlXCommon.js"}
{includeJs file="library/dhtmlxtree/dhtmlXTree.js"}
{includeJs file="library/TabControl.js"}
{includeJs file="library/rico/ricobase.js"}
{includeJs file="library/rico/ricoLiveGrid.js"}

{includeJs file="backend/Category.js"}
{includeJs file="backend/Discount.js"}

{includeJs file="/module/ads/javascript/backend/Ads.js"}
{includeCss file="/module/ads/stylesheet/backend/Ads.css"}

{includeCss file="library/ActiveList.css"}
{includeCss file="library/ActiveGrid.css"}
{includeCss file="library/TabControl.css"}
{includeCss file="library/dhtmlxtree/dhtmlXTree.css"}
{includeCss file="library/lightbox/lightbox.css"}

{include file="backend/eav/includes.tpl"}

{pageTitle}{t _manage_ads}{/pageTitle}
{include file="layout/backend/header.tpl"}

<div id="mainAdvContainer">

	<div id="advertiserContainer" class="treeContainer  maxHeight h--60">
		<div id="advertiserBrowser" class="treeBrowser"></div>

		<ul id="categoryBrowserActions" class="verticalMenu">
			<li class="addTreeNode">
				<a href="{link controller=backend.adAdvertiser action=add}" id="createAdvertiserLink">
					{t _add_advertiser}
				</a>
			</li>

			<li class="removeTreeNode">
				<a href="{link controller=backend.adAdvertiser action=delete id=_id_}" id="removeAdvertiserLink">
					{t _remove_advertiser}
				</a>
			</li>
		</ul>

	</div>

	<div id="managerContainer" class="treeManagerContainer maxHeight h--60">

		<div id="loadingCampaign" style="display: none; position: absolute; text-align: center; width: 100%; padding-top: 200px; z-index: 50000;">
			<span style="padding: 40px; background-color: white; border: 1px solid black;">{t _loading_campaign}<span class="progressIndicator"></span></span>
		</div>

		<div id="adTabs">
			<div id="tabContainer" class="tabContainer">
				{tabControl id="tabList" noHidden=true}
					{tab id="tabCampaigns"}<a href="{link controller=backend.adCampaign action=index id=_id_ }">{t _campaigns}</a>{/tab}
					{tab id="tabAdvertiser"}<a href="{link controller=backend.adAdvertiser action=index id=_id_ }">{t _advertiser}</a>{/tab}
					{tab id="tabZones"}<a href="{link controller=backend.adZone action=index id=_id_ }">{t _zones}</a>{/tab}
				{/tabControl}
			</div>
			<div id="sectionContainer" class="sectionContainer maxHeight  h--50">
			</div>
		</div>

		<div id="addAdvertiserContainer" style="display: none;"></div>
	</div>
</div>

{* Editors *}
<div id="campaignManagerContainer" style="display: none;">
	<fieldset class="container">
		<ul class="menu">
			<li class="done"><a href="#cancelEditing" id="cancel_user_edit" class="cancel">{t _cancel_editing_campaign}</a></li>
		</ul>
	</fieldset>

	<div class="tabContainer">
		{tabControl id="campaignTabList" noHidden=true}
			{tab id="tabUserInfo"}<a href="{link controller=backend.adCampaign action=edit id=_id_}"}">{t _campaign_info}</a>{/tab}
			{tab id="tabBanners"}<a href="{link controller=backend.adBanner action=index id=_id_ }">{t _banners}</a>{/tab}
		{/tabControl}
	</div>
	<div class="sectionContainer maxHeight h--50"></div>

	{literal}
	<script type="text/javascript">
		Event.observe($("cancel_user_edit"), "click", function(e) {
			Event.stop(e);
			var editor = Backend.AdCampaign.Editor.prototype.getInstance(Backend.AdCampaign.Editor.prototype.getCurrentId(), false);
			editor.cancelForm();
		});
	</script>
	{/literal}

	<div id="recordTemplate" style="display: none;">
		<li>
			<span class="recordDeleteMenu">
				<img src="image/silk/cancel.png" class="recordDelete" />
				<span class="progressIndicator" style="display: none;"></span>
			</span>
			<a href="#"><span class="recordClass"></span><span class="recordTypeSep">: </span><span class="recordName"></span></a>
		</li>
	</div>
</div>

<div id="bannerManagerContainer" style="display: none;">
	<fieldset class="container">
		<ul class="menu">
			<li class="done"><a href="#cancelEditing" id="cancel_banner_edit" class="cancel">{t _cancel_editing_banner}</a></li>
		</ul>
	</fieldset>

	<div class="tabContainer">
		{tabControl id="bannerTabList" noHidden=true}
			{tab id="tabBannerInfo"}<a href="{link controller=backend.adBanner action=edit id=_id_}"}">{t _banner_info}</a>{/tab}
		{/tabControl}
	</div>
	<div class="sectionContainer maxHeight h--50"></div>

	{literal}
	<script type="text/javascript">
		Event.observe($("cancel_banner_edit"), "click", function(e) {
			Event.stop(e);
			var editor = Backend.AdBanner.Editor.prototype.getInstance(Backend.AdBanner.Editor.prototype.getCurrentId(), false);
			editor.cancelForm();
		});
	</script>
	{/literal}
</div>

<script type="text/javascript">
	Backend.showContainer('managerContainer');

	Backend.Ads.init();

	Backend.Ads.addCategories({json array=$advertisers});

	Backend.Ads.activeCategoryId = Backend.Ads.treeBrowser.getSelectedItemId();
	Backend.Ads.initPage();

	Backend.Ads.loadBookmarkedCategory();

	Backend.Ads.showControls();
</script>

{include file="layout/backend/footer.tpl"}