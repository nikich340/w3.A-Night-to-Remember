class CNTRVoicedClue extends W3MonsterClue
{
    var stringId : int;     default stringId = -1;
    var subtitle : bool;    default subtitle = true;
    var npcTag : name;

    event OnInteraction( actionName : string, activator : CEntity  )
    {
        var npc : CNewNPC;

        super.OnInteraction( actionName, activator );
        if ( activator == thePlayer && stringId > 0 ) {
            if (npcTag == 'PLAYER') {
                thePlayer.PlayLine( stringId, subtitle );
                NTR_notify("playLine: " + stringId + ", subtl: " + subtitle);
            } else {
                npc = theGame.GetNPCByTag(npcTag);
                if (npc)
                    npc.PlayLine( stringId, subtitle );
            }
        }
    }
}
