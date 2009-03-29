{form action="controller=backend.adZone action=save query=id=`$zone.ID`" onsubmit="Backend.AdZone.prototype.save(this); return false;" method="post" handle=$form}

<fieldset>

	<legend>{t _edit_zone}</legend>

	{include file="module/ads/backend/adZone/form.tpl"}

</fieldset>

<fieldset class="controls">
	<span class="progressIndicator" style="display: none;"></span>
	<input type="submit" value="{tn _save}" class="submit">
	{t _or}
	<a href="#cancel" onclick="this.parentNode.parentNode.parentNode.innerHTML = ''; return false;" class="cancel">{t _cancel}</a>
</fieldset>

{/form}