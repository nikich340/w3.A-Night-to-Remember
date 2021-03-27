function NTR_notify(msg : string) {
	// debug only! theGame.GetGuiManager().ShowNotification(msg);
    LogChannel('NTR_MOD', msg);
}
// -------------------------------------------------
function NTR_HideActorsInRange(range : float, acceptedTags : array<name>, acceptedVoicetags: array<name>, onlyKillIfHostile : bool)  {
    var entities             : array<CGameplayEntity>;
    var actor                : CActor;
    var i, j, t, maxEntities : int;
    var tags                 : array<name>;
    var accepted             : bool;

    maxEntities = 1000;

    FindGameplayEntitiesInRange(entities, thePlayer, range, maxEntities);
            
    for (i = 0; i < entities.Size(); i += 1) {
        actor = (CActor)entities[i];
        if (actor) {
            NTR_notify("NTR_HideActorsInRange: actor " + actor);
            if (!actor.IsAlive()) {
            	continue;
            }

            accepted = false;
            tags = actor.GetTags();
            //LogChannel('DEBUG', "GetVoicetag: " + actor.GetVoicetag());
            //LogChannel('DEBUG', "GetDisplayName: " + actor.GetDisplayName());
			//LogChannel('getInRange', "* GetAttitudeGroup: " + actor.GetAttitudeGroup());
            
            for (t = 0; t < acceptedVoicetags.Size(); t += 1) {
            	if (actor.GetVoicetag() == acceptedVoicetags[t]) {
            		accepted = true;
            		break;
            	}
            }

            for (t = 0; t < tags.Size(); t += 1) {
                //NTR_notify("NTR_HideActorsInRange: > tag: " + tags[t]);
                for (j = 0; j < acceptedTags.Size(); j += 1) {
                    if (tags[t] == acceptedTags[j]) {
                        accepted = true;
                        break;
                    }
                }
            }
            if (!accepted) {
            	if (onlyKillIfHostile) {
					if ((actor.HasAttitudeTowards(thePlayer) && actor.GetAttitude(thePlayer) == AIA_Hostile) || actor.GetAttitudeGroup() == 'AG_nightwraith' || actor.GetAttitudeGroup() == 'hostile_to_player') {
						//LogChannel('HideInRange', " x KILL");
						actor.OnCutsceneDeath();
					}
            	} else {
	            	//LogChannel('HideInRange', " + HIDE");
	            	actor.AddTag('ntr_hidden_actor');
	            	actor.SetVisibility(false);
	            	actor.SetGameplayVisibility(false);
	            	actor.EnableCollisions(false);
	            	actor.EnableStaticCollisions(false);
	            	actor.EnableDynamicCollisions(false);
	            	actor.EnableCharacterCollisions(false);
            	}
        	}
        }
    }

    NTR_notify("NTR_HideActorsInRange: Done for range: " + range);
}
// ------------ Morph all npc components at once (advanced variant) ------------------
function NTR_MorphNPC( tag : name, morphRatio : float, blendTime : float ) {
	var          npcs : array<CNewNPC>;
	var    components : array<CComponent>;
	var       manager : CMorphedMeshManagerComponent;
	var          i, j : int;
	
	theGame.GetNPCsByTag(tag, npcs);
	if (npcs.Size() == 0) {
		NTR_notify("NTR_MorphNPC: [ERROR] NPCs not found by tag <" + tag + ">");
	}
	for (i = 0; i < npcs.Size(); i += 1) {
		components = npcs[i].GetComponentsByClassName('CMorphedMeshManagerComponent');
		if (components.Size() == 0) {
			NTR_notify("NTR_MorphNPC: [ERROR] Not found morph managers");
		}
		for (j = 0; j < components.Size(); j += 1) {
			manager = (CMorphedMeshManagerComponent) components[j];
			if (manager) {
				manager.SetMorphBlend( morphRatio, blendTime );
				NTR_notify("NTR_MorphNPC: [OK] Morph component: " + manager + " to <" + morphRatio + "> in " + blendTime + " sec, app: " + npcs[i].GetAppearance());
			}
		}
	}
}
