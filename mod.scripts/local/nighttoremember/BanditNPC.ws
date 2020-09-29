class CNTRBanditNPC extends CNTRCommonNPC {

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
            if (thePlayer.GetHealth() < 1.0) {
            	FactsAdd("NTR_fisfightDead");
            }
        }
    }*/
    event OnDeath( damageAction : W3DamageAction  )	{
    	if (IsInFistFightMiniGame()) {
			FactsAdd("NTR_fisfightDefeat");
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

		if ( HasTag('ntr_baron_edward') && GetHealthPercents() < 0.25 ) {
            SetAnimMultiplier();         
        }
	}
	function PlayEffect( effectName : name, optional target : CNode  ) : bool {
		//NTR_notify("Play: " + effectName + ", target: " + target);
		return super.PlayEffect( effectName, target );
	}
}
