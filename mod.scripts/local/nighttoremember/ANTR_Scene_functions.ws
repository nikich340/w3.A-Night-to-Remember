/*storyscene function NTR_TuneOriannaVampire_S( player : CStoryScenePlayer ) {
	NTR_TuneOriannaVampire();
}*/
latent storyscene function NTR_PlayMusicScene( player : CStoryScenePlayer, areaName : string, eventName : string, optional saveType : string, optional repeatDelay : float ) {
	NTR_PlayMusic(areaName, eventName, saveType);
	if (repeatDelay > 0.0f) {
		Sleep(repeatDelay);
		NTR_PlayMusic(areaName, eventName, saveType);
	}
}
storyscene function NTR_UnequipItemFromSlot_S( player : CStoryScenePlayer, tag : name, slotName : name  )
{
	var     npcs : array<CNewNPC>;
	var        i : int;
	var slotItem : SItemUniqueId;

	if (tag == 'PLAYER') {
		GetWitcherPlayer().UnequipItemFromSlot( SlotNameToEnum(slotName) );
	} else {
		theGame.GetNPCsByTag(tag, npcs);
		NTR_notify("Founds npcs: " + npcs.Size());
		for (i = 0; i < npcs.Size(); i += 1) {
			slotItem = npcs[i].GetInventory().GetItemFromSlot( slotName );
			//if ( npcs[i].GetInventory().IsIdValid(slotItem) ) {
			if ( npcs[i].UnequipItem( slotItem ) ) {
				NTR_notify("Unmount success!");
			} else {
				NTR_notify("Unmount not success!");
			}
		}
	}
}
storyscene function NTR_TimeScale_S( player : CStoryScenePlayer, timeScale : float ) {
	SetTimeScaleQuest(timeScale);
}

storyscene function NTR_RemoveAttachment_S( player : CStoryScenePlayer, id : int ) {
	NTR_RemoveAttachment_Q( id );
}
latent storyscene function NTR_CreateAttachment_S( player : CStoryScenePlayer, id : int ) {
	NTR_CreateAttachment_Q( id );
}

storyscene function NTR_LeaveSceneState_S( player : CStoryScenePlayer ) {
	var currentGameState   :   ESoundGameState;

	currentGameState = theSound.GetCurrentGameState();
	if (currentGameState == ESGS_Dialog || currentGameState == ESGS_DialogNight || currentGameState == ESGS_Cutscene) {
		theSound.LeaveGameState( currentGameState );
	}
}
storyscene function NTR_PlaySound_S( player : CStoryScenePlayer, bankName : string, eventName : string, optional saveType : string ) {
	NTR_PlaySound(bankName, eventName, saveType);
}
storyscene function NTR_PayStoryScene_PerformAction( player : CStoryScenePlayer, money : int, dontGrantExp : bool )
{
	if (thePlayer.GetMoney() < money)
		thePlayer.RemoveMoney( thePlayer.GetMoney() );
	else
		thePlayer.RemoveMoney( money );
	
	if( !dontGrantExp )
	{
		GetWitcherPlayer().AddPoints( EExperiencePoint, CeilF(money / 10), true );
	}
	
	theSound.SoundEvent("gui_bribe");
}

/*storyscene function NTR_HideActorsFishermanScene_S( player : CStoryScenePlayer ) {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var killIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('ntr_fisherman');
    acceptedVoicetags.PushBack('VAMPIRE DIVA');
    killIfHostile = false;

    NTR_HideActorsInRange(30.0, acceptedTags, acceptedVoicetags, killIfHostile);
}

storyscene function NTR_HideActorsHagScene_S( player : CStoryScenePlayer ) {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;
    var killIfHostile : bool;

    acceptedTags.PushBack('PLAYER');
    acceptedVoicetags.PushBack('CELINA MONSTER');
    killIfHostile = true;

    NTR_HideActorsInRange(30.0, acceptedTags, acceptedVoicetags, killIfHostile);
}*/

latent storyscene function NTR_NegotiateMonsterHunt_S( player: CStoryScenePlayer, resultFact : CName, rewardName : name, alwaysSuccessful : bool, isItemReward : bool ) {
	var ret : ENegotiationResult;
	var questUniqueScriptTag : CName;
	
	ResetFactQuest(resultFact);
	ret = NegotiateMonsterHunt( player, rewardName, questUniqueScriptTag, alwaysSuccessful, isItemReward );
	//NTR_notify("[NTR_NegotiateMonsterHunt_S] Negotiate result = " + ret);
	switch (ret) {
		case TooMuch:
			FactsAdd( resultFact, 1 ); // 1 if too much
			break;
		case PrettyClose:
			FactsAdd( resultFact, 2 ); // 2 if pretty close
			break;
		case WeHaveDeal:
			FactsAdd( resultFact, 3 ); // 3 if okay
			break;
		case GetLost:
			FactsAdd( resultFact, 4 ); // 4 if haggling rejected
			break;
	}
}

storyscene function NTR_ShowTimeLapse_S( player : CStoryScenePlayer, showTime : float, optional timeLapseMessageKey : string, optional timeLapseAdditionalMessageKey : string ) {
	ShowTimeLapse(showTime, timeLapseMessageKey, timeLapseAdditionalMessageKey);
}

storyscene function NTR_ChangeWeatherQuest_S( player : CStoryScenePlayer, weatherName: name, blendTime: float, randomGen: bool, questPause: bool )
{
	/* 
	changeweather(name)
	WT_Clear
	WT_Rain_Storm
	WT_Light_Clouds
	WT_Mid_Clouds
	WT_Mid_Clouds_Dark
	WT_Heavy_Clouds
	WT_Heavy_Clouds_Dark
	WT_Snow
	*/
	//NTR_notify("Change weather to " + weatherName);
	ChangeWeatherQuest( weatherName, blendTime, randomGen, questPause );
}

storyscene function NTR_ShiftTime_S( player : CStoryScenePlayer, days : int, optional hours : int, optional minutes : int, optional seconds : int )
{
	theGame.SetGameTime( theGame.GetGameTime() + GameTimeCreate(days, hours, minutes, seconds), true);
	LogTime("[NTR_ShiftTime_S] Waiting " + days + " days, " + hours + " hours, " + minutes + " minutes, " + seconds + " seconds");
}

storyscene function NTR_SceneDoorChangeState( player : CStoryScenePlayer, tag : name, newState : string, optional keyItemName : name, optional removeKeyOnUse : bool, optional smoooth : bool, optional dontBlockInCombat : bool ) {
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

latent storyscene function NTR_MorphNPC_S( player : CStoryScenePlayer, tag : name, morphRatio : float, blendTime : float, optional pauseBefore : float ) {
	if (pauseBefore > 0.0f) {
		Sleep(pauseBefore);
	}
	NTR_MorphNPC(tag, morphRatio, blendTime);
}

latent storyscene function NTR_MorphNPCTimer_S( player : CStoryScenePlayer, tag : name, morphRatio : float, blendTime : float, optional pauseBefore : float ) {
	var          npcs : array<CNewNPC>;
	var           npc : CNTROriannaVampireNPC;
	var             i : int;
	
	theGame.GetNPCsByTag(tag, npcs);
	if (npcs.Size() == 0) {
		LogChannel('NTR_MorphNPCTimer_S', "[ERROR] NPCs not found by tag <" + tag + ">");
	}
	for (i = 0; i < npcs.Size(); i += 1) {
		npc = (CNTROriannaVampireNPC) npcs[i];
		if (!npc) {
			LogChannel('NTR_MorphNPCTimer_S', "[ERROR] NPC does not support timer morph: " + npcs[i]);
		} else {
			LogChannel('NTR_MorphNPCTimer_S', "[Info] Add morph timer for entity with app [" + npcs[i].GetAppearance() + "]");
			npc.NTR_morphRatio.PushBack(morphRatio);
			npc.NTR_blendTime.PushBack(blendTime);			
			npc.AddTimer('morphMe', pauseBefore, false, , , , false);
		}
	}
}