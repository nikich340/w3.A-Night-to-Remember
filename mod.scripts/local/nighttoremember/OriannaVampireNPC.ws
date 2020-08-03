class COriannaVampireNPC extends CNewNPC {
	event OnSpawned( spawnData : SEntitySpawnData )	{
		//AddTag('dettlaff_vampire');
		//AddAnimEventCallback( 'RotateEvent',		'OnAnimEvent_RotateEvent' );
		AddAbility( 'NoShadows' );
		super.OnSpawned( spawnData );
	}
	event OnDeath( damageAction : W3DamageAction  )	{
		FactsAdd("ntr_orianna_vampire_dead", 1);
	}
	event OnTakeDamage( action : W3DamageAction ) {
		/*if ( GetHealthPercents() < 0.5 ) {
			//action.processedDmg.vitalityDamage /= 5;
		}*/
		super.OnTakeDamage( action );
		//theGame.GetGuiManager().ShowNotification("Health %: " + GetHealthPercents());
		if ( GetHealthPercents() < 0.5 ) {
			FactsAdd("ntr_orianna_vampire_halfhealth", 1);
		}
	}
}
