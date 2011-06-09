{includeCss file="/module/ads/stylesheet/Ads.css"}

<div class="bannerGroupContainer">
{foreach from=$banners item=banner}
	<div class="bannerContainer">
		{if $banner.type == 0}
			{if $banner.url}
				{assign var=url value=$banner.url|@base64_encode}
				<a href="{link controller=banner action=click id=$banner.ID query="url=$url"}" target="{$banner.target}"><img src="upload/banner/{$banner.fileName}" class="banner" /></a>
			{else}
				<img src="upload/banner/{$banner.fileName}" class="banner" />
			{/if}
		{elseif $banner.type == 1}
			<object {if $banner.width} width="{$banner.width}" {/if}{if $banner.height} height="{$banner.height}"{/if} codebase="http://active.macromedia.com/flash2/cabs/swflash.cab#version=6,0,0,0" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
				<param value="opaque" name="wmode"/>
				<param value="upload/banner/{$banner.fileName}" name="movie"/>
				<param value="autohigh" name="quality"/>
				<param value="always" name="allowScriptAccess"/>
				<param value="#" name="bgcolor"/>
				<embed {if $banner.width} width="{$banner.width}" {/if}{if $banner.height} height="{$banner.height}"{/if} pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" wmode="opaque" bgcolor="#" quality="autohigh" allowscriptaccess="always" src="upload/banner/{$banner.fileName}"/>
			</object>
		{elseif $banner.type == 2}
			{$banner.html}
		{/if}
	</div>
{/foreach}
</div>