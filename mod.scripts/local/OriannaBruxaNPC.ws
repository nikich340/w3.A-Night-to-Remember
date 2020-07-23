class COriannaBruxaNPC extends CNewNPC {
	event OnSpawned( spawnData : SEntitySpawnData )	{
		//AddTag('dettlaff_vampire');
		//AddAnimEventCallback( 'RotateEvent',		'OnAnimEvent_RotateEvent' );
		AddAbility( 'NoShadows' );
		super.OnSpawned( spawnData );
	}
	/*event OnDeath( damageAction : W3DamageAction  )	{
		FactsAdd("trissIntroDead", 1);
	}
	event OnTakeDamage( action : W3DamageAction ) {
		if ( GetHealthPercents() < 0.5 ) {
			action.processedDmg.vitalityDamage /= 5;
		}
		super.OnTakeDamage( action );
		//theGame.GetGuiManager().ShowNotification("Health %: " + GetHealthPercents());
		if ( GetHealthPercents() < 0.5 ) {
			FactsAdd("trissIntroHalf", 1);
		}
	}*/
	function PlayEffect( effectName : name, optional target : CNode  ) : bool {
		LogChannel('Orianna_bruxa', "PlayEffect: " + effectName);
		return super.PlayEffect(effectName, target);
	}	
	function PlayEffectOnBone( effectName : name, boneName : name, optional target : CNode ) : bool {
		LogChannel('Orianna_bruxa', "PlayEffectOnBone: " + effectName + ", boneName: " + boneName);
		return super.PlayEffectOnBone(effectName, boneName, target);
	}
	function StopEffect( effectName : name ) : bool {
		LogChannel('Orianna_bruxa', "StopEffect: " + effectName);
		return super.StopEffect(effectName);
	}
	/*function SetAppearance( appearanceName : CName ) {
		LogChannel('Orianna_bruxa', "SetAppearance: " + appearanceName);
		super.SetAppearance(appearanceName);
	}*/
}
