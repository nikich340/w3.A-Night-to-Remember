class CHagNPC extends CNewNPC {
    /*event OnSpawned( spawnData : SEntitySpawnData )	{
		super.OnSpawned( spawnData );
	}*/
	event OnDeath( damageAction : W3DamageAction  )	{
		FactsAdd("hagIntroDead", 1);
	}
}
