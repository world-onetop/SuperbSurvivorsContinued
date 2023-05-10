require "05_Other/SuperSurvivorManager";
require "07_UI/UIUtils";
require "ISUI/ISLayoutManager"

SurvivorInfoWindow = ISCollapsableWindow:derive("SurvivorInfoWindow");

function CallButtonPressed()
	local GID = SSM:Get(0):getGroupID()
	local members = SSGM:Get(GID):getMembers()

	if (MyGroupWindow) then -- SuperSurvivorMyGroupWindow.lua is initialized AFTER SurviviorInfoWindow because of "require"... so this needs to be checked.
		local selected = tonumber(MyGroupWindow:getSelected())
		local member = members[selected]
		if (member) then
			getSpecificPlayer(0):Say(getActionText("CallName_Before") ..
			member:getName() .. getActionText("CallName_After"))
			member:getTaskManager():AddToTop(ListenTask:new(member, getSpecificPlayer(0), false))
		end
	end
end
function SurvivorInfoWindow:initialise()
	ISCollapsableWindow.initialise(self);
end

function SurvivorInfoWindow:new(x, y, width, height)
	local o = {};
	o = ISCollapsableWindow:new(x, y, width, height);
	setmetatable(o, self);
	self.__index = self;
	o.title = getContextMenuText("SurvivorInfo");
	o.pin = false;
	o:noBackground();
	return o;
end

function SurvivorInfoWindow:setText(newText)
	self.HomeWindow.text = newText;
	self.HomeWindow:paginate();
end

function SurvivorInfoWindow:createChildren()
	local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
	self.HomeWindow = ISRichTextPanel:new(0, FONT_HGT_SMALL + 1, FONT_HGT_SMALL * 6 + 200, FONT_HGT_SMALL * 10 + 500);
	self.HomeWindow:initialise();
	self.HomeWindow.autosetheight = false
	self.HomeWindow:ignoreHeightChange()
	self:addChild(self.HomeWindow)

	self.MyCallButton = ISButton:new(FONT_HGT_SMALL * 7 + 30, FONT_HGT_SMALL + 13, 60, 25, getContextMenuText("CallOver"),
		self, CallButtonPressed);

	self.MyCallButton:setEnable(true);
	self.MyCallButton:initialise();
	--MyCallButton.textureColor.r = 255;
	self.MyCallButton:addToUIManager();
	self:addChild(self.MyCallButton)

	self.MyCallButton:setVisible(true);



	ISCollapsableWindow.createChildren(self);
end

function SurvivorInfoWindow:Load(ASuperSurvivor)
	local newText = getContextMenuText("SurvivorInfoName_Before") ..
	ASuperSurvivor:getName() .. getContextMenuText("SurvivorInfoName_After") .. "\n"
	local player = ASuperSurvivor:Get()
	newText = newText ..
	"(" .. tostring(ASuperSurvivor:getGroupRole()) .. "/" .. ASuperSurvivor:getCurrentTask() .. ")" .. "\n\n"

	for i = 1, GetTableSize(SurvivorPerks) do
		player:getModData().PerkCount = i;
		level = player:getPerkLevel(Perks.FromString(SurvivorPerks[i]));
		if (level ~= nil) and (SurvivorPerks[i] ~= nil) and (level > 0) then
			local display_perk = PerkFactory.getPerkName(Perks.FromString(SurvivorPerks[i]))

			if display_perk == nil then
				display_perk = tostring(SurvivorPerks[i]) .. "?"
			end

			newText = newText ..
			getContextMenuText("Level") ..
			" " .. tostring(level) .. " " .. display_perk .. "\n"                                            ----getText("IGUI_perks_"..SurvivorPerks[i]) .. "\n"
		end
	end

	newText = newText .. "\n"

	newText = newText ..
	getText("Tooltip_food_Hunger") .. ": " .. tostring(math.floor((player:getStats():getHunger() * 100))) .. "\n"
	newText = newText ..
	getText("Tooltip_food_Thirst") .. ": " .. tostring(math.floor((player:getStats():getThirst() * 100))) .. "\n"
	newText = newText .. "Morale: " .. tostring(math.floor(player:getStats():getMorale() * 100)) .. "\n"
	newText = newText .. "Sanity: " .. tostring(math.floor(player:getStats():getSanity() * 100)) .. "\n"
	newText = newText ..
	getText("Tooltip_food_Boredom") .. ": " .. tostring(math.floor(player:getStats():getBoredom() * 100)) .. "\n"
	newText = newText .. "IdleBoredom: " .. tostring(math.floor(player:getStats():getIdleboredom() * 100)) .. "\n"
	newText = newText ..
	getText("Tooltip_food_Unhappiness") ..
	": " .. tostring(math.floor(player:getBodyDamage():getUnhappynessLevel() * 100)) .. "\n"
	newText = newText ..
	getText("Tooltip_Wetness") .. ": " .. tostring(math.floor(player:getBodyDamage():getWetness() * 100)) .. "\n"
	newText = newText ..
	getText("Tooltip_clothing_dirty") .. ": " .. tostring(math.floor(ASuperSurvivor:getFilth() * 100)) .. "\n"


	newText = newText .. "\n"
	local melewepName = getActionText("Nothing")
	local gunwepName = getActionText("Nothing")
	if (ASuperSurvivor.LastMeleUsed ~= nil) then melewepName = ASuperSurvivor.LastMeleUsed:getDisplayName() end
	if (ASuperSurvivor.LastGunUsed ~= nil) then gunwepName = ASuperSurvivor.LastGunUsed:getDisplayName() end
	local phi
	if (player:getPrimaryHandItem() ~= nil) then
		phi = player:getPrimaryHandItem():getDisplayName()
	else
		phi = getActionText("Nothing")
	end

	newText = newText .. getContextMenuText("PrimaryHandItem") .. ": " .. tostring(phi) .. "\n"
	newText = newText .. getContextMenuText("MeleWeapon") .. ": " .. tostring(melewepName) .. "\n"
	newText = newText .. getContextMenuText("GunWeapon") .. ": " .. tostring(gunwepName) .. "\n"
	newText = newText .. getContextMenuText("CurrentTask") .. ": " .. tostring(ASuperSurvivor:getCurrentTask()) .. "\n"
	newText = newText .. "\n"
	newText = newText ..
	getContextMenuText("AmmoCount") .. ": " .. tostring(ASuperSurvivor.player:getModData().ammoCount) .. "\n"
	newText = newText ..
	getContextMenuText("AmmoType") .. ": " .. tostring(ASuperSurvivor.player:getModData().ammotype) .. "\n"
	newText = newText ..
	getContextMenuText("AmmoBoxType") .. ": " .. tostring(ASuperSurvivor.player:getModData().ammoBoxtype) .. "\n"

	newText = newText .. "\n"

	newText = newText .. getContextMenuText("SurvivorID") .. ": " .. tostring(ASuperSurvivor:getID()) .. "\n"
	newText = newText .. getContextMenuText("GroupID") .. ": " .. tostring(ASuperSurvivor:getGroupID()) .. "\n"
	newText = newText .. getContextMenuText("GroupRole") .. ": " .. tostring(ASuperSurvivor:getGroupRole()) .. "\n"
	newText = newText .. "AI mode: " .. tostring(ASuperSurvivor:getAIMode()) .. "\n"

	self:setText(newText)
end

function SurvivorInfoWindowCreate()
	local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
	MySurvivorInfoWindow = SurvivorInfoWindow:new(300, 270, FONT_HGT_SMALL * 6 + 175, FONT_HGT_SMALL * 10 + 500)
	MySurvivorInfoWindow:addToUIManager();
	MySurvivorInfoWindow:setVisible(false);
	MySurvivorInfoWindow.pin = true;
	MySurvivorInfoWindow.resizable = true

	-- build compatibility check---
	local player = getSpecificPlayer(0)
	if (player.setSceneCulled == nil) then -- this function only exists in build 41
		local text = "\n\n\nWARNING!! WARNING!! ERROR!!\n\nSUBPAR SURVIVORS MOD INCOMPATIBLE WITH THIS BUILD! \n\n";
		text = text .. "Please see the TIS forum or Discord to get help changng over to build 41."
		MySurvivorInfoWindow:setVisible(true);
		MySurvivorInfoWindow:setText(text);
	end
end

Events.OnGameStart.Add(SurvivorInfoWindowCreate);
