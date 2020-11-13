/*  !!! BookReadState_<item_name> instead !!!
quest function NTR_BookReadChecker(bookName : name, factName : string) : bool {
	var books : array<SItemUniqueId>;
	books = thePlayer.inv.GetItemsByName(bookName);
	if ( books.Size() >= 1 && thePlayer.inv.IsBookRead(books[0]) ) {
		return true;
	}
	return false;
}*/

latent quest function NTR_Wait(seconds : float) {
	Sleep(seconds);
}

latent quest function NTR_Halfsec() {
	Sleep(0.5f);
	return;
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
		NTR_notify("Kill: " + npcs[i]);
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
		NTR_notify("ERROR! Save lock id wasn't set!");
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
latent quest function NTR_TuneOriannaBruxa() {
	var NPC    : CNewNPC;
	var level  : int;
	NPC = (CNewNPC)theGame.GetNPCByTag('ntr_orianna_bruxa');

	if (!NPC) {
		LogChannel('NTR_TuneOriannaBruxa', "ERROR! Orianna bruxa entity was not found!");
	}

	level = GetWitcherPlayer().GetLevel() + 5;

	NPC.SetAppearance('bruxa_monster_gameplay');
	NPC.SetLevel(level);
	/*NPC.SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
	NPC.SetAttitude( thePlayer, AIA_Hostile );
	thePlayer.SetAttitude( NPC, AIA_Hostile );*/

	NPC.SetImmortalityMode( AIM_None, AIC_Combat );
	NPC.SetImmortalityMode( AIM_None, AIC_Default );
	NPC.SetImmortalityMode( AIM_None, AIC_Fistfight );
	NPC.SetImmortalityMode( AIM_None, AIC_IsAttackableByPlayer );

	NPC.SetHealthPerc( 0.5 );

	NPC.SetNPCType(ENGT_Enemy);
}

quest function NTR_HideActorsFishermanScene() {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var killIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('ntr_fisherman');
    acceptedVoicetags.PushBack('VAMPIRE DIVA');
    killIfHostile = false;

    NTR_HideActorsInRange(30.0, acceptedTags, acceptedVoicetags, killIfHostile);
}

quest function NTR_HideActorsHagScene() {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var killIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('ntr_hag_intro');
    acceptedVoicetags.PushBack('CELINA MONSTER');
    killIfHostile = true;

    NTR_HideActorsInRange(20.0, acceptedTags, acceptedVoicetags, killIfHostile);
}

quest function NTR_UnhideActorsInRange(range : float)  {
    var entities             : array<CGameplayEntity>;
    var actor                : CActor;
    var i, j, t, maxEntities : int;
    var tags                 : array<name>;
    var hidden               : bool;

    range = 15.0;
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
            	LogChannel('UnhideInRange', "UNHIDE: " + actor);
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

    LogChannel('NTR', "Done UnhideActorsInRange: " + range);
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
	//theGame.GetGuiManager().ShowNotification("factVal = " + factVal + ", supposed val = " + val + ", ret=" + ret);
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
		NTR_notify("Bank [" + bankName + "] was not loaded!");
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
		//theGame.GetGuiManager().ShowNotification("[ERROR] No NPCs found with tag <" + tag + ">");
		LogChannel('NTR_SetRelativeLevel', "[ERROR] No NPCs found with tag <" + tag + ">");
		return;
	}
	level = GetWitcherPlayer().GetLevel() + levelBonus;
	if (level < 1)
		level = 1;

	for (i = 0; i < NPCs.Size(); i += 1 ) {	
		NPCs[i].SetLevel(level);
	}
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
	theGame.GetGuiManager().ShowNotification("TUNE npcs by tag <" + tag + ">: " + NPCs.Size());
	if (NPCs.Size() < 1) {
		//theGame.GetGuiManager().ShowNotification("[ERROR] No NPCs found with tag <" + tag + ">");
		LogChannel('NTR_TuneNPC', "[ERROR] No NPCs found with tag <" + tag + ">");
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
		/* SET LEVEL */
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
		
		/* SET ATTITUDE TO PLAYER */
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
		
		/* SET MORTALITY */
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
		
		/* SET NPC TYPE GROUP */
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
		
		/* SET SCALE (DANGER BUT FUNNY) */
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
		LogChannel('NTR_teleportNPCs', "[ERROR] Entity <" + tag + "> not found!");
		return;
	}
	if (!node) {
		LogChannel('NTR_teleportNPCs', "[ERROR] Node <" + tagNode + "> not found!");
		return;
	}

	pos = node.GetWorldPosition();
	rot = node.GetWorldRotation();
	if (applyRotation) {
		NPC.TeleportWithRotation(pos, rot);
	} else {
		NPC.Teleport(pos);
	}
	LogChannel('NTR_teleportNPCs', "[OK] Teleport npc <" + tag + "> to node <" + tagNode + ">");
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
		LogChannel('NTR_teleportTriss', "[ERROR] Triss NPC not found! Requested tag <" + tag + ">");
	}
	trissNPC.ActionPlaySlotAnimationAsync( 'GAMEPLAY_SLOT', 'woman_sorceress_teleport_lp', 0.1, 0.2 );
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
