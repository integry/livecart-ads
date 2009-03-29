<fieldset class="container activeGridControls">

	<span class="activeGridMass" id="campaignMass_{$id}" >

		{form action="controller=backend.adCampaign action=processMass" method="POST" handle=$massForm onsubmit="return false;"}

		<input type="hidden" name="filters" value="" />
		<input type="hidden" name="selectedIDs" value="" />
		<input type="hidden" name="isInverse" value="" />

		{t _with_selected}:
		<select name="act" class="select">
			<option value="enable_isEnabled">{t _enable}</option>
			<option value="disable_isEnabled">{t _disable}</option>
			<option value="delete">{t _delete}</option>
		</select>

		<span class="bulkValues" style="display: none;"></span>

		<input type="submit" value="{tn _process}" class="submit" />
		<span class="progressIndicator" style="display: none;"></span>

		{/form}

	</span>

	<span class="activeGridItemsCount">
		<span id="userCount_{$userGroupID}">
			<span class="rangeCount" style="display: none;">{t _listing_campaigns}</span>
			<span class="notFound" style="display: none;">{t _no_campaigns}</span>
		</span>
	</span>

</fieldset>

{activeGrid
	prefix="campaign"
	id=$id
	controller="backend.adCampaign" action="lists"
	displayedColumns=$displayedColumns
	availableColumns=$availableColumns
	totalCount=$totalCount
	container="campaignGrid"
	dataFormatter="Backend.AdCampaign.GridFormatter"
}

<script type="text/javascript">
	var massHandler = new ActiveGrid.MassActionHandler($('campaignMass_{$id}'), window.activeGrids['campaign_{$id}']);
	massHandler.deleteConfirmMessage = '{t _are_you_sure_you_want_to_delete_campaign|addslashes}' ;
	massHandler.nothingSelectedMessage = '{t _nothing_selected|addslashes}' ;
</script>
