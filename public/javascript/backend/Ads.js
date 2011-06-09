/**
 *	@author Integry Systems
 */

if (Backend == undefined)
{
	var Backend = {}
}

Backend.Ads = {

	/**
	 * category tab controll instance
	 */
	tabControl: null,

	/**
	 * Category tree browser instance
	 */
	treeBrowser: null,

	/**
	 * Id of currenty selected category. Used for category tab content switching
	 */
	activeCategoryId: null,

	links: {},

	/**
	 * Category module initialization
	 */
	init: function()
	{
		this.initCategoryBrowser();
		this.initTabs();
		this.initTreeControls();
	},

	initPage: function()
	{
		// check for bookmark
		if (!Backend.getHash())
		{
			window.location.hash = $('tabCampaigns') ?  'cat_-1#tabCampaigns__' : 'cat_1#tabCampaigns__';
			Backend.Breadcrumb.display(1);
		}

		Backend.Ads.treeBrowser.showFeedback =
			function(itemId)
			{
				if (!this.iconUrls)
				{
					this.iconUrls = new Object();
				}

				if (!this.iconUrls[itemId])
				{
					this.iconUrls[itemId] = this.getItemImage(itemId, 0, 0);
					var img = this._globalIdStorageFind(itemId).htmlNode.down('img', 2);
					img.originalSrc = img.src;
					img.src = 'image/indicator.gif';
				}
			}

		Backend.Ads.treeBrowser.hideFeedback =
			function(itemId)
			{
				if (null != this.iconUrls[itemId])
				{
					this.iconUrls[itemId] = this.getItemImage(itemId, 0, 0);
					var img = this._globalIdStorageFind(itemId).htmlNode.down('img', 2);
					img.src = img.originalSrc;
					this.iconUrls[itemId] = null;
				}
			}

		var elements = Backend.getHash().split('#');

		if (elements[1].substr(0, 4) == 'cat_')
		{
			var parts = elements[1].split('_');
			var categoryId = parts[1];

			Backend.Ads.activeCategoryId = categoryId;
			Backend.Ads.treeBrowser.selectItem(categoryId, false, false);

			return true;
		}

		if($('advertiserBrowser').getElementsByClassName('selectedTreeRow')[0])
		{
			var treeNode = $('advertiserBrowser').getElementsByClassName('selectedTreeRow')[0].parentNode;
			Backend.ajaxNav.add('cat_' + treeNode.parentObject.id + '#tabProducts');
		}
	},

	initTreeControls: function()
	{
		Event.observe($("createAdvertiserLink"), "click", function(e) {
			Event.stop(e);
			this.createNewBranch();
		}.bind(this));

		Event.observe($("removeAdvertiserLink"), "click", function(e) {
			Event.stop(e);
			if (confirm(Backend.getTranslation('_confirm_advertiser_remove')))
			{
				this.removeBranch();
			}
		}.bind(this));
	},

	/**
	 * Builds category tree browser object (dhtmlxTree) and initializes its params
	 */
	initCategoryBrowser: function()
	{
		this.treeBrowser = new dhtmlXTreeObject("advertiserBrowser","","", 0);

		Backend.Breadcrumb.setTree(this.treeBrowser);

		this.treeBrowser.setImagePath("image/backend/dhtmlxtree/");
		this.treeBrowser.setOnClickHandler(this.activateCategory.bind(this));
	},

	initTabs: function()
	{
		this.tabControl = TabControl.prototype.getInstance('adTabs', this.craftTabUrl.bind(this), this.craftContainerId.bind(this), {});
	},

	craftTabUrl: function(url)
	{
		return url.replace(/_id_/, this.treeBrowser.getSelectedItemId());
	},

	craftContainerId: function(tabId)
	{
		return tabId + '_' +  this.treeBrowser.getSelectedItemId() + 'Content';
	},

	showControls: function()
	{
		var rem = $("removeAdvertiserLink");
		var detailsTab = $('tabAdvertiser');
		var active = this.tabControl.getActiveTab();

		if (this.treeBrowser.getSelectedItemId() == '-1')
		{
			rem.parentNode.hide();
			detailsTab.hide();
			if (active == detailsTab)
			{
				this.tabControl.activateTab($('tabCampaigns'));
			}
		}
		else
		{
			rem.parentNode.show();
			detailsTab.show();
		}
	},

	/**
	 * Tree browser onClick handler. Activates selected category by realoading active
	 * tab with category specific data
	 *
	 * @todo Find some better way to reference/retrieve the DOM nodes from tree by category ID's
	 * (automatically assign ID's somehow?). Also necessary for bookmarking (the ID's have to be preassigned).
	 */
	activateCategory: function(categoryId)
	{
		Backend.Breadcrumb.display(categoryId);

		this.showControls();

		this.activeCategoryId = categoryId;

		// set ID for the current tree node element
		$('advertiserBrowser').getElementsByClassName('selectedTreeRow')[0].parentNode.id = 'cat_' + categoryId;

		// and register browser history event to enable backwar/forward navigation
		// Backend.ajaxNav.add('cat_' + categoryId);

		if (!this.tabControl.activeTab)
		{
			var tabList = $('tabList');
			if (tabList)
			{
				this.tabControl.activeTab = tabList.down('li.tab');
			}
		}

		if (!this.tabControl.activeTab)
		{
			return false;
		}

		this.tabControl.activeTab.onclick();
	},

	createNewBranch: function()
	{
		new LiveCart.AjaxRequest(
			this.getUrlForNewNode(),
			false,
			function(response) { this.afterNewBranchCreated(response) }.bind(this)
		);
	},

	afterNewBranchCreated: function(response)
	{
		var newCategory = eval('(' + response.responseText + ')');
		var parentCategoryId = -1;

		this.treeBrowser.insertNewItem(parentCategoryId, newCategory.ID, newCategory.name, null, 0, 0, 0, '', 1);
		this.treeBrowser.showItemSign(newCategory.ID, 0);
		this.treeBrowser.selectItem(newCategory.ID, true);
		this.tabControl.activateTab("tabMainDetails");

		Backend.Breadcrumb.display(newCategory.ID);
		Backend.Ads.showControls();
	},

	/**
	 * Updating category branch via ajax request
	 */
	updateBranch: function(formObj)
	{
		new LiveCart.AjaxRequest(formObj, null, this.afterBranchUpdate.bind(this));
	},

	/**
	 * Post-processing request
	 */
	afterBranchUpdate: function(response)
	{
		var categoryData = response.responseData;
		this.treeBrowser.setItemText(categoryData.ID, categoryData.name);
	},

	/**
	 * Gets an URL for creating a new node (uses a globaly defined variable "newNodeUrl")
	 */
	getUrlForNewNode: function()
	{
		return $('createAdvertiserLink').href;
	},

	getUrlItemsInTabsCount: function(categoryId)
	{
		return this.buildUrl(Backend.Ads.links.countTabsItems, categoryId);
	},

	getUrlForNodeRemoval: function(nodeId)
	{
		return this.buildUrl($('removeAdvertiserLink').href, nodeId);
	},

	buildUrl: function(urlPattern, id)
	{
		return urlPattern.replace('_id_', id);
	},

	/**
	 * Removes a selected category (including sub-trees) from a store
	 */
	removeBranch: function()
	{
		var nodeIdToRemove = this.treeBrowser.getSelectedItemId();
		var parentNodeId = this.treeBrowser.getParentId(nodeIdToRemove);

		new LiveCart.AjaxRequest(this.getUrlForNodeRemoval(nodeIdToRemove));

		this.activateCategory(parentNodeId);
		this.tabControl.activateTab($('tabCampaigns'));
		this.treeBrowser.deleteItem(nodeIdToRemove, true);
	},

	/**
	 * Insert array of categories into tree
	 *
	 * @param array categories Array of category objects. Every category object should contain these elements
	 *	 parent - Id of parent category
	 *	 ID - Id o category
	 *	 name - Category name in current language
	 *	 options - Advanced options
	 *	 childrenCount - Indicates that this node has N childs
	 */
	addCategories: function(categories)
	{
		this.treeBrowser.insertNewItem(0, -1, Backend.getTranslation('_all_advertisers'), null, 0, 0, 0, "", true);

		$A(categories).each(function(category) {
			if(!category.parent || 0 == category.parent)
			{
				category.options = "";
				category.parent = 0;
			}
			else if(!category.option)
			{
				category.options = "";
			}

			// strip HTML
			category.name = '<b>' + category.name + '</b>';
			category.name = category.name.replace(/<(?:.|\s)*?>/g, "");

			this.treeBrowser.insertNewItem(-1,category.ID,category.name, null, 0, 0, 0, category.options, true);
		}.bind(this));
	},

	loadBookmarkedCategory: function(categoryID)
	{
		var match = Backend.getHash().match(/cat_(\d+)/);

		if(match)
		{
			var alreadyLoaded = false;
			try
			{
				$A(Backend.Ads.treeBrowser._globalIdStorage).each(function(id)
				{
					if(id == match[1])
					{
					   alreadyLoaded = true;
					   throw $break;
					}
				});
			}
			catch(e) { }
		}
	},

	loadBookmarkedProduct: function()
	{
		var productID = Backend.getHash().match(/product_(\d+)/);
		if (productID && productID[1])
		{
			Element.show($('loadingProduct'));
			Backend.Product.openProduct(productID[1], null, function() { Element.hide($('loadingProduct')); });
		}
	}
}

Backend.AdZone = function()
{
	Backend.AdZone.prototype.activeList = ActiveList.prototype.getInstance('zoneList', this.activeListCallbacks);
	$('addZone').onclick = this.showAddForm.bind(this);
	$('addZoneCancel').onclick = this.hideAddForm.bind(this);
}

Backend.AdZone.prototype =
{
	activeListCallbacks:
	{
		 beforeEdit:	 function(li)
		 {
			 Backend.AdZone.prototype.hideAddForm();

			 if(this.isContainerEmpty(li, 'edit'))
			 {
			 	return Backend.Router.createUrl('backend.adZone', 'edit', {id: this.getRecordId(li)});
			 }
			 else
			 {
			 	this.toggleContainer(li, 'edit');
			 }
		 },

		 afterEdit:	  function(li, response)
		 {
			 this.getContainer(li, 'edit').update(response);
		 },

		 beforeDelete:   function(li)
		 {
			if (confirm(Backend.getTranslation('_confirm_delete_zone')))
			{
				return Backend.Router.createUrl('backend.adZone', 'delete', {id: this.getRecordId(li)});
			}
		 },

		 afterDelete:	function(li, response)
		 {

		 }
	},

	save: function(form)
	{
		new LiveCart.AjaxRequest(form, null, function(req) { this.saveComplete(form, req); }.bind(this));
	},

	saveComplete: function(form, req)
	{
		var li = form.up('li');
		var cont = this.activeList.getContainer(li, 'edit');
		cont.update('');
		this.activeList.toggleContainerOff(cont);
		li.down('.zoneName').update(req.responseData.name);
		this.activeList.highlight(li);
	},

	add: function(form)
	{
		new LiveCart.AjaxRequest(form, null, function(req) { this.addComplete(form, req); }.bind(this));
	},

	addComplete: function(form, req)
	{
		this.hideAddForm();
		var cont = document.createElement('div');
		cont.innerHTML = req.responseText;
		var id = this.activeList.getRecordId(cont.firstChild);

		this.activeList.addRecord(id, cont.firstChild, true);
	},

	showAddForm: function(e)
	{
		if (e)
		{
			Event.stop(e);
		}

		$('addZoneCancel').show();
		slideForm($('newZone'), $('addZone'));
	},

	hideAddForm: function(e)
	{
		if (e)
		{
			Event.stop(e);
		}

		$('addZoneCancel').hide();
		restoreMenu($('newZone'), $('addZone'));
		$('newZone').down('form').reset();
	}
}

Backend.AdCampaign = function(data)
{
	this.data = data;
	this.container = $('tabUserInfo_' + data.ID + 'Content');
	this.findUsedNodes();
	this.bindEvents();

	// for Discount.js functions
	this.condition = this.data;
}

Backend.AdCampaign.prototype =
{
	controller: 'backend.adCampaign',

	namespace: Backend.AdCampaign,

	findUsedNodes: function()
	{
		this.recordContainer = this.container.down('.recordContainer');

		if (!this.namespace.prototype.recordTemplate)
		{
			this.namespace.prototype.recordTemplate = $('recordTemplate').down('li');
		}
	},

	bindEvents: function()
	{
		Event.observe(this.recordContainer.down('.addConditionCategory'), 'click', this.addCategory.bind(this));
		Event.observe(this.recordContainer.down('.addConditionProduct'), 'click', this.addProduct.bind(this));
		Event.observe(this.recordContainer.down('.addConditionManufacturer'), 'click', this.addManufacturer.bind(this));
	},

	setRecords: function(records)
	{
		records.each(function(record)
		{
			this.createRecord(record);
		}.bind(this));
	},

	add: function(e)
	{
		Event.stop(e);
		var link = Event.element(e);
		new LiveCart.AjaxRequest(link.href, link, this.addComplete.bind(this));
	},

	addComplete: function(req)
	{
		var campaign = req.responseData;
		Backend.AdCampaign.Editor.prototype.open(campaign.ID);
		window.activeGrids['campaign_' + campaign.Advertiser.ID].reloadGrid();
	},

	save: function(form)
	{
		new LiveCart.AjaxRequest(form, null, this.saveComplete.bind(this));
	},

	saveComplete: function(req)
	{
		window.activeGrids['campaign_' + req.responseData.campaign.Advertiser.ID].reloadGrid();
	}
};

['addCategory', 'addProduct', 'addManufacturer', 'addRecord', 'completeAddRecord', 'createRecord', 'deleteRecord', 'completeDeleteRecord'].each(function(a)
{
	Backend.AdCampaign.prototype[a] = Backend.Discount.Condition.prototype[a];
}.bind(this));

Backend.AdCampaign.GridFormatter =
{
	formatValue: function(field, value, id)
	{
		if ('AdCampaign.name' == field)
		{
			if (!this.url)
			{
				this.url = Backend.Router.createUrl('backend.ads', 'index');
			}

			value = '<span><span class="progressIndicator campaignIndicator" id="campaignIndicator_' + id + '" style="display: none;"></span></span>' +
				'<a href="' + this.url + '#campaign_' + id + '" id="campaign_' + id + '" onclick="Backend.AdCampaign.Editor.prototype.open(' + id + ', event); return false;">' +
					 value +
				'</a>';
		}

		return value;
	}
}

Backend.AdCampaign.Editor = function()
{
	this.callConstructor(arguments);
}

Backend.AdCampaign.Editor.methods =
{
	namespace: Backend.AdCampaign.Editor,

	getMainContainerId: function()
	{
		return 'campaignManagerContainer';
	},

	getInstanceContainer: function(id)
	{
		return $("tabUserInfo_" + id + "Content");
	},

	getListContainer: function()
	{
		return $('mainAdvContainer');
	},

	getNavHashPrefix: function()
	{
		return '#campaign_';
	},

	getActiveGrid: function()
	{
		return window.activeGrids["campaign_" + this.owner];
	}
}

Backend.AdCampaign.Editor.inheritsFrom(Backend.MultiInstanceEditor);

Backend.AdCampaign.GridFormatter =
{
	formatValue: function(field, value, id)
	{
		if ('AdCampaign.name' == field)
		{
			if (!this.url)
			{
				this.url = Backend.Router.createUrl('backend.ads', 'index');
			}

			value = '<span><span class="progressIndicator campaignIndicator" id="campaignIndicator_' + id + '" style="display: none;"></span></span>' +
				'<a href="' + this.url + '#campaign_' + id + '" id="campaign_' + id + '" onclick="Backend.AdCampaign.Editor.prototype.open(' + id + ', event); return false;">' +
					 value +
				'</a>';
		}
		else if ('clicks' == field || 'views' == field)
		{
			value = value ? value : 0;
		}
		else if ('ctr' == field)
		{
			value = (Math.round((value ? value : 0) * 100) / 100) + '%';
		}

		return value;
	}
}

/******** Banners ***********/

Backend.AdBanner = function(data)
{
	this.data = data;
	this.container = $('tabBannerInfo_' + data.ID + 'Content');
	this.findUsedNodes();
	this.bindEvents();

	this.typeChanged();
}

Backend.AdBanner.prototype =
{
	controller: 'backend.adBanner',

	namespace: Backend.AdBanner,

	findUsedNodes: function()
	{
		this.uploadFields = [
			this.container.down('.imageField'),
			this.container.down('.flashField'),
			this.container.down('.htmlField')
		];

		this.typeSelect = this.container.down('.typeSelect');
		this.form = this.container.down('form');
		this.previewContainer = this.container.down('.bannerPreview');
	},

	bindEvents: function()
	{
		this.typeSelect.onchange = this.typeChanged.bind(this);
	},

	typeChanged: function()
	{
		this.uploadFields.each(function(field)
		{
			field.hide();
		});

		this.uploadFields[this.typeSelect.value].show();
	},

	add: function(e)
	{
		Event.stop(e);
		var link = Event.element(e);
		new LiveCart.AjaxRequest(link.href, link, this.addComplete.bind(this));
	},

	addComplete: function(req)
	{
		var banner = req.responseData;
		Backend.AdBanner.Editor.prototype.open(banner.ID);
		window.activeGrids['banner_' + banner.Campaign.ID].reloadGrid();
	},

	setPreview: function(node)
	{
		while (this.previewContainer.firstChild)
		{
			this.previewContainer.removeChild(this.previewContainer.firstChild);
		}

		this.previewContainer.appendChild(node);
	},

	saveComplete: function(data, w)
	{
		if (data.errors)
		{
			ActiveForm.prototype.setErrorMessages(this.form, data.errors);
		}
		else
		{
			var preview = w.document.getElementById('preview');
			if (preview)
			{
				this.setPreview(preview);
			}

			parent.window.activeGrids['banner_' + data.banner.Campaign.ID].reloadGrid();
			LiveCart.AjaxRequest.prototype.showConfirmation(data);
		}
	}
};

Backend.AdBanner.Editor = function()
{
	this.callConstructor(arguments);
}

Backend.AdBanner.GridFormatter =
{
	formatValue: function(field, value, id)
	{
		if ('AdBanner.name' == field)
		{
			if (!this.url)
			{
				this.url = Backend.Router.createUrl('backend.ads', 'index');
			}

			value = '<span><span class="progressIndicator bannerIndicator" id="bannerIndicator_' + id + '" style="display: none;"></span></span>' +
				'<a href="' + this.url + '#banner_' + id + '" id="banner_' + id + '" onclick="Backend.AdBanner.Editor.prototype.open(' + id + ', event); return false;">' +
					 value +
				'</a>';
		}
		else if ('clicks' == field || 'views' == field)
		{
			value = value ? value : 0;
		}
		else if ('ctr' == field)
		{
			value = (Math.round((value ? value : 0) * 100) / 100) + '%';
		}

		return value;
	}
}

Backend.AdBanner.Editor.methods =
{
	namespace: Backend.AdBanner.Editor,

	Instances: {},

	getMainContainerId: function()
	{
		return 'bannerManagerContainer';
	},

	getInstanceContainer: function(id)
	{
		return $("tabBannerInfo_" + id + "Content");
	},

	getListContainer: function()
	{
		return $('campaignManagerContainer');
	},

	getNavHashPrefix: function()
	{
		return '#banner_';
	},

	getActiveGrid: function()
	{
		return window.activeGrids["banner_" + this.owner];
	}
}

Backend.AdBanner.Editor.inheritsFrom(Backend.MultiInstanceEditor);