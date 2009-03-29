{form id="campaignForm_`$campaign.ID`" handle=$form action="controller=backend.adCampaign action=save id=`$campaign.ID`" method="post" onsubmit="Backend.AdCampaign.prototype.save(this); return false;"}
	<fieldset>

		<legend>{t _main_info}</legend>

		<p>
			<label></label>
			{checkbox name="isEnabled" id="isEnabled_`$campaign.ID`" class="checkbox"}
			<label for="isEnabled_{$campaign.ID}" class="checkbox">{t AdCampaign.isEnabled}</label>
		</p>

		<p>
			{{err for="name"}}
				{{label {t AdCampaign.name} }}
				{textfield class="text"}
			{/err}
		</p>

		<div class="field">
			{err for="validFrom"}
				{label {t AdCampaign.validFrom}}
				{calendar id="validFrom_`{$campaign.ID}`"}
			{/err}
		</div>

		<div class="field">
			{err for="validTo"}
				{label {t AdCampaign.validTo}}
				{calendar id="validTo_`{$campaign.ID}`"}
			{/err}
		</div>

		{block FORM-CAMPAIGN-BOTTOM}

	</fieldset>

	<fieldset class="controls">
		<span class="progressIndicator" style="display: none;"></span>
		<input type="submit" class="submit" id="submit" value="{tn _save}"/> or
		<a href="#" class="cancel" onClick="$('campaignForm_{$campaign.ID}').reset(); return false;">{t _cancel}</a>
		<div class="clear"></div>
	</fieldset>

{/form}

<fieldset>

	<legend>{t _conditions}</legend>

	<div class="recordContainer">
		<ul class="menu">
			<div class="conditionItems">
				<li class="addConditionProduct"><a href="#">{t _add_product}</a></li>
				<li class="addConditionCategory"><a href="#">{t _add_category}</a></li>
				<li class="addConditionManufacturer"><a href="#">{t _add_manufacturer}</a></li>
			</div>
		</ul>
		<ul class="records"></ul>
	</div>

</fieldset>

<script type="text/javascript">
	var camp = new Backend.AdCampaign({json array=$campaign});
	camp.setRecords({$records});
</script>