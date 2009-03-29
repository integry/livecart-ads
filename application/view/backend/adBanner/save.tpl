{if $data.banner}
<div id="preview">
	{include file="module/ads/banner/block/banner.tpl" banner=$data.banner}
</div>
{/if}

<script type="text/javascript">
	window.frameElement.instance.saveComplete({json array=$data}, window);
</script>