quest function NTRBookReadChecker(bookName : name, factName : string) {
	var books : array<SItemUniqueId>;
	books = thePlayer.inv.GetItemsByName(bookName);
	if ( books.Size() >= 1 && thePlayer.inv.IsBookRead(books[0]) ) {
		FactsAdd(factName, 1);
	}
}

// ----------------------------------------------------------------------------
quest function NTRDoorChangeState(tag : name, newState : string, optional keyItemName : name, optional removeKeyOnUse : bool, optional smoooth : bool, optional dontBlockInCombat : bool ) {
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

/* !!! - better use vanilla
PlayEffectQuest ( entityTag : name, effectName : name, activate : bool, persistentEffect : bool, deactivateAll : bool, preventEffectStacking : bool )
*/
/*quest function NTRPlayEffect( tag : name, effect : name ) 
{
	var NPCs : array <CNewNPC>;
	var i      : int;
	
	theGame.GetNPCsByTag(tag, NPCs);
	LogQuest( "NTR <<Play effect>>: tag: " + tag + " found npcs: " + NPCs.Size());	
	for (i = 0; i < NPCs.Size(); i += 1 )
	{	
		NPCs[i].PlayEffect(effect);
	}
}*/
// ----------------------------------------------------------------------------
quest function NTRPlayMusic( areaName : string, eventName : string, optional saveType : string ) {
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
// -------------------------------------------------
exec function playMusic( areaName : string, eventName : string, optional saveType : string ) {
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
// -------------------------------------------------
exec function playSound( bankName : string, eventName : string ) {
	if (!theSound.SoundIsBankLoaded(bankName)) {
		theSound.SoundLoadBank(bankName, true);
	}
	thePlayer.SoundEvent(eventName);
}
// ----------------------------------------------------------------------------
quest function NTRGameplayMusic( areaName : string ) 
{
	if ( areaName == "toussaint" ) {
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
		SoundEventQuest("mus_loc_toussaint_general_cs_to_gmpl", SESB_ClearSaved);
	} else {
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );
		// todo
	}

}
// -------------------------------------------------------------------------------
quest function NTRTuneNPC( tag : name, level : int, optional attitude : string, optional mortality : string, optional finishers : bool, optional npcGroupType : string, optional scale : float ) {
	var NPCs   : array <CNewNPC>;
	var i      : int;
	var meshh : CMovingPhysicalAgentComponent;
	var meshhs : array<CComponent>;
	var j : int;
	
	theGame.GetNPCsByTag(tag, NPCs);
	//LogQuest( "<<Tune NPC>>> tag: " + tag + " found npcs: " + NPCs.Size());	//- uncomment it to check if NPCs are found
	//theGame.GetGuiManager().ShowNotification("Found npcs: " + NPCs.Size() + " nodes: " + nodes.Size());
	if (level > 500) {
		// 1005 = playerLvl + 5;
		// 995 = playerLvl - 5
		level = GetWitcherPlayer().GetLevel() + (level - 1000);
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
		if (finishers)
			NPCs[i].RemoveAbilityAll('DisableFinishers');
		else
			NPCs[i].AddAbility( 'DisableFinishers', false );
		
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

latent quest function NTR_teleportTriss( tag : CName) {	
	var choose : int;
	var trissNPC   : CNewNPC;
	
	choose = RandRange(9, 1);
	trissNPC = theGame.GetNPCByTag(tag);
	trissNPC.ActionPlaySlotAnimationAsync( 'GAMEPLAY_SLOT', 'woman_sorceress_teleport_lp', 0, 0 );
	//theGame.GetGuiManager().ShowNotification("Teleport " + tag + " to pos:" + choose);
	trissNPC.PlayEffect('teleport_out');
	Sleep(0.3);
	switch(choose) {
		case 2:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-5.9914569855, 16.1965332031, -0.5803833008) );
			break;
		case 3:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-6.1509609222, 20.0139160156, -0.7316284180) );
			break;
		case 4:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-9.6709680557, 12.0175781250, -0.5446777344) );
			break;
		case 5:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-12.9269695282, 11.5224609375, -0.5108032227) );
			break;
		case 6:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-4.3029670715, 7.1501464844, -0.2921752930) );
			break;
		case 7:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-4.5174674988, 3.7673339844, -0.2456665039) );
			break;
		case 8:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-1.7179527283, 11.9348144531, -0.2318725586) );
			break;
		case 9:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(1.1750526428, 11.5986328125, -0.2404174805) );
			break;
		default:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-5.9749526978, 11.5041503906, -0.4548339844) );
			break;
	}
	trissNPC.PlayEffect('teleport_in');
}
