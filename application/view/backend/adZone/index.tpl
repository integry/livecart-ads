<ul class="menu">
	<li id="addZone">
		<a href="#">{t _add_zone}</a>
	</li>
	<li id="addZoneCancel" class="done cancel" style="display: none;">
		<a class="cancel" href="#">{t _cancel}</a>
	</li>
</ul>

<div id="newZone" style="display: none;">
	{form action="controller=backend.adZone action=add" onsubmit="Backend.AdZone.prototype.add(this); return false;" method="post" handle=$form}

		<fieldset>

			<legend>{t _add_zone}</legend>

			{include file="module/ads/backend/adZone/form.tpl"}

		</fieldset>

		<fieldset class="controls">
			<span class="progressIndicator" style="display: none;"></span>
			<input type="submit" value="{tn _save}" class="submit">
			{t _or}
			<a href="#cancel" onclick="$('addZoneCancel').onclick(); return false;" class="cancel">{t _cancel}</a>
		</fieldset>

	{/form}
</div>

<ul id="zoneList" class="activeList activeList_add_edit activeList_add_delete">
	{foreach $zones as $zone}
		{include file="module/ads/backend/adZone/node.tpl"}
	{/foreach}
</ul>

<script type="text/javascript">
	new Backend.AdZone();
</script>