{form id="advertiserForm_`$advertiser.ID`" handle=$form action="controller=backend.adAdvertiser action=update id=`$advertiser.ID`" method="post" onsubmit="Backend.Ads.updateBranch(this); return false;"}
	<fieldset>

		<legend>{t _advertiser_info}</legend>

		<p class="required">
			<label>{t _name}:</label>
			{textfield name="name"}
		</p>

		{block FORM-ADVERTISER-BOTTOM}

	</fieldset>

	<fieldset class="controls">
		<span class="progressIndicator" style="display: none;"></span>
		<input type="submit" class="submit" id="submit" value="{tn _save}"/> or
		<a href="#" class="cancel" onClick="$('advertiserForm_{$advertiser.ID}').reset(); return false;">{t _cancel}</a>
		<div class="clear"></div>
	</fieldset>

{/form}