require "0_Utilities/SuperSurvivorWeaponsList"

-- To-Do: Change OnTickTicks to NPC_SSM_OnTicks , reason is , I don't know if other mods may try to call that variable.
OnTickTicks = 0;
SuperSurvivorSelectAnArea = false;
SuperSurvivorMouseDownTicks = 0;

-- local playerSurvivor = getSpecificPlayer(0); -- WIP not sure why there are so many "getSpecificPlayer(0)" calls when a local variable should work...
-- getSpecificPlayer(0):Say("") -- this is the function call for player character to "say" a text above their head.

function SuperSurvivorsOnTick()
	if (SuperSurvivorSelectAnArea) then
		if (Mouse.isLeftDown()) then
			SuperSurvivorMouseDownTicks = SuperSurvivorMouseDownTicks + 1;
		else
			SuperSurvivorMouseDownTicks = 0;
			SuperSurvivorSelectingArea = 0;
		end

		if (SuperSurvivorMouseDownTicks > 15) then -- 10 acts instant, so a left click would reset the select area finalization.
			if (Highlightcenter == nil) or (not SuperSurvivorSelectingArea) then
				Highlightcenter = getMouseSquare();
				HighlightX1 = getMouseSquareX();
				HighlightX2 = getMouseSquareX();
				HighlightY1 = getMouseSquareY();
				HighlightY2 = getMouseSquareY();
			end

			SuperSurvivorSelectingArea = true

			if (HighlightX1 == nil) or (HighlightX1 > getMouseSquareX()) then HighlightX1 = getMouseSquareX(); end
			if (HighlightX2 == nil) or (HighlightX2 <= getMouseSquareX()) then HighlightX2 = getMouseSquareX(); end
			if (HighlightY1 == nil) or (HighlightY1 > getMouseSquareY()) then HighlightY1 = getMouseSquareY(); end
			if (HighlightY2 == nil) or (HighlightY2 <= getMouseSquareY()) then HighlightY2 = getMouseSquareY(); end
		elseif (SuperSurvivorSelectingArea) then
			SuperSurvivorSelectingArea = false;
			--print("Done:"..tostring(HighlightX1)..","..tostring(HighlightX2).." : "..tostring(HighlightY1)..","..tostring(HighlightY2))
		end

		if (Mouse.isLeftPressed()) then
			SuperSurvivorSelectAreaHOLD = false; -- I did a folder scan, this var doesn't do anything?
			SuperSurvivorSelectingArea = false; -- new
		end


		if (HighlightX1) and (HighlightX2) then
			local x1 = HighlightX1
			local x2 = HighlightX2
			local y1 = HighlightY1
			local y2 = HighlightY2

			for xx = x1, x2 do
				for yy = y1, y2 do
					local sq = getCell():getGridSquare(xx, yy, getSpecificPlayer(0):getZ());

					if (sq) and (sq:getFloor()) then
						sq:getFloor():setHighlighted(true);
					end
				end
			end
		end
	end

	--if getSpecificPlayer(0) ~= nil then getSpecificPlayer(0):Say(tostring(getCell()~= nil) ..",".. tostring(SSM ~= nil) ..",".. tostring(UIManager.isShowPausedMessage()) ..",".. tostring(getGameSpeed()) ) end

	if SSM ~= nil and getGameSpeed() ~= 0 then
		SSM:update();
		OnTickTicks = OnTickTicks + 1;

		if (OnTickTicks % 1000 == 0) then
			SSGM:Save(); -- WIP - console.txt logged an error tracing to this line
			saveSurvivorMap(); -- WIP - console.txt logged an error tracing to this line
		end
	end
end

Events.OnRenderTick.Add(SuperSurvivorsOnTick);


function SuperSurvivorSoldierSpawn(square)
	local ASuperSurvivor = SSM:spawnSurvivor(nil, square);
	ASuperSurvivor:SuitUp("Preset_MarinesCamo");
	ASuperSurvivor:giveWeapon(getWeapon(RangeWeapons[ZombRand(1, #RangeWeapons)]), true);
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));

	return ASuperSurvivor;
end

function SuperSurvivorSoldierSpawnMelee(square)
	local ASuperSurvivor = SSM:spawnSurvivor(nil, square);
	ASuperSurvivor:SuitUp("Preset_MarinesCamo");

	ASuperSurvivor:giveWeapon(getWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)]), true);
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));

	return ASuperSurvivor;
end

function SuperSurvivorSoldierSpawnHostile(square)
	local ASuperSurvivor = SSM:spawnSurvivor(nil, square);
	ASuperSurvivor:SuitUp("Preset_MarinesCamo");

	ASuperSurvivor:giveWeapon(getWeapon(RangeWeapons[ZombRand(1, #RangeWeapons)]), true);
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor:setHostile(true);

	return ASuperSurvivor;
end

function SuperSurvivorSoldierSpawnMeleeHostile(square)
	local ASuperSurvivor = SSM:spawnSurvivor(nil, square);
	ASuperSurvivor:SuitUp("Preset_MarinesCamo");

	ASuperSurvivor:giveWeapon(getWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)]), true);
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
	ASuperSurvivor:setHostile(true);

	return ASuperSurvivor;
end

function SuperSurvivorRandomSpawn(square)
	local hoursSurvived = math.floor(getGameTime():getWorldAgeHours());
	local ASuperSurvivor = SSM:spawnSurvivor(nil, square);
	local FinalChanceToBeHostile = ChanceToBeHostileNPC + math.floor(hoursSurvived / 48);

	if (FinalChanceToBeHostile > MaxChanceToBeHostileNPC) and (ChanceToBeHostileNPC < MaxChanceToBeHostileNPC) then
		-- WIP there is a type warning here... 'MaxChanceToBeHostileNPC' is potentially a boolean rather than a number.
		FinalChanceToBeHostile = MaxChanceToBeHostileNPC;
	end

	if (ASuperSurvivor ~= nil) then
		if (ZombRand(100) < (ChanceToSpawnWithGun + math.floor(hoursSurvived / 48))) then
			ASuperSurvivor:giveWeapon(getWeapon(RangeWeapons[ZombRand(1, #RangeWeapons)]), true)
			-- make sure they have at least some ability to use the gun
			ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
			ASuperSurvivor.player:LevelPerk(Perks.FromString("Aiming"));
		elseif (ZombRand(100) < (ChanceToSpawnWithWep + math.floor(hoursSurvived / 48))) then
			ASuperSurvivor:giveWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)], true);
		end

		if (ZombRand(100) < FinalChanceToBeHostile) then
			ASuperSurvivor:setHostile(true);
		end
	end

	-- clear the immediate area
	local zlist = getCell():getZombieList();

	if (zlist ~= nil) then
		for i = zlist:size() - 1, 0, -1 do
			-- WIP - undeclared 'z' global variable?...
			z = zlist:get(i);

			if (z ~= nil
					and (math.abs(z:getX() - square:getX()) < 2)
					and (math.abs(z:getY() - square:getY()) < 2)
					and (z:getZ() == square:getZ())
				) then
				print("delete zombie " .. z:getX() .. " " .. square:getX() .. " " .. z:getY() .. " " .. square:getY())
				z:removeFromWorld();
			end
		end
	end

	return ASuperSurvivor;
end

function SuperSurvivorsLoadGridsquare(square)
	if (square ~= nil) then
		local x = square:getX();
		local y = square:getY();
		local z = square:getZ();
		local key = x .. y .. z;

		if (SurvivorMap == nil) then
			local sc = 1;
			RPresetSpawns = {};

			while PresetSpawns[sc] do
				if PresetSpawns[sc].Z == nil then
					PresetSpawns[sc].Z = 0;
				end

				local pindex = PresetSpawns[sc].X .. PresetSpawns[sc].Y .. PresetSpawns[sc].Z;
				--print("pindex:"..pindex.." for index: "..sc);
				RPresetSpawns[pindex] = PresetSpawns[sc];
				RPresetSpawns[pindex].ID = sc;
				sc = sc + 1; -- WIP - Why even bother doing a while loop here? it's a single call...
			end
			--print(tostring(sc).." preset survivors set into RPresetSpawns");

			SSM:init();
			SSGM:Load();

			-- WIP - WHAT IS THIS SUPPOSED TO DO?
			-- I don't think we need this now? But Further testing is needed
			local gameVersion = getCore():getGameVersion()
			IsDamageBroken = (gameVersion:getMajor() >= 41 and gameVersion:getMinor() > 50 and gameVersion:getMinor() < 53);
			IsNpcDamageBroken = (gameVersion:getMajor() >= 41 and gameVersion:getMinor() >= 53);

			if IsDamageBroken then
				MaxChanceToBeHostileNPC = 0;
			end

			if IsDamageBroken then
				RaidsStartAfterThisManyHours = 9999999;
			end

			if (DoesFileExist("SurvivorLocX")) then
				SurvivorMap = loadSurvivorMap() -- matrix grid containing info on location of all survivors for re-spawning purposes
				-- print("Survivor map loaded")
			else
				SurvivorMap = {};
				SurvivorLocX = {};
				SurvivorLocY = {};
				SurvivorLocZ = {};
				-- print("Survivor map set")
				-- SuperSurvivorPlayerInit(getSpecificPlayer(0)) move to on create character
			end
		end

		-- WIP - WHAT IS THIS SUPPOSED TO DO?
		if (key) and (SurvivorMap[key] ~= nil) and (#SurvivorMap[key] > 0) then
			local i = 1;
			--table.sort(SurvivorMap[key]);
			while (SurvivorMap[key][i] ~= nil) do
				SSM:LoadSurvivor(SurvivorMap[key][i], square);
				i = i + 1;
			end
			i = 1;
			--while(SurvivorMap[key][i]) do								
			--	table.remove(SurvivorMap[key],SurvivorMap[key][i]);			
			--	i = i + 1;
			--end
			SurvivorMap[key] = {} -- i think this is faster			
		end

		if (square:getModData().SurvivorSquareLoaded == nil)
			and (square:getZ() == 0 or square:isOutside() == false)
			and (not SuperSurvivorPresetSpawn(square))
		then
			SurvivorMap[key] = {}
			square:getModData().SurvivorSquareLoaded = true
			local hoursSurvived = math.floor(getGameTime():getWorldAgeHours())
			if (SuperSurvivorSpawnRate ~= 0) and (ZombRand(SuperSurvivorSpawnRate + hoursSurvived) == 0) and (square:getZoneType() == "TownZone") and (not square:isSolid()) then
				-- NON ALT SPAWNING GROUPS
				if (ZombRand(15) == 0) then -- spawn group
					local hours = getGameTime():getWorldAgeHours();
					local RaiderGroup = SSGM:newGroup();

					if (RaiderGroup:getID() == getSpecificPlayer(0):getModData().Group) then
						RaiderGroup = SSGM:newGroup();
					end

					local GroupSize = ZombRand(2, 5) + math.floor(hours / (24 * 30))
					if (GroupSize > 10) then
						GroupSize = 10;
					end

					if (GroupSize < 2) then
						GroupSize = 2;
					end

					local oldGunSpawnChance = ChanceToSpawnWithGun;
					-- ChanceToSpawnWithGun = ChanceToSpawnWithGun --* 1.5 -- -- WIP - WHAT IS THIS SUPPOSED TO DO? Why was it reassigning itself?
					local groupHostility;
					local Leader;

					for i = 1, GroupSize do
						-- WIP - undeclared 'raider' global variable?...
						raider = SuperSurvivorRandomSpawn(square)
						if (i == 1) then
							RaiderGroup:addMember(raider, "Leader")
							groupHostility = raider.player:getModData().isHostile
							Leader = raider
						else
							RaiderGroup:addMember(raider, "Guard")
							raider:setHostile(groupHostility)
							raider:getTaskManager():AddToTop(FollowTask:new(raider, Leader:Get()))
							--	--mySS:DebugSay("Follow task in survivorsmod lua - Path b")
						end

						if (raider:hasWeapon() == false) then raider:giveWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)]) end
					end
					-- WIP - WHAT IS THIS SUPPOSED TO DO? Why is it reassigning itself?
					ChanceToSpawnWithGun = oldGunSpawnChance;
				else
					SuperSurvivorRandomSpawn(square);
				end
			end
		end
	end
end

Events.LoadGridsquare.Add(SuperSurvivorsLoadGridsquare);


function SuperSurvivorsInit()
	print("GAMESTART!");

	GroupWindowCreate();

	SurvivorsCreatePVPButton()

	AchievementsEnabled = false;

	if (IsoPlayer.getCoopPVP() == true or Option_ForcePVP == 1) then
		SurvivorTogglePVP();
	end

	local player = getSpecificPlayer(0);
	player:getModData().isHostile = false
	player:getModData().ID = 0

	if (player:getX() >= 7679 and player:getX() <= 7680) and (player:getY() >= 11937 and player:getY() <= 11938) then -- if spawn in prizon
		local keyid = player:getBuilding():getDef():getKeyId();

		if (keyid) then
			local key = player:getInventory():AddItem("Base.Key1");
			key:setKeyId(keyid);
			player:getCurrentSquare():getE():AddWorldInventoryItem(key, 0.5, 0.5, 0);
			player:getInventory():Remove(key);
		end
		--PVPDefault = true 	-- true or false : should pvp be on or off at game start true=on false=off
		--ChanceToSpawnWithGun = 100 	-- choose from 0 to 100 (this is a % but dont put a % after the number)
		--ChanceToBeHostileNPC = 100

		local DeadGuardSquare = getCell():getGridSquare(7685, 11937, 1);
		--local DeadGuardSquare = nil
		if (DeadGuardSquare ~= nil) then
			local SuperSurvivorDeadGuard = SSM:spawnSurvivor(false, DeadGuardSquare);
			local DeadGuard = SuperSurvivorDeadGuard.player;

			SuperSurvivorDeadGuard:giveWeapon("Base.Pistol");
			DeadGuard:Kill(nil);
		end
	end
end

Events.OnGameStart.Add(SuperSurvivorsInit)

function SuperSurvivorsOnCharacterCollide(playerOne, PlayerTwo)
	if (playerOne ~= nil) then
		if (playerOne:isNPC()) then
			print("trying to cancel collision p1")
			playerOne:setLastCollidedW(false)
			playerOne:setLastCollidedN(false)
			playerOne:setTripping(false)
		end
	end
	if (playerTwo ~= nil) then
		if (playerTwo:isNPC()) then
			print("trying to cancel collision p2")
			playerTwo:setLastCollidedW(false)
			playerTwo:setLastCollidedN(false)
			playerTwo:setTripping(false)
		end
	end
end

--Events.OnCharacterCollide.Add(SuperSurvivorsOnCharacterCollide)

function SuperSurvivorsOnSwing(player, weapon)
	local ID = player:getModData().ID;

	if (ID ~= nil) then
		local SS = SSM:Get(ID)
		if (SS) and not player:isLocalPlayer() then
			if weapon:isRanged() then
				if weapon:haveChamber() then
					weapon:setRoundChambered(false);
				end
				-- remove ammo, add one to chamber if we still have some
				if weapon:getCurrentAmmoCount() >= weapon:getAmmoPerShoot() then
					if weapon:haveChamber() then
						weapon:setRoundChambered(true);
					end
					weapon:setCurrentAmmoCount(weapon:getCurrentAmmoCount() - weapon:getAmmoPerShoot())
				end
				if weapon:isRackAfterShoot() then -- shotgun need to be rack after each shot to rechamber round
					player:setVariable("RackWeapon", weapon:getWeaponReloadType());
				end
			end

			if (weapon:isRoundChambered()) then
				local range = weapon:getSoundRadius()
				local volume = weapon:getSoundVolume()
				--getWorldSoundManager():addWorldSound(player:getX(), player:getY(), range, volume)
				--AddWorldSound(player,range)
				addSound(player, player:getX(), player:getY(), player:getZ(), range, volume)
				getSoundManager():PlayWorldSound(weapon:getSwingSound(), player:getCurrentSquare(), 0.5, range, 1.0,
					false)

				--print("gunshot sound made!" ..tostring(weapon:getSwingSound())..","..tostring(range))
			end

			player:NPCSetAttack(false)
			player:NPCSetMelee(false)
		elseif (player:isLocalPlayer()) and weapon:isRanged() then
			SSM:GunShotHandle(SS)
		end
	end
end

Events.OnWeaponSwing.Add(SuperSurvivorsOnSwing)

function SuperSurvivorsHotKeyOrder(index)
	local order, isListening
	if (index <= #Orders) then
		order = Orders[index]
		isListening = false
	else --single
		order = Orders[(index - #Orders)]
		isListening = true
	end
	local myGroup = SSM:Get(0):getGroup()
	if (myGroup) then
		local myMembers = myGroup:getMembersInRange(SSM:Get(0):Get(), 25, isListening)
		for i = 1, #myMembers do
			SurvivorOrder(nil, myMembers[i].player, order, nil)
		end
	end
end

function SuperSurvivorTest(ob1)
	local o = ob1
	local stop
	stop:now()
end

Events.OnAIStateChange:Add(SuperSurvivorTest)

-- Cows: Who thought it was a good idea to use numeric keys as the keybinding for orders? By default, the numeric keys were used for quick access to slot items...
-- WIP - Whoever wrote this function didn't consider the keybinding issues... This needs to be rewritten.
function supersurvivortemp(keyNum)
	if (getSpecificPlayer(0)) then
		getSpecificPlayer(0):Say(tostring(GlobalTestVariable));
		getSpecificPlayer(0):Say(tostring(GFollowDistance));

		if (keyNum == getCore():getKey("Spawn Wild Survivor")) then -- the 6 key
			--SuperSurvivorsRaiderManager()

			--if DebugOptions == true then -- This should prevent the infamous 6 key spawning
			local ss = SuperSurvivorRandomSpawn(getSpecificPlayer(0):getCurrentSquare())
			--end
		elseif (keyNum == getCore():getKey("Raise Follow Distance")) then
			if (GFollowDistance ~= 50) then GFollowDistance = GFollowDistance + 1 end
			getSpecificPlayer(0):Say("Spread out more(" .. tostring(GFollowDistance) .. ")")
		elseif (keyNum == getCore():getKey("Lower Follow Distance")) then
			if (GFollowDistance ~= 0) then GFollowDistance = GFollowDistance - 1 end
			getSpecificPlayer(0):Say("Stay closer(" .. tostring(GFollowDistance) .. ")")
		elseif (keyNum == 0) then
			local attacker = getSpecificPlayer(0)
			local victim = getSpecificPlayer(0)
			local weapon = attacker:getPrimaryHandItem()
			local angle = getSpecificPlayer(0):getAngle()
			local dir = IsoDirections.fromAngle(angle)
			dir = IsoDirections.reverse(dir)
			getSpecificPlayer(0):Say("reverse facing dir is: " .. tostring(dir))

			local victimSquare1 = getSpecificPlayer(0):getCurrentSquare()
			local victimSquare2 = victimSquare1:getTileInDirection(dir)
			local coveredFire = false
			for q = 1, 2 do
				local objs
				if q == 1 then
					objs = victimSquare2:getObjects()
				else
					objs = victimSquare1:getObjects()
				end

				local aimingPerk = attacker:getPerkLevel(Perks.Aiming)
				local hitChance = weapon:getHitChance() + weapon:getAimingPerkHitChanceModifier() * aimingPerk
				local movePenalty = attacker:getBeenMovingFor() - (weapon:getAimingTime() + aimingPerk * 2)
				if movePenalty < 0 then movePenalty = 0 end
				if attacker:HasTrait("Marksman") then hitChance = hitChance + 20 end

				for i = 1, objs:size() do
					if (objs:get(i)) then
						if ZombRand(100) > getCoverValue(objs:get(i)) then
							coveredFire = true
							break
						end
						--getSpecificPlayer(0):Say(tostring(objs:get(i):getObjectName()))
					end
				end
				if (coveredFire) then break end
			end

			getSpecificPlayer(0):Say(tostring(coveredFire))
		elseif (keyNum == getCore():getKey("Call Closest Non-Group Member")) then
			local mySS = SSM:Get(0)

			local SS = SSM:GetClosestNonParty()
			if (SS) then
				mySS:Speak(GetDialogue("HeyYou"))
				SS:getTaskManager():AddToTop(ListenTask:new(SS, mySS:Get(), false))
			end
		elseif (keyNum == getCore():getKey("Toggle Group Window")) then
			-- Old menu.
			--myGroupWindow:setVisible(not myGroupWindow:getIsVisible())
			--if(myGroupWindow:getIsVisible()) then myGroupWindow:Update()
			--else mySurvivorInfoWindow:setVisible(false) end
			window_super_survivors_visibility()
		elseif (keyNum == getCore():getKey("Ask Closest Group Member to Follow")) then
			local mySS = SSM:Get(0)
			if (mySS:getGroupID() ~= nil) then
				local myGroup = SSGM:Get(mySS:getGroupID())
				if (myGroup ~= nil) then
					local member = myGroup:getClosestMember(nil, mySS:Get())
					if (member) then
						mySS:Get():Say(getActionText("ComeWithMe_Before") ..
							member:Get():getForname() .. getActionText("ComeWithMe_After"))
						member:getTaskManager():clear()
						member:getTaskManager():AddToTop(FollowTask:new(member, mySS:Get()))
						--mySS:DebugSay("Follow Task triggered in supersurvivorsmod - path a")
					else
						--print("getClosestMember returned nil")
					end
				else
					--mySS:DebugSay("no group")
					--print("cant call close member bc no group for player detected")
				end
			end
		elseif (keyNum == getCore():getKey("Call Closest Group Member")) then -- t key
			local mySS = SSM:Get(0)
			if (mySS:getGroupID() ~= nil) then
				local myGroup = SSGM:Get(mySS:getGroupID())
				if (myGroup ~= nil) then
					local member = myGroup:getClosestMember(nil, mySS:Get())
					if (member) then
						mySS:Get():Say(member:Get():getForname() .. ", come here.")
						member:getTaskManager():AddToTop(ListenTask:new(member, mySS:Get(), false))
					else
						--print("getClosestMember returned nil")
					end
				else
					--mySS:DebugSay("no group")
					--print("cant call close member bc no group for player detected")
				end
			end
		elseif (keyNum == 1) then -- esc key
			--getSpecificPlayer(0):save()
			SSM:SaveAll()
			SSGM:Save()
			saveSurvivorMap() -- WIP - console.txt logged an error tracing to this line

			-- The 'key' in markouts are the default keys befor a player changes them
		elseif (keyNum == getCore():getKey("SSHotkey_1")) then -- Up key
			local index = SuperSurvivorGetOption("SSHotkey1")
			SuperSurvivorsHotKeyOrder(index)
		elseif (keyNum == getCore():getKey("SSHotkey_2")) then -- Down key
			local index = SuperSurvivorGetOption("SSHotkey2")
			SuperSurvivorsHotKeyOrder(index)
		elseif (keyNum == getCore():getKey("SSHotkey_3")) then -- Left key
			local index = SuperSurvivorGetOption("SSHotkey3")
			SuperSurvivorsHotKeyOrder(index)
		elseif (keyNum == getCore():getKey("SSHotkey_4")) then -- Right key
			local index = SuperSurvivorGetOption("SSHotkey4")
			SuperSurvivorsHotKeyOrder(index)
		elseif (keyNum == 0) then
			local SS = SSM:Get(0);
			local Group = SS:getGroup();

			local storagecontainer = Group:getGroupAreaContainer("FoodStorageArea")
			local dest
			if (storagecontainer) then
				dest = storagecontainer
			else
				dest = Group:getGroupAreaCenterSquare("FoodStorageArea")
			end
			if (not dest) then dest = self.parent.player:getCurrentSquare() end


			if (storagecontainer) then
				getSpecificPlayer(0):Say(tostring(storagecontainer));
				GTask = CleanInvTask:new(SS, dest, false);
			else

			end
		elseif (keyNum == 0) then
			getSpecificPlayer(0):Say(tostring("updating"));
			GTask:update();
		end
	end
end

Events.OnKeyPressed.Add(supersurvivortemp);


function SuperSurvivorsOnEquipPrimary(player, weapon)
	if (player:isLocalPlayer() == false) then
		local ID = player:getModData().ID
		local SS = SSM:Get(ID)
		if (SS == nil) then return false end
		SS.UsingFullAuto = false

		if (weapon ~= nil) and (instanceof(weapon, "HandWeapon")) then
			SS.AttackRange = ((player:getPrimaryHandItem():getMaxRange() + player:getPrimaryHandItem():getMinRange()) * 0.60)

			if (weapon:isAimedFirearm()) then
				local ammotypes = getAmmoBullets(weapon, false);

				if (ammotypes ~= nil) and (ID ~= nil) then
					SS.AmmoTypes = ammotypes
					player:getModData().ammotype = "";
					player:getModData().ammoBoxtype = "";

					for i = 1, #SS.AmmoTypes do
						SS.AmmoBoxTypes[i] = getAmmoBox(SS.AmmoTypes[i])
						player:getModData().ammotype = player:getModData().ammotype .. " " .. SS.AmmoTypes[i]
						player:getModData().ammoBoxtype = player:getModData().ammoBoxtype .. " " .. SS.AmmoBoxTypes[i]
					end

					SS.LastGunUsed = weapon;
				end
			end
		end
	end
end

Events.OnEquipPrimary.Add(SuperSurvivorsOnEquipPrimary);

-- ALT SPAWNING
function SuperSurvivorsNewSurvivorManager()
	-- To make sure if the player has chosen not to use Alt spawning
	if (AlternativeSpawning == 1) or (getSpecificPlayer(0):isAsleep()) then
		return false
	end

	local hoursSurvived = math.floor(getGameTime():getWorldAgeHours())

	local FinalChanceToBeHostile = ChanceToBeHostileNPC + math.floor(hoursSurvived / 48)
	if (FinalChanceToBeHostile > MaxChanceToBeHostileNPC) and (ChanceToBeHostileNPC < MaxChanceToBeHostileNPC) then
		FinalChanceToBeHostile = MaxChanceToBeHostileNPC;
	end

	if (getSpecificPlayer(0) == nil) then return false end
	--this unrelated to raiders but need this to run every once in a while
	getSpecificPlayer(0):getModData().hitByCharacter = false;
	getSpecificPlayer(0):getModData().semiHostile = false;
	getSpecificPlayer(0):getModData().dealBreaker = nil;

	if (getSpecificPlayer(0):isAsleep()) then
		SSM:AsleepHealAll();
	end

	--	if(getSpecificPlayer(0):getModData().LastRaidTime == nil) then getSpecificPlayer(0):getModData().LastRaidTime = (RaidsStartAfterThisManyHours + 2) end

	--	local LastRaidTime = getSpecificPlayer(0):getModData().LastRaidTime

	local mySS = SSM:Get(0)
	--local hours = math.floor(getGameTime():getWorldAgeHours())
	--local chance = RaidChanceForEveryTenMinutes
	--if(mySS ~= nil and not mySS:isInBase()) then
	--	chance = (RaidChanceForEveryTenMinutes*1.5)
	--end

	--local RaidersStartTimePassed = (hours >= RaidsStartAfterThisManyHours)
	--local RaiderResult = (ZombRand(chance) == 0)
	--local RaiderAtLeastTimedExceeded = ((hours - LastRaidTime) >= RaidsAtLeastEveryThisManyHours)
	--local RaiderAtLeastTimedExceeded = ((hours - LastRaidTime) >= 1) -- The timer will now not care

	--	if RaidersStartTimePassed and ( RaiderResult or RaiderAtLeastTimedExceeded ) and mySS ~= nil then

	local hisGroup = mySS:getGroup()

	if (hisGroup == nil) then return false end

	local bounds = hisGroup:getBounds()
	local center
	if (bounds) then center = getCenterSquareFromArea(bounds[1], bounds[2], bounds[3], bounds[4], bounds[5]) end
	if not center then center = getSpecificPlayer(0):getCurrentSquare() end

	local spawnSquare

	local success = false
	local range = 45
	local drange = range * 2

	for i = 1, 10 do
		local spawnLocation = ZombRand(4)
		if (spawnLocation == 0) then
			--mySS:Speak("spawn from north")
			x = center:getX() + (ZombRand(drange) - range);
			y = center:getY() - range;
		elseif (spawnLocation == 1) then
			--mySS:Speak("spawn from east")
			x = center:getX() + range;
			y = center:getY() + (ZombRand(drange) - range);
		elseif (spawnLocation == 2) then
			--mySS:Speak("spawn from south")
			x = center:getX() + (ZombRand(drange) - range);
			y = center:getY() + range;
		elseif (spawnLocation == 3) then
			--mySS:Speak("spawn from west")
			x = center:getX() - range;
			y = center:getY() + (ZombRand(drange) - range);
		end

		spawnSquare = getCell():getGridSquare(x, y, 0)

		if (spawnSquare ~= nil) and (not hisGroup:IsInBounds(spawnSquare)) and spawnSquare:isOutside() and (not spawnSquare:IsOnScreen()) and (not spawnSquare:isSolid()) and (spawnSquare:isSolidFloor()) then
			success = true
			break
		end
	end


	if (success) and (spawnSquare) then
		-- ALT SPAWNING SECTION --
		-- SURVIVOR, NON RAIDER SPAWNING
		local RaiderGroup = SSGM:newGroup()
		local GroupSize = ZombRand(1, AltSpawnGroupSize)

		if (GroupSize > AltSpawnGroupSize) then
			GroupSize = AltSpawnGroupSize
		elseif (GroupSize < 1) then
			GroupSize = 1
		end

		-- Since the options update 0-100 , this may need changing
		local oldGunSpawnChance = ChanceToSpawnWithGun
		ChanceToSpawnWithGun    = ChanceToSpawnWithGun --* 1.5

		for i = 1, GroupSize do
			raider = SuperSurvivorRandomSpawn(spawnSquare)
			--if(i == 1) then RaiderGroup:addMember(raider,"Leader")
			--else RaiderGroup:addMember(raider,"Guard") end

			-- Updated so alt spawns can decide to be hostile or not.
			if (ZombRand(100) < FinalChanceToBeHostile) then
				raider:setHostile(true)
			else
				raider:setHostile(false)
			end

			-- raider:setHostile(false)
			raider.player:getModData().isRobber = false
			local name = raider:getName()
			-- raider:setName("Raider "..name)
			raider:setName("Survivor " .. name)
			raider:getTaskManager():AddToTop(WanderTask:new(raider))
			if (raider:hasWeapon() == false) then raider:giveWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)]) end

			local food, bag
			bag = raider:getBag()
			local count = ZombRand(0, 3)
			for i = 1, count do
				food = "Base." .. tostring(CannedFoods[ZombRand(#CannedFoods) + 1])
				bag:AddItem(food)
			end
			local count = ZombRand(0, 3)
			for i = 1, count do
				food = "Base.TinnedBeans"
				bag:AddItem(food)
			end

			--local number = ZombRand(1,3)
			--setRandomSurvivorSuit(raider,"Rare","Bandit"..tostring(number))

			GetRandomSurvivorSuit(raider) -- Even if it says 'raider' it's not giving raider outfits
		end
		ChanceToSpawnWithGun = oldGunSpawnChance
		RaiderGroup:AllSpokeTo()
	end
end

function SuperSurSurvivorSpawnGenFivePercent()
	if (AlternativeSpawning == 2) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenTenPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenTenPercent said no. AlternativeSpawning was not 1 ('2')")
		return false
	end
end

function SuperSurSurvivorSpawnGenTenPercent()
	if (AlternativeSpawning == 3) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenTenPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenTenPercent said no. AlternativeSpawning was not 2 ('3')")
		return false
	end
end

function SuperSurSurvivorSpawnGenTwentyPercent()
	if (AlternativeSpawning == 4) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenTwentyPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenTwentyPercent said no. AlternativeSpawning was not 3 ('4')")
		return false
	end
end

function SuperSurSurvivorSpawnGenThirtyPercent()
	if (AlternativeSpawning == 5) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenThirtyPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenThirtyPercent said no. AlternativeSpawning was not 4 ('5')")
		return false
	end
end

function SuperSurSurvivorSpawnGenFourtyPercent()
	if (AlternativeSpawning == 6) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenFourtyPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenFourtyPercent said no. AlternativeSpawning was not 5 ('6') ")
		return false
	end
end

function SuperSurSurvivorSpawnGenFiftyPercent()
	if (AlternativeSpawning == 7) then
		SuperSurvivorsNewSurvivorManager()
		print("SuperSurSurvivorSpawnGenFiftyPercent said yes.")
	else
		print("SuperSurSurvivorSpawnGenFiftyPercent said no. AlternativeSpawning was not 6 ('7') ")
		return false
	end
end

-- Debug version
function SuperSurvivorDoRandomSpawns()
	if (DebugOptions == true) then
		local RealAlternativeSpawning = AlternativeSpawning - 1
		for i = RealAlternativeSpawning, 1, -1
		do -- It will run through these only so many times depending on the options itself. Should reduce lag.
			print("---------------- SuperSurvivorDoRandomSpawns() START  -----------------------")
			print("")
			print("")
			print("")
			print("AltSpawnPercent			=	" .. tostring(AltSpawnPercent))
			print("i _________________ 	=	" .. tostring(i))
			print("")
			print(
				"This may not give true answers, it's testing ZombRand and how it works. To see if EVERY time it's called does it create a new one, EVEN in a For i = 1 do scenario. So don't fall for if it 'fails' or 'passes'. It's testing RANDOM.")
			print("")
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 2) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 2) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 2) Fail: " ..
					tostring(ZombRand(100)))
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 3) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 3) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 3) Fail: " ..
					tostring(ZombRand(100)))
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 4) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 4) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 4) Fail: " ..
					tostring(ZombRand(100)))
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 5) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 5) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 5) Fail: " ..
					tostring(ZombRand(100)))
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 6) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 6) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 6) Fail: " ..
					tostring(ZombRand(100)))
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning >= 7) then
				print(
					"Testing a ZombRand AltSpawnPercent and (AlternativeSpawning >= 7) Pass: " .. tostring(ZombRand(100)))
			else
				print("Testing a ZombRand AltSpawnPercent - 1 and (AlternativeSpawning >= 7) Fail: " ..
					tostring(ZombRand(100)))
			end
			print("")
			print("")
			print("")
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 2) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFivePercent() 	(==true==)")
				SuperSurSurvivorSpawnGenFivePercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFivePercent() 		(=false=)")
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 3) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenTenPercent() 		(==true==)")
				SuperSurSurvivorSpawnGenTenPercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenTenPercent() 		(=false=)")
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 4) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenTwentyPercent() 	(==true==)")
				SuperSurSurvivorSpawnGenTwentyPercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenTwentyPercent() 	(=false=)")
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 5) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenThirtyPercent() 	(==true==)")
				SuperSurSurvivorSpawnGenThirtyPercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenThirtyPercent() 	(=false=)")
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 6) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFourtyPercent() 	(==true==)")
				SuperSurSurvivorSpawnGenFourtyPercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFourtyPercent() 	(=false=)")
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 7) then
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFiftyPercent()	(==true==)")
				SuperSurSurvivorSpawnGenFiftyPercent()
			else
				print(tostring(AltSpawnPercent) ..
					" - altspawnpercent, i = " .. tostring(i) .. " SuperSurSurvivorSpawnGenFiftyPercent()		(=false=)")
			end
			print("")
			print("")
			print("")
			print("---------------- SuperSurvivorDoRandomSpawns() FINISH -----------------------")
		end
	else -- if (DebugOptions == false)
		local RealAlternativeSpawning = AlternativeSpawning - 1
		for i = RealAlternativeSpawning, 1, -1
		do
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 2) then SuperSurSurvivorSpawnGenFivePercent() end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 3) then SuperSurSurvivorSpawnGenTenPercent() end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 4) then
				SuperSurSurvivorSpawnGenTwentyPercent()
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 5) then
				SuperSurSurvivorSpawnGenThirtyPercent()
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 6) then
				SuperSurSurvivorSpawnGenFourtyPercent()
			end
			if (AltSpawnPercent > ZombRand(100)) and (AlternativeSpawning == 7) then SuperSurSurvivorSpawnGenFiftyPercent() end
		end
	end
end

Events.EveryHours.Add(SuperSurvivorDoRandomSpawns);
-- Yes the variables have 'percent' in the name, that's because before this version, I had made alt spawning work different.
-- Do not be confused, the naming scheme means nothing here.

function SuperSurvivorsRaiderManager()
	if (getSpecificPlayer(0) == nil) then return false end
	--this unrelated to raiders but need this to run every once in a while
	getSpecificPlayer(0):getModData().hitByCharacter = false
	getSpecificPlayer(0):getModData().semiHostile = false
	getSpecificPlayer(0):getModData().dealBreaker = nil

	if (getSpecificPlayer(0):isAsleep()) then
		SSM:AsleepHealAll()
	end
	--end

	if (getSpecificPlayer(0):getModData().LastRaidTime == nil) then getSpecificPlayer(0):getModData().LastRaidTime = (RaidsStartAfterThisManyHours + 2) end
	local LastRaidTime = getSpecificPlayer(0):getModData().LastRaidTime

	--rediculous amount of raiders ---
	--RaidsAtLeastEveryThisManyHours = 1
	--RaidsStartAfterThisManyHours = 0
	--RaidChanceForEveryTenMinutes = 4
	--rediculous amount of raiders ---	END

	local mySS = SSM:Get(0)
	local hours = math.floor(getGameTime():getWorldAgeHours())
	local chance = RaidChanceForEveryTenMinutes
	if (mySS ~= nil and not mySS:isInBase()) then
		chance = (RaidChanceForEveryTenMinutes * 1.5)
	end

	local RaidersStartTimePassed = (hours >= RaidsStartAfterThisManyHours)
	local RaiderResult = (ZombRand(chance) == 0)
	local RaiderAtLeastTimedExceeded = ((hours - LastRaidTime) >= RaidsAtLeastEveryThisManyHours)

	print("Last raid time is: " .. tostring(LastRaidTime) .. ". Current time is:" .. tostring(hours))
	print("Raiders start time is passed?: " .. tostring(RaidersStartTimePassed))
	print("chance for raiders is 1 in " .. tostring(chance) .. " result is " .. tostring(RaiderResult))
	print("At least this many days (" ..
		tostring(RaidsAtLeastEveryThisManyHours) .. ") time exceeded: " .. tostring(RaiderAtLeastTimedExceeded))

	if RaidersStartTimePassed and (RaiderResult or RaiderAtLeastTimedExceeded) and mySS ~= nil then
		local hisGroup = mySS:getGroup()

		if (hisGroup == nil) then return false end

		local bounds = hisGroup:getBounds()
		local center
		if (bounds) then center = getCenterSquareFromArea(bounds[1], bounds[2], bounds[3], bounds[4], bounds[5]) end
		if not center then center = getSpecificPlayer(0):getCurrentSquare() end

		local spawnSquare

		local success = false
		local range = 45
		local drange = range * 2

		for i = 1, 10 do
			local spawnLocation = ZombRand(4)
			if (spawnLocation == 0) then
				--mySS:Speak("spawn from north")
				x = center:getX() + (ZombRand(drange) - range);
				y = center:getY() - range;
			elseif (spawnLocation == 1) then
				--mySS:Speak("spawn from east")
				x = center:getX() + range;
				y = center:getY() + (ZombRand(drange) - range);
			elseif (spawnLocation == 2) then
				--mySS:Speak("spawn from south")
				x = center:getX() + (ZombRand(drange) - range);
				y = center:getY() + range;
			elseif (spawnLocation == 3) then
				--mySS:Speak("spawn from west")
				x = center:getX() - range;
				y = center:getY() + (ZombRand(drange) - range);
			end

			spawnSquare = getCell():getGridSquare(x, y, 0)

			if (spawnSquare ~= nil) and (not hisGroup:IsInBounds(spawnSquare)) and spawnSquare:isOutside() and (not spawnSquare:IsOnScreen()) and (not spawnSquare:isSolid()) and (spawnSquare:isSolidFloor()) then
				success = true
				break
			end
		end


		if (success) and (spawnSquare) then
			getSpecificPlayer(0):getModData().LastRaidTime = hours
			if (getSpecificPlayer(0):isAsleep()) then
				getSpecificPlayer(0):Say(GetDialogue("IGotABadFeeling"))
				getSpecificPlayer(0):forceAwake()
			else
				getSpecificPlayer(0):Say(GetDialogue("WhatWasThatSound"));
			end
			-- RAIDER GROUPS
			local RaiderGroup = SSGM:newGroup()
			local GroupSize = ZombRand(1, hisGroup:getMemberCount()) + math.floor(hours / (24 * 30))
			if (GroupSize > 10) then
				GroupSize = 10
			elseif (GroupSize < 2) then
				GroupSize = 2
			end
			local oldGunSpawnChance = ChanceToSpawnWithGun
			ChanceToSpawnWithGun = ChanceToSpawnWithGun --* 1.5
			print("raider group size:" .. tostring(GroupSize))
			for i = 1, GroupSize do
				print("Creating Raider...")
				raider = SuperSurvivorRandomSpawn(spawnSquare)
				if (i == 1) then
					RaiderGroup:addMember(raider, "Leader")
				else
					RaiderGroup:addMember(raider, "Guard")
				end
				raider:setHostile(true)
				raider.player:getModData().isRobber = true
				local name = raider:getName()
				raider:setName("Raider " .. name)
				raider:getTaskManager():AddToTop(PursueTask:new(raider, mySS:Get()))
				if (raider:hasWeapon() == false) then raider:giveWeapon(MeleWeapons[ZombRand(1, #MeleWeapons)]) end

				local food, bag
				bag = raider:getBag()
				local count = ZombRand(0, 3)
				for i = 1, count do
					food = "Base.CannedCorn"
					bag:AddItem(food)
				end
				local count = ZombRand(0, 3)
				for i = 1, count do
					food = "Base.Apple"
					bag:AddItem(food)
				end

				local number = ZombRand(1, 3)
				setRandomSurvivorSuit(raider, "Rare", "Bandit" .. tostring(number))
			end
			ChanceToSpawnWithGun = oldGunSpawnChance
			RaiderGroup:AllSpokeTo()
		end
	end
end

Events.EveryTenMinutes.Add(SuperSurvivorsRaiderManager);
NumberOfLocalPlayers = 0;

function SSCreatePlayerHandle(newplayerID)
	local newplayer = getSpecificPlayer(newplayerID)

	print("OnCreatePlayer event triggered in Super Survivors ID:" .. tostring(newplayerID))

	local MD = newplayer:getModData()

	if (not MD.ID) and (newplayer:isLocalPlayer()) then
		SuperSurvivorPlayerInit(newplayer)

		if (getSpecificPlayer(0) and (not getSpecificPlayer(0):isDead()) and (getSpecificPlayer(0) ~= newplayer)) then
			local MainSS = SSM:Get(0);
			local MainSSGroup = MainSS:getGroup()

			NumberOfLocalPlayers = NumberOfLocalPlayers + 1

			local newSS = SSM:setPlayer(newplayer, NumberOfLocalPlayers)
			newSS:setID(NumberOfLocalPlayers)

			print("new survivor ID is " .. tostring(newSS:getID()))

			MainSSGroup:addMember(newSS, "Guard");
		end
	end
end

local stringTest = "localStringTest";

Events.OnCreatePlayer.Add(SSCreatePlayerHandle)

-- DEBUG FUNCTIONS BELOW, COMMENT OUT AS NEEDED.
function SuperSurvivorSays1()
	getSpecificPlayer(0):Say(GFollowDistance);
end

-- DEBUG FUNCTIONS BELOW, COMMENT OUT AS NEEDED.
function SuperSurvivorSays2()
	getSpecificPlayer(0):Say(SpeakEnabled);
end

-- DEBUG FUNCTIONS BELOW, COMMENT OUT AS NEEDED.
function SuperSurvivorSays3()
	getSpecificPlayer(0):Say(GlobalTestVariable);
end

-- DEBUG FUNCTIONS BELOW, COMMENT OUT AS NEEDED.
function SuperSurvivorSays4()
	getSpecificPlayer(0):Say(stringTest);
end

-- Events.OnKeyPressed.Add(SuperSurvivorSays1);
-- Events.OnKeyPressed.Add(SuperSurvivorSays2);
-- Events.OnKeyPressed.Add(SuperSurvivorSays3);
-- Events.OnKeyPressed.Add(SuperSurvivorSays4);

function SuperSurvivorOnCreateLivingChar(character)
	print("OnCreateLivingChar:" .. tostring(character))
	if (instanceof(character, "IsoZombie")) then
		print("It's a zombie!")
	end
end

Events.OnCreateLivingCharacter.Add(SuperSurvivorOnCreateLivingChar)