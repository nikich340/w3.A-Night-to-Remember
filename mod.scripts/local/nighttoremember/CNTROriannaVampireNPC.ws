class CNTROriannaVampireNPC extends CNTRCommonNPC {
    saved var NTR_morphRatio, NTR_blendTime : array<float>;

    timer function morphMe( time : float , id : int) {
        var    components : array<CComponent>;
        var       manager : CMorphedMeshManagerComponent;
        var             j : int;

        components = GetComponentsByClassName('CMorphedMeshManagerComponent');
        if (components.Size() == 0) {
            LogChannel('CNTROriannaVampireNPC', "[ERROR] Not found morph managers for " + this);
        }
        for (j = 0; j < components.Size(); j += 1) {
            manager = (CMorphedMeshManagerComponent) components[j];
            if (manager) {
                if (NTR_morphRatio.Size() < 1 || NTR_blendTime.Size() < 1) {
                    LogChannel('CNTROriannaVampireNPC', "[ERROR] NULL morph ratio/time!");
                }
                manager.SetMorphBlend( NTR_morphRatio[0], NTR_blendTime[0] );
                LogChannel('CNTROriannaVampireNPC', "[OK] Morph component: " + manager + " to <" + NTR_morphRatio[0] + "> in " + NTR_blendTime[0] + " sec");
            
                NTR_morphRatio.Erase(0);
                NTR_blendTime.Erase(0);
            }
        }
    }

    event OnTakeDamage( action : W3DamageAction ) {
        super.OnTakeDamage( action );

        if ( HasTag('ntr_orianna_bruxa') && GetHealthPercents() < 0.25 ) {
            SetAnimMultiplier();         
        }
    }
}
