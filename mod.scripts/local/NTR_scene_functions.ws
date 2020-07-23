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

storyscene function NTR_SceneMorph( player : CStoryScenePlayer, tag : name, managerTag : name, morphRatio : float, blendTime : float, optional managerTag2 : name ) {
	var           npc : CNewNPC;
	var   ret : array<CComponent>;
	var manager : CMorphedMeshManagerComponent;
	var   i : int;
	
	npc = (CNewNPC)theGame.GetNPCByTag(tag);
	if (npc) {
		ret = npc.GetComponentsByClassName('CMorphedMeshManagerComponent');
		NTR_notify("Found " + ret.Size() + " CMorphedMeshManagerComponents");
		LogChannel('NTR_SceneMorph', "Found " + ret.Size() + " CMorphedMeshManagerComponents");
		//manager = (CMorphedMeshManagerComponent)npc.GetComponentByClassName('CMorphedMeshManagerComponent');
		//manager = (CMorphedMeshManagerComponent)npc.GetComponent(managerTag);
		for (i = 0; i < ret.Size(); i += 1) {
			manager = (CMorphedMeshManagerComponent) ret[i];
			if (manager) {
				manager.SetMorphBlend( morphRatio, blendTime );
				LogChannel('NTR_SceneMorph', "Morph component: " + manager + "");
			} else {
				LogChannel('NTR_SceneMorph', "Component " + manager + " is not CMorphedMeshManagerComponent!");
				NTR_notify("Component " + manager + " is not CMorphedMeshManagerComponent!");
			}
		}
		
		/*if (managerTag2) {
			manager = (CMorphedMeshManagerComponent)npc.GetComponent(managerTag2);
			if(manager) {
					manager.SetMorphBlend( morphRatio, blendTime );
			} else {
					theGame.GetGuiManager().ShowNotification("Morph manager2 not found!");
			}
		}*/
	} else {
		theGame.GetGuiManager().ShowNotification("Entity " + tag + " not found!");
	}
}