----------------------------------------------------------------------
-- 	Leatrix Plus 3.3.5
-- 	Last updated: 1st April 2023
----------------------------------------------------------------------

----------------------------------------------------------------------
-- 	L00: Codex
----------------------------------------------------------------------

	--	01: Locks					Option panel control locking mechanism
	--	02: Restarts				Options which require a UI reload
	--	03: Functions				Various functions used throughout the addon
	--	04: Load and Save			Handles loading and saving of the settings

	--	20: Live					Options that run after ADDON_LOADED and when an option changes
	--	21: Isolated environment	Options that run after ADDON_LOADED
	--	22: Variable				Options that run after VARIABLES_LOADED
	--	23: Player					Options that run after PLAYER_ENTERING_WORLD	
	--	24: BlizzDep				Options that run after a required Blizzard addon has loaded
	--	30: RunOnce					Generic code that runs after the Isolated Environment
	--  31: Events					Code that runs when a specific event fires

	--	32: Slash commands			Slash command parser function
	--	40: Panel definitions		Template functions for creating options panel pages
	--	41: Panel template			Template for entire options panel
	--	42: Panel buttons			Buttons used in the options panel
	--	50+ Panel pages				Pages used in the options panel
	--	5H: Panel options page		Settings page used in the options panel

----------------------------------------------------------------------
-- 	Addon code
----------------------------------------------------------------------

--  Make the saved variables file if it doesn't exist
	if not LeaPlusDB then LeaPlusDB = {} end

-- 	Create local tables to store configuration and frames
	local LeaPlusLC = {}
	local LeaPlusCB = {}

--	Initialise variables
	LeaPlusLC["ShowErrorsFlag"] = 1
	LeaPlusLC["NumberOfPages"] = 8
	LeaPlusLC["PlayerLocale"] = GetLocale()
	LeaPlusLC["PlayerClass"] = (select(2,UnitClass("player")))
	LeaPlusLC["PlayerName"] = (UnitName("player"))
	LeaPlusLC["GameVer"] = strsub(select(4, GetBuildInfo()),1,1)
	LeaPlusLC["PlusVersion"] = (GetAddOnMetadata("Leatrix_Plus", "Version"))

--	Create dungeon spam array
	LeaPlusLC["InterruptSpamTable"] = {"gag order", "dispel", "rallying cry", "shield wall", "avenger", "divine protection", "interrupted", "taunt", "activate", "mind freeze", "rebuke", "bash", "pummel", "silence", "counterspell", "wind shear", "spell lock", "salvation", "strangulate", "purge"}
	LeaPlusLC["InterruptSpamTip"] = "\n"
	for k,v in pairs(LeaPlusLC["InterruptSpamTable"]) do
		LeaPlusLC["InterruptSpamTip"] = LeaPlusLC["InterruptSpamTip"] .. "\n" .. LeaPlusLC["InterruptSpamTable"][k]
	end

--	Create event frame
	local LpEvt = CreateFrame("FRAME");
	LpEvt:RegisterEvent("ADDON_LOADED");
	LpEvt:RegisterEvent("VARIABLES_LOADED");
	LpEvt:RegisterEvent("PLAYER_ENTERING_WORLD");
	LpEvt:RegisterEvent("PLAYER_LOGOUT");

----------------------------------------------------------------------
--	L01: Locks
----------------------------------------------------------------------

-- 	Lock and unlock individual items
	function LeaPlusLC:LockItem(item,lock)
		if lock then
			item:Disable()
			item:SetAlpha(0.3)
		else
			item:Enable()
			item:SetAlpha(1.0)
		end
	end

--	Lock and dim invalid options
	function LeaPlusLC:SetDim()

		-- Player chains
		if (LeaPlusLC["ShowElitePlayerChain"] ~= LeaPlusDB["ShowElitePlayerChain"]) or LeaPlusLC["ShowElitePlayerChain"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["ShowRarePlayerChain"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["ShowRarePlayerChain"],false)
		end

		-- Tooltip scale slider
		if not (LeaPlusLC["TipModEnable"] == LeaPlusDB["TipModEnable"]) or LeaPlusLC["TipScaleCheck"] == "Off" or LeaPlusLC["TipModEnable"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusTipSize"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusTipSize"],false)
		end

		-- Frame options
		if not (LeaPlusLC["FrmEnabled"] == LeaPlusDB["FrmEnabled"]) or LeaPlusLC["FrmEnabled"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["MoveFramesButton"],true)
			LeaPlusLC:LockItem(LeaPlusCB["ResetFramesButton"],true)
			LeaPlusLC:LockItem(LeaPlusCB["RefreshFramesButton"],true)
		elseif LeaPlusLC["FrmEnabled"] == "On" then
			LeaPlusLC:LockItem(LeaPlusCB["MoveFramesButton"],false)
			LeaPlusLC:LockItem(LeaPlusCB["ResetFramesButton"],false)
			LeaPlusLC:LockItem(LeaPlusCB["RefreshFramesButton"],false)
		end

		-- Tooltip options
		if not (LeaPlusLC["TipModEnable"] == LeaPlusDB["TipModEnable"]) or LeaPlusLC["TipModEnable"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["TipShowTitle"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRank"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRace"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowTarget"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowMobType"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowClass"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRealm"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackSimple"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackFriend"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackHostile"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipAnchorToMouse"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipScaleCheck"],true)
			LeaPlusLC:LockItem(LeaPlusCB["TipHideInCombat"],true)
			LeaPlusLC:LockItem(LeaPlusCB["MoveTooltipButton"],true)
			LeaPlusLC:LockItem(LeaPlusCB["ResetTooltipButton"],true)

		elseif LeaPlusLC["TipModEnable"] == "On" then

			LeaPlusLC:LockItem(LeaPlusCB["TipShowTitle"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRank"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRace"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowTarget"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowMobType"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowClass"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipShowRealm"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackSimple"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackFriend"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipBackHostile"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipAnchorToMouse"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipScaleCheck"],false)
			LeaPlusLC:LockItem(LeaPlusCB["TipHideInCombat"],false)
			LeaPlusLC:LockItem(LeaPlusCB["MoveTooltipButton"],false)
			LeaPlusLC:LockItem(LeaPlusCB["ResetTooltipButton"],false)

		end

		-- Quest detail font slider lockout
		if (LeaPlusLC["QuestFontChange"] ~= LeaPlusDB["QuestFontChange"]) or LeaPlusLC["QuestFontChange"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusQuestFontSize"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusQuestFontSize"],false)
		end

		-- Automatically accept quest lockout
		if LeaPlusLC["AutoAcceptQuests"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["AcceptOnlyDailys"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["AcceptOnlyDailys"],false)
		end

		-- Automatic resurrection lockout
		if LeaPlusLC["AutoAcceptRes"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["NoAutoResInCombat"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["NoAutoResInCombat"],false)
		end

		----------------------------------------------------------------------
		--	Automatic summon
		----------------------------------------------------------------------

		if LeaPlusLC["AutoAcceptSummon"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_SUMMON");
		else
			LpEvt:UnregisterEvent("CONFIRM_SUMMON");
		end


		----------------------------------------------------------------------
		--	Automatic guild decline
		----------------------------------------------------------------------

		if LeaPlusLC["BlockGuild"] == "On" then
			LpEvt:RegisterEvent("GUILD_INVITE_REQUEST");
		else
			LpEvt:UnregisterEvent("GUILD_INVITE_REQUEST");
		end



		----------------------------------------------------------------------
		--	Automatic gossip All
		----------------------------------------------------------------------

		if LeaPlusLC["AutomateGossipAll"] == "On" then
			LpEvt:RegisterEvent("GOSSIP_SHOW");
		else
			LpEvt:UnregisterEvent("GOSSIP_SHOW");
		end



		----------------------------------------------------------------------
		--	Automatic gossip town NPCs
		----------------------------------------------------------------------

		if LeaPlusLC["AutomateGossip"] == "On" then
			LpEvt:RegisterEvent("GOSSIP_SHOW");
		else
			LpEvt:UnregisterEvent("GOSSIP_SHOW");
		end


		----------------------------------------------------------------------
		--	Automatic guild decline
		----------------------------------------------------------------------

		if LeaPlusLC["HideHit"] == "On" then
			PlayerFrame:UnregisterEvent("UNIT_COMBAT")
			PetFrame:UnregisterEvent("UNIT_COMBAT")
		else
			PlayerFrame:RegisterEvent("UNIT_COMBAT")
			PetFrame:RegisterEvent("UNIT_COMBAT")
		end




		-- Error frame quest lockout
		if LeaPlusLC["HideErrorFrameText"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["ShowQuestUpdates"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["ShowQuestUpdates"],false)
		end

		-- Leatrix Plus scale
		if LeaPlusLC["PlusPanelScaleCheck"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusScaleValue"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusScaleValue"],false)
		end

		-- Leatrix Plus alpha
		if LeaPlusLC["PlusPanelAlphaCheck"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusAlphaValue"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["LeaPlusAlphaValue"],false)
		end

		-- Class coloring lockout
		if (LeaPlusLC["Manageclasscolors"] ~= LeaPlusDB["Manageclasscolors"]) or LeaPlusLC["Manageclasscolors"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["ColorLocalChannels"],true)
			LeaPlusLC:LockItem(LeaPlusCB["ColorGlobalChannels"],true)
		else
			LeaPlusLC:LockItem(LeaPlusCB["ColorLocalChannels"],false)
			LeaPlusLC:LockItem(LeaPlusCB["ColorGlobalChannels"],false)
		end

		-- Trade and guild block lockout
		if (LeaPlusLC["ManageTradeGuild"] ~= LeaPlusDB["ManageTradeGuild"]) or LeaPlusLC["ManageTradeGuild"] == "Off" then
			LeaPlusLC:LockItem(LeaPlusCB["NoTradeRequests"],true)

		else
			LeaPlusLC:LockItem(LeaPlusCB["NoTradeRequests"],false)

		end

	end

----------------------------------------------------------------------
--	L02: Restarts
----------------------------------------------------------------------

	-- Check to see if any options require a UI reload
	function LeaPlusLC:ReloadCheck()

		if	(LeaPlusLC["ShowRarePlayerChain"] 		~= LeaPlusDB["ShowRarePlayerChain"])
		or	(LeaPlusLC["NoClassBar"]				~= LeaPlusDB["NoClassBar"])
		or	(LeaPlusLC["NoCharControls"]			~= LeaPlusDB["NoCharControls"])
		or	(LeaPlusLC["ManageTradeGuild"] 			~= LeaPlusDB["ManageTradeGuild"])
		or	(LeaPlusLC["ShowQuestLevels"] 			~= LeaPlusDB["ShowQuestLevels"])
		or	(LeaPlusLC["QuestFontChange"]			~= LeaPlusDB["QuestFontChange"])
		or	(LeaPlusLC["NoStickyChat"]				~= LeaPlusDB["NoStickyChat"])
		or	(LeaPlusLC["UseArrowKeysInChat"]		~= LeaPlusDB["UseArrowKeysInChat"])
		or	(LeaPlusLC["ShowElitePlayerChain"]		~= LeaPlusDB["ShowElitePlayerChain"])
		or	(LeaPlusLC["HideZoneText"]				~= LeaPlusDB["HideZoneText"])
		or	(LeaPlusLC["HideSubzoneText"]			~= LeaPlusDB["HideSubzoneText"])
		or	(LeaPlusLC["UseArrowKeysInChat"]		~= LeaPlusDB["UseArrowKeysInChat"])
		or	(LeaPlusLC["NoGryphons"]				~= LeaPlusDB["NoGryphons"])
		or	(LeaPlusLC["NoRaidRestrictions"]		~= LeaPlusDB["NoRaidRestrictions"])
		or	(LeaPlusLC["MinmapHideTime"]			~= LeaPlusDB["MinmapHideTime"])
		or	(LeaPlusLC["MinimapMouseZoom"]			~= LeaPlusDB["MinimapMouseZoom"])
		or	(LeaPlusLC["NoChatFade"]				~= LeaPlusDB["NoChatFade"])
		or	(LeaPlusLC["NoBagAutomation"]			~= LeaPlusDB["NoBagAutomation"])
		or	(LeaPlusLC["NoSystemSpam"]				~= LeaPlusDB["NoSystemSpam"])
		or	(LeaPlusLC["NoAnnounceInChat"]			~= LeaPlusDB["NoAnnounceInChat"])
		or	(LeaPlusLC["NoChannelsInDungeons"]		~= LeaPlusDB["NoChannelsInDungeons"])
		or	(LeaPlusLC["FrmEnabled"]				~= LeaPlusDB["FrmEnabled"])
		-- or	(LeaPlusLC["ShowMinimapIcon"]			~= LeaPlusDB["ShowMinimapIcon"])
		or	(LeaPlusLC["Manageclasscolors"]			~= LeaPlusDB["Manageclasscolors"])
		or	(LeaPlusLC["UseEasyChatResizing"]		~= LeaPlusDB["UseEasyChatResizing"])
		or	(LeaPlusLC["NoInterruptSpam"]			~= LeaPlusDB["NoInterruptSpam"])
		or	(LeaPlusLC["ShowChatTimeStamps"]		~= LeaPlusDB["ShowChatTimeStamps"])
		or	(LeaPlusLC["ShortenChatChannels"]		~= LeaPlusDB["ShortenChatChannels"])
		or	(LeaPlusLC["NoCombatLogTab"]			~= LeaPlusDB["NoCombatLogTab"])
		or	(LeaPlusLC["MaxChatHstory"] 			~= LeaPlusDB["MaxChatHstory"])
		or	(LeaPlusLC["MoveChatEditBoxToTop"] 		~= LeaPlusDB["MoveChatEditBoxToTop"])
		or	(LeaPlusLC["UseMinimapClicks"] 			~= LeaPlusDB["UseMinimapClicks"])
		or	(LeaPlusLC["TipModEnable"] 				~= LeaPlusDB["TipModEnable"])
		or	(LeaPlusLC["NoBossFrames"] 				~= LeaPlusDB["NoBossFrames"])
		or	(LeaPlusLC["HideErrorFrameText"] 		~= LeaPlusDB["HideErrorFrameText"])
		or	(LeaPlusLC["ShowVanityButtons"] 		~= LeaPlusDB["ShowVanityButtons"])
		or	(LeaPlusLC["ShowHonorStat"] 			~= LeaPlusDB["ShowHonorStat"])
		or	(LeaPlusLC["DungeonFinderButtons"] 		~= LeaPlusDB["DungeonFinderButtons"])
		or	(LeaPlusLC["NoChatButtons"]				~= LeaPlusDB["NoChatButtons"])
		or	(LeaPlusLC["ShowVolume"]				~= LeaPlusDB["ShowVolume"])
		or	(LeaPlusLC["ShowDressTab"]				~= LeaPlusDB["ShowDressTab"])
		or	(LeaPlusLC["AhExtras"]					~= LeaPlusDB["AhExtras"])
		or	(LeaPlusLC["FasterLooting"]				~= LeaPlusDB["FasterLooting"])


		or	((LeaPlusLC["ShowClassIcons"] ~= LeaPlusDB["ShowClassIcons"]) and (LeaPlusLC["PlayerClass"] == "HUNTER" or LeaPlusLC["PlayerClass"] == "DRUID"))

		then
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"],false)
		else
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"],true)
		end

	end

----------------------------------------------------------------------
--	L03: Functions
----------------------------------------------------------------------

	-- Check if player is in LFG queue
	function LeaPlusLC:IsInLFGQueue()
		if LeaPlusLC["GameVer"] == "5" then
			if GetLFGQueueStats(LE_LFG_CATEGORY_LFD) or GetLFGQueueStats(LE_LFG_CATEGORY_LFR) or GetLFGQueueStats(LE_LFG_CATEGORY_RF) then
				return true
			end
		else
			if GetLFGQueueStats() then return true end
		end
	end

	-- Show buff icons
	function LeaPlusLC:ShowBuff(name, spellid, owner, parent, width, height, anchor, x, y)
		local spell, _, path = GetSpellInfo(spellid)

		-- Create spell icon frame
		local name = CreateFrame("Frame", nil, PlayerFrame)
		name:SetFrameStrata("BACKGROUND")
		name:SetWidth(width)
		name:SetHeight(height)
		name:ClearAllPoints()
		name:SetPoint(anchor, parent, anchor, x, y)

		-- Create cooldown
		name.c = CreateFrame("Cooldown", nil, name, "CooldownFrameTemplate")
		name.c:SetPoint("CENTER", 0, -1)
		name.c:SetWidth(20)
		name.c:SetHeight(20)
		name.c:Hide()
		name.c:SetReverse(true)

		-- Create texture from Mend Pet spell ID
		name.t = name:CreateTexture(nil,"BACKGROUND")
		name.t:SetTexture(path)
		name.t:SetAllPoints()

		-- Create event for cooldown
		name:RegisterEvent("UNIT_AURA");
		name:SetScript("OnEvent", function(self,event,arg1)
			if arg1 == owner then
				name:Hide()
				local buff, _, _, length, expire, start
				for i=1,16 do
					buff, _, _, _, _, length, expire, _, _ = UnitBuff(owner, i)

					-- No buff
					if not buff then
						break

					-- Show Mend Pet icon
					elseif buff == spell then
						start = expire - length
						CooldownFrame_SetTimer(name.c, start, length, 1)
						name:Show()
					end
				end
			end
		end)
		name:Hide()
	end

	-- Print text
	function LeaPlusLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(text, 1.0, 0.85, 0.0)
	end

	-- Set options panel alpha
	function LeaPlusLC:SetPlusAlpha()
		if LeaPlusLC.PlusPanelAlphaCheck == "On" then
			LeaPlusLC.PageF.t:SetAlpha(LeaPlusLC.LeaPlusAlphaValue)
		else
			LeaPlusLC.PageF.t:SetAlpha(1.0)
		end
	end

	-- Set options panel scale
	function LeaPlusLC:SetPlusScale()
		LeaPlusLC.PageF:ClearAllPoints()
		LeaPlusLC.PageF:SetPoint("CENTER",0,0)
		if LeaPlusLC.PlusPanelScaleCheck == "On" then
			LeaPlusLC.PageF:SetScale(LeaPlusLC.LeaPlusScaleValue)
		else
			LeaPlusLC.PageF:SetScale(1.00)
		end
	end

	-- Check if player is in combat
	function LeaPlusLC:PlayerInCombat(status)
		if (UnitAffectingCombat("player")) then
			LeaPlusLC:Print("You cannot do that in combat.")
			return true
		end
	end

	-- Rotate texture
	function LeaPlusLC:RotateTexture(texture, angle)
		local function CalculateCorner(angle)
			local cos, sin, rad = math.cos, math.sin, math.rad;
			local r = rad(angle);
			return 0.5 + cos(r) / sqrt(2), 0.5 + sin(r) / sqrt(2);
		end
		local LRx, LRy = CalculateCorner(angle + 45);
		local LLx, LLy = CalculateCorner(angle + 135);
		local ULx, ULy = CalculateCorner(angle + 225);
		local URx, URy = CalculateCorner(angle - 45);
		texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
	end

	-- Set tooltip scale
	function LeaPlusLC:SetTipScale()
		if LeaPlusLC["TipModEnable"] == LeaPlusDB["TipModEnable"] then
			if LeaPlusLC["TipScaleCheck"] == "On" and LeaPlusLC["TipModEnable"] == "On" then
				GameTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
			elseif LeaPlusLC["TipScaleCheck"] == "Off" or LeaPlusLC["TipModEnable"] == "Off" then 
				GameTooltip:SetScale("1.00")
			end
			return
		else
			GameTooltip:SetScale("1.00")
		end
	end

	--  Hide pages
	function LeaPlusLC:HideFrames()

		-- Hide option pages
		for i = 0, LeaPlusLC["NumberOfPages"] do
			if LeaPlusLC["Page"..i] then
				LeaPlusLC["Page"..i]:Hide();
			end;
		end

		-- Hide special pages
		if LeaPlusLC["PageF"] 				then LeaPlusLC["PageF"]:Hide(); 				end
		if LeaPlusCB["TooltipDragFrame"]	then LeaPlusCB["TooltipDragFrame"]:Hide(); 		end

		-- Hide buttons
		if LeaPlusCB["RefreshFramesButton"] then LeaPlusCB["RefreshFramesButton"]:Hide(); 	end
		if LeaPlusCB["ResetFramesButton"] 	then LeaPlusCB["ResetFramesButton"]:Hide(); 	end
		if LeaPlusCB["MoveFramesButton"] 	then LeaPlusCB["MoveFramesButton"]:Hide(); 		end
		if LeaPlusCB["MoveTooltipButton"] 	then LeaPlusCB["MoveTooltipButton"]:Hide(); 	end
		if LeaPlusCB["ResetTooltipButton"]	then LeaPlusCB["ResetTooltipButton"]:Hide(); 	end
		if LeaPlusCB["SetDefaultsButton"] 	then LeaPlusCB["SetDefaultsButton"]:Hide(); 	end
		if LeaPlusCB["WipeAllButton"] 		then LeaPlusCB["WipeAllButton"]:Hide(); 		end

	end

	-- Block guild invites and trades
	function LeaPlusLC:TradeGuild()
		if LeaPlusLC["ManageTradeGuild"] == "On" then
			if LeaPlusLC["NoTradeRequests"] == "On" then
				InterfaceOptionsControlsPanelBlockTrades:SetValue("1");
			else
				InterfaceOptionsControlsPanelBlockTrades:SetValue("0");
			end

		end
	end

	-- Show button tooltips
	function LeaPlusLC:ShowTooltip()
		if LeaPlusLC["PlusShowTips"] == "On" then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
		end
	end

	-- Hide button tooltips
	function LeaPlusLC:HideTooltip() 
		GameTooltip:Hide() 
	end

	-- Check if a player is in your friends list
	function LeaPlusLC:FriendCheck(name)
		ShowFriends()
		for i = 1, GetNumFriends() do
			if (name == GetFriendInfo(i)) then
				return true
			end
		end
		return false;
	end

	-- Check if a player is in your Real ID friends list
	function LeaPlusLC:RealIDCheck(name)
		ShowFriends() 
		for i = 1, BNGetNumFriends() do
			local presenceID, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
			if (client == "WoW" and isOnline) then
				_, toonname, _, realmname = BNGetToonInfo(presenceID)
				if (name == toonname) or (name == toonname .. "-" .. realmname) then
					return true
				end
			end
		end
		return false;
	end

	-- Quest size update (run on startup and when changing slider)
	function LeaPlusLC:QuestSizeUpdate()
		if LeaPlusLC["QuestFontChange"] == "On" then
			QuestTitleFont:SetFont(QuestTitleFont:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"]+6, nil);
			QuestFont:SetFont(QuestFont:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"]+1, nil);
			QuestFontNormalSmall:SetFont(QuestFontNormalSmall:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"], nil);
		end
	end

	-- Master volume update (run on startup and when changing slider)
	function LeaPlusLC:MasterVolUpdate()
		if LeaPlusLC["ShowVolume"] == "On" then
			SetCVar("Sound_MasterVolume", LeaPlusLC["LeaPlusMaxVol"]);
		end
	end

----------------------------------------------------------------------
--	L04: Load and Save Global Profile
----------------------------------------------------------------------

-- 	Copy globals to locals
	function LeaPlusLC:Load()

		-- Automation
		if not LeaPlusDB["AcceptPartyFriends"]		then LeaPlusLC["AcceptPartyFriends"]	= "Off"	else LeaPlusLC["AcceptPartyFriends"]	= LeaPlusDB["AcceptPartyFriends"]	end 
		if not LeaPlusDB["AutoConfirmRole"]			then LeaPlusLC["AutoConfirmRole"]		= "Off"	else LeaPlusLC["AutoConfirmRole"]		= LeaPlusDB["AutoConfirmRole"]		end 
		if not LeaPlusDB["InviteFromWhisper"]		then LeaPlusLC["InviteFromWhisper"]		= "Off"	else LeaPlusLC["InviteFromWhisper"]		= LeaPlusDB["InviteFromWhisper"]	end 

		if not LeaPlusDB["AutoReleaseInBG"] 		then LeaPlusLC["AutoReleaseInBG"] 		= "Off"	else LeaPlusLC["AutoReleaseInBG"] 		= LeaPlusDB["AutoReleaseInBG"] 		end 
		if not LeaPlusDB["AutoAcceptRes"] 			then LeaPlusLC["AutoAcceptRes"] 		= "Off"	else LeaPlusLC["AutoAcceptRes"] 		= LeaPlusDB["AutoAcceptRes"] 		end 
		if not LeaPlusDB["NoAutoResInCombat"]		then LeaPlusLC["NoAutoResInCombat"]		= "Off"	else LeaPlusLC["NoAutoResInCombat"]		= LeaPlusDB["NoAutoResInCombat"]	end 

		if not LeaPlusDB["NoDuelRequests"] 			then LeaPlusLC["NoDuelRequests"] 		= "Off" else LeaPlusLC["NoDuelRequests"] 		= LeaPlusDB["NoDuelRequests"] 		end 
		if not LeaPlusDB["NoPartyInvites"] 			then LeaPlusLC["NoPartyInvites"] 		= "Off" else LeaPlusLC["NoPartyInvites"] 		= LeaPlusDB["NoPartyInvites"] 		end 

		if not LeaPlusDB["ManageTradeGuild"] 		then LeaPlusLC["ManageTradeGuild"] 		= "Off"	else LeaPlusLC["ManageTradeGuild"]		= LeaPlusDB["ManageTradeGuild"] 	end 
		if not LeaPlusDB["NoTradeRequests"]			then LeaPlusLC["NoTradeRequests"]		= "Off"	else LeaPlusLC["NoTradeRequests"]		= LeaPlusDB["NoTradeRequests"]		end 
		-- if not LeaPlusDB["NoGuildInvites"]			then LeaPlusLC["NoGuildInvites"]		= "Off"	else LeaPlusLC["NoGuildInvites"]		= LeaPlusDB["NoGuildInvites"]		end 
		if not LeaPlusDB["AutoAcceptSummon"] 		then LeaPlusLC["AutoAcceptSummon"]		= "Off"	else LeaPlusLC["AutoAcceptSummon"]		= LeaPlusDB["AutoAcceptSummon"] 	end 
		if not LeaPlusDB["BlockGuild"] 				then LeaPlusLC["BlockGuild"]			= "Off"	else LeaPlusLC["BlockGuild"]			= LeaPlusDB["BlockGuild"] 			end 
		if not LeaPlusDB["FasterLooting"] 				then LeaPlusLC["FasterLooting"]			= "Off"	else LeaPlusLC["FasterLooting"]			= LeaPlusDB["FasterLooting"] 			end 


		-- Interaction
		if not LeaPlusDB["ShowQuestLevels"]			then LeaPlusLC["ShowQuestLevels"]		= "Off"	else LeaPlusLC["ShowQuestLevels"]		= LeaPlusDB["ShowQuestLevels"]		end 
		if not LeaPlusDB["AutoAcceptQuests"] 		then LeaPlusLC["AutoAcceptQuests"]		= "Off"	else LeaPlusLC["AutoAcceptQuests"] 		= LeaPlusDB["AutoAcceptQuests"] 	end 
		if not LeaPlusDB["AcceptOnlyDailys"] 		then LeaPlusLC["AcceptOnlyDailys"]		= "Off"	else LeaPlusLC["AcceptOnlyDailys"]		= LeaPlusDB["AcceptOnlyDailys"]		end 
		if not LeaPlusDB["AutoTurnInQuests"] 		then LeaPlusLC["AutoTurnInQuests"]		= "Off"	else LeaPlusLC["AutoTurnInQuests"] 		= LeaPlusDB["AutoTurnInQuests"] 	end 

		if not LeaPlusDB["QuestFontChange"] 		then LeaPlusLC["QuestFontChange"] 		= "Off"	else LeaPlusLC["QuestFontChange"]		= LeaPlusDB["QuestFontChange"] 		end 
		if not LeaPlusDB["LeaPlusQuestFontSize"] 	then LeaPlusLC["LeaPlusQuestFontSize"] 	= "18"	else LeaPlusLC["LeaPlusQuestFontSize"] 	= LeaPlusDB["LeaPlusQuestFontSize"]	end 

		if not LeaPlusDB["AutoSellJunk"] 			then LeaPlusLC["AutoSellJunk"]			= "Off"	else LeaPlusLC["AutoSellJunk"] 			= LeaPlusDB["AutoSellJunk"] 		end 
		if not LeaPlusDB["AutoRepairOwnFunds"] 		then LeaPlusLC["AutoRepairOwnFunds"]	= "Off"	else LeaPlusLC["AutoRepairOwnFunds"] 	= LeaPlusDB["AutoRepairOwnFunds"] 	end 
		if not LeaPlusDB["NoBagAutomation"]			then LeaPlusLC["NoBagAutomation"] 		= "Off"	else LeaPlusLC["NoBagAutomation"] 		= LeaPlusDB["NoBagAutomation"] 		end 
		if not LeaPlusDB["AutomateGossip"]			then LeaPlusLC["AutomateGossip"] 		= "Off"	else LeaPlusLC["AutomateGossip"] 		= LeaPlusDB["AutomateGossip"] 		end 
		if not LeaPlusDB["AutomateGossipAll"]		then LeaPlusLC["AutomateGossipAll"] 	= "Off"	else LeaPlusLC["AutomateGossipAll"] 	= LeaPlusDB["AutomateGossipAll"] 	end 


		if not LeaPlusDB["NoRaidRestrictions"] 		then LeaPlusLC["NoRaidRestrictions"]	= "Off"	else LeaPlusLC["NoRaidRestrictions"] 	= LeaPlusDB["NoRaidRestrictions"] 	end 
		if not LeaPlusDB["NoConfirmLoot"] 			then LeaPlusLC["NoConfirmLoot"]			= "Off"	else LeaPlusLC["NoConfirmLoot"] 		= LeaPlusDB["NoConfirmLoot"] 		end 

		-- Chat
		if not LeaPlusDB["UseEasyChatResizing"]		then LeaPlusLC["UseEasyChatResizing"]	= "Off"	else LeaPlusLC["UseEasyChatResizing"]	= LeaPlusDB["UseEasyChatResizing"]	end 
		if not LeaPlusDB["NoCombatLogTab"]			then LeaPlusLC["NoCombatLogTab"]		= "Off"	else LeaPlusLC["NoCombatLogTab"]		= LeaPlusDB["NoCombatLogTab"]		end 
		if not LeaPlusDB["NoChatButtons"]			then LeaPlusLC["NoChatButtons"]			= "Off"	else LeaPlusLC["NoChatButtons"]			= LeaPlusDB["NoChatButtons"]		end 
		if not LeaPlusDB["MoveChatEditBoxToTop"]	then LeaPlusLC["MoveChatEditBoxToTop"]	= "Off"	else LeaPlusLC["MoveChatEditBoxToTop"]	= LeaPlusDB["MoveChatEditBoxToTop"]	end 

		if not LeaPlusDB["NoStickyChat"] 			then LeaPlusLC["NoStickyChat"]			= "Off"	else LeaPlusLC["NoStickyChat"] 			= LeaPlusDB["NoStickyChat"] 		end 
		if not LeaPlusDB["UseArrowKeysInChat"]		then LeaPlusLC["UseArrowKeysInChat"]	= "Off"	else LeaPlusLC["UseArrowKeysInChat"]	= LeaPlusDB["UseArrowKeysInChat"]	end 
		if not LeaPlusDB["NoChatFade"]				then LeaPlusLC["NoChatFade"]			= "Off"	else LeaPlusLC["NoChatFade"]			= LeaPlusDB["NoChatFade"]			end 
		if not LeaPlusDB["ShowChatTimeStamps"]		then LeaPlusLC["ShowChatTimeStamps"]	= "Off"	else LeaPlusLC["ShowChatTimeStamps"]	= LeaPlusDB["ShowChatTimeStamps"]	end 
		if not LeaPlusDB["MaxChatHstory"]			then LeaPlusLC["MaxChatHstory"]			= "Off"	else LeaPlusLC["MaxChatHstory"]			= LeaPlusDB["MaxChatHstory"]		end 

		if not LeaPlusDB["Manageclasscolors"]		then LeaPlusLC["Manageclasscolors"]		= "Off"	else LeaPlusLC["Manageclasscolors"]		= LeaPlusDB["Manageclasscolors"]	end 
		if not LeaPlusDB["ColorLocalChannels"]		then LeaPlusLC["ColorLocalChannels"]	= "Off"	else LeaPlusLC["ColorLocalChannels"]	= LeaPlusDB["ColorLocalChannels"]	end 
		if not LeaPlusDB["ColorGlobalChannels"]		then LeaPlusLC["ColorGlobalChannels"]	= "Off"	else LeaPlusLC["ColorGlobalChannels"]	= LeaPlusDB["ColorGlobalChannels"]	end 

		-- Text
		if not LeaPlusDB["HideZoneText"] 			then LeaPlusLC["HideZoneText"] 			= "Off"	else LeaPlusLC["HideZoneText"] 			= LeaPlusDB["HideZoneText"] 		end 
		if not LeaPlusDB["HideSubzoneText"] 		then LeaPlusLC["HideSubzoneText"] 		= "Off"	else LeaPlusLC["HideSubzoneText"] 		= LeaPlusDB["HideSubzoneText"] 		end 

		if not LeaPlusDB["HideErrorFrameText"]		then LeaPlusLC["HideErrorFrameText"]	= "Off"	else LeaPlusLC["HideErrorFrameText"]	= LeaPlusDB["HideErrorFrameText"]	end 
		if not LeaPlusDB["ShowQuestUpdates"]		then LeaPlusLC["ShowQuestUpdates"]		= "Off"	else LeaPlusLC["ShowQuestUpdates"]		= LeaPlusDB["ShowQuestUpdates"]		end 
		if not LeaPlusDB["HideHit"] 		then LeaPlusLC["HideHit"]		= "Off"	else LeaPlusLC["HideHit"]		= LeaPlusDB["HideHit"] 	end 


		if not LeaPlusDB["NoSystemSpam"] 			then LeaPlusLC["NoSystemSpam"] 			= "Off"	else LeaPlusLC["NoSystemSpam"] 			= LeaPlusDB["NoSystemSpam"] 		end 
		if not LeaPlusDB["NoInterruptSpam"]			then LeaPlusLC["NoInterruptSpam"]		= "Off"	else LeaPlusLC["NoInterruptSpam"]		= LeaPlusDB["NoInterruptSpam"]		end 
		if not LeaPlusDB["NoChannelsInDungeons"] 	then LeaPlusLC["NoChannelsInDungeons"]	= "Off"	else LeaPlusLC["NoChannelsInDungeons"]	= LeaPlusDB["NoChannelsInDungeons"]	end 
		if not LeaPlusDB["ShortenChatChannels"]		then LeaPlusLC["ShortenChatChannels"]	= "Off"	else LeaPlusLC["ShortenChatChannels"]	= LeaPlusDB["ShortenChatChannels"]	end 
		if not LeaPlusDB["NoAnnounceInChat"]		then LeaPlusLC["NoAnnounceInChat"]		= "Off"	else LeaPlusLC["NoAnnounceInChat"]		= LeaPlusDB["NoAnnounceInChat"]		end 

		-- Tooltip
		if not LeaPlusDB["TipModEnable"]			then LeaPlusLC["TipModEnable"] 			= "Off"	else LeaPlusLC["TipModEnable"]			= LeaPlusDB["TipModEnable"]			end 

		if not LeaPlusDB["TipShowTitle"]			then LeaPlusLC["TipShowTitle"] 			= "Off"	else LeaPlusLC["TipShowTitle"]			= LeaPlusDB["TipShowTitle"]			end 
		if not LeaPlusDB["TipShowRealm"]			then LeaPlusLC["TipShowRealm"] 			= "On"	else LeaPlusLC["TipShowRealm"]			= LeaPlusDB["TipShowRealm"]			end 
		if not LeaPlusDB["TipShowRace"]				then LeaPlusLC["TipShowRace"] 			= "On"	else LeaPlusLC["TipShowRace"]			= LeaPlusDB["TipShowRace"]			end 
		if not LeaPlusDB["TipShowClass"]			then LeaPlusLC["TipShowClass"] 			= "On"	else LeaPlusLC["TipShowClass"]			= LeaPlusDB["TipShowClass"]			end 
		if not LeaPlusDB["TipShowRank"]				then LeaPlusLC["TipShowRank"] 			= "On"	else LeaPlusLC["TipShowRank"]			= LeaPlusDB["TipShowRank"]			end 
		if not LeaPlusDB["TipShowMobType"]			then LeaPlusLC["TipShowMobType"] 		= "On"	else LeaPlusLC["TipShowMobType"]		= LeaPlusDB["TipShowMobType"]		end 
		if not LeaPlusDB["TipShowTarget"]			then LeaPlusLC["TipShowTarget"] 		= "On"	else LeaPlusLC["TipShowTarget"]			= LeaPlusDB["TipShowTarget"]		end 

		if not LeaPlusDB["TipBackSimple"]			then LeaPlusLC["TipBackSimple"] 		= "On"	else LeaPlusLC["TipBackSimple"]			= LeaPlusDB["TipBackSimple"]		end 
		if not LeaPlusDB["TipBackFriend"]			then LeaPlusLC["TipBackFriend"] 		= "Off"	else LeaPlusLC["TipBackFriend"]			= LeaPlusDB["TipBackFriend"]		end 
		if not LeaPlusDB["TipBackHostile"]			then LeaPlusLC["TipBackHostile"] 		= "Off"	else LeaPlusLC["TipBackHostile"]		= LeaPlusDB["TipBackHostile"]		end 

		if not LeaPlusDB["TipHideInCombat"]			then LeaPlusLC["TipHideInCombat"] 		= "Off"	else LeaPlusLC["TipHideInCombat"]		= LeaPlusDB["TipHideInCombat"]		end 
		if not LeaPlusDB["TipAnchorToMouse"]		then LeaPlusLC["TipAnchorToMouse"] 		= "Off"	else LeaPlusLC["TipAnchorToMouse"]		= LeaPlusDB["TipAnchorToMouse"]		end 
		if not LeaPlusDB["TipScaleCheck"]			then LeaPlusLC["TipScaleCheck"] 		= "Off"	else LeaPlusLC["TipScaleCheck"]			= LeaPlusDB["TipScaleCheck"]		end 
		if not LeaPlusDB["LeaPlusTipSize"]			then LeaPlusLC["LeaPlusTipSize"] 		= "1.25" else LeaPlusLC["LeaPlusTipSize"]		= LeaPlusDB["LeaPlusTipSize"]		end 

		if not LeaPlusDB["TipPosAnchor"]			then LeaPlusLC["TipPosAnchor"] 			= "BOTTOMRIGHT" else LeaPlusLC["TipPosAnchor"] 	= LeaPlusDB["TipPosAnchor"]			end 
		if not LeaPlusDB["TipPosRelative"]			then LeaPlusLC["TipPosRelative"] 		= "BOTTOMRIGHT" else LeaPlusLC["TipPosRelative"] = LeaPlusDB["TipPosRelative"] 		end 
		if not LeaPlusDB["TipPosXOffset"]			then LeaPlusLC["TipPosXOffset"] 		= "-13"	else LeaPlusLC["TipPosXOffset"]			= LeaPlusDB["TipPosXOffset"]		end 
		if not LeaPlusDB["TipPosYOffset"]			then LeaPlusLC["TipPosYOffset"] 		= "94"	else LeaPlusLC["TipPosYOffset"]			= LeaPlusDB["TipPosYOffset"]		end 

		-- Frames
		if not LeaPlusDB["FrmEnabled"]				then LeaPlusLC["FrmEnabled"] 			= "Off"	else LeaPlusLC["FrmEnabled"]			= LeaPlusDB["FrmEnabled"]			end 

		if not LeaPlusDB["NoGryphons"]				then LeaPlusLC["NoGryphons"]			= "Off"	else LeaPlusLC["NoGryphons"]			= LeaPlusDB["NoGryphons"]			end 
		if not LeaPlusDB["NoClassBar"]				then LeaPlusLC["NoClassBar"]			= "Off"	else LeaPlusLC["NoClassBar"]			= LeaPlusDB["NoClassBar"]			end 
		if not LeaPlusDB["NoBossFrames"]			then LeaPlusLC["NoBossFrames"]			= "Off"	else LeaPlusLC["NoBossFrames"]			= LeaPlusDB["NoBossFrames"]			end 
		if not LeaPlusDB["NoCharControls"]			then LeaPlusLC["NoCharControls"]		= "Off"	else LeaPlusLC["NoCharControls"]		= LeaPlusDB["NoCharControls"]		end 

		-- Miscellaneous
		if not LeaPlusDB["UseMinimapClicks"] 		then LeaPlusLC["UseMinimapClicks"]		= "Off"	else LeaPlusLC["UseMinimapClicks"]		= LeaPlusDB["UseMinimapClicks"]		end 
		if not LeaPlusDB["MinimapMouseZoom"]		then LeaPlusLC["MinimapMouseZoom"]		= "Off"	else LeaPlusLC["MinimapMouseZoom"]		= LeaPlusDB["MinimapMouseZoom"]		end 
		if not LeaPlusDB["MinmapHideTime"] 			then LeaPlusLC["MinmapHideTime"]		= "Off"	else LeaPlusLC["MinmapHideTime"]		= LeaPlusDB["MinmapHideTime"]		end 

		if not LeaPlusDB["AhExtras"] 				then LeaPlusLC["AhExtras"]				= "Off"	else LeaPlusLC["AhExtras"]				= LeaPlusDB["AhExtras"]				end 
		if not LeaPlusDB["AhBuyoutOnly"] 			then LeaPlusLC["AhBuyoutOnly"]			= "Off"	else LeaPlusLC["AhBuyoutOnly"]			= LeaPlusDB["AhBuyoutOnly"]			end 
		-- if not LeaPlusDB["AhGoldOnly"] 				then LeaPlusLC["AhGoldOnly"]			= "Off"	else LeaPlusLC["AhGoldOnly"]			= LeaPlusDB["AhGoldOnly"]			end 
		if not LeaPlusDB["AhDuration"] 				then 											else LeaPlusLC["AhDuration"]			= LeaPlusDB["AhDuration"]			end 

		if not LeaPlusDB["NoDeathEffect"]			then LeaPlusLC["NoDeathEffect"]			= "Off"	else LeaPlusLC["NoDeathEffect"]			= LeaPlusDB["NoDeathEffect"] 		end 
		if not LeaPlusDB["NoSpecialEffects"]		then LeaPlusLC["NoSpecialEffects"]		= "Off"	else LeaPlusLC["NoSpecialEffects"]		= LeaPlusDB["NoSpecialEffects"] 	end 
		if not LeaPlusDB["NoGlowEffect"] 			then LeaPlusLC["NoGlowEffect"]			= "Off"	else LeaPlusLC["NoGlowEffect"] 			= LeaPlusDB["NoGlowEffect"] 		end 
		if not LeaPlusDB["MaxZoomOutLevel"]			then LeaPlusLC["MaxZoomOutLevel"]		= "Off"	else LeaPlusLC["MaxZoomOutLevel"]		= LeaPlusDB["MaxZoomOutLevel"]		end 

		if not LeaPlusDB["ShowVanityButtons"]		then LeaPlusLC["ShowVanityButtons"]		= "Off"	else LeaPlusLC["ShowVanityButtons"]		= LeaPlusDB["ShowVanityButtons"]	end 
		if not LeaPlusDB["DungeonFinderButtons"]	then LeaPlusLC["DungeonFinderButtons"]	= "Off"	else LeaPlusLC["DungeonFinderButtons"]	= LeaPlusDB["DungeonFinderButtons"]	end 
		if not LeaPlusDB["ShowClassIcons"]			then LeaPlusLC["ShowClassIcons"]		= "Off"	else LeaPlusLC["ShowClassIcons"]		= LeaPlusDB["ShowClassIcons"]		end 
		if not LeaPlusDB["ShowHonorStat"]			then LeaPlusLC["ShowHonorStat"]			= "Off"	else LeaPlusLC["ShowHonorStat"]			= LeaPlusDB["ShowHonorStat"]		end 
		if not LeaPlusDB["ShowVolume"]	 			then LeaPlusLC["ShowVolume"] 			= "Off"	else LeaPlusLC["ShowVolume"] 			= LeaPlusDB["ShowVolume"] 			end 
		if not LeaPlusDB["ShowDressTab"]	 		then LeaPlusLC["ShowDressTab"] 			= "Off"	else LeaPlusLC["ShowDressTab"] 			= LeaPlusDB["ShowDressTab"] 		end 

		if not LeaPlusDB["ShowElitePlayerChain"] 	then LeaPlusLC["ShowElitePlayerChain"] 	= "Off"	else LeaPlusLC["ShowElitePlayerChain"] 	= LeaPlusDB["ShowElitePlayerChain"] end 
		if not LeaPlusDB["ShowRarePlayerChain"] 	then LeaPlusLC["ShowRarePlayerChain"] 	= "Off"	else LeaPlusLC["ShowRarePlayerChain"] 	= LeaPlusDB["ShowRarePlayerChain"] 	end 

		-- Settings
		if not LeaPlusDB["ShowMinimapIcon"]	 		then LeaPlusLC["ShowMinimapIcon"] 		= "On"	else LeaPlusLC["ShowMinimapIcon"] 		= LeaPlusDB["ShowMinimapIcon"] 		end 
		if not LeaPlusDB["MinimapIconPos"] 			then LeaPlusLC["MinimapIconPos"] 		= -65	else LeaPlusLC["MinimapIconPos"] 		= LeaPlusDB["MinimapIconPos"] 		end 
		if not LeaPlusDB["PlusShowTips"] 			then LeaPlusLC["PlusShowTips"] 			= "On"	else LeaPlusLC["PlusShowTips"] 			= LeaPlusDB["PlusShowTips"]			end 
		if not LeaPlusDB["ShowBackground"]			then LeaPlusLC["ShowBackground"] 		= "On"	else LeaPlusLC["ShowBackground"]		= LeaPlusDB["ShowBackground"]		end 
		if not LeaPlusDB["OpenPlusAtHome"] 			then LeaPlusLC["OpenPlusAtHome"]		= "Off"	else LeaPlusLC["OpenPlusAtHome"] 		= LeaPlusDB["OpenPlusAtHome"] 		end 

		if not LeaPlusDB["PlusPanelAlphaCheck"] 	then LeaPlusLC["PlusPanelAlphaCheck"] 	= "Off"	else LeaPlusLC["PlusPanelAlphaCheck"] 	= LeaPlusDB["PlusPanelAlphaCheck"] 	end 
		if not LeaPlusDB["LeaPlusAlphaValue"] 		then LeaPlusLC["LeaPlusAlphaValue"] 	= "1.0"	else LeaPlusLC["LeaPlusAlphaValue"] 	= LeaPlusDB["LeaPlusAlphaValue"] 	end 

		if not LeaPlusDB["PlusPanelScaleCheck"] 	then LeaPlusLC["PlusPanelScaleCheck"] 	= "Off"	else LeaPlusLC["PlusPanelScaleCheck"] 	= LeaPlusDB["PlusPanelScaleCheck"]	end 
		if not LeaPlusDB["LeaPlusScaleValue"] 		then LeaPlusLC["LeaPlusScaleValue"] 	= "1.0"	else LeaPlusLC["LeaPlusScaleValue"] 	= LeaPlusDB["LeaPlusScaleValue"]	end 

		if not LeaPlusDB["LeaStartPage"]			then LeaPlusLC["LeaStartPage"] 			= "0"	else LeaPlusLC["LeaStartPage"]			= LeaPlusDB["LeaStartPage"]			end 

		-- Save all settings now
		LeaPlusLC:Save();

	end

-- 	Save locals to globals
	function LeaPlusLC:Save()

		-- Automation
		LeaPlusDB["AcceptPartyFriends"]		= LeaPlusLC["AcceptPartyFriends"]
		LeaPlusDB["AutoConfirmRole"]		= LeaPlusLC["AutoConfirmRole"]
		LeaPlusDB["InviteFromWhisper"]		= LeaPlusLC["InviteFromWhisper"]

		LeaPlusDB["AutoReleaseInBG"] 		= LeaPlusLC["AutoReleaseInBG"]
		LeaPlusDB["AutoAcceptRes"] 			= LeaPlusLC["AutoAcceptRes"]
		LeaPlusDB["NoAutoResInCombat"]		= LeaPlusLC["NoAutoResInCombat"]
		LeaPlusDB["AutoAcceptSummon"] 		= LeaPlusLC["AutoAcceptSummon"]
		LeaPlusDB["BlockGuild"] 			= LeaPlusLC["BlockGuild"]
		LeaPlusDB["FasterLooting"] 			= LeaPlusLC["FasterLooting"]
		

		LeaPlusDB["NoDuelRequests"] 		= LeaPlusLC["NoDuelRequests"]
		LeaPlusDB["NoPartyInvites"]			= LeaPlusLC["NoPartyInvites"]

		LeaPlusDB["ManageTradeGuild"] 		= LeaPlusLC["ManageTradeGuild"]
		LeaPlusDB["NoTradeRequests"]		= LeaPlusLC["NoTradeRequests"]
		-- LeaPlusDB["NoGuildInvites"]			= LeaPlusLC["NoGuildInvites"]

		-- Interaction
		LeaPlusDB["ShowQuestLevels"]		= LeaPlusLC["ShowQuestLevels"]
		LeaPlusDB["AutoAcceptQuests"] 		= LeaPlusLC["AutoAcceptQuests"]
		LeaPlusDB["AcceptOnlyDailys"] 		= LeaPlusLC["AcceptOnlyDailys"]
		LeaPlusDB["AutoTurnInQuests"] 		= LeaPlusLC["AutoTurnInQuests"]

		LeaPlusDB["QuestFontChange"] 		= LeaPlusLC["QuestFontChange"]
		LeaPlusDB["LeaPlusQuestFontSize"]	= LeaPlusLC["LeaPlusQuestFontSize"]

		LeaPlusDB["AutoSellJunk"] 			= LeaPlusLC["AutoSellJunk"]
		LeaPlusDB["AutoRepairOwnFunds"] 	= LeaPlusLC["AutoRepairOwnFunds"]
		LeaPlusDB["NoBagAutomation"] 		= LeaPlusLC["NoBagAutomation"]
		LeaPlusDB["AutomateGossip"] 		= LeaPlusLC["AutomateGossip"]
		LeaPlusDB["AutomateGossipAll"] 		= LeaPlusLC["AutomateGossipAll"]

		LeaPlusDB["NoRaidRestrictions"]		= LeaPlusLC["NoRaidRestrictions"]
		LeaPlusDB["NoConfirmLoot"] 			= LeaPlusLC["NoConfirmLoot"]

		-- Chat
		LeaPlusDB["UseEasyChatResizing"]	= LeaPlusLC["UseEasyChatResizing"]
		LeaPlusDB["NoCombatLogTab"]			= LeaPlusLC["NoCombatLogTab"]
		LeaPlusDB["NoChatButtons"]			= LeaPlusLC["NoChatButtons"]
		LeaPlusDB["MoveChatEditBoxToTop"]	= LeaPlusLC["MoveChatEditBoxToTop"]

		LeaPlusDB["NoStickyChat"] 			= LeaPlusLC["NoStickyChat"]
		LeaPlusDB["UseArrowKeysInChat"]		= LeaPlusLC["UseArrowKeysInChat"]
		LeaPlusDB["NoChatFade"]				= LeaPlusLC["NoChatFade"]
		LeaPlusDB["ShowChatTimeStamps"]		= LeaPlusLC["ShowChatTimeStamps"]
		LeaPlusDB["MaxChatHstory"]			= LeaPlusLC["MaxChatHstory"]

		LeaPlusDB["Manageclasscolors"]		= LeaPlusLC["Manageclasscolors"]
		LeaPlusDB["ColorLocalChannels"]		= LeaPlusLC["ColorLocalChannels"]
		LeaPlusDB["ColorGlobalChannels"]	= LeaPlusLC["ColorGlobalChannels"]

		-- Text
		LeaPlusDB["HideZoneText"] 			= LeaPlusLC["HideZoneText"]
		LeaPlusDB["HideSubzoneText"] 		= LeaPlusLC["HideSubzoneText"]

		LeaPlusDB["HideErrorFrameText"]		= LeaPlusLC["HideErrorFrameText"]
		LeaPlusDB["ShowQuestUpdates"]		= LeaPlusLC["ShowQuestUpdates"]
		LeaPlusDB["HideHit"]				= LeaPlusLC["HideHit"]

		LeaPlusDB["NoSystemSpam"] 			= LeaPlusLC["NoSystemSpam"]
		LeaPlusDB["NoInterruptSpam"]		= LeaPlusLC["NoInterruptSpam"]
		LeaPlusDB["NoChannelsInDungeons"]	= LeaPlusLC["NoChannelsInDungeons"]
		LeaPlusDB["ShortenChatChannels"]	= LeaPlusLC["ShortenChatChannels"]
		LeaPlusDB["NoAnnounceInChat"]		= LeaPlusLC["NoAnnounceInChat"]

		-- Tooltip
		LeaPlusDB["TipModEnable"]			= LeaPlusLC["TipModEnable"]

		LeaPlusDB["TipShowTitle"]			= LeaPlusLC["TipShowTitle"]
		LeaPlusDB["TipShowRealm"]			= LeaPlusLC["TipShowRealm"]
		LeaPlusDB["TipShowRace"]			= LeaPlusLC["TipShowRace"]
		LeaPlusDB["TipShowClass"]			= LeaPlusLC["TipShowClass"]
		LeaPlusDB["TipShowRank"]			= LeaPlusLC["TipShowRank"]
		LeaPlusDB["TipShowMobType"]			= LeaPlusLC["TipShowMobType"]
		LeaPlusDB["TipShowTarget"]			= LeaPlusLC["TipShowTarget"]

		LeaPlusDB["TipBackSimple"]			= LeaPlusLC["TipBackSimple"]
		LeaPlusDB["TipBackFriend"]			= LeaPlusLC["TipBackFriend"]
		LeaPlusDB["TipBackHostile"]			= LeaPlusLC["TipBackHostile"]

		LeaPlusDB["TipHideInCombat"]		= LeaPlusLC["TipHideInCombat"]
		LeaPlusDB["TipAnchorToMouse"]		= LeaPlusLC["TipAnchorToMouse"]
		LeaPlusDB["TipScaleCheck"] 			= LeaPlusLC["TipScaleCheck"]
		LeaPlusDB["LeaPlusTipSize"]			= LeaPlusLC["LeaPlusTipSize"]

		LeaPlusDB["TipPosAnchor"]			= LeaPlusLC["TipPosAnchor"]
		LeaPlusDB["TipPosRelative"]			= LeaPlusLC["TipPosRelative"]
		LeaPlusDB["TipPosXOffset"]			= LeaPlusLC["TipPosXOffset"]
		LeaPlusDB["TipPosYOffset"]			= LeaPlusLC["TipPosYOffset"]

		-- Frames
		LeaPlusDB["FrmEnabled"]				= LeaPlusLC["FrmEnabled"]

		LeaPlusDB["NoGryphons"]				= LeaPlusLC["NoGryphons"]
		LeaPlusDB["NoClassBar"]				= LeaPlusLC["NoClassBar"]
		LeaPlusDB["NoCharControls"]			= LeaPlusLC["NoCharControls"]
		LeaPlusDB["NoBossFrames"]			= LeaPlusLC["NoBossFrames"]

		-- Miscellaneous
		LeaPlusDB["UseMinimapClicks"]		= LeaPlusLC["UseMinimapClicks"]
		LeaPlusDB["MinimapMouseZoom"]		= LeaPlusLC["MinimapMouseZoom"]
		LeaPlusDB["MinmapHideTime"]			= LeaPlusLC["MinmapHideTime"]

		LeaPlusDB["AhExtras"]				= LeaPlusLC["AhExtras"]
		LeaPlusDB["AhBuyoutOnly"]			= LeaPlusLC["AhBuyoutOnly"]
		LeaPlusDB["AhGoldOnly"]				= LeaPlusLC["AhGoldOnly"]
		LeaPlusDB["AhDuration"]				= LeaPlusLC["AhDuration"]

		LeaPlusDB["NoDeathEffect"] 			= LeaPlusLC["NoDeathEffect"]
		LeaPlusDB["NoSpecialEffects"] 		= LeaPlusLC["NoSpecialEffects"]
		LeaPlusDB["NoGlowEffect"] 			= LeaPlusLC["NoGlowEffect"]
		LeaPlusDB["MaxZoomOutLevel"]		= LeaPlusLC["MaxZoomOutLevel"]

		LeaPlusDB["ShowVanityButtons"]		= LeaPlusLC["ShowVanityButtons"]
		LeaPlusDB["DungeonFinderButtons"]	= LeaPlusLC["DungeonFinderButtons"]
		LeaPlusDB["ShowClassIcons"]			= LeaPlusLC["ShowClassIcons"]
		LeaPlusDB["ShowHonorStat"]			= LeaPlusLC["ShowHonorStat"]
		LeaPlusDB["ShowVolume"] 			= LeaPlusLC["ShowVolume"]
		LeaPlusDB["ShowDressTab"] 			= LeaPlusLC["ShowDressTab"]

		LeaPlusDB["ShowElitePlayerChain"]	= LeaPlusLC["ShowElitePlayerChain"]
		LeaPlusDB["ShowRarePlayerChain"]	= LeaPlusLC["ShowRarePlayerChain"]

		-- Settings
		LeaPlusDB["ShowMinimapIcon"] 		= LeaPlusLC["ShowMinimapIcon"]
		LeaPlusDB["MinimapIconPos"] 		= LeaPlusLC["MinimapIconPos"]
		LeaPlusDB["PlusShowTips"] 			= LeaPlusLC["PlusShowTips"]
		LeaPlusDB["ShowBackground"]			= LeaPlusLC["ShowBackground"]
		LeaPlusDB["OpenPlusAtHome"]			= LeaPlusLC["OpenPlusAtHome"]

		LeaPlusDB["PlusPanelAlphaCheck"] 	= LeaPlusLC["PlusPanelAlphaCheck"]
		LeaPlusDB["LeaPlusAlphaValue"] 		= LeaPlusLC["LeaPlusAlphaValue"]

		LeaPlusDB["PlusPanelScaleCheck"] 	= LeaPlusLC["PlusPanelScaleCheck"]
		LeaPlusDB["LeaPlusScaleValue"] 		= LeaPlusLC["LeaPlusScaleValue"]

		LeaPlusDB["LeaStartPage"]			= LeaPlusLC["LeaStartPage"]

	end

----------------------------------------------------------------------
--	L20: Live
----------------------------------------------------------------------

--	The Live bit
	function LeaPlusLC:Live()

		-- Stop if player is in combat
		if (UnitAffectingCombat("player")) then
			LpEvt:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end

		-- Automatically accept Dungeon Finder role confirmations
		if LeaPlusLC["AutoConfirmRole"] == "On" then
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", function()
				local leader = ""
				if LeaPlusLC["GameVer"] == "5" then
					for i=1, GetNumSubgroupMembers() do 
						if (UnitIsGroupLeader("party"..i)) then 
							leader = UnitName("party"..i);
							break; 
						end
					end
				else
					leader = UnitName("party"..GetPartyLeaderIndex());
				end
				if (LeaPlusLC:FriendCheck(leader)) or (LeaPlusLC:RealIDCheck(leader)) then
					LFDRoleCheckPopupAcceptButton:Click();
				end
			end)
		else
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", nil)
		end

		-- Class colors in all channels
		if LeaPlusLC["Manageclasscolors"] == "On" then
			for i=1, 18 do
				if _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"] then
					if LeaPlusLC["ColorLocalChannels"] == "On" then
						ToggleChatColorNamesByClassGroup(true, _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"]:GetParent().type);
					else
						ToggleChatColorNamesByClassGroup(false, _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"]:GetParent().type);
					end
				end
			end
			for i=1, 50 do
				if LeaPlusLC["ColorGlobalChannels"] == "On" then
					ToggleChatColorNamesByClassGroup(true, "CHANNEL"..i)
				else
					ToggleChatColorNamesByClassGroup(false, "CHANNEL"..i)
				end
			end
		end

		-- Show Leatrix Plus background image
		if LeaPlusLC["ShowBackground"] == "On" then
			LeaPlusLC["MainTexture"]:SetTexture("Interface\\DressUpFrame\\DressUpBackground-NightElf1");
		else
			LeaPlusLC["MainTexture"]:SetTexture("");
		end

		-- Invite from whispers
		if LeaPlusLC["InviteFromWhisper"] == "On" then
			LpEvt:RegisterEvent("CHAT_MSG_WHISPER");
			LpEvt:RegisterEvent("CHAT_MSG_BN_WHISPER");
		else
			LpEvt:UnregisterEvent("CHAT_MSG_WHISPER");
			LpEvt:UnregisterEvent("CHAT_MSG_BN_WHISPER");
		end

		-- Set zoom out level to max
		if LeaPlusLC["MaxZoomOutLevel"] == "On" then
			SetCVar("CameraDistanceMax", "50")
		else
			SetCVar("CameraDistanceMax", "15")
		end

		-- Disable full-screen glow
		if LeaPlusLC["NoGlowEffect"] == "On" then
			SetCVar("ffxGlow", "0")
		else
			SetCVar("ffxGlow", "1")
		end

		-- Disable death effect
		if LeaPlusLC["NoDeathEffect"] == "On" then
			SetCVar("ffxDeath", "0")
		else
			SetCVar("ffxDeath", "1")
		end

		-- Disable special effects
		if LeaPlusLC["NoSpecialEffects"] == "On" then
			SetCVar("ffxSpecial", "0")
			SetCVar("ffxNetherWorld", "0")
		else
			SetCVar("ffxSpecial", "1")
			SetCVar("ffxNetherWorld", "1")
		end

		-- Block duels
		if LeaPlusLC["NoDuelRequests"] == "On" then
			LpEvt:RegisterEvent("DUEL_REQUESTED");
		else
			LpEvt:UnregisterEvent("DUEL_REQUESTED");
		end

		-- Block party invites
		if LeaPlusLC["NoPartyInvites"] == "On" or LeaPlusLC["AcceptPartyFriends"] == "On" then
			LpEvt:RegisterEvent("PARTY_INVITE_REQUEST");
		else
			LpEvt:UnregisterEvent("PARTY_INVITE_REQUEST");
		end

		-- Battleground release
		if LeaPlusLC["AutoReleaseInBG"] == "On" then
			LpEvt:RegisterEvent("PLAYER_DEAD");
		else
			LpEvt:UnregisterEvent("PLAYER_DEAD");
		end

		-- Automatic resurrection
		if LeaPlusLC["AutoAcceptRes"] == "On" then
			LpEvt:RegisterEvent("RESURRECT_REQUEST");
		else
			LpEvt:UnregisterEvent("RESURRECT_REQUEST");
		end

		-- Get quests automatically
		if LeaPlusLC["AutoAcceptQuests"] == "On" or (LeaPlusLC["AutoAcceptQuests"] == "On" and LeaPlusLC["AcceptOnlyDailys"] == "On") then
			LpEvt:RegisterEvent("QUEST_DETAIL");
			LpEvt:RegisterEvent("QUEST_ACCEPT_CONFIRM")
		else
			LpEvt:UnregisterEvent("QUEST_DETAIL");
			LpEvt:UnregisterEvent("QUEST_ACCEPT_CONFIRM")
		end

		-- Turn-in quests automatically
		if LeaPlusLC["AutoTurnInQuests"] == "On" then
			LpEvt:RegisterEvent("QUEST_PROGRESS")
			LpEvt:RegisterEvent("QUEST_COMPLETE")
		else
			LpEvt:UnregisterEvent("QUEST_PROGRESS")
			LpEvt:UnregisterEvent("QUEST_COMPLETE")
		end

		-- Sell junk automatically and repair automatically
		if LeaPlusLC["AutoSellJunk"] == "On" or LeaPlusLC["AutoRepairOwnFunds"] == "On" then
			LpEvt:RegisterEvent("MERCHANT_SHOW");
		else
			LpEvt:UnregisterEvent("MERCHANT_SHOW");
		end

		-- Don't confirm loot rolls
		if LeaPlusLC["NoConfirmLoot"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_LOOT_ROLL");
			LpEvt:RegisterEvent("CONFIRM_DISENCHANT_ROLL");
			LpEvt:RegisterEvent("LOOT_BIND_CONFIRM");
		else
			LpEvt:UnregisterEvent("CONFIRM_LOOT_ROLL");
			LpEvt:UnregisterEvent("CONFIRM_DISENCHANT_ROLL");
			LpEvt:UnregisterEvent("LOOT_BIND_CONFIRM");
		end

	end

----------------------------------------------------------------------
--	L21: Isolated Environment
----------------------------------------------------------------------

	function LeaPlusLC:Isolated()

		-- Fix the quest fading bug (may as well disable it for all here as there's no option to use it in the client)
		QuestInfoDescriptionText.SetAlphaGradient = function() return end

		-- Hide character controls
		if LeaPlusLC["NoCharControls"] == "on" then
			CharacterModelFrameControlFrame.Show = CharacterModelFrameControlFrame.Hide;
			DressUpModelControlFrame.Show = DressUpModelControlFrame.Hide;
			SideDressUpModelControlFrame.Show = DressUpModelControlFrame.Hide;
		end

		-- Zone text
		if LeaPlusLC["HideZoneText"] == "On" then
			ZoneTextFrame:SetScript("OnShow", function() ZoneTextFrame:Hide() end)
		end

		-- Subzone text
		if LeaPlusLC["HideSubzoneText"] == "On" then
			SubZoneTextFrame:SetScript("OnShow", function() SubZoneTextFrame:Hide() end)
		end

		-- Player chains
		if LeaPlusLC["ShowElitePlayerChain"] == "On" and LeaPlusLC["ShowRarePlayerChain"] == "Off" then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp");
		elseif LeaPlusLC["ShowElitePlayerChain"] == "On" and LeaPlusLC["ShowRarePlayerChain"] == "On" then
			PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp");
		end

		-- Classic chat
		if LeaPlusLC["NoStickyChat"] == "On" then
			ChatTypeInfo['WHISPER']['sticky'] = 0
			ChatTypeInfo['BN_WHISPER']['sticky'] = 0
		end

		-- Enable arrow keys in chat
		if LeaPlusLC["UseArrowKeysInChat"] == "On" then
			for i = 1, NUM_CHAT_WINDOWS do
				local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
				_G[format("%s%d%s", "ChatFrame", i, "EditBox")]:SetAltArrowKeyMode(false)
			end
		end

		-- Hide class bar
		if LeaPlusLC["PlayerClass"] == "HUNTER" or LeaPlusLC["PlayerClass"] == "PALADIN" or LeaPlusLC["PlayerClass"] == "DRUID" or LeaPlusLC["PlayerClass"] == "WARRIOR" or LeaPlusLC["PlayerClass"] == "DEATHKNIGHT" then
			if LeaPlusLC["NoClassBar"] == "On" then
				if LeaPlusLC["GameVer"] == "5" then
					StanceBarFrame:Hide();
					RegisterStateDriver(StanceBarFrame, "visibility", "hide")
				else
					ShapeshiftBarFrame:Hide();
					RegisterStateDriver(ShapeshiftBarFrame, "visibility", "hide")
				end
			end
		end

		-- Remove raid restrictions
		if LeaPlusLC["NoRaidRestrictions"] == "On" then
			SetAllowLowLevelRaid(1);
		end

		-- Hide gryphons
		if LeaPlusLC["NoGryphons"] == "On" then
			MainMenuBarLeftEndCap:Hide();
			MainMenuBarRightEndCap:Hide();
		end

		-- Use scrollwheel for minimap
		if LeaPlusLC["MinimapMouseZoom"] == "On" then
			MinimapZoomIn:Hide()
			MinimapZoomOut:Hide()
			Minimap:EnableMouseWheel(true)
			Minimap:SetScript("OnMouseWheel", function(self, arg1)
				if arg1 > 0 and self:GetZoom() < 5 then
					self:SetZoom(self:GetZoom() + 1)
				elseif arg1 < 0 and self:GetZoom() > 0 then
					self:SetZoom(self:GetZoom() - 1)
				end
			end)
		end

		-- Disable chat fade
		if LeaPlusLC["NoChatFade"] == "On" then
			for i = 1, NUM_CHAT_WINDOWS do
				_G[('ChatFrame'..i)]:SetFading(false)
			end
		end

		-- Bag automation
		if LeaPlusLC["NoBagAutomation"] == "On" then
			function OpenAllBags(...)
				return
			end

			function CloseAllBags(...)
				return
			end
		end

		-- Block system spam
		if LeaPlusLC["NoSystemSpam"] == "On" then

			-- Block duel spam
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(arg1,arg2,msg)
				if (UnitName("player")) and (msg:find(UnitName("player"))) then
					return
				end
				if	(msg:find(gsub(DUEL_WINNER_KNOCKOUT, "%%%d%$s", "(.+)"))) or
					(msg:find(gsub(DUEL_WINNER_RETREAT, "%%%d%$s", "(.+)"))) then
					return true
				end
			end)

			-- Block drunken spam
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(arg1,arg2,msg)
				if 	(msg:find(format(DRUNK_MESSAGE_OTHER1, ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_OTHER2, ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_OTHER3, ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_OTHER4, ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_ITEM_OTHER1, ".+", ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_ITEM_OTHER2, ".+", ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_ITEM_OTHER3, ".+", ".+"))) or
					(msg:find(format(DRUNK_MESSAGE_ITEM_OTHER4, ".+", ".+"))) then
					return true
				end
			end)
		
			-- Block dual-spec spam
			LpEvt:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(arg1,arg2,msg)
				if 	(msg:find(format(ERR_LEARN_ABILITY_S, ".+"))) or
					(msg:find(format(ERR_LEARN_SPELL_S, ".+"))) or
					(msg:find(format(ERR_SPELL_UNLEARNED_S, ".+"))) then 
					return true 
				end
			end)
			
			-- Block NPC spam in cities
			ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_SAY", function(arg1,arg2,msg)
				if IsResting() then	return true	end
			end)
			ChatFrame_AddMessageEventFilter("CHAT_MSG_MONSTER_YELL", function(arg1,arg2,msg)
				if IsResting() then	return true	end
			end)

		end

		-- Hide announcements when changing zones
		if LeaPlusLC["NoAnnounceInChat"] == "On" then
			ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(self, event, type, ...)
				if (event == "CHAT_MSG_CHANNEL_NOTICE") then
					if (type == "YOU_JOINED" or type == "YOU_LEFT" or type == "SUSPENDED") then
						return true
					elseif type == "THROTTLED" then
						return false
					else
						return true
					end
				end
			end)
		end

		-- No channels in dungeons
		if LeaPlusLC["NoChannelsInDungeons"] == "On" then
			LpEvt:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE");
		end

		-- Set tooltip position
		if LeaPlusLC["TipModEnable"] == "On" then
			hooksecurefunc("GameTooltip_SetDefaultAnchor", function (tooltip, parent)
				if (LeaPlusLC["TipAnchorToMouse"] == "On") then
					GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
				else
					GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
					GameTooltip:SetPoint(LeaPlusLC["TipPosAnchor"], UIParent, LeaPlusLC["TipPosRelative"], LeaPlusLC["TipPosXOffset"], LeaPlusLC["TipPosYOffset"]);
				end
			end)
			LeaPlusLC:SetTipScale();
		end

		-- Use easy resizing
		if LeaPlusLC["UseEasyChatResizing"] == "On" then
			ChatFrame1Tab:HookScript("OnMouseDown", function(self,arg1)
				if arg1 == "LeftButton" then
					if select(8, GetChatWindowInfo(1)) then
						ChatFrame1:StartSizing("TOP")
					end
				end
			end)
			ChatFrame1Tab:SetScript("OnMouseUp", function(self,arg1)
				if arg1 == "LeftButton" then
					ChatFrame1:StopMovingOrSizing()
					FCF_SavePositionAndDimensions(ChatFrame1)
				end
			end)
		end

		-- Block interrupt messages
		if LeaPlusLC["PlayerLocale"] ~= "enUS" then
			LeaPlusLC:LockItem(LeaPlusCB["NoInterruptSpam"],true)

		elseif LeaPlusLC["NoInterruptSpam"] == "On" then

			local function LeaPlusInterruptFilter(arg1,arg2,msg,arg4)
				if not (IsInInstance() == nil) and (UnitAffectingCombat("player")) then
					for k,v in pairs(LeaPlusLC["InterruptSpamTable"]) do
						if string.lower(msg):find(v) then
							return true
						end
					end
				end
			end

			if LeaPlusLC["NoInterruptSpam"] == "On" then
				ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", LeaPlusInterruptFilter)
				ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", LeaPlusInterruptFilter)
				ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", LeaPlusInterruptFilter)
				ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", LeaPlusInterruptFilter)
				ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", LeaPlusInterruptFilter)
				ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", LeaPlusInterruptFilter)
			end

		end

		-- Short channel names
		if LeaPlusLC["PlayerLocale"] ~= "enUS" and LeaPlusLC["PlayerLocale"] ~= "deDE" and LeaPlusLC["PlayerLocale"] ~= "frFR" and LeaPlusLC["PlayerLocale"] ~= "ruRU" then
			LeaPlusLC:LockItem(LeaPlusCB["ShortenChatChannels"],true)

		elseif LeaPlusLC["ShortenChatChannels"] == "On" then

			local LeaPlusShortNew = {}
			if not LeaPlusLC["Short"] then LeaPlusLC["Short"] = {} end

			-- Locale support
			if LeaPlusLC["PlayerLocale"] == "enUS" then
				LeaPlusLC["Short"]["Gen"] 	= "%[%d0?%. General.-%]"
				LeaPlusLC["Short"]["Trade"] = "%[%d0?%. Trade.-%]"
				LeaPlusLC["Short"]["WD"] 	= "%[%d0?%. WorldDefense%]"
				LeaPlusLC["Short"]["LD"] 	= "%[%d0?%. LocalDefense.-%]"
				LeaPlusLC["Short"]["LFG"] 	= "%[%d0?%. LookingForGroup%]"
				LeaPlusLC["Short"]["GR"] 	= "%[%d0?%. GuildRecruitment.-%]"

			elseif LeaPlusLC["PlayerLocale"] == "deDE" then
				LeaPlusLC["Short"]["Gen"] 	= "%[%d0?%. Allgemein.-%]"
				LeaPlusLC["Short"]["Trade"] = "%[%d0?%. Handel.-%]"
				LeaPlusLC["Short"]["WD"] 	= "%[%d0?%. Weltverteidigung%]"
				LeaPlusLC["Short"]["LD"] 	= "%[%d0?%. LokaleVerteidigung.-%]"
				LeaPlusLC["Short"]["LFG"] 	= "%[%d0?%. SucheNachGruppe%]"
				LeaPlusLC["Short"]["GR"]	= "%[%d0?%. Gildenrekrutierung.-%]"

			elseif LeaPlusLC["PlayerLocale"] == "frFR" then
				LeaPlusLC["Short"]["Gen"] 	= "%[%d0?%. Général.-%]"
				LeaPlusLC["Short"]["Trade"] = "%[%d0?%. Commerce.-%]"
				LeaPlusLC["Short"]["WD"] 	= "%[%d0?%. DéfenseUniverselle%]"
				LeaPlusLC["Short"]["LD"] 	= "%[%d0?%. DéfenseLocale.-%]"
				LeaPlusLC["Short"]["LFG"] 	= "%[%d0?%. RechercheDeGroupe%]"
				LeaPlusLC["Short"]["GR"]	= "%[%d0?%. RecrutementDeGuilde.-%]"

			elseif LeaPlusLC["PlayerLocale"] == "ruRU" then
				LeaPlusLC["Short"]["Gen"] 	= "%[%d0?%. Общий.-%]"
				LeaPlusLC["Short"]["Trade"] = "%[%d0?%. Торговля.-%]"
				LeaPlusLC["Short"]["WD"] 	= "%[%d0?%. Оборона: глобальный%]"
				LeaPlusLC["Short"]["LD"] 	= "%[%d0?%. Оборона.-%]"
				LeaPlusLC["Short"]["LFG"] 	= "%[%d0?%. Поиск спутников%]"
				LeaPlusLC["Short"]["GR"]	= "%[%d0?%. Гильдии.-%]"

			end

			for i=1, NUM_CHAT_WINDOWS do
				if i ~= 2 then
					LeaPlusShortNew[format("%s%d", "ChatFrame", i)] = _G[format("%s%d", "ChatFrame", i)].AddMessage
					_G[format("%s%d", "ChatFrame", i)].AddMessage = function(self, text, ...)

						text = gsub(text, LeaPlusLC["Short"]["Gen"]		, "[GEN]") 
						text = gsub(text, LeaPlusLC["Short"]["Trade"]	, "[T]") 
						text = gsub(text, LeaPlusLC["Short"]["WD"]		, "[WD]") 
						text = gsub(text, LeaPlusLC["Short"]["LD"]		, "[LD]") 
						text = gsub(text, LeaPlusLC["Short"]["LFG"]		, "[LFG]") 
						text = gsub(text, LeaPlusLC["Short"]["GR"]		, "[GR]") 
						
						text = gsub(text, gsub(CHAT_BATTLEGROUND_GET		, ".*%[(.*)%].*", "%%[%1%%]"), "[BG]")
						text = gsub(text, gsub(CHAT_BATTLEGROUND_LEADER_GET	, ".*%[(.*)%].*", "%%[%1%%]"), "[BGL]") 
						text = gsub(text, gsub(CHAT_GUILD_GET				, ".*%[(.*)%].*", "%%[%1%%]"), "[G]") 
						text = gsub(text, gsub(CHAT_PARTY_GET				, ".*%[(.*)%].*", "%%[%1%%]"), "[P]") 
						text = gsub(text, gsub(CHAT_PARTY_LEADER_GET		, ".*%[(.*)%].*", "%%[%1%%]"), "[PL]") 
						text = gsub(text, gsub(CHAT_PARTY_GUIDE_GET			, ".*%[(.*)%].*", "%%[%1%%]"), "[PL]") 
						text = gsub(text, gsub(CHAT_OFFICER_GET				, ".*%[(.*)%].*", "%%[%1%%]"), "[O]") 
						text = gsub(text, gsub(CHAT_RAID_GET				, ".*%[(.*)%].*", "%%[%1%%]"), "[R]") 
						text = gsub(text, gsub(CHAT_RAID_LEADER_GET			, ".*%[(.*)%].*", "%%[%1%%]"), "[RL]") 
						text = gsub(text, gsub(CHAT_RAID_WARNING_GET		, ".*%[(.*)%].*", "%%[%1%%]"), "[RW]") 
						text = gsub(text, "%[(%d0?)%. (.-)%]", "[%1]")

						return LeaPlusShortNew[self:GetName()](self, text, ...)
					end
				end
			end
		end

		-- Chat history size
		if LeaPlusLC["MaxChatHstory"] == "On" then
			for i = 1, NUM_CHAT_WINDOWS, 1 do
				if (_G["ChatFrame" .. i]:GetMaxLines() ~= 4096) then
					_G["ChatFrame" .. i]:SetMaxLines(4096);
				end
			end
		end

		-- Minimap clicks
		if LeaPlusLC["UseMinimapClicks"] == "On" then
			MiniMapTracking:Hide()
			GameTimeFrame:Hide()
			Minimap:SetScript("OnMouseUp", function(self, button)

				if button == "RightButton"  then
					ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
				elseif button == "MiddleButton" then
					ToggleCalendar()
				elseif button == "LeftButton" then
					Minimap_OnClick(self)
				end

			end)
		end

		-- Hide boss frames
		if LeaPlusLC["NoBossFrames"] == "On" then
			for i = 1, 4 do
				_G["Boss"..i.."TargetFrame"]:UnregisterAllEvents()
				_G["Boss"..i.."TargetFrame"]:Hide()
				_G["Boss"..i.."TargetFrame"].Show = function () end
			end
		end
		
		-- Dungeon Finder buttons
		if LeaPlusLC["DungeonFinderButtons"] == "On" then

			-- Dungeon Finder time button
			LeaPlusCB["DungeonTimeButton"] = CreateFrame("Button", nil, LFDQueueFrame, "UIPanelButtonTemplate") 
			LeaPlusCB["DungeonTimeButton"]:SetWidth(30)
			LeaPlusCB["DungeonTimeButton"]:SetHeight(30) 
			LeaPlusCB["DungeonTimeButton"]:SetPoint("BOTTOMLEFT", 04, 292)
			LeaPlusCB["DungeonTimeButton"]:RegisterForClicks("AnyUp") 

			LeaPlusCB["DungeonTimeButton"]:SetNormalTexture([[Interface/LFGFRAME/BattlenetWorking9]])
			LeaPlusCB["DungeonTimeButton"]:SetHighlightTexture([[Interface/LFGFRAME/BattlenetWorking3]])
			LeaPlusCB["DungeonTimeButton"]:SetPushedTexture([[Interface/LFGFRAME/BattlenetWorking3]])

			LeaPlusCB["DungeonTimeButton"]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				GameTooltip:SetText("Toggles showing your random dungeon cooldown.", nil, nil, nil, nil, true)
			end)

			LeaPlusCB["DungeonTimeButton"]:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)

			LeaPlusCB["DungeonTimeButton"]:SetScript("OnClick", function() 
				if LFDQueueFramePartyBackfillNoBackfillButton:IsShown() then
					LFDQueueFramePartyBackfillNoBackfillButton:Click();
				end
				if LFDQueueFrameCooldownFrame:IsShown() then
					LFDQueueFrameCooldownFrame:Hide();
				else
					LFDQueueFrameCooldownFrame:Show();
				end
			end)

			-- Create checkbox for Role Check Confirmations
			LeaPlusCB["DungeonAntiHarassBox"] = CreateFrame('CheckButton', nil, LFDQueueFrame, "OptionsCheckButtonTemplate")
			LeaPlusCB["DungeonAntiHarassBox"]:SetText("")
			LeaPlusCB["DungeonAntiHarassBox"]:SetHitRectInsets(0, 0, 0, 0);
			LeaPlusCB["DungeonAntiHarassBox"]:SetSize(24, 24)
			LeaPlusCB["DungeonAntiHarassBox"]:SetPoint("BOTTOMLEFT", 46, 290)

			-- Click the checkbox
			LeaPlusCB["DungeonAntiHarassBox"]:SetScript('OnClick', function()
				if LeaPlusCB["DungeonAntiHarassBox"]:GetChecked() then
					SetRaidTargetIcon("player", 0);
					LeaPlusCB["DungeonAntiHarassBox"]:RegisterEvent("RAID_TARGET_UPDATE");
				else
					LeaPlusCB["DungeonAntiHarassBox"]:UnregisterEvent("RAID_TARGET_UPDATE");
				end
			end)

			-- Hide target markers
			LeaPlusCB["DungeonAntiHarassBox"]:SetScript("OnEvent", function()
				SetRaidTargetIcon("player", 0);
			end)

			-- Show tooltip
			LeaPlusCB["DungeonAntiHarassBox"]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_LEFT")
				GameTooltip:SetText("If checked, target markers placed on you will be automatically removed.\n\nYou can use this checkbox if someone in your dungeon group is behaving inappropriately.\n\nThe setting of this checkbox is not saved between login sessions.", nil, nil, nil, nil, 1)
			end)

			LeaPlusCB["DungeonAntiHarassBox"]:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)

		end

		-- Quest levels
		if LeaPlusLC["ShowQuestLevels"] == "On" then

			-- Create table for tags (only needed if quest type tags are used)
			local _, QuestTags = {}, {Elite = "+", Group = "G", Dungeon = "D", Raid = "R", PvP = "P", Daily = "!", Heroic = "H", Repeatable = "?"}

			-- Show quest levels
			local function QuestFunc()

				local buttons = QuestLogScrollFrame.buttons
				local QuestButtons = #buttons
				local QuestScrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
				local QuestEntries, _ = GetNumQuestLogEntries()

				-- Go through quest log
				for i = 1, QuestButtons do
					local QuestIndex = i + QuestScrollOffset
					local QuestTitle = buttons[i]
					if QuestIndex <= QuestEntries then

						local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(QuestIndex)

						-- Add quest type
						if not isHeader or title then
							if not suggestedGroup or suggestedGroup == 0 then suggestedGroup = nil end
							title = string.format("[%s%s%s%s] %s", level, questTag and QuestTags[questTag] or "", isDaily and QuestTags.Daily or "",suggestedGroup or "", title), questTag, isDaily, isComplete
						end

						-- Show quest title with level
						if not isHeader then
							QuestTitle:SetText(title)
							QuestLogTitleButton_Resize(QuestTitle)
						end

					end
				end

			end

			hooksecurefunc('QuestLog_Update', QuestFunc)
			QuestLogScrollFrameScrollBar:HookScript('OnValueChanged', QuestFunc)

		end

		-- Error text
		if LeaPlusLC["HideErrorFrameText"] == "On" then
	
			local LeaPlusErrScript = UIErrorsFrame:GetScript('OnEvent')

			--	Error message events
			UIErrorsFrame:SetScript('OnEvent', function (self, event, LeaPlusError, ...)

				-- Handle error messages
				if event == "UI_ERROR_MESSAGE" then
					if LeaPlusLC["ShowErrorsFlag"] == 1 then
						if 	LeaPlusError == ERR_INV_FULL or
							LeaPlusError == ERR_QUEST_LOG_FULL or
							LeaPlusError == ERR_RAID_GROUP_ONLY	or
							LeaPlusError == ERR_PARTY_LFG_BOOT_LIMIT or
							LeaPlusError == ERR_PARTY_LFG_BOOT_DUNGEON_COMPLETE or
							LeaPlusError == ERR_PARTY_LFG_BOOT_IN_COMBAT or
							LeaPlusError == ERR_PARTY_LFG_BOOT_IN_PROGRESS or
							LeaPlusError == ERR_PARTY_LFG_BOOT_LOOT_ROLLS or
							LeaPlusError:find(format(ERR_PARTY_LFG_BOOT_NOT_ELIGIBLE_S, ".+")) or
							LeaPlusError == ERR_PARTY_LFG_TELEPORT_IN_COMBAT or
							LeaPlusError == ERR_PET_SPELL_DEAD or
							LeaPlusError == ERR_PLAYER_DEAD then
							return LeaPlusErrScript(self, event, LeaPlusError, ...) 
						end
					else
						return LeaPlusErrScript(self, event, LeaPlusError, ...) 
					end
				end

				-- Handle information messages
				if event == 'UI_INFO_MESSAGE'  then
					if LeaPlusLC["ShowQuestUpdates"] == "On" then
						return LeaPlusErrScript(self, event, LeaPlusError, ...)
					end
				end

			end)

		end

		-- Character sheet checkboxes
		if LeaPlusLC["ShowVanityButtons"] == "On" then

			-- Create checkboxs
			LeaPlusCB["ShowHelmBox"] = CreateFrame('CheckButton', nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
			LeaPlusCB["ShowHelmBox"]:SetHitRectInsets(0, 0, 0, 0);
			LeaPlusCB["ShowHelmBox"]:SetSize(24, 24)
			LeaPlusCB["ShowHelmBox"]:SetPoint("TOPLEFT", 5, -165)

			LeaPlusCB["ShowHelmBox.f"] = LeaPlusCB["ShowHelmBox"]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
			LeaPlusCB["ShowHelmBox.f"]:SetPoint("LEFT", 24, 0)
			LeaPlusCB["ShowHelmBox.f"]:SetText("Helm")
			LeaPlusCB["ShowHelmBox.f"]:Show();

			LeaPlusCB["ShowCloakBox"] = CreateFrame('CheckButton', nil, CharacterModelFrame, "OptionsCheckButtonTemplate")
			LeaPlusCB["ShowCloakBox"]:SetHitRectInsets(0, 0, 0, 0);
			LeaPlusCB["ShowCloakBox"]:SetSize(24, 24)
			LeaPlusCB["ShowCloakBox"]:SetPoint("TOPLEFT", 75, -165)

			LeaPlusCB["ShowCloakBox.f"] = LeaPlusCB["ShowCloakBox"]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
			LeaPlusCB["ShowCloakBox.f"]:SetPoint("LEFT", 24, 0)
			LeaPlusCB["ShowCloakBox.f"]:SetText("Cloak")
			LeaPlusCB["ShowCloakBox.f"]:Show();

			-- Set the checkbox state
			LeaPlusCB["ShowHelmBox"]:SetScript('OnShow', function() 
				LeaPlusCB["ShowHelmBox"]:SetChecked(ShowingHelm())
			end)
			LeaPlusCB["ShowCloakBox"]:SetScript('OnShow', function() 
				LeaPlusCB["ShowCloakBox"]:SetChecked(ShowingCloak())
			end)

			-- Click the checkboxes
			LeaPlusCB["ShowHelmBox"]:SetScript('OnClick', function()
				ShowHelm(LeaPlusCB["ShowHelmBox"]:GetChecked())
			end)
			LeaPlusCB["ShowCloakBox"]:SetScript('OnClick', function()
				ShowCloak(LeaPlusCB["ShowCloakBox"]:GetChecked())
			end)

			-- Unusable while dead
			CharacterModelFrame:HookScript("OnShow",function()

				if UnitIsDeadOrGhost("player") then
					LeaPlusLC:LockItem(LeaPlusCB["ShowHelmBox"],true)
					LeaPlusLC:LockItem(LeaPlusCB["ShowCloakBox"],true)
				else
					LeaPlusLC:LockItem(LeaPlusCB["ShowHelmBox"],false)
					LeaPlusLC:LockItem(LeaPlusCB["ShowCloakBox"],false)
				end

			end)

		end

		-- Show hide tabard button on dressup windows
		if LeaPlusLC["ShowDressTab"] == "On" then

			-- Add button to main dressup frame
			LeaPlusLC:CreateButton("DressUpTabBtn", DressUpFrame, "Hide Tabard", "BOTTOMLEFT", 26, 79, 116, 22,"")
			LeaPlusCB["DressUpTabBtn"]:SetScript("OnClick", function()
				DressUpModel:UndressSlot(19)
			end)

			-- Add button to auction house dressup frame
			LeaPlusLC:CreateButton("DressUpSideBtn", SideDressUpFrame, "Hide Tabard", "BOTTOMLEFT", 34, 20, 116, 22,"")
			LeaPlusCB["DressUpSideBtn"]:SetFrameStrata("HIGH");
			LeaPlusCB["DressUpSideBtn"]:SetScript("OnClick", function()
				SideDressUpModel:UndressSlot(19)
			end)

		end

		-- Honor shown in tooltip
		if LeaPlusLC["ShowHonorStat"] == "On" then
			PVPFrameHonor:HookScript("OnEnter", function()
				GameTooltip:AddLine("Lifetime Honorable Kills: |cffffffff" .. GetStatistic(588))
				GameTooltip:Show();
			end)
		end

		-- Mend Pet icon
		if LeaPlusLC["ShowClassIcons"] == "On" then
			if LeaPlusLC["PlayerClass"] == "HUNTER" then
				LeaPlusLC:ShowBuff("Mend", 136, "pet", TargetFrame, 22, 20, "TOPLEFT", 5, 5)
				LeaPlusLC:ShowBuff("Focus Fire", 82692, "player", TargetFrame, 22, 20, "TOPLEFT", 30, 5)
			elseif LeaPlusLC["PlayerClass"] == "DRUID" then
				LeaPlusLC:ShowBuff("Predatorsswiftness", 69369, "player", TargetFrame, 22, 20, "TOPLEFT", 5, 5)
			end
		end

		----------------------------------------------------------------------
		-- Minimap button (no reload required)
		----------------------------------------------------------------------

		do

			-- Minimap button click function
			local function MiniBtnClickFunc(arg1)

				if LeaPlusLC["LeaPlusFrameMove"] and LeaPlusLC["LeaPlusFrameMove"]:IsShown() then return end
                if LeaPlusCB["TooltipDragFrame"] and LeaPlusCB["TooltipDragFrame"]:IsShown() then return end
                if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() then return end

                if arg1 == "LeftButton" then
                    if IsShiftKeyDown() then
                        ReloadUI();
                        --Sound_ToggleMusic();
                        if GetCVar("Sound_EnableMusic") == "1" then
                            LeaPlusLC:Print("Music enabled.")
                        else
                            LeaPlusLC:Print("Music disabled.")
                        end
                    else
                        if LeaPlusLC["PageF"]:IsShown() then
                            LeaPlusLC:HideFrames();
                        else
                            LeaPlusLC:HideFrames();
                            LeaPlusLC["PageF"]:Show();
                        end
                        if LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]] and LeaPlusLC["OpenPlusAtHome"] == "Off" then
                             LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
                        else
                            LeaPlusLC["Page0"]:Show();
                        end
                    end
                end
                if arg1 == "RightButton" then
                    if IsShiftKeyDown() then
                        ReloadUI();
                        --Sound_ToggleMusic();
                        if GetCVar("Sound_EnableMusic") == "1" then
                            LeaPlusLC:Print("Music enabled.")
                        else
                            LeaPlusLC:Print("Music disabled.")
                        end
                    else
                        if LeaPlusLC["PageF"]:IsShown() then
                            LeaPlusLC:HideFrames();
                        else
                            LeaPlusLC:HideFrames();
                            LeaPlusLC["PageF"]:Show();
                        end
                        if LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]] and LeaPlusLC["OpenPlusAtHome"] == "Off" then
                             LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
                        else
                            LeaPlusLC["Page0"]:Show();
                        end
                    end
                end

			end

			-- Create minimap button using LibDBIcon
			local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("Leatrix_Plus", {
				type = "data source",
				text = "Leatrix Plus",
				icon = "Interface\\addons\\Leatrix_Plus\\assets\\minimapicon.tga",
				OnClick = function(self, btn)
					MiniBtnClickFunc(btn)
				end,
				OnTooltipShow = function(tooltip)
					if not tooltip or not tooltip.AddLine then return end
					tooltip:AddLine("Leatrix Plus")
					tooltip:AddLine("|cffeda55fClick|r to open Leatrix Plus options.")
                    tooltip:AddLine("|cffeda55fShift-Click|r to reload the user interface.")
				end,
			})

			local icon = LibStub("LibDBIcon-1.0", true)
			icon:Register("Leatrix_Plus", miniButton, LeaPlusDB)

			-- Function to toggle LibDBIcon
			local function SetLibDBIconFunc()
				if LeaPlusLC["ShowMinimapIcon"] == "On" then
					LeaPlusDB["hide"] = false
					icon:Show("Leatrix_Plus")
				else
					LeaPlusDB["hide"] = true
					icon:Hide("Leatrix_Plus")
				end
			end

			-- Set LibDBIcon when option is clicked and on startup
			LeaPlusCB["ShowMinimapIcon"]:HookScript("OnClick", SetLibDBIconFunc)
			SetLibDBIconFunc()

		end

		----------------------------------------------------------------------
		--	Tooltip customisation
		----------------------------------------------------------------------

		if LeaPlusLC["TipModEnable"] == "On" then

			local LeaPlusTT = {}

			-- Tooltip
			LeaPlusTT["LpTipColorBlind"] = GetCVar("colorblindMode")

			-- 	Create drag frame
			LeaPlusCB["TooltipDragFrame"] = CreateFrame("Frame", nil, UIParent)
			LeaPlusCB["TooltipDragFrame"]:SetMovable(true)
			LeaPlusCB["TooltipDragFrame"]:EnableMouse(true)
			LeaPlusCB["TooltipDragFrame"]:RegisterForDrag("LeftButton")
			LeaPlusCB["TooltipDragFrame"]:SetToplevel(true);
			LeaPlusCB["TooltipDragFrame"]:SetClampedToScreen();
			LeaPlusCB["TooltipDragFrame"]:SetSize(130, 64);
			LeaPlusCB["TooltipDragFrame"]:Hide();
			LeaPlusCB["TooltipDragFrame"]:SetFrameStrata("TOOLTIP")
			LeaPlusCB["TooltipDragFrame"]:SetBackdropColor(0.0, 0.5, 1.0);
			LeaPlusCB["TooltipDragFrame"]:SetBackdrop({ 
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 16,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }});

			-- Show text in drag frame
			LeaPlusCB["TooltipDragFrame.f"] = LeaPlusCB["TooltipDragFrame"]:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
			LeaPlusCB["TooltipDragFrame.f"]:SetPoint('TOPLEFT', 16, -16)
			LeaPlusCB["TooltipDragFrame.f"]:SetText("Tooltip")

			-- Create texture
			LeaPlusCB["TooltipDragFrame.t"] = LeaPlusCB["TooltipDragFrame"]:CreateTexture()
			LeaPlusCB["TooltipDragFrame.t"]:SetAllPoints()
			LeaPlusCB["TooltipDragFrame.t"]:SetTexture(0.0, 0.5, 1.0,0.5)
			LeaPlusCB["TooltipDragFrame.t"]:SetAlpha(0.5)

			-- Create moving message
			local LeaPlusMoveTipMsg = UIParent:CreateFontString(nil, "OVERLAY", 'GameFontNormalLarge')
			LeaPlusMoveTipMsg:SetPoint("CENTER", 0, 0)
			LeaPlusMoveTipMsg:SetText("Drag the tooltip frame then right-click it to finish.")
			LeaPlusMoveTipMsg:Hide();

			-- Control movement functions
			LeaPlusCB["TooltipDragFrame"]:SetScript("OnMouseDown", function (self,arg1)
				if arg1 == "RightButton" then
					LeaPlusMoveTipMsg:Hide();
					if LeaPlusCB["TooltipDragFrame"]:IsShown() then
						LeaPlusCB["TooltipDragFrame"]:Hide();
					end
					LeaPlusLC["PageF"]:Show();
					LeaPlusLC["Page5"]:Show();
					return
				end
			end)
			LeaPlusCB["TooltipDragFrame"]:SetScript("OnDragStart", LeaPlusCB["TooltipDragFrame"].StartMoving)
			LeaPlusCB["TooltipDragFrame"]:SetScript("OnDragStop", function ()
				LeaPlusCB["TooltipDragFrame"]:StopMovingOrSizing();
				LeaPlusLC["TipPosAnchor"], LeaPlusLC["LpTipRelaAnchor"], LeaPlusLC["TipPosRelative"], LeaPlusLC["TipPosXOffset"], LeaPlusLC["TipPosYOffset"] = LeaPlusCB["TooltipDragFrame"]:GetPoint()
			end)

			--	Move the tooltip
			LeaPlusCB["MoveTooltipButton"]:SetScript("OnClick", function()
				LeaPlusLC:HideFrames();
				LeaPlusMoveTipMsg:Show();
				if LeaPlusCB["TooltipDragFrame"]:IsShown() then
					LeaPlusMoveTipMsg:Hide();
					LeaPlusCB["TooltipDragFrame"]:Hide();
					return
				else
					LeaPlusCB["TooltipDragFrame"]:Show();
				end

				-- Set scale
				if LeaPlusLC["TipScaleCheck"] == "On" then
					LeaPlusCB["TooltipDragFrame"]:SetScale(LeaPlusLC["LeaPlusTipSize"])
				else
					LeaPlusCB["TooltipDragFrame"]:SetScale(1.00)
				end

				-- Set position of the drag frame
				LeaPlusCB["TooltipDragFrame"]:ClearAllPoints();
				LeaPlusCB["TooltipDragFrame"]:SetPoint(LeaPlusLC["TipPosAnchor"], UIParent, LeaPlusLC["TipPosRelative"], LeaPlusLC["TipPosXOffset"], LeaPlusLC["TipPosYOffset"]);
			end)
					
			-- Colorblind setting change
			LeaPlusCB["TooltipDragFrame"]:RegisterEvent("CVAR_UPDATE");
			LeaPlusCB["TooltipDragFrame"]:SetScript("OnEvent", function(self,event,arg1,arg2)
				if (arg1 == "USE_COLORBLIND_MODE") then
					LeaPlusTT["LpTipColorBlind"] = arg2;
				end
			end)

			-- Reset position button
			LeaPlusCB["ResetTooltipButton"]:SetScript("OnClick", function()
				LeaPlusCB["TooltipDragFrame"]:Hide();
				LeaPlusLC["TipPosXOffset"] = "-13";
				LeaPlusLC["TipPosYOffset"] = "94";
				LeaPlusLC["TipPosAnchor"] = "BOTTOMRIGHT";
				LeaPlusLC["TipPosRelative"] = "BOTTOMRIGHT";
			end)

			-- 	Replace line in the tooltip
			local function repline(line,text)
				_G["GameTooltipTextLeft"..line]:SetText(text)
			end

			--	Show tooltip
			local function ShowTip(update)

				-- If tooltips are hidden in combat, hide them and go back!
				if LeaPlusLC["TipHideInCombat"] == "On" and (UnitAffectingCombat("player") == 1) and not IsShiftKeyDown() then
					GameTooltip:Hide()
					return
				end

				-- Get unit information
				if GetMouseFocus() == WorldFrame then
					LeaPlusTT["LpTipUnitTarget"] = "mouseover"
				else
					LeaPlusTT["LpTipNameHelper"], LeaPlusTT["LpTipUnitTarget"] = GameTooltip:GetUnit()
					if not (LeaPlusTT["LpTipUnitTarget"]) then return end
				end

				-- If something is wrong, get the hell out of here!
				if (UnitReaction(LeaPlusTT["LpTipUnitTarget"],"player")) == nil then return end

				-- Setup variables
				local TipUnitName, TipUnitRealm = UnitName(LeaPlusTT["LpTipUnitTarget"])
				local TipIsPlayer = UnitIsPlayer(LeaPlusTT["LpTipUnitTarget"])
				local TipUnitLevel = UnitLevel(LeaPlusTT["LpTipUnitTarget"])
				local _,TipUnitClass = UnitClassBase(LeaPlusTT["LpTipUnitTarget"])

				-- Get guild information
				if (TipIsPlayer) then
					if (GetGuildInfo(LeaPlusTT["LpTipUnitTarget"])) then
						if LeaPlusTT["LpTipColorBlind"] == "1" then
							LeaPlusTT["LpTipGuildLines"], LeaPlusTT["LpTipInfomation"] = 2, 4
						else
							LeaPlusTT["LpTipGuildLines"], LeaPlusTT["LpTipInfomation"] = 2, 3
						end
						LeaPlusTT["LpTipGuildNames"], LeaPlusTT["LpTipGuildsRank"] = GetGuildInfo(LeaPlusTT["LpTipUnitTarget"])
						LeaPlusTT["LpTipMyOwnGuild"], _ = GetGuildInfo("player")
					else
						LeaPlusTT["LpTipGuildNames"] = nil
						if LeaPlusTT["LpTipColorBlind"] == "1" then
							LeaPlusTT["LpTipGuildLines"], LeaPlusTT["LpTipInfomation"] = 0,3
						else
							LeaPlusTT["LpTipGuildLines"], LeaPlusTT["LpTipInfomation"] = 0,2
						end
					end
				end

				-- Sort out the class color
				if (TipUnitClass) then
					LeaPlusTT["LpTipPlayGender"] = (UnitSex(LeaPlusTT["LpTipUnitTarget"]))
					if LeaPlusTT["LpTipPlayGender"] == 2 then
						LeaPlusTT["LpTipUnitsClass"] = LOCALIZED_CLASS_NAMES_MALE[TipUnitClass]
					else
						LeaPlusTT["LpTipUnitsClass"] = LOCALIZED_CLASS_NAMES_FEMALE[TipUnitClass]
					end
					LeaPlusTT["LpTipPureClassC"] = RAID_CLASS_COLORS[TipUnitClass]
					LeaPlusTT["LpTipClassColor"] = "|cff" .. string.format('%02x%02x%02x',LeaPlusTT["LpTipPureClassC"].r * 255, LeaPlusTT["LpTipPureClassC"].g * 255, LeaPlusTT["LpTipPureClassC"].b * 255)
				end
				----------------------------------------------------------------------
				-- Name line (name and realm for friendly or higher players, pets and npcs)
				if ((TipIsPlayer) or (UnitPlayerControlled(LeaPlusTT["LpTipUnitTarget"]))) or (UnitReaction(LeaPlusTT["LpTipUnitTarget"],"player")) > 4 then

					-- If it's a player show name in class color
					if (TipIsPlayer) then
						LeaPlusTT["TipNameColor"] = LeaPlusTT["LpTipClassColor"]
					else
						-- If not, set to green or blue depending on PvP status
						if (UnitIsPVP(LeaPlusTT["LpTipUnitTarget"])) then
							LeaPlusTT["TipNameColor"] = "|cff00ff00"
						else
							LeaPlusTT["TipNameColor"] = "|cff00aaff"
						end
					end

					-- Show title
					if LeaPlusLC["TipShowTitle"] == "On" then
						LeaPlusTT["TipNameData"] = UnitPVPName(LeaPlusTT["LpTipUnitTarget"])
					else
						LeaPlusTT["TipNameData"] = TipUnitName
					end

					-- Show realm
					if not (TipUnitRealm == nil) and LeaPlusLC["TipShowRealm"] == "On" then
						LeaPlusTT["TipNameData"] = LeaPlusTT["TipNameData"] .. " - " .. TipUnitRealm
					end

					-- Show dead units in grey
					if UnitIsDeadOrGhost(LeaPlusTT["LpTipUnitTarget"]) then
						LeaPlusTT["TipNameColor"] = "|c88888888"
					end

					-- Show name line in color (alive) or grey (dead)
					repline(1, LeaPlusTT["TipNameColor"] .. LeaPlusTT["TipNameData"] .. "|cffffffff|r")
					
				elseif UnitIsDeadOrGhost(LeaPlusTT["LpTipUnitTarget"]) then

					-- Show grey name for other dead units
					repline(1,"|c88888888" .. _G["GameTooltipTextLeft1"]:GetText() .. "|cffffffff|r")

				return end
				----------------------------------------------------------------------
				-- Guild line
				if (TipIsPlayer) and not (LeaPlusTT["LpTipGuildNames"] == nil) then
					
					-- Show guild line (with rank if enabled)
					if LeaPlusLC["TipShowRank"] == "On" then
						if (LeaPlusTT["LpTipGuildNames"] == LeaPlusTT["LpTipMyOwnGuild"]) then
							repline (LeaPlusTT["LpTipGuildLines"], "|c00aaaaff" .. LeaPlusTT["LpTipGuildNames"] .. " - " .. LeaPlusTT["LpTipGuildsRank"] .. "|r")
						else
							repline (LeaPlusTT["LpTipGuildLines"], "|c00aaaaff" .. LeaPlusTT["LpTipGuildNames"] .. "|cffffffff|r")
						end
					else
						repline (LeaPlusTT["LpTipGuildLines"], "|c00aaaaff" .. LeaPlusTT["LpTipGuildNames"] .. "|cffffffff|r")
					end
				end
				----------------------------------------------------------------------
				-- Information line (level, class, race)
				if (TipIsPlayer) then

					-- Show level
					if (UnitReaction(LeaPlusTT["LpTipUnitTarget"],"player")) < 5 then
						if TipUnitLevel == -1 then
							LeaPlusTT["LpTipInfomaData"] = ("|cffff3333Level ??|cffffffff")
						else
							LeaPlusTT["LpTipLevelColor"] = (GetQuestDifficultyColor(UnitLevel(LeaPlusTT["LpTipUnitTarget"])))
							LeaPlusTT["LpTipLevelColor"] = string.format('%02x%02x%02x', LeaPlusTT["LpTipLevelColor"].r * 255, LeaPlusTT["LpTipLevelColor"].g * 255, LeaPlusTT["LpTipLevelColor"].b * 255)
							LeaPlusTT["LpTipInfomaData"] = ("|cff" .. LeaPlusTT["LpTipLevelColor"] .. "Level " .. TipUnitLevel .. "|cffffffff")
						end
					else
						LeaPlusTT["LpTipInfomaData"] = "Level " .. TipUnitLevel
					end

					-- Show race
					if (LeaPlusLC["TipShowRace"] == "On") then
						LeaPlusTT["LpTipInfomaData"] = LeaPlusTT["LpTipInfomaData"] .. " " .. UnitRace(LeaPlusTT["LpTipUnitTarget"])
					end

					-- Show class
					if (LeaPlusLC["TipShowClass"] == "On") then
						LeaPlusTT["LpTipInfomaData"] = LeaPlusTT["LpTipInfomaData"] .. " " .. LeaPlusTT["LpTipClassColor"] .. LeaPlusTT["LpTipUnitsClass"]
					end

					-- Show information line
					repline (LeaPlusTT["LpTipInfomation"], LeaPlusTT["LpTipInfomaData"] .. "|cffffffff|r")

				end
				----------------------------------------------------------------------
				-- Mob name in brighter red (alive) and steel blue (tapped)
				if not (TipIsPlayer) and (UnitReaction(LeaPlusTT["LpTipUnitTarget"],"player")) < 4 and not (UnitPlayerControlled(LeaPlusTT["LpTipUnitTarget"])) then
					if (UnitIsTapped(LeaPlusTT["LpTipUnitTarget"]) and not (UnitIsTappedByPlayer(LeaPlusTT["LpTipUnitTarget"]))) then
						LeaPlusTT["TipNameData"] = "|c8888bbbb" .. TipUnitName .. "|r"
					else
						LeaPlusTT["TipNameData"] = "|cffff3333" .. TipUnitName .. "|r"
					end
					repline(1,LeaPlusTT["TipNameData"])
				end
				----------------------------------------------------------------------
				-- Mob level in color (neutral or lower)
				if not (TipIsPlayer) and (UnitReaction(LeaPlusTT["LpTipUnitTarget"],"player")) < 5 and not (UnitPlayerControlled(LeaPlusTT["LpTipUnitTarget"])) then

					-- Level ?? mob
					if TipUnitLevel == -1 then
						LeaPlusTT["LpTipInfomaData"] = "|cffff3333Level ??|cffffffff "

					-- Mobs within level range
					else
						LeaPlusTT["LpTipMyMobColor"] = (GetQuestDifficultyColor(UnitLevel(LeaPlusTT["LpTipUnitTarget"])))
						LeaPlusTT["LpTipMyMobColor"] = string.format('%02x%02x%02x', LeaPlusTT["LpTipMyMobColor"].r * 255, LeaPlusTT["LpTipMyMobColor"].g * 255, LeaPlusTT["LpTipMyMobColor"].b * 255)
						LeaPlusTT["LpTipInfomaData"] = "|cff" .. LeaPlusTT["LpTipMyMobColor"] .. "Level " .. TipUnitLevel .. "|cffffffff "
					end

					-- Find the line with level information on it
					if not (strsplit(" ", string.lower(_G["GameTooltipTextLeft2"]:GetText()),2) == "level") then LeaPlusTT["LpTipMobInfLine"] = 3 else LeaPlusTT["LpTipMobInfLine"] = 2 end

					-- Show creature type and classification (find a happy place!)
					local LeaLeaTipOptMobType = UnitCreatureType(LeaPlusTT["LpTipUnitTarget"])
					if LeaPlusLC["TipShowMobType"] == "On" and (LeaLeaTipOptMobType) and not (LeaLeaTipOptMobType == "Not specified") then
						LeaPlusTT["LpTipInfomaData"] = LeaPlusTT["LpTipInfomaData"] .. "|cffffffff" .. LeaLeaTipOptMobType .. "|cffffffff "
					end

					-- Sort out the special mobs
					local LeaPlusTipElite = UnitClassification(LeaPlusTT["LpTipUnitTarget"])
					if (LeaPlusTipElite) then
						if LeaPlusTipElite == "elite" then LeaPlusTipElite = "(Elite)"
						elseif LeaPlusTipElite == "rare" then LeaPlusTipElite = "|c00e066ff(Rare)"
						elseif LeaPlusTipElite == "rareelite" then LeaPlusTipElite = "|c00e066ff(Rare Elite)"
						elseif LeaPlusTipElite == "worldboss" then LeaPlusTipElite = "(Boss)"
						else LeaPlusTipElite = nil end
						if (LeaPlusTipElite) then
							LeaPlusTT["LpTipInfomaData"] = LeaPlusTT["LpTipInfomaData"] .. LeaPlusTipElite
						end
					end
					repline(LeaPlusTT["LpTipMobInfLine"], LeaPlusTT["LpTipInfomaData"])
				end
				----------------------------------------------------------------------
				-- Backdrops
				local LeaPlusTipFaction = UnitFactionGroup(LeaPlusTT["LpTipUnitTarget"])
				if UnitCanAttack("player",LeaPlusTT["LpTipUnitTarget"]) and not (UnitIsDeadOrGhost(LeaPlusTT["LpTipUnitTarget"])) and not (LeaPlusTipFaction == nil) and not (LeaPlusTipFaction == UnitFactionGroup("player")) then
					if (TipIsPlayer) and LeaPlusLC["TipBackHostile"] == "On" then
						GameTooltip:SetBackdropColor(LeaPlusTT["LpTipPureClassC"].r, LeaPlusTT["LpTipPureClassC"].g, LeaPlusTT["LpTipPureClassC"].b);
					else
						if LeaPlusLC["TipBackSimple"] == "On" then
							GameTooltip:SetBackdropColor(0.5, 0.0, 0.0);
						else
							GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
						end
					end
				else
					if (TipIsPlayer) and LeaPlusLC["TipBackFriend"] == "On" then
						GameTooltip:SetBackdropColor(LeaPlusTT["LpTipPureClassC"].r, LeaPlusTT["LpTipPureClassC"].g, LeaPlusTT["LpTipPureClassC"].b);
					else
						if LeaPlusLC["TipBackSimple"] == "On" then
							GameTooltip:SetBackdropColor(0.0, 0.0, 0.5);
						else
							GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
						end
					end
				end
				----------------------------------------------------------------------
				--	Show target
				if LeaPlusLC["TipShowTarget"] == "On" then
					local target = UnitName(LeaPlusTT["LpTipUnitTarget"].."target");
					if target == nil or target == "" then return end
					if (UnitIsUnit(target, "player")) then target = ("|c12ff4400YOU") end

					-- Show target in class color
					if not (UnitIsUnit(target, "player")) and (UnitIsPlayer(LeaPlusTT["LpTipUnitTarget"].."target")) then
						local _,tar_g = UnitClassBase(LeaPlusTT["LpTipUnitTarget"].."target");
						local LeaPlusTipTcolr = RAID_CLASS_COLORS[tar_g]
						local LeaPlusTipTcolr = "|cff" .. string.format('%02x%02x%02x',LeaPlusTipTcolr.r * 255, LeaPlusTipTcolr.g * 255, LeaPlusTipTcolr.b * 255)
						target = (LeaPlusTipTcolr .. target)
					end
					
					GameTooltip:AddLine("Target: " .. target)
				end
				----------------------------------------------------------------------
			end
			GameTooltip:HookScript("OnTooltipSetUnit", function(self) ShowTip(true) end)
			
		end

	end

----------------------------------------------------------------------
--	L22: Variable
----------------------------------------------------------------------

	function LeaPlusLC:Variable()

		-- Show volume control on character sheet
		if LeaPlusLC["ShowVolume"] == "On" then
			LeaPlusLC["LeaPlusMaxVol"] = tonumber(GetCVar("Sound_MasterVolume"));
			if LeaPlusLC["ShowVanityButtons"] == "On" then
				LeaPlusLC:MakeSL(CharacterModelFrame, "LeaPlusMaxVol", "",	0, 1, 0.05, 10, -145, "%.2f")
			else
				LeaPlusLC:MakeSL(CharacterModelFrame, "LeaPlusMaxVol", "",	0, 1, 0.05, 10, -165, "%.2f")
			end
			LeaPlusCB["LeaPlusMaxVol"]:SetWidth(84);

			LeaPlusCB["LeaPlusMaxVol"]:SetScript("OnShow", function()
				LeaPlusCB["LeaPlusMaxVol"]:SetValue(GetCVar("Sound_MasterVolume"))
			end)
		end

		-- Move the chat frame editbox to the top (combat log part is done in BlizzDep)
		if LeaPlusLC["MoveChatEditBoxToTop"] == "On" then

			-- Set the chat style to classic and prevent changes
			SetCVar("chatStyle", "classic")
			InterfaceOptionsSocialPanelChatStyle_SetChatStyle("classic")

			InterfaceOptionsSocialPanelChatStyleButton:Disable()
			InterfaceOptionsSocialPanelChatStyleText:SetAlpha(0.0)
			InterfaceOptionsSocialPanelChatStyle.tooltip="Chat style is set to classic and controlled by Leatrix Plus."

			-- Position the editbox
			_G["ChatFrame1EditBox"]:ClearAllPoints();
			_G["ChatFrame1EditBox"]:SetPoint("TOPLEFT", GeneralDockManager, "TOPLEFT", 0, -25);
			_G["ChatFrame1EditBox"]:SetWidth(ChatFrame1:GetWidth());

			-- Ensure editbox width matches chatframe width
			ChatFrame1:HookScript("OnSizeChanged", function()
				ChatFrame1EditBox:SetWidth(ChatFrame1:GetWidth())
			end)

		end

		-- Hide chat buttons
		if LeaPlusLC["NoChatButtons"] == "On" then

			-- Enable mouse scrolling and prevent changes
			SetCVar("chatMouseScroll", "1")
			InterfaceOptionsSocialPanelChatMouseScroll:Disable()
			InterfaceOptionsSocialPanelChatMouseScrollText:SetAlpha(0.3)
			InterfaceOptionsSocialPanelChatMouseScroll_SetScrolling("1")

			-- Add CTRL key (scroll to top or bottom) and SHIFT key (page up and down) to mousescroll functionality
			for i = 1, NUM_CHAT_WINDOWS, 1 do
				_G["ChatFrame"..i]:HookScript("OnMouseWheel", function(self, direction)
					if IsControlKeyDown() then
						if direction == 1 then
							self:ScrollToTop()
						else
							self:ScrollToBottom()
						end
					elseif IsShiftKeyDown() then
						if direction == 1 then
							self:PageUp()
						else
							self:PageDown()
						end
					end
				end)
			end

			-- -- Set whisper mode to inline and lock Blizzard options
			-- SetCVar("whisperMode", "inline")
			-- InterfaceOptionsSocialPanelWhisperModeButton:Disable()
			-- InterfaceOptionsSocialPanelWhisperModeText:SetAlpha(0.0)
			-- InterfaceOptionsSocialPanelWhisperMode.tooltip = "Whispers are set to inline and are controlled by Leatrix Plus."

			-- -- Set Real ID mode to inline and lock Blizzard options
			-- SetCVar("bnWhisperMode", "inline")
			-- InterfaceOptionsSocialPanelBnWhisperModeButton:Disable()
			-- InterfaceOptionsSocialPanelBnWhisperModeText:SetAlpha(0.0)
			-- InterfaceOptionsSocialPanelBnWhisperMode.tooltip = "Real ID whispers are set to inline and are controlled by Leatrix Plus."

			-- -- Set Real ID conversation mode and lock Blizzard options
			-- SetCVar("conversationMode", "inline")
			-- InterfaceOptionsSocialPanelConversationModeButton:Disable()
			-- InterfaceOptionsSocialPanelConversationModeText:SetAlpha(0.0)
			-- InterfaceOptionsSocialPanelConversationMode.tooltip = "Real ID conversation mode is set to inline and are controlled by Leatrix Plus."

			-- Hide chat window buttons
			for i = 1, NUM_CHAT_WINDOWS, 1 do
				_G["ChatFrame" .. i .. "ButtonFrameUpButton"].Show = function() return nil; end;
				_G["ChatFrame" .. i .. "ButtonFrameDownButton"].Show = function() return nil; end;
				_G["ChatFrame" .. i .. "ButtonFrameMinimizeButton"].Show = function() return nil; end;
				_G["ChatFrame" .. i .. "ButtonFrameUpButton"]:Hide();
				_G["ChatFrame" .. i .. "ButtonFrameDownButton"]:Hide();
				_G["ChatFrame" .. i .. "ButtonFrameMinimizeButton"]:Hide();
				_G["ChatFrame" .. i .. "ButtonFrame"]:SetSize(0.1,0.1)
			end

			-- Hide outer chat frame buttons
			ChatFrameMenuButton.Show = function() return nil; end;
			ChatFrameMenuButton:Hide();
			FriendsMicroButton.Show = function() return nil; end;
			FriendsMicroButton:Hide();

			-- Add chat menu to the middle mouse button
			ChatMenu:ClearAllPoints()
			ChatMenu:SetPoint("TOP", ChatFrame1Tab, "BOTTOM", 0, 0)
			ChatMenu.ClearAllPoints = function() end
			ChatMenu.SetPoint = function() end
			ChatFrame1Tab:HookScript("OnMouseDown", function(self, arg1)
				if arg1 == "MiddleButton" then
					if ChatMenu:IsShown() then
						ChatMenu:Hide();
					else
						ChatMenu:Show();
					end
				end
			end)

			-- Highlight tabs
			for i = 1, NUM_CHAT_WINDOWS, 1 do

				-- Set position of bottom button
				_G["ChatFrame" .. i .. "ButtonFrameBottomButtonFlash"]:SetTexture("Interface/BUTTONS/GRADBLUE.png")
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:ClearAllPoints()
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetPoint("BOTTOM",_G["ChatFrame" .. i .. "Tab"],0,-6)
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:Show()
				_G["ChatFrame" .. i .. "ButtonFrameBottomButtonFlash"]:SetAlpha(0.5)
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetWidth(_G["ChatFrame" .. i .. "Tab"]:GetWidth()-10)
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetHeight(24)

				-- Resize bottom button according to tab size
				_G["ChatFrame" .. i .. "Tab"]:SetScript("OnSizeChanged", function()
					for j = 1, NUM_CHAT_WINDOWS, 1 do
						_G["ChatFrame" .. j .. "ButtonFrameBottomButton"]:SetWidth(_G["ChatFrame" .. j .. "Tab"]:GetWidth()-10)
					end
				end)

				--Remove click from the bottom button
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetScript("OnClick", nil)

				-- Remove textures
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetNormalTexture("")
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetHighlightTexture("")
				_G["ChatFrame" .. i .. "ButtonFrameBottomButton"]:SetPushedTexture("")

				-- Unclamp chat frame
				_G["ChatFrame" .. i]:SetClampedToScreen(false);

				-- Always scroll to bottom when clicking a tab
				_G["ChatFrame" .. i .. "Tab"]:HookScript("OnClick", function(self,arg1)
					if arg1 == "LeftButton" then
						_G["ChatFrame" .. i]:ScrollToBottom();
					end
				end)

			end

		end

		-- Show time stamps
		if LeaPlusLC["ShowChatTimeStamps"] == "On" then

			-- Disable Blizzards timestamp option
			CHAT_TIMESTAMP_FORMAT = nil
			CHAT_SHOW_TIME = false;
			InterfaceOptionsSocialPanelTimestampsButton:Disable()
			InterfaceOptionsSocialPanelTimestampsText:SetAlpha(0.0)
			InterfaceOptionsSocialPanelTimestamps.tooltip="Timestamps are enabled and controlled by Leatrix Plus."

			-- New timestamp routine
			local SecDiff, LastMin

			local function ServerTime(format)
				local TempTime = date("*t")
				TempTime["hour"], TempTime["min"] = GetGameTime()
						  
				if LastMin ~= TempTime["min"] then
					LastMin = select(2, GetGameTime())
					SecDiff = mod(time(), 60)
				end
				TempTime["sec"] = mod(time() - SecDiff, 60)
				return date(format, time(TempTime))
			end

			local TimeNew = {}

			for i=1, NUM_CHAT_WINDOWS do
				if i ~= 2 then
					TimeNew[format("%s%d", "ChatFrame", i)] = _G[format("%s%d", "ChatFrame", i)].AddMessage
					_G[format("%s%d", "ChatFrame", i)].AddMessage = function(chnl, text, ...)
						text = ServerTime("|cffffd900[%H:%M]|r ")..text
						return TimeNew[chnl:GetName()](chnl, text, ...)
					end
				end
			end

		end

		-- Frame Movement
		if LeaPlusLC["FrmEnabled"] == "On" then

			-- -- Set reference sizes for stubborn frames
			-- PlayerPowerBarAlt:SetSize(256, 64); 

			-- -- Lock the player and target frames
			-- PlayerFrame_SetLocked(true)
			-- TargetFrame_SetLocked(true)

			-- Remove integrated movement functions to avoid conflicts
			PlayerFrame_ResetUserPlacedPosition = function() LeaPlusLC:Print("Please use Leatrix Plus to reset the player frame.") end
			TargetFrame_ResetUserPlacedPosition = function() LeaPlusLC:Print("Please use Leatrix Plus to reset the target frame.") end
			PlayerFrame_SetLocked = function() LeaPlusLC:Print("Please use Leatrix Plus to move the player frame.") end
			TargetFrame_SetLocked = function() LeaPlusLC:Print("Please use Leatrix Plus to move the target frame.") end

			-- Control frame locks (prevent Blizzard from moving frames)
			local DurabilityFramePoint 					= DurabilityFrame.SetPoint
			local MirrorTimer1Point 					= MirrorTimer1.SetPoint
			-- local GhostFramePoint 						= GhostFrame.SetPoint
			-- local PlayerPowerBarAltPoint 				= PlayerPowerBarAlt.SetPoint

			function LeaPlusLC:LeaPlusFrameLock(status)
				if status then
					-- Prevent frames from being moved
					DurabilityFrame.SetPoint 			= function() end
					MirrorTimer1.SetPoint 				= function() end
					-- GhostFrame.SetPoint 				= function() end
					-- PlayerPowerBarAlt.SetPoint 			= function() end
				else 
					-- Allow frames to be moved
					DurabilityFrame.SetPoint 			= DurabilityFramePoint
					MirrorTimer1.SetPoint 				= MirrorTimer1Point
					-- GhostFrame.SetPoint 				= GhostFramePoint
					-- PlayerPowerBarAlt.SetPoint 			= PlayerPowerBarAltPoint
				end
			end

			-- Lock frames by default
			LeaPlusLC:LeaPlusFrameLock(true)

			-- Create profile table structure
			if (LeaPlusDB["Frames"]) == nil then
				LeaPlusDB["Frames"] = {}
			end

			-- Create frame table
			LeaPlusLC["FrameTable"] = {
			DragPlayerFrame = PlayerFrame,
			DragTargetFrame = TargetFrame,
			DragWorldStateAlwaysUpFrame = WorldStateAlwaysUpFrame,
			-- DragGhostFrame = GhostFrame,
			DragMirrorTimer1 = MirrorTimer1,
			DragDurabilityFrame = DurabilityFrame,}
			-- DragPlayerPowerBarAlt = PlayerPowerBarAlt

			-- Set cached status
			local function LeaPlusFramesSaveCache(frame)
				if frame == "PlayerFrame" or frame == "TargetFrame" then
					_G[frame]:SetUserPlaced(true);
				else
					_G[frame]:SetUserPlaced(false);
				end
			end

			-- Set frames to manual values
			local function LeaFramesSetPos(frame, point, parent, relative, xoff, yoff)
				frame:SetMovable(true);
				frame:ClearAllPoints();
				frame:SetPoint(point,parent,relative,xoff,yoff)
			end

			-- Set frames to default values
			local function LeaPlusFramesDefaults()
				-- Unlock frames, set positions and lock them again
				LeaPlusLC:LeaPlusFrameLock(false)
				LeaFramesSetPos(PlayerFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	, -19, -4)
				LeaFramesSetPos(TargetFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	, 250, -4)
				LeaFramesSetPos(WorldStateAlwaysUpFrame	, "TOP"		, UIParent, "TOP"		, -5, -15)
				-- LeaFramesSetPos(GhostFrame				, "TOP"		, UIParent, "TOP"		, -5, -29)
				LeaFramesSetPos(MirrorTimer1			, "TOP"		, UIParent, "TOP"		, -5, -96)
				LeaFramesSetPos(DurabilityFrame			, "TOPRIGHT", UIParent, "TOPRIGHT"	, -20, -192)
				-- LeaFramesSetPos(PlayerPowerBarAlt		, "BOTTOM"	, UIParent, "BOTTOM"	, 0, 95)
				LeaPlusLC:LeaPlusFrameLock(true)
			end

			-- Create moving frame
			local LeaPlusFrameMove = CreateFrame("Frame")
			LeaPlusLC["LeaPlusFrameMove"] = LeaPlusFrameMove
			LeaPlusFrameMove:Hide();
			LeaPlusFrameMove:SetSize(220, 104) 
			LeaPlusFrameMove:SetToplevel(true)
			LeaPlusFrameMove:ClearAllPoints() 
			LeaPlusFrameMove:SetClampedToScreen(true);
			LeaPlusFrameMove:EnableMouse(true)
			LeaPlusFrameMove:SetMovable(true)
			LeaPlusFrameMove:RegisterForDrag("LeftButton")
			LeaPlusFrameMove:SetScript("OnDragStart", LeaPlusFrameMove.StartMoving)
			LeaPlusFrameMove:SetScript("OnDragStop", function ()
				LeaPlusFrameMove:StopMovingOrSizing();
				LeaPlusFrameMove:SetUserPlaced(false);
			end)

			-- Add background color
			LeaPlusFrameMove.t = LeaPlusFrameMove:CreateTexture(nil, "BACKGROUND")
			LeaPlusFrameMove.t:SetAllPoints()
			LeaPlusFrameMove.t:SetTexture(0.05, 0.05, 0.05, 0.8)

			-- Add moving message
			local LeaPlusMoveFrameMsg = UIParent:CreateFontString(nil, "OVERLAY", 'GameFontNormalLarge')
			LeaPlusMoveFrameMsg:SetPoint("CENTER", 0, 0)
			LeaPlusMoveFrameMsg:SetText("Drag frames then right-click any frame to finish.")
			LeaPlusMoveFrameMsg:Hide();

			-- Create frame checkboxes
			local function LeaPlusFramesCB(name, x, y, frame, text, tip)
				LeaPlusCB[name] = CreateFrame('CheckButton', nil, LeaPlusFrameMove, 'ChatConfigCheckButtonTemplate')
				LeaPlusCB[name]:SetPoint("TOPLEFT", x, y)
				LeaPlusCB[name]:SetHitRectInsets(0, -70, 0, 0);

				-- Checkbox tooltips
				LeaPlusCB[name].tiptext = tip
				LeaPlusCB[name]:SetScript("OnEnter", LeaPlusLC.ShowTooltip)		
				LeaPlusCB[name]:SetScript("OnLeave", LeaPlusLC.HideTooltip)

				-- Checkbox labels
				LeaPlusCB[name].t = LeaPlusCB[name]:CreateFontString(nil, "BACKGROUND", "GameTooltipText") 
					LeaPlusCB[name].t:SetPoint("LEFT",30,0) 
					LeaPlusCB[name].t:SetText(text)

				-- Process clicks
				LeaPlusCB[name]:SetScript('OnClick', function(self)
					if LeaPlusCB[name]:GetChecked() == nil then LeaPlusLC[frame]:Hide(); end
					if LeaPlusCB[name]:GetChecked() == 1 then LeaPlusLC[frame]:Show(); end					
				end)

				-- Set default checkbox state and panel position
				LeaPlusFrameMove:HookScript("OnShow", function() 
					LeaPlusCB[name]:SetChecked(true)
					LeaPlusFrameMove:ClearAllPoints() 
					LeaPlusFrameMove:SetPoint("RIGHT", 0, 0)
				end)
			end

			-- Create checkboxes
			LeaPlusFramesCB("ChkPlayerFrame"			, 10, -10, 	"DragPlayerFrame"				, "Player"		, "Player (including pet)")
			LeaPlusFramesCB("ChkTargetFrame"			, 10, -30, 	"DragTargetFrame"				, "Target"		, "Target")
			LeaPlusFramesCB("ChkWorldStateAlwaysUpFrame", 10, -50, 	"DragWorldStateAlwaysUpFrame"	, "World"		, "World state PvP")
			-- LeaPlusFramesCB("ChkGhostFrame"				, 10, -70,	"DragGhostFrame"				, "Ghost"		, "Ghost (return to spirit healer)")

			LeaPlusFramesCB("ChkMirrorTimer1"			, 110, -10,	"DragMirrorTimer1"				, "Timer"		, "Timer bar")
			LeaPlusFramesCB("ChkDurabilityFrame"		, 110, -30,	"DragDurabilityFrame"			, "Durability"	, "Durability")
			-- LeaPlusFramesCB("ChkPlayerPowerBarAlt"		, 110, -50,	"DragPlayerPowerBarAlt"			, "Power"		, "Alternative power bar")

			-- Create drag frames
			local function LeaPlusMakeDrag(dragframe,realframe)

				local dragframe = CreateFrame("Frame", nil);
				LeaPlusLC[dragframe] = dragframe
				dragframe:SetSize(realframe:GetSize())
				dragframe:SetPoint("TOP", realframe, "TOP", 0, 2.5)

				dragframe:SetBackdropColor(0.0, 0.5, 1.0);
				dragframe:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false, tileSize = 0, edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }});
				dragframe:SetToplevel(true)
				dragframe:Hide()

				realframe:SetMovable(true);

				dragframe:SetScript("OnMouseDown", function(self,arg1)
					if arg1 == "LeftButton" then
						realframe:StartMoving()
					elseif arg1 == "RightButton" then
						LeaPlusLC:LeaPlusFrameLock(true);
						LeaPlusFrameMove:Hide();
						for k,_ in pairs(LeaPlusLC["FrameTable"]) do
							LeaPlusLC[k]:Hide();
						end
						LeaPlusLC["PageF"]:Show();
						LeaPlusLC["Page6"]:Show();
						LeaPlusMoveFrameMsg:Hide();
					end
				end)

				dragframe:SetScript("OnMouseUp", function()
					LeaPlusLC:LeaPlusFrameLock(false);
					realframe:StopMovingOrSizing()
					dragframe.p, _, dragframe.r, dragframe.x, dragframe.y = realframe:GetPoint()
					LeaPlusDB["Frames"][realframe:GetName()] = {["Point"] = dragframe.p, ["Relative"] = dragframe.r, ["XOffset"] = dragframe.x, ["YOffset"] = dragframe.y}
					LeaPlusFramesSaveCache(realframe:GetName())
					LeaPlusLC:LeaPlusFrameLock(true);
				end)
	
				dragframe.t = dragframe:CreateTexture()
				dragframe.t:SetAllPoints()
				dragframe.t:SetTexture(0.0, 0.5, 1.0,0.5)
				dragframe.t:SetAlpha(0.5)

				dragframe.f = dragframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
				dragframe.f:SetPoint('TOPLEFT', 16, -16)

				-- Add titles
				if realframe:GetName() == "PlayerFrame" 			then dragframe.f:SetText("Player") end
				if realframe:GetName() == "TargetFrame" 			then dragframe.f:SetText("Target") end
				if realframe:GetName() == "WorldStateAlwaysUpFrame" then dragframe.f:SetText("World PvP") end
				if realframe:GetName() == "MirrorTimer1" 			then dragframe.f:SetText("Timer") end
				if realframe:GetName() == "GhostFrame" 				then dragframe.f:SetText("Ghost") end
				if realframe:GetName() == "DurabilityFrame" 		then dragframe.f:SetText("Dur") end
				if realframe:GetName() == "PlayerPowerBarAlt" 		then dragframe.f:SetText("Power"); end
				return LeaPlusLC[dragframe]

			end
			
			for k,v in pairs(LeaPlusLC["FrameTable"]) do
				LeaPlusLC[k] = LeaPlusMakeDrag(k,v)
			end

			-- Load frames
			local function LeaPlusLoadFrames()

				if LeaPlusDB["Frames"] then
					LeaPlusLC:LeaPlusFrameLock(false)
					for k,v in pairs(LeaPlusLC["FrameTable"]) do
						if LeaPlusDB["Frames"][v:GetName()] then
							if LeaPlusDB["Frames"][v:GetName()]["Point"] and LeaPlusDB["Frames"][v:GetName()]["Relative"] and LeaPlusDB["Frames"][v:GetName()]["XOffset"] and LeaPlusDB["Frames"][v:GetName()]["YOffset"] then
								LeaPlusFramesSaveCache(v:GetName())
								_G[v:GetName()]:ClearAllPoints();
								_G[v:GetName()]:SetPoint(LeaPlusDB["Frames"][v:GetName()]["Point"], UIParent, LeaPlusDB["Frames"][v:GetName()]["Relative"], LeaPlusDB["Frames"][v:GetName()]["XOffset"], LeaPlusDB["Frames"][v:GetName()]["YOffset"])
							end
						end
					end
					LeaPlusLC:LeaPlusFrameLock(true)
				end
			end

			-- Load defaults first then overwrite with saved values
			LeaPlusFramesDefaults();
			LeaPlusLoadFrames();
	
			-- Add move button
			LeaPlusCB["MoveFramesButton"]:Show();
			LeaPlusCB["MoveFramesButton"]:SetScript("OnClick", function()
				if (IsShiftKeyDown()) and (IsControlKeyDown()) then
					if LeaPlusLC:PlayerInCombat() then
						return
					else
						-- Manual profile
						LeaPlusLC:LeaPlusFrameLock(false)
						LeaFramesSetPos(PlayerFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"-35"	, "-14")
						LeaFramesSetPos(TargetFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"192"	, "-14")
						-- LeaFramesSetPos(GhostFrame				, "CENTER"	, UIParent, "CENTER"	,	"3"		, "-142")
						LeaFramesSetPos(DurabilityFrame			, "TOP"		, UIParent, "TOP"		,	"212"	, "-138")
						LeaFramesSetPos(WorldStateAlwaysUpFrame	, "TOP"		, UIParent, "TOP"		,	"-40"	, "-530")
						LeaFramesSetPos(MirrorTimer1			, "TOP"		, UIParent, "TOP"		,	"0"		, "-120")
						-- LeaFramesSetPos(PlayerPowerBarAlt		, "BOTTOM"	, UIParent, "BOTTOM"	,	"0"		, "95")
					end
					for k,v in pairs(LeaPlusLC["FrameTable"]) do
						v.p, _, v.r, v.x, v.y = _G[v:GetName()]:GetPoint()
						LeaPlusDB["Frames"][v:GetName()] = {["Point"] = v.p, ["Relative"] = v.r, ["XOffset"] = v.x, ["YOffset"] = v.y}
						LeaPlusFramesSaveCache(v:GetName());
					end
					LeaPlusLC:LeaPlusFrameLock(true)
				else
					-- Show mover frame
					LeaPlusFrameMove:Show();
					LeaPlusLC:HideFrames();
					LeaPlusMoveFrameMsg:Show();

					-- Find out if the UI has a non-standard scale
					if GetCVar("useuiscale") == "1" then
						LeaPlusLC["gscale"] = GetCVar("uiscale")
					else
						LeaPlusLC["gscale"] = 1
					end

					-- Set all scaled sizes and show drag frames
					for k,v in pairs(LeaPlusLC["FrameTable"]) do
						LeaPlusLC[k]:SetWidth(v:GetWidth() * LeaPlusLC["gscale"])
						LeaPlusLC[k]:SetHeight(v:GetHeight() * LeaPlusLC["gscale"])
						LeaPlusLC[k]:Show();
					end

					-- Set specific scaled sizes for stubborn frames
					LeaPlusLC["DragWorldStateAlwaysUpFrame"]:SetSize(300 * LeaPlusLC["gscale"], 50 * LeaPlusLC["gscale"]);
					LeaPlusLC["DragMirrorTimer1"]:SetSize(206 * LeaPlusLC["gscale"], 50 * LeaPlusLC["gscale"]);
					-- LeaPlusLC["DragGhostFrame"]:SetSize(130 * LeaPlusLC["gscale"], 46 * LeaPlusLC["gscale"]);
					-- LeaPlusLC["DragPlayerPowerBarAlt"]:SetSize(256 * LeaPlusLC["gscale"], 64 * LeaPlusLC["gscale"]);
				end
			end)
			
			-- Add reset button
			LeaPlusCB["ResetFramesButton"]:Show();
			LeaPlusCB["ResetFramesButton"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					LeaPlusFramesDefaults();
					for k,v in pairs(LeaPlusLC["FrameTable"]) do
						v.p, _, v.r, v.x, v.y = _G[v:GetName()]:GetPoint()
						LeaPlusDB["Frames"][v:GetName()] = {["Point"] = v.p, ["Relative"] = v.r, ["XOffset"] = v.x, ["YOffset"] = v.y}
					end
				end
			end)

			-- Add refresh button
			LeaPlusCB["RefreshFramesButton"]:Show();
			LeaPlusCB["RefreshFramesButton"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					LeaPlusFramesDefaults();
					LeaPlusLoadFrames();
				end
			end)
		end
	end

----------------------------------------------------------------------
--	L23: Player
----------------------------------------------------------------------

	function LeaPlusLC:Player()

		-- Hide the combat log
		if LeaPlusLC["NoCombatLogTab"] == "On" then
			FCF_DockFrame(ChatFrame2, 2);
			ChatFrame2:Hide();
			ChatFrame2Tab:Hide();
			ChatFrame2.Show = ChatFrame2.Hide;
			ChatFrame2Tab.Show = ChatFrame2Tab.Hide;
			ChatFrame2Tab:SetText(".")
		end

		if IsAddOnLoaded("Leatrix_Frames") then
			LeaPlusLC:Print("Leatrix Frames is now included with Leatrix Plus and should be removed to avoid conflicts.")
		end

		if IsAddOnLoaded("Leatrix_Tooltip") then
			LeaPlusLC:Print("Leatrix Tooltip is now included with Leatrix Plus and should be removed to avoid conflicts.")
		end

		-- Set trade and guild locks
		if LeaPlusLC["ManageTradeGuild"] == "On" then
			LeaPlusLC:TradeGuild();
			InterfaceOptionsControlsPanelBlockTrades:Disable();

			_G[InterfaceOptionsControlsPanelBlockTrades:GetName() .. 'Text']:SetText("Trade blocking is controlled by Leatrix Plus.")
			_G[InterfaceOptionsControlsPanelBlockTrades:GetName() .. 'Text']:SetAlpha(0.6)

		end

		-- Lock class color checkboxes in Blizzard options if manage class colors is enabled
		if LeaPlusLC["Manageclasscolors"] == "On" then
			for i=1, 18 do
				if _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"] then
					LeaPlusLC:LockItem(_G["ChatConfigChatSettingsLeftCheckBox" .. i .. "ColorClasses"],true)
				end
			end
		end

		LpEvt:UnregisterEvent("PLAYER_ENTERING_WORLD")

	end

----------------------------------------------------------------------
-- 	L24: BlizzDep (options which require Blizzard modules)
----------------------------------------------------------------------

	function LeaPlusLC:BlizzDep(module)

		if module == "Blizzard_CombatLog" then
		
			-- Move chat editbox to top
			if LeaPlusLC["MoveChatEditBoxToTop"] == "On" then

				-- Move the combat log quick button bar if combat log is showing
				if LeaPlusLC["NoCombatLogTab"] == "Off" then

					if ChatFrame2.isDocked then
						CombatLogQuickButtonFrame_Custom:ClearAllPoints()
						CombatLogQuickButtonFrame_Custom:SetPoint("TOPLEFT",  "ChatFrame2", "TOPLEFT", 0, 00)
						CombatLogQuickButtonFrame_Custom:SetPoint("TOPRIGHT", "ChatFrame2", "TOPRIGHT")
						CombatLogQuickButtonFrame_Custom:Hide();
					else
						CombatLogQuickButtonFrame_Custom:ClearAllPoints()
						CombatLogQuickButtonFrame_Custom:SetPoint("TOPLEFT",  "ChatFrame2", "TOPLEFT", 0, 25)
						CombatLogQuickButtonFrame_Custom:SetPoint("BOTTOMRIGHT", "ChatFrame2", "TOPRIGHT")
					end

					-- Reposition the quick button bar if combat log is docked/undocked
					hooksecurefunc("FCF_UnDockFrame", function(frame)
						if frame == COMBATLOG then 
							CombatLogQuickButtonFrame_Custom:ClearAllPoints()
							CombatLogQuickButtonFrame_Custom:SetPoint("TOPLEFT",  "ChatFrame2", "TOPLEFT", 0, 25)
							CombatLogQuickButtonFrame_Custom:SetPoint("BOTTOMRIGHT", "ChatFrame2", "TOPRIGHT")
						end
					end)

					hooksecurefunc("FCF_DockFrame", function(frame)
						if frame == COMBATLOG then 
							CombatLogQuickButtonFrame_Custom:ClearAllPoints()
							CombatLogQuickButtonFrame_Custom:SetPoint("TOPLEFT",  "ChatFrame2", "TOPLEFT", 0, 00)
							CombatLogQuickButtonFrame_Custom:SetPoint("TOPRIGHT", "ChatFrame2", "TOPRIGHT")
						end
					end)
		
				end

			end
	
		elseif module == "Blizzard_TimeManager" then

			-- Hide time frame
			if LeaPlusLC["MinmapHideTime"] == "On" then
				TimeManagerClockButton:Hide();
			end

		elseif module == "Blizzard_AuctionUI" then
	
			-- Auction House buyout only
			if LeaPlusLC["AhExtras"] == "On" then

				-- Change size of maximise buttons to make room for find button
				AuctionsStackSizeMaxButton:SetWidth(50);
				AuctionsStackSizeMaxButton:SetText("Max")
				AuctionsNumStacksMaxButton:SetWidth(50);
				AuctionsNumStacksMaxButton:SetText("Max")

				-- Create buyout only checkbox
				LeaPlusCB["AhBuyoutOnly"] = CreateFrame('CheckButton', nil, AuctionFrameAuctions, "OptionsCheckButtonTemplate")
				LeaPlusCB["AhBuyoutOnly"]:SetFrameStrata("HIGH")
				LeaPlusCB["AhBuyoutOnly"]:SetHitRectInsets(0, 0, 0, 0);
				LeaPlusCB["AhBuyoutOnly"]:SetSize(20, 20)
				LeaPlusCB["AhBuyoutOnly"]:SetPoint("BOTTOMLEFT", 200, 16)

				LeaPlusCB["AhBuyoutOnly.f"] = LeaPlusCB["AhBuyoutOnly"]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
				LeaPlusCB["AhBuyoutOnly.f"]:SetPoint("LEFT", 20, 0)
				LeaPlusCB["AhBuyoutOnly.f"]:SetText("Buyout Only")
				LeaPlusCB["AhBuyoutOnly.f"]:Show();

				local function SetupAh()
					if LeaPlusLC["AhBuyoutOnly"] == "On" then
						-- Hide the start price
						StartPrice:SetAlpha(0);
						-- Set start price to buyout price 
						StartPriceGold:SetText(BuyoutPriceGold:GetText());
						StartPriceSilver:SetText(BuyoutPriceSilver:GetText());
						StartPriceCopper:SetText(BuyoutPriceCopper:GetText());
					else
						StartPrice:SetAlpha(1);
					end
					-- Validate the auction (mainly for the create auction button status)
					AuctionsFrameAuctions_ValidateAuction();
				end

				LeaPlusCB["AhBuyoutOnly"]:SetScript('OnClick', function()
					if LeaPlusCB["AhBuyoutOnly"]:GetChecked() == nil then
						LeaPlusLC["AhBuyoutOnly"] = "Off"
					elseif LeaPlusCB["AhBuyoutOnly"]:GetChecked() == 1 then
						LeaPlusLC["AhBuyoutOnly"] = "On"
					end
					SetupAh()
				end)

				LeaPlusCB["AhBuyoutOnly"]:SetScript('OnShow', function(self)
					self:SetChecked(LeaPlusLC["AhBuyoutOnly"])
					SetupAh();
				end)

				-- Match start price to buyout price if any editboxes change
				local function SetPriceMatch()
					if LeaPlusLC["AhBuyoutOnly"] == "On" then
						-- Set start price to buyout price 
						StartPriceGold:SetText(BuyoutPriceGold:GetText());
						StartPriceSilver:SetText(BuyoutPriceSilver:GetText());
						StartPriceCopper:SetText(BuyoutPriceCopper:GetText());
					end

					-- If gold only is on, set copper and silver to 99
					if LeaPlusLC["AhGoldOnly"] == "On" then
						StartPriceCopper:SetText("99")
						StartPriceSilver:SetText("99")
						BuyoutPriceCopper:SetText("99")
						BuyoutPriceSilver:SetText("99")
					end
				end

				AuctionFrameAuctions:HookScript("OnShow", SetPriceMatch)
				BuyoutPriceGold:HookScript("OnTextChanged", SetPriceMatch)
				BuyoutPriceSilver:HookScript("OnTextChanged", SetPriceMatch)
				BuyoutPriceCopper:HookScript("OnTextChanged", SetPriceMatch)
				StartPriceGold:HookScript("OnTextChanged", SetPriceMatch)
				StartPriceSilver:HookScript("OnTextChanged", SetPriceMatch)
				StartPriceCopper:HookScript("OnTextChanged", SetPriceMatch)

				-- Lock the create auction button if buyout gold box is empty (when using buyout only and gold only)
				AuctionsCreateAuctionButton:HookScript("OnEnable", function()
					if LeaPlusLC["AhGoldOnly"] == "On" and LeaPlusLC["AhBuyoutOnly"] == "On" then
						if BuyoutPriceGold:GetText() == "" then
							AuctionsCreateAuctionButton:Disable();
						end
					end
				end)

				-- -- Create gold only checkbox (typing in silver and copper is so boring most of the time)
				-- LeaPlusCB["AhGoldOnly"] = CreateFrame('CheckButton', nil, AuctionFrameAuctions, "OptionsCheckButtonTemplate")
				-- LeaPlusCB["AhGoldOnly"]:SetFrameStrata("HIGH")
				-- LeaPlusCB["AhGoldOnly"]:SetHitRectInsets(0, 0, 0, 0);
				-- LeaPlusCB["AhGoldOnly"]:SetSize(20, 20)
				-- LeaPlusCB["AhGoldOnly"]:SetPoint("BOTTOMLEFT", 320, 16)

				-- LeaPlusCB["AhGoldOnly.f"] = LeaPlusCB["AhGoldOnly"]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
				-- LeaPlusCB["AhGoldOnly.f"]:SetPoint("LEFT", 20, 0)
				-- LeaPlusCB["AhGoldOnly.f"]:SetText("Gold Only")
				-- LeaPlusCB["AhGoldOnly.f"]:Show();

				-- local function LockPrice()
				-- 	if LeaPlusCB["AhGoldOnly"]:GetChecked() == 1 then
				-- 		StartPriceCopper:SetText("99")
				-- 		StartPriceCopper:Disable();
				-- 		StartPriceSilver:SetText("99")
				-- 		StartPriceSilver:Disable();
				-- 		BuyoutPriceCopper:SetText("99")
				-- 		BuyoutPriceCopper:Disable();
				-- 		BuyoutPriceSilver:SetText("99")
				-- 		BuyoutPriceSilver:Disable();
				-- 	else
				-- 		StartPriceCopper:Enable();
				-- 		StartPriceSilver:Enable();
				-- 		BuyoutPriceCopper:Enable();
				-- 		BuyoutPriceSilver:Enable();
				-- 	end
				-- 	AuctionsFrameAuctions_ValidateAuction();
				-- end

				-- LeaPlusCB["AhGoldOnly"]:SetScript('OnClick', function()
				-- 	if LeaPlusCB["AhGoldOnly"]:GetChecked() == nil then
				-- 		LeaPlusLC["AhGoldOnly"] = "Off"
				-- 		BuyoutPriceCopper:SetText("")
				-- 		BuyoutPriceSilver:SetText("")
				-- 		StartPriceCopper:SetText("")
				-- 		StartPriceSilver:SetText("")
				-- 	elseif LeaPlusCB["AhGoldOnly"]:GetChecked() == 1 then
				-- 		LeaPlusLC["AhGoldOnly"] = "On"
				-- 	end
				-- 	LockPrice();
				-- end)

				-- LeaPlusCB["AhGoldOnly"]:SetScript('OnShow', function(self)
				-- 	self:SetChecked(LeaPlusLC["AhGoldOnly"])
				-- 	LockPrice();
				-- end)

				-- Create find button
				LeaPlusLC:CreateButton("FindAuctionButton", AuctionFrameAuctions, "Find", "BOTTOMLEFT", 146, 246, 50, 21, "")
				LeaPlusCB["FindAuctionButton"]:SetFrameStrata("HIGH")
				LeaPlusCB["FindAuctionButton"]:SetScript("OnClick", function()
					if GetAuctionSellItemInfo() then
						name = GetAuctionSellItemInfo()
						BrowseName:SetText(name)
						QueryAuctionItems(name)
						AuctionFrameTab1:Click();
					end
				end)

				-- Show find button when required (new item added or window shown)
				local function SetFindButton()
					if GetAuctionSellItemInfo() then
						LeaPlusCB["FindAuctionButton"]:SetAlpha(1)
					else
						LeaPlusCB["FindAuctionButton"]:SetAlpha(0)
					end
				end
				AuctionsItemButton:HookScript("OnEvent", function(self,event)
					if event == "NEW_AUCTION_UPDATE" then
						SetFindButton();
					end
				end)
				AuctionFrameAuctions:HookScript("OnShow", function()
					SetFindButton();
				end)

				-- Hide find button when Blizzard block frame is shown (respecting the Blizzard UI)
				AuctionsBlockFrame:HookScript("OnShow", function()
					LeaPlusCB["FindAuctionButton"]:SetAlpha(0)
				end)
				AuctionsBlockFrame:HookScript("OnHide", function()
					LeaPlusCB["FindAuctionButton"]:SetAlpha(1)
				end)

				-- Clear the cursor and reset editboxes when a new item replaces an existing one
				hooksecurefunc("AuctionsFrameAuctions_ValidateAuction", function()
					if GetAuctionSellItemInfo() then
						-- Return anything you might be holding
						ClearCursor();
						-- Set copper and silver prices to 99 if gold mode is on
						if LeaPlusLC["AhGoldOnly"] == "On" then
							StartPriceCopper:SetText("99")
							StartPriceSilver:SetText("99")
							BuyoutPriceCopper:SetText("99")
							BuyoutPriceSilver:SetText("99")
						end
						-- Only clear the gold if its zero (otherwise it's a buyout price repeater)
						if 	BuyoutPriceGold:GetText() == "0" then
							StartPriceGold:SetText("")
							BuyoutPriceGold:SetText("")
						end
					end
				end)

				-- Set duration dropdown value and save it account-wide
				hooksecurefunc("DurationDropDown_Initialize", function(self)
					if not LeaPlusLC["AhDuration"] or type(LeaPlusLC["AhDuration"]) ~= "number" or LeaPlusLC["AhDuration"] < 1 or LeaPlusLC["AhDuration"] > 3 then 
						LeaPlusLC["AhDuration"] = AuctionFrameAuctions.duration;
					else
						AuctionFrameAuctions.duration = LeaPlusLC["AhDuration"];
					end
				end)

				hooksecurefunc("DurationDropDown_OnClick", function(self)
					LeaPlusLC["AhDuration"] = AuctionFrameAuctions.duration;
				end)

			end

		end

	end
	
----------------------------------------------------------------------
-- 	L30: RunOnce
----------------------------------------------------------------------

	function LeaPlusLC:RunOnce()

		-- Hide Leatrix Plus if Blizzard options are shown
		InterfaceOptionsFrame:HookScript("OnShow", function()
			LeaPlusLC:HideFrames();
		end)
		VideoOptionsFrame:HookScript("OnShow", function()
			LeaPlusLC:HideFrames();
		end)
		LeaPlusLC["PageF"]:HookScript("OnShow", function()
			if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() then
				LeaPlusLC:HideFrames();
			end
		end)

		-- Lock channel colors after channel table is shown
		if LeaPlusLC["Manageclasscolors"] == "On" then
			hooksecurefunc("ChatConfig_CreateCheckboxes", function(self, checkBoxTable, checkBoxTemplate, title)
				if ( ChatConfigChannelSettingsLeft.checkBoxTable ) then
					for i=1,50 do
						if _G["ChatConfigChannelSettingsLeftCheckBox" .. i .. "ColorClasses"] then
							LeaPlusLC:LockItem(_G["ChatConfigChannelSettingsLeftCheckBox" .. i .. "ColorClasses"],true)
						end
					end
				end
			end)
		end
	end

----------------------------------------------------------------------
-- 	L31: Default Events
----------------------------------------------------------------------

	local function eventHandler(self, event, arg1, arg2, ...)

		-- Run Live after combat ends
		if event == "PLAYER_REGEN_ENABLED" then
			LeaPlusLC:Live();
			LpEvt:UnregisterEvent("PLAYER_REGEN_ENABLED");
			return
		end

		-- Invite from whisper
		if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
			if (not UnitExists("party1") or IsPartyLeader("player")) and strlower(arg1) == ("plusinvite") then
				if event == "CHAT_MSG_WHISPER" then
					InviteUnit(arg2)
				elseif event == "CHAT_MSG_BN_WHISPER" then
					local _, toonname, _, realmname = BNGetToonInfo(select(11, ...))
					InviteUnit(toonname .. "-" .. realmname)
				end
			end
		end

		-- No channels in dungeons
		if event == "CHAT_MSG_CHANNEL_NOTICE" and LeaPlusLC["NoChannelsInDungeons"] == "On" then
			local _,_,_,_,arg7 = ...
			if (not arg1 or not arg7) then
				return
			end
			if (arg7 == 1) then
				if ((arg1 == "YOU_JOINED") or (arg1 == "YOU_CHANGED")) then
					local inInstance, instanceType = IsInInstance()
					if ((inInstance) and (instanceType == "party") or (instanceType == "raid")) then
						ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, GENERAL)
					else
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, GENERAL)
					end
				end
			end
		end

		-- Block duels
		if event == "DUEL_REQUESTED" and not LeaPlusLC:RealIDCheck(arg1) and not LeaPlusLC:FriendCheck(arg1) then
			CancelDuel();
			StaticPopup_Hide("DUEL_REQUESTED");
		end

		-- Automatic resurrection
		if event == "RESURRECT_REQUEST" then
			if (GetCorpseRecoveryDelay() == 0) then
				if ((UnitAffectingCombat(arg1)) and LeaPlusLC["NoAutoResInCombat"] == "Off") or not (UnitAffectingCombat(arg1)) then
					AcceptResurrect();
					StaticPopup_Hide("RESURRECT_NO_TIMER");
					DoEmote("thank", arg1)
				end
			end
		end

		----------------------------------------------------------------------
		-- Accept summon
		----------------------------------------------------------------------

local function confirmSummonAfterCombat()
    if not UnitAffectingCombat("player") then
        ConfirmSummon()
        StaticPopup_Hide("CONFIRM_SUMMON")
        return true
    end
    return false
end

local function onUpdate(self, elapsed)
    if not StaticPopup1:IsShown() then
        self.TimerText:Hide()
        return
    end

    self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
    if self.timeSinceLastUpdate >= 10 then
        if confirmSummonAfterCombat() then
            self:SetScript("OnUpdate", nil)
            self.TimerText:Hide()
        end
        self.timeSinceLastUpdate = 0
    else
        self.TimerText:SetText(format("Auto-accept in: %.1f", 10 - self.timeSinceLastUpdate))
        self.TimerText:Show()
    end
end

if event == "CONFIRM_SUMMON" then
    local SummonFrame = CreateFrame("Frame")
    SummonFrame.timeSinceLastUpdate = 0
    SummonFrame:SetScript("OnUpdate", onUpdate)

    -- Create and anchor the timer text
    SummonFrame.TimerText = SummonFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    SummonFrame.TimerText:SetPoint("BOTTOM", StaticPopup1, "TOP", 0, 5)
    SummonFrame.TimerText:Show()

    return
end


		----------------------------------------------------------------------
		-- Block Guild Invite
		----------------------------------------------------------------------

if event == "GUILD_INVITE_REQUEST" then
	print("Guild invite declined.")
    DeclineGuild()
    StaticPopup_Hide("GUILD_INVITE")
end


		----------------------------------------------------------------------
		-- Automate Gossip Trainer and other town NPCs.
		----------------------------------------------------------------------

			-- Function to skip gossip
			local function SkipGossip()
if IsShiftKeyDown() then return end
local void, gossipType = GetGossipOptions()

if gossipType then
    -- Completely automate gossip
    if gossipType == "banker"
    or gossipType == "taxi"
    or gossipType == "trainer"
    or gossipType == "vendor"
    or gossipType == "battlemaster"
    or gossipType == "arenamaster"
    then
        if not IsAltKeyDown() then
        	if GetNumGossipAvailableQuests() == 0 and GetNumGossipActiveQuests() == 0 then
            SelectGossipOption(1)
            print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
        end
        elseif IsAltKeyDown() then
            SelectGossipOption(2)
            print("|cFF00ff99AutoGossip:|r option 2 chosen. Hold a shift key to override.")
        end
    end
end
end

			-- 		-- Choose gossip option 2 (usually vendor window or reset talents) with ALT key
			-- 		if IsAltKeyDown() then
			-- 			if gossipType == "gossip"
			-- 			then
			-- 				SelectGossipOption(2)
			-- 			end
			-- 		end
			-- 	end
			-- end

			-- Create gossip event frame
			local gossipFrame = CreateFrame("FRAME")

			-- Function to setup events
			local function SetupEvents()
				if LeaPlusLC["AutomateGossip"] == "On" then
					gossipFrame:RegisterEvent("GOSSIP_SHOW")
					gossipFrame:UnregisterEvent("GOSSIP_SHOW")
				end
			end

			-- Setup events when option is clicked and on startup (if option is enabled)
			LeaPlusCB["AutomateGossip"]:HookScript("OnClick", SetupEvents)
			if LeaPlusLC["AutomateGossip"] == "On" then SkipGossip() end

			-- Event handler
			gossipFrame:SetScript("OnEvent", function()
				-- Special treatment for specific NPCs
				local npcGuid = UnitGUID("target") or nil
				if npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						if npcID == "9999999999" -- Reserved for future use
						then
							SkipGossip()
							print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
							return
						end
					end
				end

				-- Process gossip
				if GetNumGossipOptions() == 1 and GetNumGossipAvailableQuests() == 0 and GetNumGossipActiveQuests() == 0 then
					SkipGossip()
					print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
				end
			end)



		----------------------------------------------------------------------
		-- Automate Gossip for All NPCs with 1 option of Gossip
		----------------------------------------------------------------------
			GossipFrame:HookScript("OnShow",function()
			local targetid = tonumber(string.match(tostring(UnitGUID("target")), "-([^-]+)-[^-]+$"))

			-- Shadowlands prepatch stuff START
			local GetNumGossipAvailableQuests = GetNumGossipAvailableQuests or C_GossipInfo.GetNumAvailableQuests
			local GetNumGossipActiveQuests = GetNumGossipActiveQuests or C_GossipInfo.GetNumActiveQuests
			local GetNumGossipOptions = GetNumGossipOptions or C_GossipInfo.GetNumOptions

			local GetGossipAvailableQuests = GetGossipAvailableQuests or C_GossipInfo.GetAvailableQuests
			local GetGossipActiveQuests = GetGossipActiveQuests or C_GossipInfo.GetActiveQuests
			local GetGossipOptions = GetGossipOptions or C_GossipInfo.GetOptions

			local SelectGossipAvailableQuest = SelectGossipAvailableQuest or C_GossipInfo.SelectAvailableQuest
			local SelectGossipActiveQuest = SelectGossipActiveQuest or C_GossipInfo.SelectActiveQuest
			local SelectGossipOption = SelectGossipOption or C_GossipInfo.SelectOption

			local CloseGossip = CloseGossip or C_GossipInfo.CloseGossip

			local ActionStatus_DisplayMessage = ActionStatus_DisplayMessage or function(self) ActionStatus:DisplayMessage(self) end
			-- Shadowlands prepatch stuff END
				if LeaPlusLC["AutomateGossipAll"] == "On" then
			-- Stop if modifier key is held down
				if
				(
					IsShiftKeyDown()
				)
				then 
					return
				end 

			-- Stop if NPC has quests or quest turn-ins
				if
				(
					GetNumGossipActiveQuests() > 0						
					or GetNumGossipAvailableQuests() > 0						
				)
				then 
					return
				end 

			-- Stop if particular NPC
				if
				(
					targetid == 155261			-- Sean Wilkers 1 (inside Statholme Pet Dungeon)
					or targetid == 155264			-- Sean Wilkers 2 (inside Statholme Pet Dungeon)
					or targetid == 155270			-- Sean Wilkers 3 (inside Statholme Pet Dungeon)
					or targetid == 155346			-- Sean Wilkers 4 (inside Statholme Pet Dungeon)
				)
				then 
					return
				end 
				
			-- Auto select option if only 1 is available	
			
				if
				(
					GetNumGossipOptions() == 1						
				)
				then 
					SelectGossipOption(1)
					print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
				end

			-- Auto select option 1 if more than one option is available for the listed NPCs	
				if
				(
					GetNumGossipOptions() > 1							
				)
				then
					if
					(
						targetid == 93188		-- Mongar (Legion Dalaran)
						or targetid == 96782		-- Lucian Trias (Legion Dalaran)
						or targetid == 97004		-- "Red" Jack Findle (Legion Dalaran)
						or targetid == 138708		-- Garona Halforcen (BFA)
						or targetid == 135614		-- Master Mathias Shaw (BFA)
						or targetid == 131287		-- Natal'hakata (Horde Zandalari Emissary)
						or targetid == 138097		-- Muka Stormbreaker (Stormsong Valley Horde flight master)
						or targetid == 35642		-- Jeeves
						or targetid == 57850		-- Teleportologist Fozlebub (Darkmoon Faire)
					)
					then
						SelectGossipOption(1)
						print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
					end

			-- Auto select option 2 if more than one option is available for the listed NPCs	
					if
					(
						targetid == 35004		-- Jaeren Sunsworn (Trial of the Champion)
						or targetid == 35005		-- Arelas Brightstar (Trial of the Champion)
					)
					then
						SelectGossipOption(2)
						print("|cFF00ff99AutoGossip:|r option chosen. Hold a shift key to override.")
					end
				end
			end
			end)


		----------------------------------------------------------------------
		--	Faster looting
		----------------------------------------------------------------------

		-- if LeaPlusLC["FasterLooting"] == "On" then

			-- -- Time delay
			-- local tDelay = 0

			-- -- Fast loot function
			-- local function FastLoot()
			-- 	if GetTime() - tDelay >= 0.3 then
			-- 		tDelay = GetTime()
			-- 		if not IsModifiedClick("AUTOLOOTTOGGLE") then
			-- 			if TSMDestroyBtn and TSMDestroyBtn:IsShown() and TSMDestroyBtn:GetButtonState() == "DISABLED" then tDelay = GetTime() return end
			-- 			if GetLootMethod() == "master" then
			-- 				-- Master loot is enabled so fast loot if item should be auto looted
			-- 				local lootThreshold = GetLootThreshold()
			-- 				for i = GetNumLootItems(), 1, -1 do
			-- 					local lootIcon, lootName, lootQuantity, currencyID, lootQuality = GetLootSlotInfo(i)
			-- 					if lootQuality and lootThreshold and lootQuality < lootThreshold then
			-- 						LootSlot(i)
			-- 						print("xd master")
			-- 					end
			-- 				end
			-- 			else
			-- 				-- Master loot is disabled so fast loot regardless
			-- 				for i = GetNumLootItems(), 1, -1 do
			-- 					LootSlot(i)
			-- 					print("xd")
			-- 				end
			-- 			end
			-- 			tDelay = GetTime()
			-- 		end
			-- 	end
			-- end

			-- -- Event frame
			-- local faster = CreateFrame("Frame")
			-- faster:RegisterEvent("LOOT_OPENED")
			-- faster:SetScript("OnEvent", FastLoot)

		-- end


		----------------------------------------------------------------------
		--	Faster looting v2
		----------------------------------------------------------------------

if LeaPlusLC["FasterLooting"] == "On" then
	local addonName = ...
	local AutoLoot = CreateFrame("Frame")
	local Settings = {}

	local SetCVar = SetCVar or C_CVar.SetCVar
	local GetCVarBool = GetCVarBool or C_CVar.GetCVarBool
	local BACKPACK_CONTAINER, LOOT_SLOT_ITEM, NUM_BAG_SLOTS = BACKPACK_CONTAINER, LOOT_SLOT_ITEM, NUM_BAG_SLOTS
	local GetContainerNumFreeSlots = GetContainerNumFreeSlots
	local GetCursorPosition = GetCursorPosition
	local GetItemCount = GetItemCount
	local GetItemInfo = GetItemInfo
	local GetLootSlotInfo = GetLootSlotInfo
	local GetLootSlotLink = GetLootSlotLink
	local GetLootSlotType = GetLootSlotType
	local GetNumLootItems = GetNumLootItems
	local IsFishingLoot = IsFishingLoot
	local IsModifiedClick = IsModifiedClick
	local LootSlot = LootSlot
	-- local PlaySound = PlaySound
	local band = bit.band
	local select = select
	local tContains = tContains

	function AutoLoot:ProcessLoot(item, q)
		local total, free, bagFamily = 0
		local itemFamily = GetItemFamily(item)
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			free, bagFamily = GetContainerNumFreeSlots(i)
			if (not bagFamily or bagFamily == 0) or (itemFamily and band(itemFamily, bagFamily) > 0) then
				total = total + free
			end
		end
		if total > 0 then
			return true
		end

		local have = (GetItemCount(item) or 0)
		if have > 0 then
			local itemStackCount = (select(8,GetItemInfo(item)) or 0)
			if itemStackCount > 1 then
				while have > itemStackCount do
					have = have - itemStackCount
				end
				local remain = itemStackCount - have
				if remain >= q then
					return true
				end
			end
		end
		return false
	end

	function AutoLoot:ShowLootFrame(show)
		if self.ElvUI then
			if show then
				ElvLootFrame:SetParent(ElvLootFrameHolder)
				ElvLootFrame:SetFrameStrata("HIGH")
				self:LootUnderMouse(ElvLootFrame, ElvLootFrameHolder, 20)
				self.isHidden = false
			else
				ElvLootFrame:SetParent(self)
				self.isHidden = true
			end
		elseif LootFrame:IsEventRegistered("LOOT_SLOT_CLEARED") then
			LootFrame.page = 1;
			if show then
				LootFrame_Show(LootFrame)
				self.isHidden = false
			else
				self.isHidden = true
			end
		end
	end

	function AutoLoot:LootItems(numItems)
		local lootThreshold = (self.isClassic and select(2,GetLootMethod()) == 0) and GetLootThreshold() or 10
		for i = numItems, 1, -1 do
			local itemLink = GetLootSlotLink(i)
	--		-- local slotType = GetLootSlotType(i)
			local quantity, _, quality, locked, isQuestItem = select(3, GetLootSlotInfo(i))
			if locked or (quality and quality >= lootThreshold) then
				self.isItemLocked = true
			else
				if slotType ~= LOOT_SLOT_ITEM or (not self.isClassic and isQuestItem) or self:ProcessLoot(itemLink, quantity) then
					numItems = numItems - 1
					LootSlot(i)
				end
			end
		end
		if numItems > 0 then
			self:ShowLootFrame(true)
			-- self:PlayInventoryFullSound()
		end

		-- if IsFishingLoot() and not Settings.global.fishingSoundDisabled then
		-- 	PlaySound(SOUNDKIT.FISHING_REEL_IN, self.audioChannel)
		-- end
	end

	function AutoLoot:OnEvent(e, ...)
		-- if e == "ADDON_LOADED" and ... == addonName then
		-- 	SpeedyAutoLootDB = SpeedyAutoLootDB or {}
		-- 	Settings = SpeedyAutoLootDB
		-- 	Settings.global = Settings.global or {}
	    if e == "PLAYER_LOGIN" then
			SetCVar("autoLootDefault",1)

		elseif (e == "LOOT_READY" or e == "LOOT_OPENED") and not self.isLooting then
			local aL = ...

			local numItems = GetNumLootItems()
			if numItems == 0 then
				return
			end

			self.isLooting = true
			-- if aL or (aL == nil and GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE")) then
			if not IsModifiedClick("AUTOLOOTTOGGLE") then
				self:LootItems(numItems)
				-- print("loot")
			else
				self:ShowLootFrame(true)
				-- print("show")
			end
		elseif e == "LOOT_CLOSED" then
			self.isLooting = false
			self.isHidden = false
			self.isItemLocked = false
			self:ShowLootFrame(false)
		elseif (e == "UI_ERROR_MESSAGE" and tContains(({ERR_INV_FULL,ERR_ITEM_MAX_COUNT}), select(2,...))) or e == "LOOT_BIND_CONFIRM" then
			if self.isLooting and self.isHidden then
				self:ShowLootFrame(true)
				-- if e == "UI_ERROR_MESSAGE" then
				-- 	self:PlayInventoryFullSound()
				-- end
			end
		end
	end

	-- function AutoLoot:PlayInventoryFullSound()
	-- 	if Settings.global.enableSound and not self.isItemLocked then
	-- 		PlaySound(Settings.global.InventoryFullSound, self.audioChannel)
	-- 	end
	-- end

	function AutoLoot:LootUnderMouse(self, parent, yoffset)
		if GetCVarBool("lootUnderMouse") then
			local x, y = GetCursorPosition()
			x = x / self:GetEffectiveScale()
			y = y / self:GetEffectiveScale()

			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + (yoffset or 20))
			self:GetCenter()
			self:Raise()
		else
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", parent, "TOPLEFT")
		end
	end

	-- function AutoLoot:Help(msg)
	-- 	local fName = "|cffEEE4AESpeedy AutoLoot:|r "
	-- 	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	-- 	if not cmd or cmd == "" or cmd == "help" then
	-- 		print(fName.."   |cff58C6FA/sal    /speedyautoloot    /speedyloot|r")
	-- 		print("  |cff58C6FA/sal auto              -|r  |cffEEE4AEEnable Auto Looting for all characters|r")
	-- 		print("  |cff58C6FA/sal fish              -|r  |cffEEE4AEDisable Fishing reel in sound|r")
	-- 		print("  |cff58C6FA/sal sound            -|r  |cffEEE4AEPlay a Sound when Inventory is full while looting|r")
	-- 		if self.isClassic then
	-- 			print("  |cff58C6FA/sal set (SoundID) -|r  |cffEEE4AESet a Sound (SoundID), Default:  /sal set 139|r")
	-- 		else
	-- 			print("  |cff58C6FA/sal set (SoundID) -|r  |cffEEE4AESet a Sound (SoundID), Default:  /sal set 44321|r")
	-- 		end
	-- 	elseif cmd == "fish" then
	-- 		if not Settings.global.fishingSoundDisabled then
	-- 			Settings.global.fishingSoundDisabled = true
	-- 			print(fName.."|cffB6B6B6Fishing reel in sound disabled.")
	-- 		else
	-- 			Settings.global.fishingSoundDisabled = false
	-- 			print(fName.."|cff37DB33Fishing reel in sound enabled.")
	-- 		end
	-- 	elseif cmd == "auto" then
	-- 		if Settings.global.alwaysEnableAutoLoot then
	-- 			Settings.global.alwaysEnableAutoLoot = false
	-- 			print(fName.."|cffB6B6B6Auto Loot for all Characters disabled.")
	-- 			SetCVar("autoLootDefault",0)
	-- 		else
	-- 			Settings.global.alwaysEnableAutoLoot = true
	-- 			print(fName.."|cff37DB33Auto Loot for all Characters enabled.")
	-- 			SetCVar("autoLootDefault",1)
	-- 		end
	-- 	elseif cmd == "sound" then
	-- 		if Settings.global.enableSound then
	-- 			Settings.global.enableSound = false
	-- 			print(fName.."|cffB6B6B6Don't play a sound when inventory is full.")
	-- 		else
	-- 			if not Settings.global.InventoryFullSound then
	-- 				if self.isClassic then
	-- 					Settings.global.InventoryFullSound = 139
	-- 				else
	-- 					Settings.global.InventoryFullSound = 44321
	-- 				end
	-- 			end
	-- 			Settings.global.enableSound = true
	-- 			print(fName.."|cff37DB33Play a sound when inventory is full.")
	-- 		end
	-- 	elseif cmd == "set" and args ~= "" then
	-- 		local SoundID = tonumber(args:match("%d+"))
	-- 		if SoundID then
	-- 			Settings.global.InventoryFullSound = tonumber(args:match("%d+"))
	-- 			PlaySound(SoundID, self.audioChannel)
	-- 			print(fName.."Set Sound|r |cff37DB33"..SoundID.."|r")
	-- 		end
	-- 	end
	-- end

	function AutoLoot:OnLoad()
		self:SetToplevel(true)
		self:Hide()
		self:SetScript("OnEvent", function(_,...)
			self:OnEvent(...)
		end)

		for _,e in next, ({	"ADDON_LOADED", "PLAYER_LOGIN", "LOOT_READY", "LOOT_OPENED", "LOOT_CLOSED", "UI_ERROR_MESSAGE" }) do
			self:RegisterEvent(e)
		end

		self.audioChannel = "master"
		self.isClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

		if self.isClassic then
	        self:RegisterEvent("LOOT_BIND_CONFIRM")
	        self:RegisterEvent("OPEN_MASTER_LOOT_LIST")
		end

		LootFrame:UnregisterEvent('LOOT_OPENED')
	end

	-- SLASH_SPEEDYAUTOLOOT1, SLASH_SPEEDYAUTOLOOT2, SLASH_SPEEDYAUTOLOOT3  = "/sal", "/speedyloot", "/speedyautoloot"
	-- SlashCmdList["SPEEDYAUTOLOOT"] = function(...)
	--     AutoLoot:Help(...)
	-- end

	AutoLoot:OnLoad()
end

		----------------------------------------------------------------------
		-- Check For Talent Switch
		----------------------------------------------------------------------
		if event == "ACTIVE_TALENT_GROUP_CHANGED" then
			LeaPlusLC:Print("Talent spec changed.")
		end

		-- Block party invites
		if event == "PARTY_INVITE_REQUEST" then

			-- If a friend, accept if you're accepting friends and not in Dungeon Finder
			if (LeaPlusLC:FriendCheck(arg1) or LeaPlusLC:RealIDCheck(arg1)) and not LeaPlusLC:IsInLFGQueue() then
				if LeaPlusLC["AcceptPartyFriends"] == "On" then
					AcceptGroup();
					for i=1, STATICPOPUP_NUMDIALOGS do
						if _G["StaticPopup"..i].which == "PARTY_INVITE" then
							_G["StaticPopup"..i].inviteAccepted = 1
							break
						end
					end
					StaticPopup_Hide("PARTY_INVITE");
					return
				end
			end

			-- If neither friend or guild and you're blocking invites, decline
			if LeaPlusLC["NoPartyInvites"] == "On" then
				if LeaPlusLC:FriendCheck(arg1) or LeaPlusLC:RealIDCheck(arg1) then
					return
				else
					DeclineGroup(); 
					StaticPopup_Hide("PARTY_INVITE");
					print("Party Invite has been auto-declined.")
					return
				end
			end	

		end

		-- Don't confirm loot rolls
		if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
			if not IsShiftKeyDown() then
				ConfirmLootRoll(arg1, arg2)
				StaticPopup_Hide("CONFIRM_LOOT_ROLL")
			end
		end

		if event == "LOOT_BIND_CONFIRM" then
			if not IsShiftKeyDown() then
				ConfirmLootSlot(arg1, arg2);
				StaticPopup_Hide("LOOT_BIND",...)
			end
		end

		-- Sell junk automatically
		if event == "MERCHANT_SHOW" and LeaPlusLC["AutoSellJunk"] == "On" then

			local Total = 0
			local SoldCount = 0
			local Rarity = 0
			local ItemPrice = 0
			local ItemCount = 0
			local CurrentItemLink

			for BagID = 0,4 do
				for BagSlot = 1, GetContainerNumSlots(BagID) do
					CurrentItemLink = GetContainerItemLink(BagID, BagSlot)
					if CurrentItemLink then
						_, _, Rarity, _, _, _, _, _, _, _, ItemPrice = GetItemInfo(CurrentItemLink)
						_, ItemCount = GetContainerItemInfo(BagID, BagSlot)
						if Rarity == 0 and ItemPrice ~= 0 then
							Total = Total + (ItemPrice * ItemCount)
							SoldCount = SoldCount + 1
							UseContainerItem(BagID, BagSlot)
						end
					end
				end
			end
			if Total ~= 0 then
				LeaPlusLC:Print("Sold " .. SoldCount .. " grey items for " .. GetCoinTextureString(Total) .. ".")
			end
		end

		-- Automatically accept quests
		if ((LeaPlusLC["AutoAcceptQuests"] == "On" and LeaPlusLC["AcceptOnlyDailys"] == "Off") or (LeaPlusLC["AutoAcceptQuests"] == "On" and LeaPlusLC["AcceptOnlyDailys"] == "On" and QuestIsDaily() == 1)) then

			-- Automatically accept all quests or daily quests with daily check on
			if event == "QUEST_DETAIL" then
				if not IsShiftKeyDown() then
					if not QuestGetAutoAccept() then
						-- If quest requires an accept click
						AcceptQuest()
					else
						-- If it's automatically accepted, just close the window
						CloseQuest()
					end
				end
			end

			-- Quests requiring confirmation
			if event == "QUEST_ACCEPT_CONFIRM" then
				if not IsShiftKeyDown() then
					ConfirmAcceptQuest()
					StaticPopup_Hide("QUEST_ACCEPT_CONFIRM")
				end
			end
		end
		
		-- Automatically turn-in quests
		if LeaPlusLC["AutoTurnInQuests"] == "On" then

			-- Active quest turn-ins
			if event == "QUEST_PROGRESS" then
				if not IsShiftKeyDown() then
					if IsQuestCompletable() then
						CompleteQuest()
					end
				end
			end

			-- Turn-in completed quest
			if event == "QUEST_COMPLETE" then
				if not IsShiftKeyDown() then
					if GetNumQuestChoices() <= 1 then
						-- If there is only one reward item offered, grab it
						GetQuestReward(GetNumQuestChoices())
					end
				end
			end

		end

		-- Battleground release
		if event == "PLAYER_DEAD" then
			local InstStat, InstType = IsInInstance();
			if InstStat == 1 and InstType == "pvp" then
				-- Check for soulstone
				if not (HasSoulstone()) then
					RepopMe();
				end
			end
		end

		-- Repair automatically
		if event == "MERCHANT_SHOW" and LeaPlusLC["AutoRepairOwnFunds"] == "On" then

		-- Stop if shift key is held down
		if
		(
			IsShiftKeyDown()
		)
		then 
			return
		end 
			if CanMerchantRepair() then
				local PlayerMoney = GetMoney()
				local RepairCost, CanRepair = GetRepairAllCost()

				if (CanRepair) then -- if the repair option is available at the merchant
					if PlayerMoney == nil then PlayerMoney = 0 end
					if (RepairCost <= PlayerMoney) then
						RepairAllItems()
						LeaPlusLC:Print("Repaired for " .. GetCoinTextureString(RepairCost) .. ".")
					else
						LeaPlusLC:Print("The repair cost is " .. GetCoinTextureString(RepairCost) ..".")
						LeaPlusLC:Print("You do not have enough money to automatically repair.")
					end
				end
			end
		end

		-- Run modules
		if event == "ADDON_LOADED" then
			if arg1 == "Leatrix_Plus" then
				LeaPlusLC:Load();
				LeaPlusLC:Live();
				LeaPlusLC:Isolated();
				LeaPlusLC:RunOnce();
				LeaPlusLC:SetDim();
				LeaPlusLC:QuestSizeUpdate();
				LeaPlusLC:SetPlusAlpha();
				LeaPlusLC:SetPlusScale();
			elseif (arg1 == "Blizzard_AuctionUI" or arg1 == "Blizzard_TimeManager" or arg1 == "Blizzard_CombatLog") then
				LeaPlusLC:BlizzDep(arg1);			
			end
		end

		if (event == "VARIABLES_LOADED") then
			LeaPlusLC:Variable()
			UIParentLoadAddOn("Blizzard_DebugTools")
			LeaPlusLC:Print("Leatrix Plus " .. LeaPlusLC["PlusVersion"] .. ".");
		end

		if (event == "PLAYER_ENTERING_WORLD") then
			LeaPlusLC:Player();
		end

		-- Save locals back to globals on logout
		if (event == "PLAYER_LOGOUT") then
			LeaPlusLC:Save();
			if LeaPlusLC["FrmEnabled"] == "On" then
				-- PlayerFrame:SetUserPlaced(false)
				-- TargetFrame:SetUserPlaced(false)
			end
		end

	end

--	Register event handler
	LpEvt:SetScript("OnEvent", eventHandler);

----------------------------------------------------------------------
--	L32: Slash commands
----------------------------------------------------------------------

--	Slash command handler
	function LeaPlusLC:SlashInterpreter(str)
		if LeaPlusLC["LeaPlusFrameMove"] and LeaPlusLC["LeaPlusFrameMove"]:IsShown() then return end
		if LeaPlusCB["TooltipDragFrame"] and LeaPlusCB["TooltipDragFrame"]:IsShown() then return end
		if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() then return end
		if str == "" then
			if LeaPlusLC["PageF"]:IsShown() then
				LeaPlusLC:HideFrames();
			else
				LeaPlusLC:HideFrames();
				LeaPlusLC["PageF"]:Show();
			end
			if LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]] and LeaPlusLC["OpenPlusAtHome"] == "Off" then
				 LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
			else
				LeaPlusLC["Page0"]:Show();
			end
		elseif str == "help" then LeaPlusLC:Print("Leatrix Plus\n/ltp - Toggle the options panel\n/ltp toggle - Toggle error messages\n/ltp frame - Toggle frame Information\n/ltp restart - Restart graphics subsystem")
		elseif str == "frame" then
			FrameStackTooltip_Toggle();
		elseif str == "restart" then
			RestartGx();
		elseif str == "toggle" then
			if LeaPlusLC["ShowErrorsFlag"] == 1 then LeaPlusLC["ShowErrorsFlag"] = 0 else LeaPlusLC["ShowErrorsFlag"] = 1 end
		else
			LeaPlusLC:Print("Invalid command.  Type '/ltp help' for help.")
		end
	end

--	Slash command support
	SLASH_Leatrix_Plus1 = '/ltp'
	SLASH_Leatrix_Plus2 = '/leaplus'
	SlashCmdList["Leatrix_Plus"] = function(str) LeaPlusLC:SlashInterpreter(string.lower(str)) end
	
----------------------------------------------------------------------
-- 	L40: Options panel definitions
----------------------------------------------------------------------

	-- Define panel title
	function LeaPlusLC:CreateMainTitle(frame, title, subtitle)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		text:SetPoint('TOPLEFT', 16, -16);
		text:SetText(title)
		local subtext = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		subtext:SetHeight(32);
		subtext:SetPoint('TOPLEFT', text, 'BOTTOMLEFT', 0, -8); 
		subtext:SetPoint('RIGHT', frame, -32, 0)
		subtext:SetJustifyH('LEFT'); subtext:SetJustifyV('TOP');
		subtext:SetNonSpaceWrap(true); subtext:SetText(subtitle)
	end

	-- Define panel title (mid)
	function LeaPlusLC:CreatePageTitle(frame, title)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		text:SetPoint('TOPLEFT', 146, -16)
		text:SetText(title)
	end
	
	-- Define subheadings
	function LeaPlusLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(title)
	end

	-- Define text
	function LeaPlusLC:MakeWD(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(title)
	end

	-- Define slider control
	function LeaPlusLC:MakeSL(frame, field, caption, low, high, step, x, y, form)

		-- Create slider control
		LeaPlusCB[field] = CreateFrame("slider", field, frame, "OptionssliderTemplate")
		LeaPlusCB[field]:SetMinMaxValues(low, high)
		LeaPlusCB[field]:SetValueStep(step)
		LeaPlusCB[field]:EnableMouseWheel(true)
		LeaPlusCB[field]:SetPoint('TOPLEFT', x,y)
		LeaPlusCB[field]:SetWidth(100)
		LeaPlusCB[field]:SetHeight(20)
		LeaPlusCB[field]:SetHitRectInsets(0, 0, 0, 0);

		_G[LeaPlusCB[field]:GetName().."Low"]:SetText('');
		_G[LeaPlusCB[field]:GetName().."High"]:SetText('');

		-- Create slider label
		LeaPlusCB[field].f = LeaPlusCB[field]:CreateFontString(nil, 'BACKGROUND')
		LeaPlusCB[field].f:SetFontObject('GameFontHighlight')
		LeaPlusCB[field].f:SetPoint('LEFT', LeaPlusCB[field], 'RIGHT', 12, 0)
		LeaPlusCB[field].f:SetText(string.format("%.2f", LeaPlusCB[field]:GetValue()))

		-- Process mousewheel scrolling
		LeaPlusCB[field]:SetScript('OnMouseWheel', function(frame, arg1)
			local step = frame:GetValueStep() * arg1
			local value = frame:GetValue()
			local minVal, maxVal = frame:GetMinMaxValues()
			if step > 0 then
				frame:SetValue(min(value+step, maxVal))
			else
				frame:SetValue(max(value+step, minVal))
			end
			if field == "LeaPlusScaleValue" then
				LeaPlusLC:SetPlusScale();
			elseif field == "LeaPlusMaxVol" then
				LeaPlusLC:MasterVolUpdate();
			end
		end)

		-- Process value changed
		LeaPlusCB[field]:SetScript('OnValueChanged', function(frame, value)
			LeaPlusCB[field].f:SetText(format(form, value))
			LeaPlusLC[field] = value
			if field == "LeaPlusQuestFontSize" then
				LeaPlusLC:QuestSizeUpdate();
			elseif field == "LeaPlusTipSize" then
				LeaPlusLC:SetTipScale();
			elseif field == "LeaPlusAlphaValue" then
				LeaPlusLC:SetPlusAlpha();
			elseif field == "LeaPlusMaxVol" then
				LeaPlusLC:MasterVolUpdate();
			end
		end)

		-- Process click finish
		LeaPlusCB[field]:SetScript('OnMouseUp', function()
			if field == "LeaPlusScaleValue" then
				LeaPlusLC:SetPlusScale();
			end
		end)

		-- Set default state
		LeaPlusCB[field]:SetScript('OnShow', function(frame)
			frame.onShow = true
			frame:SetValue(LeaPlusLC[field])
			frame.onShow = nil
		end)
	end

	-- Define Checkbox control
	function LeaPlusLC:MakeCB(frame, field, caption, x, y, tip)

		-- Create checkbox
		LeaPlusCB[field] = CreateFrame('CheckButton', nil, frame, "ChatConfigCheckButtonTemplate")
		LeaPlusCB[field]:SetPoint("TOPLEFT",x, y)

		-- Checkbox tooltips
		LeaPlusCB[field].tiptext = tip
		LeaPlusCB[field]:SetScript("OnEnter", LeaPlusLC.ShowTooltip)		
		LeaPlusCB[field]:SetScript("OnLeave", LeaPlusLC.HideTooltip)

		-- Checkbox labels
		LeaPlusCB[field].f = LeaPlusCB[field]:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		LeaPlusCB[field].f:SetPoint('LEFT', 20, 0)
		LeaPlusCB[field].f:SetText(caption)

		-- Default checkbox state
		LeaPlusCB[field]:SetScript('OnShow', function(frame)
			frame:SetChecked(LeaPlusLC[field])
		end)

		-- Process clicks
		LeaPlusCB[field]:SetScript('OnClick', function(frame)
			if LeaPlusCB[field]:GetChecked() == nil then
				LeaPlusLC[field] = "Off"
			elseif LeaPlusCB[field]:GetChecked() == 1 then
				LeaPlusLC[field] = "On"
			end
			LeaPlusLC:SetDim();
			LeaPlusLC:ReloadCheck();
			LeaPlusLC:Live();
			LeaPlusLC:TradeGuild();

			-- Special checkboxes
			if field == "TipScaleCheck" or field == "TipModEnable" then LeaPlusLC:SetTipScale(); end
			if field == "PlusPanelScaleCheck" then LeaPlusLC:SetPlusScale(); end
			if field == "PlusPanelAlphaCheck" then LeaPlusLC:SetPlusAlpha(); end

			-- Frame movement
			if field == "FrmEnabled" and LeaPlusLC["FrmEnabled"] == "Off" then
				PlayerFrame:SetUserPlaced(false)
				TargetFrame:SetUserPlaced(false)
			elseif field == "FrmEnabled" and LeaPlusLC["FrmEnabled"] == "On" then
				PlayerFrame:SetUserPlaced(true)
				TargetFrame:SetUserPlaced(true)
			end
		end)
	end

	-- Define close button
	function LeaPlusLC:MakeCL(name, frame, anchor, x, y, width, height, tip)
		LeaPlusCB[name] = CreateFrame("Button", nil, frame, "UIPanelCloseButton") 
		LeaPlusCB[name]:SetSize(width, height)
		LeaPlusCB[name]:SetPoint(anchor, x, y)
		LeaPlusCB[name].tiptext = tip
		LeaPlusCB[name]:SetScript("OnEnter", LeaPlusLC.ShowTooltip)		
		LeaPlusCB[name]:SetScript("OnLeave", LeaPlusLC.HideTooltip)
	end

	-- Define button
	function LeaPlusLC:CreateButton(name, frame, label, anchor, x, y, width, height, tip)
		LeaPlusCB[name] = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate") 
		LeaPlusCB[name]:SetWidth(width)
		LeaPlusCB[name]:SetHeight(height) 
		LeaPlusCB[name]:SetAlpha(1.0)
		LeaPlusCB[name]:SetPoint(anchor, x, y)
		LeaPlusCB[name]:SetText(label) 
		LeaPlusCB[name]:RegisterForClicks("AnyUp") 
		LeaPlusCB[name].tiptext = tip
		LeaPlusCB[name]:SetScript("OnEnter", LeaPlusLC.ShowTooltip)		
		LeaPlusCB[name]:SetScript("OnLeave", LeaPlusLC.HideTooltip)
	end
	
	-- Define menu button
	function LeaPlusLC:MakeMN(name, text, parent, anchor, x, y, width, height)

		local name = CreateFrame("Button", nil, parent)
		LeaPlusLC[name] = name
		name:Show();
		name:SetSize(width, height)
		name:SetAlpha(1.0)
		name:SetPoint(anchor, x, y)

		name.t = name:CreateTexture(name, "BACKGROUND")
		name.t:SetAllPoints()
		name.t:SetTexture(0.3, 0.3, 0.00, 0.8)
		name.t:Hide();

		name.s = name:CreateTexture(name, "BACKGROUND")
		LeaPlusLC[name.s] = name.s
		name.s:SetAllPoints()
		name.s:SetTexture(0.3, 0.3, 0.00, 0.8)
		name.s:Hide();

		name.f = name:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		name.f:SetPoint('LEFT', 16, 0)
		name.f:SetText(text)
	
		name:SetScript("OnEnter", function()
			UIFrameFadeIn(name.t, 0.1, 0.0, 1)
		end)

		name:SetScript("OnLeave", function()
			UIFrameFadeOut(name.t, 0.1, 1, 0.0)
		end)

		return LeaPlusLC[name], LeaPlusLC[name.s]
	end

	-- Create textured bar
	function LeaPlusLC:CreateBar(name,parent,width,height,anchor,r,g,b,alpha,texture)
		LeaPlusLC[name] = parent:CreateTexture(nil, 'BORDER')
		LeaPlusLC[name]:SetTexture(texture)
		LeaPlusLC[name]:SetSize(width, height)  
		LeaPlusLC[name]:SetPoint(anchor)
		LeaPlusLC[name]:SetVertexColor(r,g,b,alpha)
	end

----------------------------------------------------------------------
-- 	L41: Options Panel Template
----------------------------------------------------------------------

	-- Create the page template
	local PageF = CreateFrame("Frame", "LeaPlusGlobalPanel", UIParent); 
	table.insert(UISpecialFrames, "LeaPlusGlobalPanel")
	LeaPlusLC["PageF"] = PageF
	PageF:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	PageF:SetSize(570,370)
	LeaPlusLC:MakeTx(PageF, "Menu", 16, -72);
	PageF:Hide();
	PageF:SetFrameStrata("FULLSCREEN_DIALOG")

	-- Add background color
	LeaPlusLC.PageF.t = PageF:CreateTexture(LeaPlusLC["PageF"], "BACKGROUND")
	LeaPlusLC.PageF.t:SetAllPoints()
	LeaPlusLC.PageF.t:SetTexture(0.05, 0.05, 0.05, 0.9)

	-- Add textures
	LeaPlusLC:CreateBar("FootTexture", PageF, 570, 42, "BOTTOM", 0.3, 0.3, 1.0, 0.4, "Interface\\GLUES\\MODELS\\UI_MAINMENU\\GRADIENT")
	LeaPlusLC:CreateBar("MainTexture", PageF, 440, 348, "TOPRIGHT", 0.8, 0.8, 0.8, 0.4, "Interface\\DressUpFrame\\DressUpBackground-NightElf1")
	LeaPlusLC:CreateBar("MenuTexture", PageF, 130, 348, "TOPLEFT", 0.6, 0.6, 0.6, 0.4, "Interface\\GLUES\\MODELS\\UI_MAINMENU\\GRADIENT")

	-- Make the options panel movable
	PageF:SetClampedToScreen(true);
	PageF:EnableMouse(true)
	PageF:SetMovable(true)
	PageF:RegisterForDrag("LeftButton")
	PageF:SetScript("OnDragStart", PageF.StartMoving)
	PageF:SetScript("OnDragStop", function ()
		PageF:StopMovingOrSizing();
		PageF:SetUserPlaced(true);
		for i = 0,LeaPlusLC["NumberOfPages"] do
			LeaPlusLC["Page"..i]:SetAllPoints(PageF)
		end
	end)

	-- Make options panel page
	function LeaPlusLC:MakePage(name, title, menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)
		local name = CreateFrame("Frame", nil, LeaPlusLC["PageF"]); 
		LeaPlusLC[name] = name
		name:SetAllPoints(LeaPlusLC["PageF"])
		LeaPlusLC:CreateMainTitle(name, "Leatrix Plus", "Version " .. LeaPlusLC["PlusVersion"]);
		LeaPlusLC:CreatePageTitle(name, title)
		name:Hide();
		if menu then
			LeaPlusLC[menu], LeaPlusLC[menu .. ".s"] = LeaPlusLC:MakeMN(menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)
			LeaPlusLC[name]:SetScript("OnShow", function() LeaPlusLC[menu .. ".s"]:Show(); end)
			LeaPlusLC[name]:SetScript("OnHide", function() LeaPlusLC[menu .. ".s"]:Hide(); end)
		end
		return LeaPlusLC[name]
	end

	-- Show buttons along with pages
	function LeaPlusLC:AutoShowButtons(name, button)
		LeaPlusLC[name]:HookScript("OnShow", function()
			LeaPlusCB[button]:Show();
		end)
	end

----------------------------------------------------------------------
-- 	L42: Buttons
----------------------------------------------------------------------

	-- Home Button
	LeaPlusLC:CreateButton("HomePageButton", LeaPlusLC["PageF"], "Home", "BOTTOMLEFT", 10, 10, 70, 25, "Click to go home.")
	LeaPlusCB["HomePageButton"]:SetScript("OnClick", function() 
		LeaPlusLC:HideFrames();
		LeaPlusLC["Page0"]:Show();
		LeaPlusLC["PageF"]:Show();
		LeaPlusLC["LeaStartPage"] = "0"
	end)

	-- Defaults Button
	LeaPlusLC:CreateButton("SetDefaultsButton", LeaPlusLC["PageF"], "Reset", "BOTTOMLEFT", 90, 10, 70, 25,"This button will set all the options in Leatrix Plus back to the default settings.  Your UI will be reloaded.\n\nThis does not reset your tooltip options or frame layout.\n\nAs a precaution, you need to hold down CTRL and SHIFT while clicking this button in order for it to work.")
	LeaPlusCB["SetDefaultsButton"]:Hide();
	LeaPlusCB["SetDefaultsButton"]:SetScript("OnClick", function()
		if IsShiftKeyDown() and IsControlKeyDown() then
			if LeaPlusLC:PlayerInCombat() then
				return
			else
				for k,v in pairs(LeaPlusDB) do
					if (string.sub(k, 0, 3) ~= "Tip") and (string.sub(k, 0, 3) ~= "Frm") and k ~= "Frames" then
						if LeaPlusLC[k] then LeaPlusLC[k] = nil end
						if LeaPlusDB[k] then LeaPlusDB[k] = nil end
					end
				end
				ReloadUI();
			end
		else
			LeaPlusLC:Print("You need to hold down CTRL and SHIFT while clicking this button.")
		end
	end)

	-- Wipe All Button
	LeaPlusLC:CreateButton("WipeAllButton", LeaPlusLC["PageF"], "Wipe", "BOTTOMLEFT", 170, 10, 70, 25,"This button will wipe ALL your Leatrix Plus settings.  Your UI will be reloaded.\n\nEverything will be wiped including your tooltip options and frame layout.\n\nAs a precaution, you need to hold down CTRL and SHIFT while clicking this button in order for it to work.")
	LeaPlusCB["WipeAllButton"]:Hide();
	LeaPlusCB["WipeAllButton"]:SetScript("OnClick", function()
		if IsShiftKeyDown() and IsControlKeyDown() then
			if LeaPlusLC:PlayerInCombat() then
				return
			else
				-- PlayerFrame:SetUserPlaced(false);
				-- TargetFrame:SetUserPlaced(false);
				wipe(LeaPlusDB)
				wipe(LeaPlusLC)
				ReloadUI();
			end
		else
			LeaPlusLC:Print("You need to hold down CTRL and SHIFT while clicking this button.")
		end
	end)

	-- Reset tooltip button
	LeaPlusLC:CreateButton("ResetTooltipButton", LeaPlusLC["PageF"], "Reset", "BOTTOMLEFT", 90, 10, 70, 25, "Click to reset the tooltip location.")
	LeaPlusCB["ResetTooltipButton"]:Hide();

	-- Move tooltip button
	LeaPlusLC:CreateButton("MoveTooltipButton", LeaPlusLC["PageF"], "Move", "BOTTOMLEFT", 170, 10, 70, 25, "Click to unlock your tooltip.\n\nDrag the tooltip frame to your desired location then right-click it to finish.")
	LeaPlusCB["MoveTooltipButton"]:Hide();

	-- Reload UI Button
	LeaPlusLC:CreateButton("ReloadUIButton", LeaPlusLC["PageF"], "Reload", "BOTTOMLEFT", 330, 10, 70, 25,"Your UI needs to be reloaded for some of the changes to take effect.")
	LeaPlusCB["ReloadUIButton"]:Show();
	LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"],true)
	LeaPlusCB["ReloadUIButton"]:SetScript("OnClick", function()
		if LeaPlusLC:PlayerInCombat() then
			return
		else
			ReloadUI();
		end
	end)

	-- Reset frames button
	LeaPlusLC:CreateButton("ResetFramesButton", LeaPlusLC["PageF"], "Reset", "BOTTOMLEFT", 90, 10, 70, 25,"Click to reset frames back to their default positions.")
	LeaPlusCB["ResetFramesButton"]:Hide();

	-- Modify frames button
	LeaPlusLC:CreateButton("MoveFramesButton", LeaPlusLC["PageF"], "Move", "BOTTOMLEFT", 170, 10, 70, 25,"Click to unlock your frames.\n\nDrag the frames to your desired location then right-click any frame to finish.")
	LeaPlusCB["MoveFramesButton"]:Hide();

	-- Refresh frames button
	LeaPlusLC:CreateButton("RefreshFramesButton", LeaPlusLC["PageF"], "Refresh", "BOTTOMLEFT", 250, 10, 70, 25,"Click to refresh your frames.\n\nThis will set them to the positions you last dragged them to.")
	LeaPlusCB["RefreshFramesButton"]:Hide();

	-- Page Back Button
	LeaPlusLC:CreateButton("PageBackButton", LeaPlusLC["PageF"], "<<", "BOTTOMLEFT",410, 10, 70, 25,"Previous page")
	LeaPlusCB["PageBackButton"]:SetScript("OnClick", function()
		for i = 0,LeaPlusLC["NumberOfPages"] do
			if LeaPlusLC["Page"..i]:IsShown() then
				LeaPlusLC:HideFrames();
				if i > 1 then
					LeaPlusLC["Page"..i - 1]:Show();
					PageF:Show();
					LeaPlusLC["LeaStartPage"] = i - 1
					return
				else
					LeaPlusLC["Page"..LeaPlusLC["NumberOfPages"]]:Show();
					PageF:Show();
					LeaPlusLC["LeaStartPage"] = LeaPlusLC["NumberOfPages"]
					return
				end
			end
		end
	end)

	-- Page Forward Button
	LeaPlusLC:CreateButton("PageForwardButton", LeaPlusLC["PageF"], ">>", "BOTTOMLEFT", 490, 10, 70, 25,"Next page")
	LeaPlusCB["PageForwardButton"]:SetScript("OnClick", function()
		for i = 0,LeaPlusLC["NumberOfPages"] do
			if	LeaPlusLC["Page"..i]:IsShown() then
				LeaPlusLC:HideFrames();
				if i < LeaPlusLC["NumberOfPages"] then
					LeaPlusLC["Page"..i + 1]:Show();
					LeaPlusLC["PageF"]:Show();
					LeaPlusLC["LeaStartPage"] = i + 1
					return
				else
					LeaPlusLC["Page1"]:Show();
					LeaPlusLC["PageF"]:Show();
					LeaPlusLC["LeaStartPage"] = 1
					return
				end
			end
		end
	end)

	-- Close Button
	LeaPlusLC:MakeCL("CloseOptionsButton", LeaPlusLC["PageF"], "TOPRIGHT", 0, 0, 30, 30, "Close the options panel")
	LeaPlusCB["CloseOptionsButton"]:SetScript("OnClick", function() 
		LeaPlusLC:HideFrames();
	end)

----------------------------------------------------------------------
-- 	L51: Create option pages
----------------------------------------------------------------------

	LeaPlusLC["Page0"] = 	LeaPlusLC:MakePage("Page0"	, 	"Welcome, " .. LeaPlusLC["PlayerName"])
	LeaPlusLC["Page1"] = 	LeaPlusLC:MakePage("Page1"	,	"Automation"	,	"LeaPlusNav1"	,	"- Automation"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -92, 112, 20)
	LeaPlusLC["Page2"] = 	LeaPlusLC:MakePage("Page2"	, 	"Interaction"	, 	"LeaPlusNav2"	, 	"- Interaction"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -112, 112, 20)
	LeaPlusLC["Page3"] = 	LeaPlusLC:MakePage("Page3"	, 	"Chat"			, 	"LeaPlusNav3"	,	"- Chat"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -132, 112, 20)
	LeaPlusLC["Page4"] = 	LeaPlusLC:MakePage("Page4"	, 	"Text"			, 	"LeaPlusNav4"	,	"- Text"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -152, 112, 20)
	LeaPlusLC["Page5"] = 	LeaPlusLC:MakePage("Page5"	, 	"Tooltip"		, 	"LeaPlusNav5"	, 	"- Tooltip"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -172, 112, 20)
	LeaPlusLC["Page6"] = 	LeaPlusLC:MakePage("Page6"	, 	"Frames"		, 	"LeaPlusNav6"	, 	"- Frames"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -192, 112, 20)
	LeaPlusLC["Page7"] = 	LeaPlusLC:MakePage("Page7"	, 	"Miscellaneous"	, 	"LeaPlusNav7"	, 	"- Misc"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -212, 112, 20)
	LeaPlusLC["Page8"] = 	LeaPlusLC:MakePage("Page8"	, 	"Settings"		, 	"LeaPlusNav8"	, 	"- Settings"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -232, 112, 20)

----------------------------------------------------------------------
-- 	L50: Page 0 - Welcome
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page0"], "Welcome to Leatrix Plus.", 146, -72);
	LeaPlusLC:MakeWD(LeaPlusLC["Page0"], "To begin, choose an options page.", 146, -92);

----------------------------------------------------------------------
-- 	L61: Page 1: Automation
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page1"], "Party Automation"		, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "AcceptPartyFriends"		, 	"Party from friends"			, 	146, -92, 	"If checked, party invitations from friends will be automatically accepted unless you are queued in Dungeon Finder.  This includes Real ID friends.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "AutoConfirmRole"			, 	"Dungeon groups"				,	146, -112, 	"If checked, role checks for dungeon groups will be accepted automatically if the party leader is in your friends list.  This includes Real ID friends.\n\nEnabling this option does not port you into the dungeon automatically.\n\nThis option requires that you select a role for your character in the Dungeon Finder window.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "InviteFromWhisper"		, 	"Invite from whispers"			, 	146, -132, 	"If checked, when someone whispers 'plusinvite' to you they will be automatically invited to a group with you.\n\nYou need to be either ungrouped or party leader in your own group for this to work.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page1"], "Death Automation"			, 	146, -172);
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "AutoReleaseInBG"			,	"Release in battlegrounds"		, 	146, -192, 	"If checked, you will release automatically after you die in a battleground unless you are protected by a soulstone.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "AutoAcceptRes"			,	"Accept resurrect"				, 	146, -212, 	"If checked, resurrection attempts cast on you will be automatically accepted.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "NoAutoResInCombat"		,	"Exclude combat res"			, 	166, -232, 	"If checked, resurrection attempts cast on you will not be automatically accepted if the player resurrecting you is in combat.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "AutoAcceptSummon"			,	"Accept summon"					, 	146, -252, 	"If checked, summon requests will be accepted automatically unless you are in combat.")


	LeaPlusLC:MakeTx(LeaPlusLC["Page1"], "Blockers"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "NoDuelRequests"			, 	"Block duels"					,	340, -92, 	"If checked, duel requests will be blocked unless the player requesting the duel is in your friends list.  This includes Real ID friends.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "NoPartyInvites"			, 	"Block party invites"			, 	340, -112, 	"If checked, party invitations will be blocked unless the player inviting you is in your friends list.  This includes Real ID friends.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page1"], "Blizzard Blockers"		, 	340, -152);
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "ManageTradeGuild"			, 	"Manage blockers*"				, 	340, -172, 	"If checked, you will be able to enable or disable trade request.\n\nThis is a replacements for the Blizzard options panel settings to make them account-wide.\n\nEnabling this option will prevent you from changing the trade request in the Blizzard options panel.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "NoTradeRequests"			, 	"Block trades"					, 	360, -192, 	"If checked, trade requests will be blocked.")
	-- LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "NoGuildInvites"			,	"Block guild invites"			,	340, -212, 	"If checked, guild invitations and petitions will be blocked.\n\nIf you are in the process of making your own guild, you need to uncheck this box to see your own petition.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page1"], "BlockGuild"				,	"Block Guild Invites"			, 	360, -212, 	"If checked, guild invitations will be blocked.")

----------------------------------------------------------------------
-- 	L62: Page 2: Interaction
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page2"], "Quests"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "ShowQuestLevels"			,	"Show quest levels*"			,	146, -92, 	"If checked, quest levels will be shown in the quest log.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutoAcceptQuests"			, 	"Accept quests"					,	146, -112, 	"If checked, all quests will be accepted automatically.\n\nYou can hold the shift key down when you talk to a quest giver to over-ride this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AcceptOnlyDailys"			, 	"Restrict to dailies"			, 	166, -132, 	"If checked, only daily quests will be accepted automatically.\n\nYou can hold the shift key down when you talk to a quest giver to over-ride this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutoTurnInQuests"			,	"Turn-in quests"				,	146, -152, 	"If checked, quests will be turned-in automatically.\n\nYou can hold the shift key down when you talk to a quest giver to over-ride this setting.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page2"], "Quest Log Text Size"		, 	146, -192);
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "QuestFontChange"			,	"Resize quest log text*"		, 	146, -212, 	"If checked, quest log text will be resized according to the value set by the slider.\n\n* Requires UI reload.")
	LeaPlusLC:MakeSL(LeaPlusLC["Page2"], "LeaPlusQuestFontSize"		, 	"",	10, 36, 1, 170, -242, "%.0f")

	LeaPlusLC:MakeTx(LeaPlusLC["Page2"], "Vendors"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutoSellJunk"				,	"Sell junk automatically"		,	340, -92, 	"If checked, all grey items in your bags will be automatically sold when you visit a merchant.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutoRepairOwnFunds"		, 	"Automatically repair"			,	340, -112, 	"If checked, your armor will be automatically repaired when you visit a suitable merchant.")
	--3.3.5disabledbecauseOpenAllBagsNotWorkingWithDefaultBagsHOokLeaPlusLC:MakeCB(LeaPlusLC["Page2"], "NoBagAutomation"			, 	"Prevent bag automation*"		,	340, -132, 	"If checked, bags will not be opened and closed automatically when using a vendor or mailbox, allowing you to open and close them freely at your command.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AhExtras"					, 	"Auction house extras*"			, 	340, -152, 	"If checked, additional functionality will be added to the auction house frame.\n\nBuyout only - enables you to create buyout auctions without having to fill in the starting price boxes.\n\nIn addition, the duration dropdown setting will be saved account-wide.\n\n\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "FasterLooting"			, 	"Faster Looting*"				, 	340, -172, 	"If checked, your auto-looting will become much faster.\n\nIt additionaly hides loot window to make looting even faster, however you will be able to see it when your inventory is full or you looted with Modifier key (shift key default)\n\n\n\n* Requires UI reload.")


	LeaPlusLC:MakeTx(LeaPlusLC["Page2"], "Groups"					, 	340, -195);
	-- LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "NoRaidRestrictions"	, 	"Remove raid restrictions*"		,	340, -212, 	"If checked, your low level characters will be allowed to join raids.\n\nWhen combined with a free starter account, this option will allow you to create raid groups without requiring the help of another player.\n\nThis is useful if you wish to solo old raids but don't want to hassle another player to make a raid group with you.\n\nLeatrix Plus needs to be installed for the low level characters that you wish to make a raid group with.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "NoConfirmLoot"			, 	"Don't confirm loot rolls"		,	340, -212, 	"If checked, you will not be asked to confirm rolls on loot.\n\nThis includes need, greed, disenchant and soulbound confirmations.\n\nYou can hold the shift key down while looting to over-ride this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutomateGossip"			, 	"Automate Town NPCs Gossip"				,	340, -232, 	"If the gossip item type is banker, taxi, trainer, vendor or battlemaster, gossip will be skipped.|n|nYou can hold alt key to skip to gossip #2 (usually talent reset)\n\nYou can hold the shift key down to prevent this.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page2"], "AutomateGossipAll"		, 	"Always skip gossip with 1 option"				,	360, -252, 	"If checked, all the gossips with 1 option (mostly quest NPCs) will be skipped.  |n|nYou can hold the shift key down to prevent this.")

----------------------------------------------------------------------
-- 	L63: Page 3: Chat
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page3"], "Chat Frame"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "UseEasyChatResizing"		, 	"Use easy resizing*"			, 	146, -92, 	"If checked, dragging the General chat tab while the chat frame is locked will expand the chat frame upwards.  The general chat frame doesn't need to be showing to do this.\n\n\If the chat frame is unlocked, dragging the General chat tab will move the frame as normal.\n\nThis is a very useful option that enables you to quickly see more of the recent chat text when required (such as damage meters, loot rolls, etc).\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "NoCombatLogTab" 			, 	"Hide the combat log*"			, 	146, -112, 	"If checked, the combat log will be hidden.\n\nThis is useful if you never wish to use the combat log.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "NoChatButtons" 			, 	"Hide chat buttons*"			, 	146, -132, 	"If checked, chat frame buttons will be hidden and the chat frame will no longer be clamped to the screen.\n\nClicking chat tabs will automatically show the latest messages.\n\nYou can middle-click the General chat tab to show the hidden chat menu.\n\nYou can use the mouse wheel to scroll through the chat history.\n\nWhile scrolling, you can hold down SHIFT to scroll a page at a time or CTRL to jump to the top or bottom of your chat history.\n\nEnabling this option prevents you from changing the mouse wheel scroll setting, the whisper mode setting and the conversation mode setting in the Blizzard options.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "MoveChatEditBoxToTop" 	, 	"Move editbox to top*"			,	146, -152, 	"If checked, the editbox will be moved to the top of the chat frame.\n\nEnabling this option will set the Blizzard chat style to classic and prevent you from changing it.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page3"], "Mechanics"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "NoStickyChat"				, 	"Use classic chat*"				,	340, -92,	"If checked, you can press enter to talk in group chat using whatever method you used last (say, party, guild, etc).\n\nTo reply to whispers, press r as normal.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "UseArrowKeysInChat"		, 	"Use arrow keys in chat*"		, 	340, -112, 	"If checked, you can press the arrow keys to move your insertion point left and right in the chat frame.\n\nIf unchecked, the arrow keys will use the default keybind setting.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "NoChatFade"				, 	"Disable chat fade*"			, 	340, -132, 	"If checked, chat text will not fade out after a time period.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "ShowChatTimeStamps"		, 	"Show time stamps*"				, 	340, -152, 	"If checked, time stamps will be shown in the chat frame.\n\nThe time itself will be based on the server you're currently connected to (realm server, dungeon server, etc) and will be in 24 hour format.\n\nEnabling this option prevents you from changing the time stamps setting in the Blizzard options.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "MaxChatHstory"			,	"Increase chat history*"		, 	340, -172, 	"If checked, your chat history will increase to 4096 lines.  If unchecked, the default will be used (128 lines).\n\nEnabling this option may prevent some chat text from showing during login.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page3"], "Class Colors"				, 	340, -212);
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "Manageclasscolors"		, 	"Manage class colors*"			, 	340, -232, 	"If checked, you will be able to enable or disable class-coloring in the chat frame using the two settings below.  This is a replacement for the Blizzard options panel to make it simpler and account-wide.\n\nEnabling this option will prevent you from changing the class coloring options in the Blizzard chat options.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "ColorLocalChannels"		, 	"Local channel colors"			, 	360, -252, 	"If checked, names will be shown in class color in local channels (such as say, party, raid, etc).\n\nIf unchecked, names will be shown in normal chat color.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page3"], "ColorGlobalChannels"		, 	"Global channel colors"			,	360, -272, 	"If checked, names will be shown in class color in global channels (such as general, trade, etc).\n\nIf unchecked, names will be shown in normal chat color.")

----------------------------------------------------------------------
-- 	L64: Page 4: Text
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page4"], "Zone Text"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "HideZoneText"				,	"Hide zone text*"				,	146, -92, 	"If checked, zone text will not be shown (eg. 'Ironforge').\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "HideSubzoneText"			, 	"Hide subzone text*"			,	146, -112, 	"If checked, subzone text will not be shown (eg. 'Mystic Quarter').\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page4"], "Error Frame"				, 	146, -152);
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "HideErrorFrameText"		, 	"Hide error messages*"			,	146, -172, 	"If checked, error messages (eg. 'Not enough rage') will not be shown in the error frame.\n\nCertain important errors (such as Inventory full, quest log full and votekick errors) will be shown regardless of this setting.\n\nYou can also use /ltp toggle.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "ShowQuestUpdates"			, 	"Show quest updates"			, 	166, -192, 	"If checked, quest updates will be shown in the error frame.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page4"], "More Texts"				, 	146, -232);
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "HideHit"					, 	"Hide portrait hit indicators"	, 	146, -252, 	"Hides portrait hit and heal indicators for player and pet")


	LeaPlusLC:MakeTx(LeaPlusLC["Page4"], "Spam"						, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "NoSystemSpam"				, 	"Block system spam*"			, 	340, -92, 	"If checked, duel messages will be blocked unless you took part in the duel.\n\nDrunken state spam will be blocked unless it belongs to you.\n\nSpell spam caused by switching specs will be blocked.\n\nNPC spam will be blocked while your character is resting.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "NoInterruptSpam"			, 	"Hide interrupt messages*"		, 	340, -112, 	"If checked, messages will be blocked in party, raid, say and yell chat if they contain any of the words below" .. LeaPlusLC["InterruptSpamTip"] .. "\n\nThis only applies while you are inside an instance (of any type) and only while you are in combat.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "NoChannelsInDungeons"		, 	"Toggle General in dungeons*"	,	340, -132, 	"If checked, the General channel will be hidden while you are in a dungeon or raid and shown when you are not in a dungeon or raid.\n\nThis option has no effect if you are not a member of the General channel (such as if you used '/leave General').\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "ShortenChatChannels"		, 	"Use short channel names*"		, 	340, -152, 	"If checked, channel names in chat will be abbreviated.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page4"], "NoAnnounceInChat"			,	"Hide channel announcements*"	,	340, -172, 	"If checked, no channel announcements will be shown (such as changing zones).\n\n* Requires UI reload.")

----------------------------------------------------------------------
-- 	L66: Page 5: Tooltip
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page5"], "Tooltip Customisation"	, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipModEnable"				,	"Enable customisation*"			,	146, -92, 	"If checked, Leatrix Plus will manage the tooltip and you will be able to modify it using the checkboxes on this page.\n\nIf you wish to use another addon for tooltip customisation, leave this box unchecked.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page5"], "Tooltip Details"			, 	146, -132);
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowTitle"				, 	"Show title"					, 	146, -152, 	"If checked, the unit's title will be shown (if it's a player).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowRealm"				, 	"Show realm"					,	146, -172, 	"If checked, the unit's realm will be shown (if it's different from your own).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowRace"				, 	"Show race"						, 	146, -192, 	"If checked, the unit's race will be shown (if it's a player).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowClass"				, 	"Show class"					, 	146, -212, 	"If checked, the unit's class will be shown (if it's a player).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowRank"				, 	"Show guild rank"				, 	146, -232, 	"If checked, the unit's guild rank will be shown (if it's a player from your own guild).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowMobType"			, 	"Show creature type"			, 	146, -252, 	"If checked, the unit's creature type will be shown (such as 'Humanoid' or 'Beast').")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipShowTarget"			, 	"Show target of target"			, 	146, -272, 	"If checked, the target of the unit will be shown (in class color).")

	LeaPlusLC:MakeTx(LeaPlusLC["Page5"], "Backdrops"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipBackSimple"			, 	"Show color backdrops"			,	340, -92, 	"If checked, backdrops will be tinted blue (to indicate a friendly faction) or red (to indicate a hostile faction).")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipBackFriend"			, 	"Friendly class backdrop"		, 	340, -112, 	"If checked, friendly unit backdrops will be tinted with the target's class color.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipBackHostile"			,	 "Enemy class backdrop"			, 	340, -132, 	"If checked, hostile unit backdrops will be tinted with the target's class color.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page5"], "Tooltip Layout"			, 	340, -172);
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipHideInCombat"			, 	"Hide unit tooltips in combat"	,	340, -192, 	"If checked, tooltips will be hidden while you are in combat.  This does not apply to spell buttons or objects.\n\nYou can hold the shift key down during combat to over-ride this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipAnchorToMouse"			, 	"Anchor tooltip to cursor"		,	340, -212, 	"If checked, tooltips will be anchored to the cursor instead of a fixed point on the screen.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page5"], "TipScaleCheck"			, 	"Rescale the tooltip"			, 	340, -232, 	"If checked, tooltips will be rescaled to the value set by the slider.\n\nIf unchecked, the default value (1.00) will be used.")
	LeaPlusLC:MakeSL(LeaPlusLC["Page5"], "LeaPlusTipSize", "", 0.50, 3.00, 0.05, 364, -262, "%.2f")

	LeaPlusLC:AutoShowButtons("Page5", "ResetTooltipButton");
	LeaPlusLC:AutoShowButtons("Page5", "MoveTooltipButton");

	-- Lock tooltip move and reset buttons if tooltip customisation isn't enabled
	LeaPlusLC["Page5"]:HookScript("OnShow", function() 
		if LeaPlusLC["TipModEnable"] == "On" then
			LeaPlusLC:LockItem(LeaPlusCB["ResetTooltipButton"], false);
			LeaPlusLC:LockItem(LeaPlusCB["MoveTooltipButton"], false) 
		else
			LeaPlusLC:LockItem(LeaPlusCB["ResetTooltipButton"], true);
			LeaPlusLC:LockItem(LeaPlusCB["MoveTooltipButton"], true);
		end;
	end)

----------------------------------------------------------------------
-- 	L67: Page 6: Frames
----------------------------------------------------------------------

	--3.3.5 disabled  LeaPlusLC:MakeTx(LeaPlusLC["Page6"], "Frame Customisation"		, 	146, -72);
	--disabled in 3.3.5because needs fix LeaPlusLC:MakeCB(LeaPlusLC["Page6"], "FrmEnabled"				,	"Enable customisation*"			, 	146, -92, 	"If checked, Leatrix Plus will manage the positions of the player frame, target frame, world PvP state, ghost frame, timer bar, durability frame and alternative power bar.\n\nYou will be able to move these frames to your desired locations and your layout will be saved account-wide.\n\nIf you wish to use another addon for frame movement, leave this box unchecked.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page6"], "Frame Visibility"			, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page6"], "NoGryphons"				,	"Hide gryphons*"				, 	146, -92, 	"If checked, the Blizzard gryphons will not be shown either side of the main bar.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page6"], "NoClassBar"				,	"Hide class bar*"				, 	146, -112, 	"If checked, the class bar for Paladin, Warrior, Druid, Hunter and Death Knight will not be shown.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page6"], "NoBossFrames"				,	"Hide boss frames*"				,	146, -132, 	"If checked, boss frames will not be shown under the minimap.\n\n* Requires UI reload.")
	--3.3.5 disabled LeaPlusLC:MakeCB(LeaPlusLC["Page6"], "NoCharControls"			,	"Hide character controls*"		,	340, -152, 	"If checked, control buttons (such as zoom) will not be shown at the top of the character frame and dressup frame.\n\n* Requires UI reload.")

	LeaPlusLC:AutoShowButtons("Page6", "MoveFramesButton");
	LeaPlusLC:AutoShowButtons("Page6", "ResetFramesButton");
	LeaPlusLC:AutoShowButtons("Page6", "RefreshFramesButton");

----------------------------------------------------------------------
-- 	L65: Page 7: Miscellaneous
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page7"], "Minimap"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "UseMinimapClicks"			,	"Enable minimap clicks*"		,	146, -92, 	"If checked, you will be able to right-click the minimap to toggle the tracking menu and middle click to toggle the calendar.  The corresponding minimap buttons will be hidden.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "MinimapMouseZoom"			,	"Use scrollwheel zoom*"			,	146, -112, 	"If checked, the minimap zoom buttons will be hidden and you will be able to use the scrollwheel to zoom in and out.\n\n* Requires UI reload.")
	--LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "MinmapHideTime"			,	"Hide the time*"				,	146, -132, 	"If checked, the time will not be shown under the minimap.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page7"], "Graphics"					, 	146, -172);
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "NoDeathEffect"			, 	"Hide death effect"				, 	146, -192, 	"If checked, the death effect will not be shown.\n\nThis is the grey screen glow that appears while your character is a ghost.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "NoSpecialEffects"			, 	"Hide special effects"			, 	146, -212, 	"If checked, the netherworld effect (such as mage Invisibility) and special effects (such as the mist in Borean Tundra) will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "NoGlowEffect"				, 	"Remove screen glow"			, 	146, -232, 	"If checked, the screen glow will not be shown.\n\nThis is useful if you find the screen to be too bright.\n\nIt also has a handy side effect in that it blocks the blurry haze effect while your character is drunk.\n\nEnabling this option may increase your overall graphics performance.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "MaxZoomOutLevel"			, 	"Maximum zoom"					,	146, -252, 	"If checked, you will be able to zoom out to a greater distance.\n\nThis can help with lots of encounters where you need to see more of the area around you.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page7"], "Controls"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowVanityButtons"		,	"Show vanity controls*"			, 	340, -92, 	"If checked, two buttons will be added to the character sheet to allow you to toggle your helm and cloak easily.\n\nThese checkboxes are not clickable while your character is dead.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "DungeonFinderButtons"		, 	"Show dungeon buttons*"			,	340, -112, 	"If checked, a time button will be shown in the Dungeon Finder frame which will toggle your random dungeon cooldown.\n\nA checkbox will also be available next to it.  If checked, target markers placed on your character will be automatically removed.\n\n* Requires UI reload.")
	-- LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowClassIcons"			, 	"Show class icons*"				, 	340, -132, 	"If checked, class specific icons will be shown above the target frame while the following spells are active.\n\nHunter - Mend Pet, Focus Fire\nDruid - Predator's Swiftness\n\nMake sure that you are not showing normal buffs on top of the target frame else you won't see them (right-click the target frame, click Move Frame then uncheck 'Buffs On Top').\n\n* Requires UI reload only if logged in as one of the classes above.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowHonorStat"			,	"Show honorable kills*"			, 	340, -152, 	"If checked, the total number of lifetime honorable kills for your character will be shown in the tooltip for the honor points icon (shown at the top of the honor window).\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowVolume"				, 	"Show volume control*"			, 	340, -172, 	"If checked, a master volume slider will be shown in the character sheet.\n\n* Requires UI reload.")
	--LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowDressTab"				, 	"Show dressup button*"			, 	340, -192, 	"If checked, a button will be added to the dressup frame which will allow you to hide your tabard.\n\n* Requires UI reload.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page7"], "Fun Stuff"				, 	340, -232);
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowElitePlayerChain"		, 	"Show player chain*"			,	340, -252, 	"If checked, your player portrait will have an elite gold chain around it.\n\n* Requires UI reload.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page7"], "ShowRarePlayerChain"		, 	"Make it silver*"				,	360, -272, 	"If checked, the player chain will be silver instead of gold.\n\n* Requires UI reload.")

----------------------------------------------------------------------
-- 	L5H: Settings
----------------------------------------------------------------------

	LeaPlusLC:MakeTx(LeaPlusLC["Page8"], "Settings"					, 146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "ShowMinimapIcon"			, "Show minimap button"			, 146, -92, 	"If checked, a minimap button will be available.\n\nLeft or Right-clicking it will launch the options panel.\n\n Middle-clicking it will toggle the Recount window if you have Recount installed.\n\nHolding down shift and clicking it will Reload UI")
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "PlusShowTips"				, "Show tooltips"					, 146, -112, 	"If checked, tooltips will be shown for all of the checkboxes and buttons in Leatrix Plus.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "ShowBackground"			, "Show background"					, 146, -132, 	"If checked, the options panel background image will be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "OpenPlusAtHome"			, "Show home on startup"			, 146, -152, 	"If checked, the home page will always be shown when you open Leatrix Plus.\n\nIf unchecked, Leatrix Plus will open with the page that you were on when you last closed it.")

	LeaPlusLC:MakeTx(LeaPlusLC["Page8"], "Panel Alpha"				, 340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "PlusPanelAlphaCheck"		, "Modify panel alpha"				, 340, -92, 	"If checked, you will be able to change the alpha (transparency) of the options panel.  If unchecked, the normal alpha will be used.")
	LeaPlusLC:MakeSL(LeaPlusLC["Page8"], "LeaPlusAlphaValue"		, "", 0.0, 1.0, 0.1, 364, -122, "%.1f")

	LeaPlusLC:MakeTx(LeaPlusLC["Page8"], "Panel Scale"				, 340, -162);
	LeaPlusLC:MakeCB(LeaPlusLC["Page8"], "PlusPanelScaleCheck"		, "Modify panel scale"				, 340, -182, 	"If checked, you will be able to change the scale of the options panel.  If unchecked, the normal scale will be used.")
	LeaPlusLC:MakeSL(LeaPlusLC["Page8"], "LeaPlusScaleValue"		, "", 0.5, 1.7, 0.1, 364, -212, "%.1f")

	LeaPlusLC:AutoShowButtons("Page8", "SetDefaultsButton");
	LeaPlusLC:AutoShowButtons("Page8", "WipeAllButton");

----------------------------------------------------------------------
-- 	Page navigation mechanism
----------------------------------------------------------------------

	for i = 1, LeaPlusLC["NumberOfPages"] do
		LeaPlusLC["LeaPlusNav"..i]:SetScript("OnClick", function()
			LeaPlusLC:HideFrames()
			LeaPlusLC["PageF"]:Show();
			LeaPlusLC["Page"..i]:Show();
			LeaPlusLC["LeaStartPage"] = i
		end)
	end
