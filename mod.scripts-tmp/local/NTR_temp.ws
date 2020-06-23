exec function startNTR() {
	FactsAdd("NTRstartquest", 1);
}

exec function orianaDoor(newState : string, optional smoooth : bool, optional dontBlockInCombat : bool ) {
	NTR_DoorChangeState('q704_oriana_feeding_room', newState, , , smoooth, dontBlockInCombat);
}

exec function myspawn(path : string) {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource(path, true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	pos.Z += 1.0;
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_dress_test');
}

exec function morphOriana( morphRatio : float, blendTime : float ) {
	var           npc : CNewNPC;
	var manager : CMorphedMeshManagerComponent;
	
	npc = (CNewNPC)theGame.GetNPCByTag('oriana_test2');
	if (npc) {
		//manager = (CMorphedMeshManagerComponent)npc.GetComponentByClassName('CMorphedMeshManagerComponent');
		manager = (CMorphedMeshManagerComponent)npc.GetComponent('face_morph');
		if(manager) {
			manager.SetMorphBlend( morphRatio, blendTime );
		} else {
			theGame.GetGuiManager().ShowNotification("Morph component not found!");
		}
	} else {
		theGame.GetGuiManager().ShowNotification("Entity [OrianaTest] not found!");
	}
}

latent quest function playSoundsCustom() {
	var snds : array<string>;
	var idx : int;
	var bnk : string;

	bnk = "qu_ep2_701_dlg.bnk";
	idx = 0;

	snds.PushBack("q701_17_shackles");
	snds.PushBack("q701_bandit_hits_woman");
	snds.PushBack("q701_bandit_reaction");
	snds.PushBack("q701_bandits_arrival");
	snds.PushBack("q701_bandits_arrival_02");
	snds.PushBack("q701_bandits_arrival_03");
	snds.PushBack("q701_bandits_arrival_04");
	snds.PushBack("q701_bandits_have_fun_02");
	snds.PushBack("q701_bandits_in_da_haus");
	snds.PushBack("q701_bloody_coins");
	snds.PushBack("q701_boat_escapes_from_G");
	snds.PushBack("q701_bruxa_fight_bruxa_dropping_hand");
	snds.PushBack("q701_bruxa_fight_bruxa_searching_body_01");
	snds.PushBack("q701_bruxa_fight_bruxa_searching_body_02");
	snds.PushBack("q701_bruxa_morph");
	snds.PushBack("q701_bruxa_moves");
	snds.PushBack("q701_bruxa_puts_hand");
	snds.PushBack("q701_bruxa_shuts_gate");
	snds.PushBack("q701_bruxa_skin_morph");
	snds.PushBack("q701_bruxa_sniffs_hand");
	snds.PushBack("q701_Damien_hits_table");
	snds.PushBack("q701_easyboy");
	snds.PushBack("q701_eating_grass");
	snds.PushBack("q701_fenix_egg_opened");
	snds.PushBack("q701_finish_him_01");
	snds.PushBack("q701_finish_him_02");
	snds.PushBack("q701_fish_prop");
	snds.PushBack("q701_G_takes_hand");
	snds.PushBack("q701_G_unsheathe_sword");
	snds.PushBack("q701_Geralt_beaten_moans");
	snds.PushBack("q701_grab_key_paper");
	snds.PushBack("q701_hand_02");
	snds.PushBack("q701_hide_hand");
	snds.PushBack("q701_key");
	snds.PushBack("q701_LOL_01");
	snds.PushBack("q701_lol_02");
	snds.PushBack("q701_milton_lifts_up_guillaume_armor_rattle");
	snds.PushBack("q701_moving_hand");
	snds.PushBack("q701_ouch");
	snds.PushBack("q701_Palmerin_gets_up");
	snds.PushBack("q701_Palmerin_rolls_DAH_letter");
	snds.PushBack("q701_Palmerins_sword");
	snds.PushBack("q701_paper_clue");
	snds.PushBack("q701_pickup_letter_from_DAH");
	snds.PushBack("q701_playing_kids_01");
	snds.PushBack("q701_playing_kids_02");
	snds.PushBack("q701_sharlei_death");
	snds.PushBack("q701_sharley_bells_01");
	snds.PushBack("q701_sharley_bells_02");
	snds.PushBack("q701_sharley_bells_03");
	snds.PushBack("q701_sharley_bells_04");
	snds.PushBack("q701_smash_this_fish");
	snds.PushBack("q701_splashy_G");
	snds.PushBack("q701_take_fish");
	snds.PushBack("q701_taking_sword_from_body");
	snds.PushBack("q701_torch");
	snds.PushBack("q701_tournament_gate");
	snds.PushBack("q701_unicorn_easyboy_02");
	snds.PushBack("q701_unicorn_with_apple_01");
	snds.PushBack("q701_unicorn_with_apple_02");
	snds.PushBack("q701_unicorn_with_carrots_basket");
	snds.PushBack("q701_won_unicorn_fight");
	snds.PushBack("Stop_q701_dlg");

	theGame.GetGuiManager().ShowNotification("Loaded events: " + snds.Size());
	Sleep(10.0);

	while ( idx < snds.Size() ) {
		if (!theSound.SoundIsBankLoaded(bnk)) {
			theSound.SoundLoadBank(bnk, false);
			theGame.GetGuiManager().ShowNotification("SoundEvent[load]: " + snds[idx]);
		} else {
			theGame.GetGuiManager().ShowNotification("SoundEvent[ok]: " + snds[idx]);
		}
		thePlayer.SoundEvent(snds[idx]);
		Sleep(7.0);
		idx = idx + 1;
	}
}
latent quest function playSoundsBruxa() {
	var snds : array<string>;
	var idx : int;

	snds.PushBack("monster_alp_voice_scream");
	snds.PushBack("monster_alp_voice_scream_stop");
	snds.PushBack("monster_bruxa_combat_appear");
	snds.PushBack("monster_bruxa_combat_bite");
	snds.PushBack("monster_bruxa_combat_blast_shockwave");
	snds.PushBack("monster_bruxa_combat_burning_skin");
	snds.PushBack("monster_bruxa_combat_disappear");
	snds.PushBack("monster_bruxa_combat_drinks_blood");
	snds.PushBack("monster_bruxa_combat_drinks_blood_stop");
	snds.PushBack("monster_bruxa_combat_drop_cloak");
	snds.PushBack("monster_bruxa_combat_ears_ringing");
	snds.PushBack("monster_bruxa_combat_healing_skin");
	snds.PushBack("monster_bruxa_combat_silver_dust_start");
	snds.PushBack("monster_bruxa_combat_silver_dust_stop");
	snds.PushBack("monster_bruxa_combat_teleport_trail");
	snds.PushBack("monster_bruxa_dialog_human_breath");
	snds.PushBack("monster_bruxa_geralt_custom_choke_01");
	snds.PushBack("monster_bruxa_geralt_sword_miss");
	snds.PushBack("monster_bruxa_geralt_sword_take_out");
	snds.PushBack("monster_bruxa_missed_by_sword");
	snds.PushBack("monster_bruxa_movement_bodyfall");
	snds.PushBack("monster_bruxa_movement_footsteps_jump");
	snds.PushBack("monster_bruxa_movement_footsteps_land");
	snds.PushBack("monster_bruxa_movement_footsteps_run");
	snds.PushBack("monster_bruxa_movement_footsteps_walk");
	snds.PushBack("monster_bruxa_movement_hand_pat");
	snds.PushBack("monster_bruxa_movement_whoosh_mid");
	snds.PushBack("monster_bruxa_movement_whoosh_small");
	snds.PushBack("monster_bruxa_voice_attack_1");
	snds.PushBack("monster_bruxa_voice_attack_2");
	snds.PushBack("monster_bruxa_voice_breath");
	snds.PushBack("monster_bruxa_voice_breath_cycle");
	snds.PushBack("monster_bruxa_voice_breathing_rush");
	snds.PushBack("monster_bruxa_voice_breathing_rush_stop");
	snds.PushBack("monster_bruxa_voice_breathing_rush_teleport");
	snds.PushBack("monster_bruxa_voice_burning");
	snds.PushBack("monster_bruxa_voice_choke");
	snds.PushBack("monster_bruxa_voice_confused");
	snds.PushBack("monster_bruxa_voice_death");
	snds.PushBack("monster_bruxa_voice_death_burning");
	snds.PushBack("monster_bruxa_voice_death_stop");
	snds.PushBack("monster_bruxa_voice_feeding_attack");
	snds.PushBack("monster_bruxa_voice_feeding_pre");
	snds.PushBack("monster_bruxa_voice_feeding_pre_jump");
	snds.PushBack("monster_bruxa_voice_feeding_pre_jump_stop");
	snds.PushBack("monster_bruxa_voice_hiss_scream");
	snds.PushBack("monster_bruxa_voice_pain");
	snds.PushBack("monster_bruxa_voice_panting");
	snds.PushBack("monster_bruxa_voice_panting_scream");
	snds.PushBack("monster_bruxa_voice_paralysed");
	snds.PushBack("monster_bruxa_voice_roar");
	snds.PushBack("monster_bruxa_voice_scream");
	snds.PushBack("monster_bruxa_voice_scream_stop");
	snds.PushBack("monster_bruxa_voice_snarl");
	snds.PushBack("monster_bruxa_voice_taunt_blood");
	snds.PushBack("Set_Switch_bruxa_state_black_blood");
	snds.PushBack("Set_Switch_bruxa_state_clean");
	snds.PushBack("Set_Switch_bruxa_taunt_choke");
	snds.PushBack("Set_Switch_bruxa_taunt_taunt");
	snds.PushBack("Stop_monster_bruxa_dialog_human_breath");

	Sleep(10.0);

	while ( idx < snds.Size() ) {
		if (!theSound.SoundIsBankLoaded("monster_bruxa.bnk")) {
			theSound.SoundLoadBank("monster_bruxa.bnk", false);
			theGame.GetGuiManager().ShowNotification("SoundEvent[load]: " + snds[idx]);
		} else {
			theGame.GetGuiManager().ShowNotification("SoundEvent[ok]: " + snds[idx]);
		}
		thePlayer.SoundEvent(snds[idx]);
		Sleep(5.0);
		idx = idx + 1;
	}
}

exec function oridet() {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource("dlc/dlcntr/data/entities/orianna_vampire.w2ent", true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_test2');
	ent.ApplyAppearance('orianna_vampire');
}

exec function oridress() {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource("dlc/dlcntr/data/entities/oriana_dress/orianna_dress_lying.w2ent", true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	pos.Z += 1.0;
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_dress_test');
}
exec function testnpc() {
	var           npc : CNewNPC;
	
	npc = (CNewNPC)theGame.GetNPCByTag('oriana_test2');
	theGame.GetGuiManager().ShowNotification("appearance: " + npc.GetAppearance() + ", alive: " + npc.IsAlive());
}

exec function oribru() {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource("dlc/dlcntr/data/entities/orianna_bruxa.w2ent", true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_test2');
	ent.ApplyAppearance('bruxa_monster_gameplay');
}
exec function oricloak() {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource("dlc/dlcntr/data/entities/orianna_bruxa_cloak.w2ent", true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_test2');
	ent.ApplyAppearance('orianna_bruxa');
}
exec function detl() {
	var      template : CEntityTemplate;
	var           pos : Vector;
	var           ent : CEntity;
	
	template = (CEntityTemplate)LoadResource("dlc/bob/data/quests/main_quests/quest_files/q704_truth/characters/q704_dettlaff_vampire.w2ent", true);
	pos = thePlayer.GetWorldPosition() + VecRingRand(1.f,2.f);
	ent = (CEntity)theGame.CreateEntity(template, pos);
	ent.AddTag('oriana_test2');
	ent.ApplyAppearance('dettlaff_vampire');
}
exec function applyAp( ap : name ) {
	var           npc : CNewNPC;
	
	npc = (CNewNPC)theGame.GetNPCByTag('oriana_test2');
	npc.ApplyAppearance(ap);
}
exec function playEff( effect : name ) {
	var           npc : CNewNPC;
	
	npc = (CNewNPC)theGame.GetNPCByTag('oriana_test2');
	npc.PlayEffect(effect);
}
exec function playEffGeralt( effect : name, optional stop : bool ) {
	if (stop) {
		theGame.GetGuiManager().ShowNotification("Stop: " + effect);
		thePlayer.StopEffect(effect);
	} else {
		theGame.GetGuiManager().ShowNotification("Play: " + effect);
		thePlayer.PlayEffect(effect);
	}
}
exec function tsc() {
    var scene : CStoryScene;
    var template: CEntityTemplate;
    var entity: CEntity;

    // -> SET SCENE PATH
    scene = (CStoryScene)LoadResource( "dlc\dlcntr\data\scenes\15.fistfight_repeat.w2scene", true);
    theGame.GetStorySceneSystem().PlayScene(scene, "Input");
}
/*quest function <modid>_setFactOnIgnite (tag : name, factName : name) {
	var gameLightComp : CGameplayLightComponent;        
	var           ent : CEntity;
        
	ent = (CEntity)theGame.GetEntityByTag(tag);
	gameLightComp = (CGameplayLightComponent)ent.GetComponentByClassName('CGameplayLightComponent');
	if (gameLightComp) {
		gameLightComp.factOnIgnite = factName;  
	} else {
		theGame.GetGuiManager().ShowNotification("CGameplayLightComponent not found in [" + tag + "]");
	}
}*/

exec function hostileOrianna() {
	NTRTuneNPC( 'oriana_test2', 40, "Hostile", "None", false, "ENGT_Enemy", -1 );
}
exec function hostileOrianna2() {
	NTRTuneNPC2( 'oriana_test2', 40, "Hostile", "None", false, "ENGT_Enemy", -1 );
}
quest function NTRTuneNPC2( tag : name, level : int, optional attitude : string, optional mortality : string, optional finishers : bool, optional npcGroupType : string, optional scale : float ) {
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
		//ForceTargetQuest('oriana_test2','PLAYER', false);
		//ModifyNPCAbilityQuest('oriana_test2', 'DettlaffVampire_q704', false);
		SetGroupAttitudeQuest('player', 'dettlaff', AIA_Hostile);
		/* SET LEVEL */
		if (level > 0)
			NPCs[i].SetLevel(level);
		
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