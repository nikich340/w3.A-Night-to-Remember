class CNTRCommonNPC extends CNewNPC {
	editable saved var       NTR_factOnSpawn : String;
    editable saved var  NTR_factOnHalfHealth : String;
    editable saved var       NTR_factOnDeath : String;
    editable saved var    NTR_factNearlyDead : String;
    editable saved var   NTR_avoidDeathEvent : Bool;

    editable saved var NTR_animationMultiplier : float;
    saved var             NTR_slowdownCauserId : int;
    saved var                  NTR_slowdownSet : Bool;
    default NTR_slowdownSet = false;

    event OnSpawned( spawnData : SEntitySpawnData )	{
		super.OnSpawned( spawnData );
		FactsAdd(NTR_factOnSpawn, 1);

	}
	event OnTakeDamage( action : W3DamageAction ) {
		super.OnTakeDamage( action );

        if ( GetHealthPercents() < 0.5 ) {
			FactsAdd(NTR_factOnHalfHealth, 1);
		}
        if ( GetHealthPercents() < 0.05 ) {
            FactsAdd(NTR_factNearlyDead, 1);
        }
	}
	event OnDeath( damageAction : W3DamageAction  )	{
		FactsAdd(NTR_factOnDeath, 1, -1);
        ResetAnimMultiplier();
        if (!NTR_avoidDeathEvent) {
            super.OnDeath( damageAction );
        }
	}

    function SetAnimMultiplier(optional customMultiplier : float) {
        if (NTR_slowdownSet)
            return;
        if (customMultiplier) {
            NTR_animationMultiplier = customMultiplier;
        }
        NTR_slowdownCauserId = SetAnimationSpeedMultiplier( NTR_animationMultiplier );
        LogChannel('CNTRCommonNPC', "SetAnimationSpeedMultiplier to: " + NTR_animationMultiplier);
        NTR_slowdownSet = true;
    }
    function ResetAnimMultiplier() {
        if (!NTR_slowdownSet)
            return;
        ResetAnimationSpeedMultiplier( NTR_slowdownCauserId );
        NTR_slowdownSet = false;
    }

    function PlayEffect( effectName : name, optional target : CNode  ) : bool {
        NTR_notify("PlayEffect(" + effectName + ", " + target + ")");
        return super.PlayEffect(effectName, target);
    }   
    function PlayEffectOnBone( effectName : name, boneName : name, optional target : CNode ) : bool {
        NTR_notify("PlayEffectOnBone(" + effectName + ", " + boneName + "," + target + ")");
        return super.PlayEffectOnBone(effectName, boneName, target);
    }

	/*protected function Attack( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity)
    {
        var action : W3Action_Attack;
        
        if(PrepareAttackAction(hitTarget, animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity, action))
        {
            theGame.damageMgr.ProcessAction(action);
            LogChannel('NTR_MOD', "-----ATTACK ACTION LOG!!!-----");
            //LogChannel('NTR_MOD', "GetWeaponId: " + action.GetWeaponId() );
            LogChannel('NTR_MOD', "IsParried: " + action.IsParried() );
            LogChannel('NTR_MOD', "IsCountered: " + action.IsCountered() );
            LogChannel('NTR_MOD', "WasDodged: " + action.WasDodged() );
            LogChannel('NTR_MOD', "GetDamageDealt: " + action.GetDamageDealt() );
            LogChannel('NTR_MOD', "GetAttackAnimName: " + action.GetAttackAnimName() );
            NTR_notify("GetAttackAnimName: " + action.GetAttackAnimName() );
            LogChannel('NTR_MOD', "GetHitTime: " + action.GetHitTime() );
            LogChannel('NTR_MOD', "GetWeaponSlot: " + action.GetWeaponSlot() );
            LogChannel('NTR_MOD', "GetSoundAttackType: " + action.GetSoundAttackType() );
            LogChannel('NTR_MOD', "GetAttackName: " + action.GetAttackName() );
            LogChannel('NTR_MOD', "GetAttackTypeName: " + action.GetAttackTypeName() );
            LogChannel('NTR_MOD', "GetHitTime: " + action.GetAttackAnimName() );
            delete action;
        }
    }*/
}
