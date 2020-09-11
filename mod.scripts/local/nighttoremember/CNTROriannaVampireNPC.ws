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

    event OnTakeDamage( action : W3DamageAction ) {
        super.OnTakeDamage( action );

        if ( HasTag('ntr_orianna_bruxa') && GetHealthPercents() < 0.25 ) {
            SetAnimMultiplier();         
        }
    }

    event OnAnimEvent_DeactivateSide( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
    {
        super.OnAnimEvent_DeactivateSide(animEventName, animEventType, animInfo); 
        NTR_notify("OnAnimEvent_DeactivateSide");    
    }
    
    event OnAnimEvent_DeactivateUp( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
    {
        super.OnAnimEvent_DeactivateUp(animEventName, animEventType, animInfo);
        NTR_notify("OnAnimEvent_DeactivateUp");      
    }
}
