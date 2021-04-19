/*  !!! BookReadState_<item_name> instead !!!
quest function NTR_BookReadChecker(bookName : name, factName : string) : bool {
	var books : array<SItemUniqueId>;
	books = thePlayer.inv.GetItemsByName(bookName);
	if ( books.Size() >= 1 && thePlayer.inv.IsBookRead(books[0]) ) {
		return true;
	}
	return false;
}*/
quest function NTR_UndressGeralt() {
	var excludedItems : array <SItemNameProperty>;

	UnequipPlayerItemsQuest(1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, excludedItems, 0, 0, 0);
}

/*exec function getA() {
	NTR_notify("mq7006_wisdom = " + FactsQuerySum("mq7006_wisdom"));
	NTR_notify("mq7006_wisdom_added_gor_a_10 = " + FactsQuerySum("mq7006_wisdom_added_gor_a_10"));
	NTR_notify("poi_gor_a_10_candle_ignited = " + FactsQuerySum("poi_gor_a_10_candle_ignited"));
	NTR_notify("poi_gor_a_10_opened = " + FactsQuerySum("poi_gor_a_10_opened"));
	NTR_notify("poi_gor_a_10_wisdom_fail = " + FactsQuerySum("poi_gor_a_10_wisdom_fail"));
	NTR_notify("poi_gor_a_10_puzzle_done = " + FactsQuerySum("poi_gor_a_10_puzzle_done"));
}

exec function NTR_Flow( val : int ) {
	switch (val) {
		case 1:
			FactsAdd( "ntr_flowdebug_1", 1 );
			break;
		case 2:
			FactsAdd( "ntr_flowdebug_2", 1 );
			break;
		case 3:
			FactsAdd( "ntr_flowdebug_3", 1 );
			break;
	}
}*/

exec function NTR_FixBaron() {
	FactsAdd("ntr_fix_baron", 1);
	NTR_notify("Fixing Baron..");
}

quest function NTR_DebugWarning(str : String) {
	theGame.GetGuiManager().ShowNotification(str);
}

latent quest function NTR_Wait(seconds : float) {
	Sleep(seconds);
}

latent quest function NTR_Halfsec() {
	Sleep(0.5f);
	return;
}

quest function NTR_SwitchEncounter(tag : name, enable: bool) {
	var encounter : CEncounter;
	encounter = (CEncounter)theGame.GetEntityByTag( tag ); // shop_20_fishermans_hut_alchemist_enc
	if (encounter) {
		encounter.EnableEncounter(enable);
		NTR_notify("[Info] switch encounter <" + tag + "> to: " + enable);
		if (!enable) {
			encounter.ForceDespawnDetached();
			// or encounter.LeaveArea() ?
		} else {
			encounter.EnterArea();
		}
	}
}

latent quest function NTR_ShowCredits(effectName : name, destoy : Bool) {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var          logo : CEntity;
	var        result : Bool;
	
	logo = theGame.GetEntityByTag('ntr_logo_credits');
	if (destoy) {
		if (logo) {
			logo.Destroy();
		}
		return;
	}
	if (!logo) {
		template = (CEntityTemplate)LoadResourceAsync("dlc/dlcntr/data/entities/ntr_logo_entity.w2ent", true);
		pos = thePlayer.GetWorldPosition();
		logo = (CEntity)theGame.CreateEntity(template, pos);
		logo.AddTag('ntr_logo_credits');
		result = logo.CreateAttachment(thePlayer, 'r_weapon', Vector(0, 0, 0), EulerAngles(0, 0, 0));
	}

	logo.StopAllEffects();
	logo.PlayEffect(effectName);
}

quest function NTR_FixCampHorses() {
	NTR_teleportToNode('ntr_camp_horse1', 'ntr_bob_horse1_parked_ap', true);
	NTR_teleportToNode('ntr_camp_horse2', 'ntr_bob_horse2_parked_ap', true);
	NTR_teleportToNode('ntr_camp_horse3', 'ntr_bob_horse3_parked_ap', true);
	NTR_teleportToNode('ntr_camp_horse_baron', 'ntr_bob_horse_baron_parked_ap', true);
}

quest function NTR_HasItem(itemName : name) : Bool {
	var quantity : int;

	quantity = GetWitcherPlayer().GetInventory().GetItemQuantityByName(itemName);
	return (quantity >= 1);
}

quest function NTR_IsContainersEmpty(tag : name) : Bool {
	var entities : array<CEntity>;
	var container : W3Container;
	var i : int;

	theGame.GetEntitiesByTag(tag, entities);
	
	for (i = 0; i < entities.Size(); i += 1) {
		container = (W3Container) entities[i];
		if ( container && !container.IsEmpty() ) {
			return false;
		}
	}

	return true;
}

quest function NTR_IsTimeRange(hours1 : int, minutes1 : int, hours2 : int, minutes2 : int) : Bool {
	var gameTime		: GameTime;
	var minutes : int;

	gameTime = theGame.GetGameTime();
	minutes = GameTimeHours( gameTime ) * 60 + GameTimeMinutes( gameTime );

	//NTR_notify("game minutes = " + minutes);

	return (hours1 * 60 + minutes1 <= minutes && minutes <= hours2 * 60 + minutes2);
}

function NTR_LocStringSupported(s : String) : bool {
	return StrLen(s) > 0;
}
quest function NTR_CheckQuestConditions() {
	var popup : CNTRPopupRequest;
	var message, locString, locString2 : String;
	var conditionIdx : int;
	var selectedSpeech : String;
	var selectedText   : String;
	
	conditionIdx = 0;
	FactsSet("ntr_quest_lang_allowed", 0);
	message = "";
	theGame.GetGameLanguageName( selectedSpeech, selectedText );

	if ( selectedSpeech != "EN" ) {
		conditionIdx += 1;
		locString = GetLocStringByKeyExt("ntr_language_unsupported");
		if ( !NTR_LocStringSupported(locString) ) {
			locString = "You are using unsupported";
		}
		locString2 = GetLocStringByKeyExt("ntr_speech_unsupported");
		if ( !NTR_LocStringSupported(locString2) ) {
			locString2 = "lanaguage for speech.<br>It is STRONGLY recommended to change it to [EN], otherwise you will have MUTED scenes with JERKED animations and WITHOUT lipsync!!<br><br>";
		}
		message += conditionIdx + ") " + locString  + " [" + selectedSpeech + "] " + locString2;
	}

	// barely
	if ( StrFindFirst(GetLocStringByKeyExt("ntr_language_check"), "1") < 0 ) {
		conditionIdx += 1;
		message += conditionIdx + ") You are using unsupported [" + selectedText + "] lanaguage for text.<br>It is STRONGLY recommended to change it to [EN], otherwise you will have MISSED text in scenes!<br><br>";
	}
	if (FactsQuerySum("q704_orianas_part_done") < 1) {
		conditionIdx += 1;
		locString = GetLocStringByKeyExt("ntr_plot_unsupported");
		if ( !NTR_LocStringSupported(locString) ) {
			locString = "You did not passed 'Blood Simple' Orianna's quest (Unseen Elder path) in Blood and Wine DLC.<br>It is recommended to play (or watch) it before starting this quest to avoid spoilers and misunderstandings!<br><br>";
		}
		message += conditionIdx + ") " + locString;
	}

	if (message != "") {
		locString = GetLocStringByKeyExt("ntr_unsupported_action1");
		if ( !NTR_LocStringSupported(locString) ) {
			locString = "* If you are not ready press ESCAPE and return here next night.<br>";
		}
		message += locString;

		locString = GetLocStringByKeyExt("ntr_unsupported_action2");
		if ( !NTR_LocStringSupported(locString) ) {
			locString = "* If you want to proceed anyway press OK but you WERE WARNED!<br>";
		}
		message += locString;
		//?popup = new CNTRPopupRequest in thePlayer;
		locString2 = GetLocStringByKeyExt("ntr_language_unsupported_title");
		if ( !NTR_LocStringSupported(locString2) ) {
			locString2 = "WARNING!";
		}

		
		// for next night
		theGame.SetGameTime( theGame.GetGameTime() + GameTimeCreate(0, 2, 2, 0), true);
		popup = new CNTRPopupRequest in thePlayer;
		popup.open(locString2, message, true, "ntr_quest_allowed");
	} else {
		FactsAdd("ntr_quest_allowed", 1);
	}	
}

quest function NTR_GiveRewardToPlayer( rewardName : name )
{
	theGame.GiveReward( rewardName, thePlayer );
}

quest function NTR_ForceKillNPC(tag : name, playDeath : bool) {
	var npcs : array<CNewNPC>;
	var NTR_npc : CNTRCommonNPC;
	var i : int;

	theGame.GetNPCsByTag(tag, npcs);
	for (i = 0; i < npcs.Size(); i += 1) {
		NTR_notify("NTR_ForceKillNPC: " + npcs[i]);
		NTR_npc = (CNTRCommonNPC) npcs[i];
		if (NTR_npc) {
			NTR_npc.NTR_avoidDeathEvent = false;
		}
		if (!playDeath) {
			npcs[i].EnterKnockedUnconscious();
			// will call DisableDeathAndAgony();
		}
		npcs[i].Kill( 'Kill', true );
	}
}

quest function NTR_RemoveAttachment_Q( id : int ) {
	var attachmentTag : name;
	var entities      : array<CEntity>;
	var        i      : int;

	switch (id) {
		case 1: // bruxa bow 1
			attachmentTag = 'ntr_bruxa_arrow1';
			break;
		case 2: // bruxa bow 2 heart
			attachmentTag = 'ntr_bruxa_arrow2';
			break;
		case 3:
			attachmentTag = 'ntr_geralt_letter_stamped';
			break;
		case 4:
			attachmentTag = 'ntr_orianna_letter_opened';
			break;
		case 5:
			attachmentTag = 'ntr_geralt_orianna_diary';
			break;
	}

	theGame.GetEntitiesByTag(attachmentTag, entities);
	for (i = 0; i < entities.Size(); i += 1) {
		entities[i].Destroy();
	}
}

quest function NTR_CreateAttachment_Q( id : int ) {
	var template                 : CEntityTemplate;
	var entity, attachment       : CEntity;
	var entityTag, attachmentTag : name;
	var slotName                 : name;
	var relativePosition         : Vector;
	var relativeRotation         : EulerAngles;
	var result                   : Bool;

	switch (id) {
		case 1: // bruxa bow 1
			entityTag = 'ntr_orianna_bruxa';
			attachmentTag = 'ntr_bruxa_arrow1';
			template = (CEntityTemplate)LoadResource("items/weapons/projectiles/arrows/bolt_01.w2ent", true);

			slotName = 'blood_point';
			relativePosition = Vector(0.05, 0.1, 0);
			relativeRotation = EulerAngles(0, 200, 0);
			break;

		case 2: // bruxa bow 2 heart
			entityTag = 'ntr_orianna_bruxa';
			attachmentTag = 'ntr_bruxa_arrow2';
			template = (CEntityTemplate)LoadResource("items/weapons/projectiles/arrows/bolt_01.w2ent", true);
			
			slotName = 'blood_point';
			relativePosition = Vector(0.05, 0.03, 0.07);
			relativeRotation = EulerAngles(-5, 210, 0);
			break;
		case 3:
			entityTag = 'PLAYER';
			attachmentTag = 'ntr_geralt_letter_stamped';
			template = (CEntityTemplate)LoadResource("dlc\bob\data\items\quest_items\q705\q705_item__assasination_letter_closed_small.w2ent", true);

			slotName = 'r_weapon';
			relativePosition = Vector(0.03, 0.01, 0.05);
			relativeRotation = EulerAngles(100.0, 0.0, 0.0);
			break;
		case 4:
			entityTag = 'ntr_orianna_human';
			attachmentTag = 'ntr_orianna_letter_opened';
			template = (CEntityTemplate)LoadResource("dlc\bob\data\items\quest_items\q705\q705_item__comercial_poster_stamped.w2ent", true);

			slotName = 'r_weapon';
			relativePosition = Vector(0.22, 0.08, 0.0);
			relativeRotation = EulerAngles(0, 120, 90);
			break;
		case 5:
			entityTag = 'PLAYER';
			attachmentTag = 'ntr_geralt_orianna_diary';
			template = (CEntityTemplate)LoadResource("dlc\dlcntr\data\entities\notebook_actor.w2ent", true);

			slotName = 'l_weapon';
			relativePosition = Vector(0, 0, 0);
			relativeRotation = EulerAngles(0, 0, 0);
			break;
	}
	attachment = theGame.CreateEntity(template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation());
	attachment.AddTag(attachmentTag);
	entity = theGame.GetEntityByTag(entityTag);
	if (!entity) {
		NTR_notify("NTR_CreateAttachment_Q: [ERROR] " + entityTag + " not found!");
	}
	result = attachment.CreateAttachment(entity, slotName, relativePosition, relativeRotation);
}

quest function NTR_releaseOriannaBruxa() {
	var npc : CNewNPC;

	npc = theGame.GetNPCByTag('ntr_orianna_bruxa');
	npc.SetAppearance('orianna_bruxa_human_bloody2');
	npc.TeleportWithRotation(Vector(-204.5, -597.8, 0.277527), EulerAngles(0.000000, -110.0, 0.000000));
	NTR_ForceKillNPC('ntr_orianna_bruxa', false);
	npc.TeleportWithRotation(Vector(-204.5, -597.8, 0.277527), EulerAngles(0.000000, -110.0, 0.000000));
}
quest function NTR_SaveLock(lock : bool) {
	var saveLockId : int;
	if (lock) {
		theGame.CreateNoSaveLock("NightToRemember", saveLockId, true, true);
		FactsSet("ntr_save_lock_id", saveLockId);
	} else if ( FactsDoesExist("ntr_save_lock_id") ) {
		saveLockId = FactsQuerySum("ntr_save_lock_id");
		theGame.ReleaseNoSaveLock( saveLockId );
	} else {
		NTR_notify("NTR_SaveLock: [ERROR] Save lock id wasn't set!");
	}
}
quest function NTR_SaveGame(type : string, slot : int) {
	switch (type) {
		case "SGT_QuickSave":
			theGame.SaveGame(SGT_QuickSave, slot);
			break;
		case "SGT_Manual":
			theGame.SaveGame(SGT_Manual, slot);
			break;
		case "SGT_ForcedCheckPoint":
			theGame.SaveGame(SGT_ForcedCheckPoint, slot);
			break;
		case "SGT_AutoSave":
			theGame.SaveGame(SGT_AutoSave, slot);
			break;
	}
}
quest function NTR_TuneOriannaBruxa() {
	var NPC    : CNewNPC;
	var level  : int;
	NPC = (CNewNPC)theGame.GetNPCByTag('ntr_orianna_bruxa');

	if (!NPC) {
		NTR_notify("NTR_TuneOriannaBruxa: [ERROR] Orianna bruxa entity was not found!");
	}

	level = GetWitcherPlayer().GetLevel() + 5;

	NPC.SetAppearance('bruxa_monster_gameplay');
	// OK - it will add MonsterLevelBonusArmored abls
	NPC.SetLevel(level);
	NPC.SetNPCType(ENGT_Enemy);
	NPC.SetHealthPerc( 0.5 );
}
quest function NTR_TuneOriannaVampire() {
	var NPC          : CNewNPC;
	var level, diff  : int;
	NPC = (CNewNPC)theGame.GetNPCByTag('ntr_orianna_vampire');

	if (!NPC) {
		NTR_notify("NTR_TuneOriannaVampire: [ERROR] Orianna vampire entity was not found!");
		return;
	}

	level = GetWitcherPlayer().GetLevel();

	NPC.SetAppearance('orianna_vampire');

	diff = level - NPC.GetLevel();
	NTR_notify("NTR_TuneOriannaVampire: [Info] diff = " + diff);
	if (diff > 0) {
		NPC.AddAbilityMultiple('ntr_mon_orianna_vampire_LevelBonus', diff);
	}

	NPC.SetNPCType(ENGT_Enemy);
}
quest function NTR_TuneBaronEdward() {
	var NPC          : CNewNPC;
	var level, diff  : int;
	NPC = (CNewNPC)theGame.GetNPCByTag('ntr_baron_edward');

	if (!NPC) {
		NTR_notify("NTR_TuneBaronEdward: [ERROR] Baron entity was not found!");
		return;
	}

	level = GetWitcherPlayer().GetLevel();

	diff = level - NPC.GetLevel();
	NTR_notify("NTR_TuneBaronEdward: [Info] diff = " + diff + "player="+GetWitcherPlayer().GetLevel()+", npc="+NPC.GetLevel());
	if (diff > 0) {
		NPC.AddAbilityMultiple('ntr_baron_edward_LevelBonus', diff);
	}

	NPC.SetNPCType(ENGT_Enemy);
}

quest function NTR_HideActorsFishermanScene() {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var onlyKillIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('PLAYER_horse');
    acceptedTags.PushBack('playerHorse');
    acceptedTags.PushBack('ntr_fisherman');
    acceptedVoicetags.PushBack('VAMPIRE DIVA');
    onlyKillIfHostile = false;

    NTR_HideActorsInRange(50.0, acceptedTags, acceptedVoicetags, onlyKillIfHostile);
}

quest function NTR_HideActorsHagScene() {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var onlyKillIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('PLAYER_horse');
    acceptedTags.PushBack('playerHorse');
    acceptedTags.PushBack('ntr_hag_intro');
    acceptedVoicetags.PushBack('CELINA MONSTER');
    onlyKillIfHostile = true;

    NTR_HideActorsInRange(50.0, acceptedTags, acceptedVoicetags, onlyKillIfHostile);
}

quest function NTR_HideActorsCampScene() {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var onlyKillIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('PLAYER_horse');
    acceptedTags.PushBack('playerHorse');
    acceptedTags.PushBack('ntr_camp_horses');
    acceptedTags.PushBack('ntr_camp_bandits');
    onlyKillIfHostile = true;

    NTR_HideActorsInRange(50.0, acceptedTags, acceptedVoicetags, onlyKillIfHostile);
}

quest function NTR_UnhideActorsInRange(range : float)  {
    var entities             : array<CGameplayEntity>;
    var actor                : CActor;
    var i, j, t, maxEntities : int;
    var tags                 : array<name>;
    var hidden               : bool;

    maxEntities = 1000;
    FindGameplayEntitiesInRange(entities, thePlayer, range, maxEntities);
            
    for (i = 0; i < entities.Size(); i += 1) {
        actor = (CActor)entities[i];
        if (actor) {
            //LogChannel('DEBUG', "actor " + actor);
            if (!actor.IsAlive()) {
            	//LogChannel('DEBUG', "* actor dead");
            	continue;
            }

            hidden = false;
            tags = actor.GetTags();

            for (t = 0; t < tags.Size(); t += 1) {
                //LogChannel('DEBUG', "> tag: " + tags[t]);
                if (tags[t] == 'ntr_hidden_actor') {
                    hidden = true;
                }
            }
            if (hidden) {
            	NTR_notify("UnhideInRange: UNHIDE " + actor);
            	actor.RemoveTag('ntr_hidden_actor');
            	actor.SetVisibility(true);
            	actor.SetGameplayVisibility(true);
            	actor.EnableCollisions(true);
            	actor.EnableStaticCollisions(true);
            	actor.EnableDynamicCollisions(true);
            	actor.EnableCharacterCollisions(true);
        	}
        }
        
    }

    NTR_notify("Done UnhideActorsInRange: " + range);
}

quest function NTR_FocusEffect( actionType : string, effectName : name, effectEntityTag : name, duration : float ) {
	switch(actionType) {
		case "FEAA_Enable":
			FocusEffect(FEAA_Enable, effectName, effectEntityTag, duration);
			break;
		case "FEAA_Disable":
			FocusEffect(FEAA_Disable, effectName, effectEntityTag, duration);
			break;
	}
}

quest function NTR_FadeOutQuest( fadeTime : float, r : int, g : int, b : int ) {
    FadeOutQuest( fadeTime, Color( r, g, b ) );
}

quest function NTR_FactChecker(factName : string, factCond : string, val : int) : bool {
	var factVal : int;
	var ret : bool;

	factVal = FactsQuerySum(factName);
	
	switch(factCond) {
		case "==":
			ret = (factVal == val);
			break;
		case "!=":
			ret = (factVal != val);
			break;
		case ">=":
			ret = (factVal >= val);
			break;
		case "<=":
			ret = (factVal <= val);
			break;
		case ">":
			ret = (factVal > val);
			break;
		case "<":
			ret = (factVal < val);
			break;
	}
	//NTR_notify("factVal = " + factVal + ", supposed val = " + val + ", ret=" + ret);
	return ret;
}

quest function NTR_SetMoneyNPC(tag : name, amount : int) {
	var inv : CInventoryComponent;
	var NPCs : array <CNewNPC>;
	var i      : int;
	
	theGame.GetNPCsByTag(tag, NPCs);

	for (i = 0; i < NPCs.Size(); i += 1 ) {
		inv = NPCs[i].GetInventory();
		inv.SetMoney( amount );
	}
}
quest function NTR_StealGeraltMoney(tag : name, amount : int) {
	if (amount < 0 || amount > thePlayer.inv.GetMoney()) {
		amount = thePlayer.inv.GetMoney();
	}
	if (amount > 0) {
		thePlayer.inv.RemoveMoney(amount);
		NTR_SetMoneyNPC(tag, amount);
		GetWitcherPlayer().DisplayHudMessage( GetLocStringByKeyExt("panel_hud_message_guards_took_money") );
	}
}
quest function NTR_ReturnGeraltMoney(tag : name) {
	var NPC : CNewNPC;
	var inv : CInventoryComponent;
	var amount : int;

	NPC = theGame.GetNPCByTag(tag);
	if (NPC) {
		inv = NPC.GetInventory();
		amount = inv.GetMoney();
		if (amount > 0) {
			inv.RemoveMoney( amount );
			thePlayer.inv.AddMoney( amount );
			thePlayer.DisplayItemRewardNotification('Crowns', amount);
		}
	}
}
quest function NTR_FistfightNPC(tag : name, activate : bool) {
	var NPCs : array <CNewNPC>;
	var i      : int;
	
	theGame.GetNPCsByTag(tag, NPCs);
	for (i = 0; i < NPCs.Size(); i += 1 )
	{	
		if (activate) {
			NPCs[i].OnStartFistfightMinigame();
		} else {
			NPCs[i].OnEndFistfightMinigame();
		}
	}
}

quest function NTR_FistfightPlayer(activate : bool, optional healthMultiplier : float, optional toDeath : bool, optional endsWithBS : bool) {
	if (activate) {
		if (!toDeath && !endsWithBS)
			thePlayer.SetFistFightParams(toDeath, endsWithBS);
		thePlayer.OnStartFistfightMinigame();
		if (healthMultiplier) {
			thePlayer.ClampGeraltMaxHealth( thePlayer.GetStatMax(BCS_Vitality) * healthMultiplier );
			thePlayer.SetHealthPerc( 100 );
		}
	} else {
		thePlayer.OnEndFistfightMinigame();
	}
}

quest function NTR_FocusSetHighlight(tag : name, highlightType : string, optional overrideCustomLogic : bool ) {
	switch(highlightType) {
		case "FMV_Clue":
			FocusSetHighlight(tag, FMV_Clue, overrideCustomLogic);
			break;
		case "FMV_Interactive":
			FocusSetHighlight(tag, FMV_Interactive, overrideCustomLogic);
			break;
		case "FMV_None":
			FocusSetHighlight(tag, FMV_None, overrideCustomLogic);
			break;
	}
}

// ----------------------------------------------------------------------------
quest function NTR_DoorChangeState(tag : name, newState : string, optional keyItemName : name, optional removeKeyOnUse : bool, optional smoooth : bool, optional dontBlockInCombat : bool ) {
	switch(newState) {
			case "EDQS_Open":
				DoorChangeState(tag, EDQS_Open, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;
			case "EDQS_Close":
				DoorChangeState(tag, EDQS_Close, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;
			case "EDQS_Enable":
				DoorChangeState(tag, EDQS_Enable, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;
			case "EDQS_Disable":
				DoorChangeState(tag, EDQS_Disable, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;
			case "EDQS_RemoveLock":
				DoorChangeState(tag, EDQS_RemoveLock, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;
			case "EDQS_Lock":
				DoorChangeState(tag, EDQS_Lock, keyItemName, removeKeyOnUse, smoooth, dontBlockInCombat);
				break;			
	}
}
// ----------------------------------------------------------------------------
quest function NTR_PlaySound( bankName : string, eventName : string, optional saveType : string ) {
	if ( !theSound.SoundIsBankLoaded(bankName) ) {
		theSound.SoundLoadBank(bankName, true);
		NTR_notify("NTR_PlaySound: [Warning] Bank <" + bankName + "> was not loaded!");
	}
	//NTR_notify("Play Sound: bnk [" + bankName + "], event [" + eventName + "]");

	switch (saveType) {
		case "SESB_Save":
			SoundEventQuest(eventName, SESB_Save);
			break;
		case "SESB_ClearSaved":
			SoundEventQuest(eventName, SESB_ClearSaved);
			break;
		default:
			SoundEventQuest(eventName, SESB_DontSave);
			break;
	}
}
// ----------------------------------------------------------------------------
/*
areaName = "novigrad", "skellige", "kaer_morhen", "prolog_village", 
	"wyzima_castle", "island_of_mist", "spiral", "no_mans_land", "toussaint" 
	(from which area you want to play music)
	NMLand = novigrad!!!
*/
quest function NTR_PlayMusic( areaName : string, eventName : string, optional saveType : string ) {
	if ( areaName == "toussaint" )
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
	else
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );

	switch (saveType) {
		case "SESB_Save":
			SoundEventQuest(eventName, SESB_Save);
			break;
		case "SESB_ClearSaved":
			SoundEventQuest(eventName, SESB_ClearSaved);
			break;
		default:
			SoundEventQuest(eventName, SESB_DontSave);
			break;
	}
}
// ----------------------------------------------------------------------------
quest function NTR_GameplayMusic( areaName : string ) 
{
	if ( areaName == "toussaint" ) {
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
		SoundEventQuest("mus_loc_toussaint_general_cs_to_gmpl", SESB_ClearSaved);
	} else {
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );
	}

}
// -------------------------------------------------------------------------------
quest function NTR_SetRelativeLevel( tag : name, levelBonus : int ) {
	var NPCs      : array <CNewNPC>;
	var i, level  : int;

	theGame.GetNPCsByTag(tag, NPCs);
	if (NPCs.Size() < 1) {
		NTR_notify("NTR_SetRelativeLevel [ERROR] No NPCs found with tag <" + tag + ">!");
		return;
	}
	level = GetWitcherPlayer().GetLevel() + levelBonus;
	if (level < 1)
		level = 1;

	for (i = 0; i < NPCs.Size(); i += 1 ) {	
		NPCs[i].SetLevel(level);
	}
}
// --------------not working !!! NPC.TeleportToNode( node, applyRotation );-------------------------
quest function NTR_teleportToNode( tag : CName, tagNode : CName, optional applyRotation : bool ) {	
	var NPC   : CNewNPC;
	var node   : CNode;
	var i      : int;
	var pos    : Vector;
	var rot    : EulerAngles;

	NPC = theGame.GetNPCByTag(tag);
	node = theGame.GetNodeByTag( tagNode );

	if (!NPC) {
		NTR_notify("NTR_teleportNPCs [ERROR] Entity <" + tag + "> not found!");
		return;
	}
	if (!node) {
		NTR_notify("NTR_teleportNPCs [ERROR] Node <" + tagNode + "> not found!");
		return;
	}

	pos = node.GetWorldPosition();
	rot = node.GetWorldRotation();
	if (applyRotation) {
		NPC.TeleportWithRotation(pos, rot);
	} else {
		NPC.Teleport(pos);
	}
}
// ------------------- preset values to teleport Triss in sphere during battle ---------------------------
latent quest function NTR_teleportTriss( tag : CName) {	
	var choose     : int;
	var scenePos   : Vector;
	var trissNPC   : CNewNPC;
	
	scenePos = Vector(24.4257621765, -2107.7331542969, 126.1453247070);
	choose = RandRange(9, 1);
	
	trissNPC = theGame.GetNPCByTag(tag);
	if (!trissNPC) {
		NTR_notify("NTR_teleportTriss [ERROR] Triss NPC not found! Requested tag <" + tag + ">");
	}
	trissNPC.ActionPlaySlotAnimationAsync( 'GAMEPLAY_SLOT', 'woman_sorceress_teleport_lp', 0.2, 0.2 );
	trissNPC.PlayEffect('teleport_out');
	Sleep(0.3);
	switch(choose) {
		case 2:
			trissNPC.Teleport( scenePos + Vector(-5.9914569855, 16.1965332031, -0.5803833008) );
			break;
		case 3:
			trissNPC.Teleport( scenePos + Vector(-6.1509609222, 20.0139160156, -0.7316284180) );
			break;
		case 4:
			trissNPC.Teleport( scenePos + Vector(-9.6709680557, 12.0175781250, -0.5446777344) );
			break;
		case 5:
			trissNPC.Teleport( scenePos + Vector(-12.9269695282, 11.5224609375, -0.5108032227) );
			break;
		case 6:
			trissNPC.Teleport( scenePos + Vector(-4.3029670715, 7.1501464844, -0.2921752930) );
			break;
		case 7:
			trissNPC.Teleport( scenePos + Vector(-4.5174674988, 3.7673339844, -0.2456665039) );
			break;
		case 8:
			trissNPC.Teleport( scenePos + Vector(-1.7179527283, 11.9348144531, -0.2318725586) );
			break;
		case 9:
			trissNPC.Teleport( scenePos + Vector(1.1750526428, 11.5986328125, -0.2404174805) );
			break;
		default:
			trissNPC.Teleport( scenePos + Vector(-5.9749526978, 11.5041503906, -0.4548339844) );
			break;
	}
	trissNPC.PlayEffect('teleport_in');
}

// -------------------------------------------------------------------------------
// Not good
quest function NTR_TuneNPC( tag : name, level : int, optional attitude : string, optional mortality : string, optional finishers : bool, optional npcGroupType : string, optional scale : float ) {
	var NPCs   : array <CNewNPC>;
	var i      : int;
	var meshh : CMovingPhysicalAgentComponent;
	var meshhs : array<CComponent>;
	var j : int;
	
	theGame.GetNPCsByTag(tag, NPCs);
	NTR_notify("TUNE npcs by tag <" + tag + ">: " + NPCs.Size());
	if (NPCs.Size() < 1) {
		//theGame.GetGuiManager().ShowNotification("[ERROR] No NPCs found with tag <" + tag + ">");
		NTR_notify("NTR_TuneNPC: [ERROR] No NPCs found with tag <" + tag + ">");
		return;
	}
	if (level > 500) {
		// 1005 = playerLvl + 5;
		// 995 = playerLvl - 5
		level = GetWitcherPlayer().GetLevel() + (level - 1000);
		if (level < 1)
			level = 1;
	}
	
	for (i = 0; i < NPCs.Size(); i += 1 )
	{	
		// SET LEVEL
		if (level > 0)
			NPCs[i].SetLevel(level);
		NPCs[i].RemoveAbilityAll('NPCDoNotGainBoost');
		NPCs[i].RemoveAbilityAll('NPCLevelBonusDeadly');
		NPCs[i].RemoveAbilityAll('VesemirDamage');
		NPCs[i].RemoveAbilityAll('BurnIgnore');
		NPCs[i].RemoveAbilityAll('_q403Follower');
		if (finishers) {
			NPCs[i].RemoveAbilityAll('DisableFinishers');
			NPCs[i].RemoveAbilityAll('InstantKillImmune');
		} else {
			NPCs[i].AddAbility( 'DisableFinishers', false );
			NPCs[i].AddAbility( 'InstantKillImmune', false );
		}
		
		// SET ATTITUDE TO PLAYER
		switch (attitude) {
			case "Friendly":
				NPCs[i].SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );
				NPCs[i].SetAttitude( thePlayer, AIA_Friendly );
				thePlayer.SetAttitude( NPCs[i], AIA_Friendly );
				break;
			case "Hostile":
				NPCs[i].SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
				NPCs[i].SetAttitude( thePlayer, AIA_Hostile );
				thePlayer.SetAttitude( NPCs[i], AIA_Hostile );
				break;
			case "Neutral":
				NPCs[i].SetTemporaryAttitudeGroup( 'neutral_to_player', AGP_Default );
				NPCs[i].SetAttitude( thePlayer, AIA_Neutral );
				thePlayer.SetAttitude( NPCs[i], AIA_Neutral );
				break;
		}
		
		// SET MORTALITY
		switch (mortality) {
			case "None":
				NPCs[i].SetImmortalityMode( AIM_None, AIC_Combat );
				NPCs[i].SetImmortalityMode( AIM_None, AIC_Default );
				NPCs[i].SetImmortalityMode( AIM_None, AIC_Fistfight );
				NPCs[i].SetImmortalityMode( AIM_None, AIC_IsAttackableByPlayer );
				break;
			case "Unconscious":
				NPCs[i].SetImmortalityMode( AIM_Unconscious, AIC_Combat );
				NPCs[i].SetImmortalityMode( AIM_Unconscious, AIC_Default );
				NPCs[i].SetImmortalityMode( AIM_Unconscious, AIC_Fistfight );
				NPCs[i].SetImmortalityMode( AIM_Unconscious, AIC_IsAttackableByPlayer );
				break;
			case "Invulnerable":
				NPCs[i].SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
				NPCs[i].SetImmortalityMode( AIM_Invulnerable, AIC_Default );
				NPCs[i].SetImmortalityMode( AIM_Invulnerable, AIC_Fistfight );
				NPCs[i].SetImmortalityMode( AIM_Invulnerable, AIC_IsAttackableByPlayer );
				break;
			case "Immortal":
				NPCs[i].SetImmortalityMode( AIM_Immortal, AIC_Combat );
				NPCs[i].SetImmortalityMode( AIM_Immortal, AIC_Default );
				NPCs[i].SetImmortalityMode( AIM_Immortal, AIC_Fistfight );
				NPCs[i].SetImmortalityMode( AIM_Immortal, AIC_IsAttackableByPlayer );
				break;
		}
		
		// SET NPC TYPE GROUP
		switch(npcGroupType) {
			case "ENGT_Commoner":
				NPCs[i].SetNPCType(ENGT_Commoner);
				break;
			case "ENGT_Guard":
				NPCs[i].SetNPCType(ENGT_Guard);
				break;
			case "ENGT_Quest":
				NPCs[i].SetNPCType(ENGT_Quest);
				break;
			case "ENGT_Enemy":
				NPCs[i].SetNPCType(ENGT_Enemy);
				break;
			
		}
		
		// SET SCALE (DANGER BUT FUNNY)
		if (scale > 0) {
			meshhs = NPCs[i].GetComponentsByClassName('CMovingPhysicalAgentComponent');

			for (j = 0; j < meshhs.Size(); j += 1) {
				meshh = (CMovingPhysicalAgentComponent)meshhs[j];
				if (meshh) {
					meshh.SetScale(Vector(scale, scale, scale));
				}
			}
		}
	}
}