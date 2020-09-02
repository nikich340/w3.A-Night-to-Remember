class CNTROriannaBruxaNPC extends CNTROriannaVampireNPC {
    editable saved var NTR_animationMultiplier : float;
    saved var             NTR_slowdownCauserId : int;
    saved var                  NTR_slowdownSet : Bool;

    default NTR_slowdownSet = false;

    event OnTakeDamage( action : W3DamageAction ) {
        super.OnTakeDamage( action );

        if ( GetHealthPercents() < 0.25 ) {
            SetAnimMultiplier();            
        }
    }
    event OnDeath( damageAction : W3DamageAction  ) {
        ResetAnimMultiplier();
        super.OnDeath( damageAction );
    }

    function SetAnimMultiplier() {
        if (NTR_slowdownSet)
            return;
        NTR_slowdownCauserId = SetAnimationSpeedMultiplier( NTR_animationMultiplier );
        LogChannel('CNTROriannaBruxaNPC', "SetAnimationSpeedMultiplier to: " + NTR_animationMultiplier);
        NTR_slowdownSet = true;
    }
    function ResetAnimMultiplier() {
        if (!NTR_slowdownSet)
            return;
        ResetAnimationSpeedMultiplier( NTR_slowdownCauserId );
        NTR_slowdownSet = false;
    }
}
