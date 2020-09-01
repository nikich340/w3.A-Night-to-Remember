class CNTROriannaVampireNPC extends CNTRCommonNPC {
    public var NTR_morphRatio, NTR_blendTime : float;

    timer function morphMe( time : float , id : int) {
        var    components : array<CComponent>;
        var       manager : CMorphedMeshManagerComponent;
        var             j : int;

        if (NTR_blendTime) {
            components = GetComponentsByClassName('CMorphedMeshManagerComponent');
            if (components.Size() == 0) {
                //NTR_notify("Not found morph managers for " + this);
            }
            for (j = 0; j < components.Size(); j += 1) {
                manager = (CMorphedMeshManagerComponent) components[j];
                if (manager) {
                    manager.SetMorphBlend( NTR_morphRatio, NTR_blendTime );
                    //NTR_notify("[OK] Morph component: " + manager + " to <" + NTR_morphRatio + "> in " + NTR_blendTime + " sec");
                }
            }
        }
    }
}
