class CNTRBanditNPC extends CNewNPC {

	//editable saved var stolenMoney : int; default stolenMoney = 0;

	/*event OnSpawned( spawnData : SEntitySpawnData )	{
		super.OnSpawned( spawnData );
	}*/
	//event OnDeath( damageAction : W3DamageAction  )	{
		//FactsAdd("trissIntroDead", 1);
	//}
	//event OnTakeDamage( action : W3DamageAction ) {
		
	//}

	function Kill(source : name, optional ignoreImmortalityMode : bool, optional attacker : CGameplayEntity)
	{
		theGame.GetGuiManager().ShowNotification("CActor.Kill: called for actor <<" + this + ">> with source <<" + source + ">>");
		super.Kill(source, ignoreImmortalityMode, attacker);
	}
	/*protected function PrepareAttackAction( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity, out attackAction : W3Action_Attack) : bool
	{
		var ret : bool;
		ret = super.PrepareAttackAction(hitTarget, animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity, attackAction);
		//theGame.GetGuiManager().ShowNotification("PrepareAttackAction, damage: " + attackAction.processedDmg.vitalityDamage);
		
		return ret;
	}*/
	protected function Attack( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity)
    {
        var action : W3Action_Attack;
        
        if(PrepareAttackAction(hitTarget, animData, weaponId, parried, countered, parriedBy, attackAnimationName, hitTime, weaponEntity, action))
        {
            theGame.damageMgr.ProcessAction(action);
            delete action;
            if (thePlayer.GetHealth() < 1.0) {
            	FactsAdd("NTR_fisfightDead");
            }
        }
    }
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
	}
}
