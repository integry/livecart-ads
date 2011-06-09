{form id="bannerForm_`$banner.ID`" target="bannerUpload_`$banner.ID`" handle=$form action="controller=backend.adBanner action=save id=`$banner.ID`" method="post" enctype="multipart/form-data"}
	<fieldset>

		<legend>{t _main_info}</legend>

		<fieldset class="bannerPreviewContainer">
			<legend>{t _preview}</legend>
			<div class="bannerPreview">
				{include file="module/ads/banner/block/banner.tpl" banners=$preview}
			</div>
		</fieldset>

		<p>
			<label></label>
			{checkbox name="isEnabled" id="isEnabled_`$banner.ID`" class="checkbox"}
			<label for="isEnabled_{$banner.ID}" class="checkbox">{t AdBanner.isEnabled}</label>
		</p>

		<p class="required">
			{{err for="name"}}
				{{label {t AdBanner.name} }}
				{textfield class="text"}
			{/err}
		</p>

		<p class="required">
			{{err for="AdZone"}}
				{{label {t AdZone.name} }}
				{selectfield options=$zones}
			{/err}
		</p>

		<p class="required">
			{{err for="type"}}
				{{label {t AdBanner.type} }}
				{selectfield class="typeSelect" options=$types}
			{/err}
		</p>

		<div class="imageField">
			<p class="required">
				{{err for="image"}}
					{{label {t _up_image} }}
					{filefield}
				{/err}
			</p>

			<p>
				{{err for="url"}}
					{{label {t AdBanner.url} }}
					{textfield class="text"}
				{/err}
			</p>

			<p>
				{{err for="target"}}
					{{label {t AdBanner.target} }}
					{selectfield options=$target}
				{/err}
			</p>
		</div>

		<div class="flashField">
			<p class="required">
				{{err for="flash"}}
					{{label {t _up_flash} }}
					{filefield}
				{/err}
			</p>

			<p>
				{{err for="width"}}
					{{label {t AdBanner.width} }}
					{textfield class="text number"}
				{/err}
			</p>

			<p>
				{{err for="height"}}
					{{label {t AdBanner.height} }}
					{textfield class="text number"}
				{/err}
			</p>
		</div>

		<div class="htmlField">
			<p class="required">
				{{err for="html"}}
					{{label {t AdBanner.html} }}
					{textarea}
				{/err}
			</p>
		</div>

		<p>
			{{err for="priority"}}
				{{label {t AdBanner.priority} }}
				{textfield class="text number"}
			{/err}
		</p>

		{block FORM-BANNER-BOTTOM}

	</fieldset>

	<fieldset class="controls">
		<span class="progressIndicator" style="display: none;"></span>
		<input type="submit" class="submit" id="submit" value="{tn _save}"/> or
		<a href="#" class="cancel" onClick="$('bannerForm_{$banner.ID}').reset(); return false;">{t _cancel}</a>
		<div class="clear"></div>
	</fieldset>

{/form}

<iframe id="bannerUpload_{$banner.ID}" name="bannerUpload_{$banner.ID}" style="display: none;"></iframe>

<script type="text/javascript">
	$('bannerUpload_{$banner.ID}').instance = new Backend.AdBanner({json array=$banner});
</script>