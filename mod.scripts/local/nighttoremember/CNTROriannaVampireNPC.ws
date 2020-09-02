class CNTROriannaVampireNPC extends CNTRCommonNPC {
    saved var NTR_morphRatio, NTR_blendTime : float;

    timer function morphMe( time : float , id : int) {
        var    components : array<CComponent>;
        var       manager : CMorphedMeshManagerComponent;
        var             j : int;

        if (NTR_blendTime) {
            components = GetComponentsByClassName('CMorphedMeshManagerComponent');
            if (components.Size() == 0) {
                LogChannel('CNTROriannaVampireNPC', "[ERROR] Not found morph managers for " + this);
            }
            for (j = 0; j < components.Size(); j += 1) {
                manager = (CMorphedMeshManagerComponent) components[j];
                if (manager) {
                    manager.SetMorphBlend( NTR_morphRatio, NTR_blendTime );
                    LogChannel('CNTROriannaVampireNPC', "[OK] Morph component: " + manager + " to <" + NTR_morphRatio + "> in " + NTR_blendTime + " sec");
                }
            }
        }
    }
}
