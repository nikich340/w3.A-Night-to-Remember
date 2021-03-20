class CNTRBanditNPC extends CNTRCommonNPC {
    private var baronReplicCounter : int;
    private var baronReplicPrev    : int;
    default baronReplicPrev = -2;

	protected function Attack( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity)
    {
        var action : W3Action_Attack;
        
        if(PrepareAttackAction(hitTarget, animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity, action))
        {
            theGame.damageMgr.ProcessAction(action);

            /*LogChannel('NTR_MOD', "-----ATTACK ACTION LOG!!!-----");
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
            */

            delete action;
            if (thePlayer.GetHealth() < 1.0) {
            	FactsAdd("ntr_fisfight_dead");
            }
        }
    }
    event OnDeath( damageAction : W3DamageAction  )	{
    	if (IsInFistFightMiniGame()) {
			FactsAdd("ntr_fisfight_defeat");
		}
		super.OnDeath( damageAction );
	}
	event OnTakeDamage( action : W3DamageAction ) {
		if (IsInFistFightMiniGame()) {
			if (action.processedDmg.vitalityDamage > 1.0 && action.processedDmg.vitalityDamage < 0.1 * GetMaxHealth())
				action.processedDmg.vitalityDamage += 0.1 * GetMaxHealth();
			if (action.processedDmg.vitalityDamage > 0.5 * GetMaxHealth())
				action.processedDmg.vitalityDamage /= 4;
		}
		super.OnTakeDamage( action );

		if ( HasTag('ntr_baron_edward') && GetHealthPercents() < 0.25 && baronReplicCounter < 3 ) {
            SetAnimMultiplier();
            
            PlayBaronReplic();
            baronReplicCounter += 1;     
        }
        if ( HasTag('ntr_baron_edward') && GetHealthPercents() < 0.5 && baronReplicCounter < 2 ) {
            PlayBaronReplic();
            baronReplicCounter += 1;     
        }
        if ( HasTag('ntr_baron_edward') && GetHealthPercents() < 0.75 && baronReplicCounter < 1 ) {
            PlayBaronReplic();
            baronReplicCounter += 1;     
        }
	}

    function PlayBaronReplic() {
        var scene : CStoryScene;

        baronReplicPrev = RandDifferent( baronReplicPrev, 4 );

        scene = (CStoryScene)LoadResource("dlc/dlcntr/data/scenes/17.baron_oneliners.w2scene", true);
        theGame.GetStorySceneSystem().PlayScene(scene, "fight_replic" + IntToString(baronReplicPrev + 1));
    }
}

exec function baronReplic() {
    ((CNTRBanditNPC)theGame.GetEntityByTag('ntr_baron_edward')).PlayBaronReplic();
}