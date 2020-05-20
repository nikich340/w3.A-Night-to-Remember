storyscene function NTRPlayMusicScene( player : CStoryScenePlayer, areaName : string, eventName : string) {
	if ( areaName == "toussaint" )
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
	else
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );
	
	theSound.SoundEvent( eventName );
}

storyscene function NTR_SceneDoorChangeState( player : CStoryScenePlayer, tag : name, newState : string, optional keyItemName : name, optional removeKeyOnUse : bool, optional smoooth : bool, optional dontBlockInCombat : bool ) {
	if (smoooth)
		theGame.GetGuiManager().ShowNotification("Smooth!");
	else
		theGame.GetGuiManager().ShowNotification("NOT Smooth!");
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