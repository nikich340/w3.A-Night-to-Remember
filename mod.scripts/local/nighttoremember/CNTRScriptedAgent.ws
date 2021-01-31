class CNTRScriptedAgent extends CGameplayEntity
{
    event OnSpawned( spawnData : SEntitySpawnData )
    {
        super.OnSpawned(spawnData);

        AddTimer( 'NTR_AgentWork', 1.0f, false );
    }

    /* 1.0 sec to load focusController! */
    timer function NTR_AgentWork( time : float , id : int ) {
        if (FactsQuerySum("ntr_town_scent_enabled") == 1) {
            FocusEffect( FEAA_Enable, 'focus_smell', 'ntr_orianna_scents', -1.0 );
            LogChannel('CNTRScriptedAgent', "Enable scent!");
        }
        if (FactsQuerySum("ntr_orianna_horse_tracks_enabled") == 1) {
            FocusSetHighlight('ntr_orianna_horse_tracks', FMV_Clue, false);
        }
        if (FactsQuerySum("ntr_footprints_to_cemetery_enabled") == 1) {
            FocusSetHighlight('ntr_footprints_to_cemetery', FMV_Clue, false);
        }
        if (FactsQuerySum("ntr_footprints_to_fisher_enabled") == 1) {
            FocusSetHighlight('ntr_footprints_to_fisher', FMV_Clue, false);
        }
        LogChannel('CNTRScriptedAgent', "Stuff done!");
    }
}
