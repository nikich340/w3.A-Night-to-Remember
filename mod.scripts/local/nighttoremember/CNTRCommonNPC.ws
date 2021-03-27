class CNTRCommonNPC extends CNewNPC {
	editable saved var       NTR_factOnSpawn : String;
    editable saved var  NTR_factOnHalfHealth : String;
    editable saved var       NTR_factOnDeath : String;
    editable saved var    NTR_factNearlyDead : String;
    editable saved var   NTR_avoidDeathEvent : Bool;
    default NTR_avoidDeathEvent = false;

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
        NTR_notify("CNTRCommonNPC: SetAnimationSpeedMultiplier = " + NTR_animationMultiplier);
        NTR_slowdownSet = true;
    }
    function ResetAnimMultiplier() {
        if (!NTR_slowdownSet)
            return;
        ResetAnimationSpeedMultiplier( NTR_slowdownCauserId );
        NTR_slowdownSet = false;
    }
}
