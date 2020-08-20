class COriannaBruxaNPC extends CNewNPC {
	event OnSpawned( spawnData : SEntitySpawnData )	{
		//AddTag('dettlaff_vampire');
		//AddAnimEventCallback( 'RotateEvent',		'OnAnimEvent_RotateEvent' );
		AddAbility( 'NoShadows' );
		super.OnSpawned( spawnData );
	}
	/*event OnDeath( damageAction : W3DamageAction  )	{
		FactsAdd("ntr_orianna_bruxa_dead", 1);
	}*/
	event OnTakeDamage( action : W3DamageAction ) {
		super.OnTakeDamage( action );
		//theGame.GetGuiManager().ShowNotification("Health %: " + GetHealthPercents());
		if ( GetHealthPercents() < 0.05 ) {
			FactsAdd("ntr_orianna_bruxa_dead", 1);
		}
	}
	protected function Attack( hitTarget : CGameplayEntity, animData : CPreAttackEventData, weaponId : SItemUniqueId, parried : bool, countered : bool, parriedBy : array<CActor>, attackAnimationName : name, hitTime : float, weaponEntity : CItemEntity)
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
    }
	/*function SetAppearance( appearanceName : CName ) {
		LogChannel('Orianna_bruxa', "SetAppearance: " + appearanceName);
		super.SetAppearance(appearanceName);
	}*/
}
