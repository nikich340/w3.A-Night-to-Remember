class CNTRScent extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
        
        if (FactsQuerySum("ntr_town_scent_enabled") == 1) {
            FocusEffect( FEAA_Enable, 'focus_smell', 'ntr_orianna_scents', -1 );
            LogChannel('CNTRScent', "Enable orianna scent!");
        } else {
            FocusEffect( FEAA_Disable, 'focus_smell', 'ntr_orianna_scents', -1 );
            LogChannel('CNTRScent', "Disable orianna scent!");
        }
	}
}
