/*class CNTRScriptedAgent extends CGameplayEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
		//AddTimer( 'UpdateScent', 0.1f, true , , , true, true );
		LogChannel('NTRScriptedAgent', "I was spawned!");
        
        if (FactsQuerySum("ntr_town_scent_enabled") == 1) {
            FocusEffect( FEAA_Enable, 'focus_smell', 'ntr_orianna_scents', -1 );
            LogChannel('NTRScriptedAgent', "Enable orianna scent!");
        } else {
            FocusEffect( FEAA_Disable, 'focus_smell', 'ntr_orianna_scents', -1 );
            LogChannel('NTRScriptedAgent', "Disable orianna scent!");
        }
	}
}	*/
