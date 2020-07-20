storyscene function NTRPlayMusicScene( player : CStoryScenePlayer, areaName : string, eventName : string) {
	if ( areaName == "toussaint" )
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
	else
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );
	
	theSound.SoundEvent( eventName );
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

storyscene function NTR_HideActorsFishermanScene_S( player : CStoryScenePlayer ) {
    var acceptedTags : array<name>;
    var acceptedVoicetags : array<name>;

    acceptedTags.PushBack('PLAYER');
    acceptedTags.PushBack('ntr_fisherman');
    acceptedVoicetags.PushBack('VAMPIRE DIVA');

    NTR_HideActorsInRange(30.0, acceptedTags, acceptedVoicetags);
}

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

storyscene function NTR_SceneMorph( player : CStoryScenePlayer, tag : name, managerTag : name, morphRatio : float, blendTime : float ) {
	var           npc : CNewNPC;
	var manager : CMorphedMeshManagerComponent;
	
	npc = (CNewNPC)theGame.GetNPCByTag(tag);
	if (npc) {
		//manager = (CMorphedMeshManagerComponent)npc.GetComponentByClassName('CMorphedMeshManagerComponent');
		manager = (CMorphedMeshManagerComponent)npc.GetComponent(managerTag);
		if(manager) {
			manager.SetMorphBlend( morphRatio, blendTime );
		} else {
			theGame.GetGuiManager().ShowNotification("Morph component not found!");
		}
	} else {
		theGame.GetGuiManager().ShowNotification("Entity " + tag + " not found!");
	}
}