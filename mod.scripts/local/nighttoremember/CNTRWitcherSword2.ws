/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CNTRWitcherSword2 extends CWitcherSword
{
	public var                  swordAuthor : String;
    private var           aceroEffectActive : Bool;
    private var  restoredPlayerEnhancements : Bool;
    private var          playerEnhancements : CInventoryComponent;

    default          aceroEffectActive = false;
    default restoredPlayerEnhancements = true;

	/*function PlayEffect( effectName : name, optional target : CNode  ) : bool {
        NTR_notify("[sword] PlayEffect(" + effectName + ", " + target + ")");
        return super.PlayEffect(effectName, target);
    }*/

    public function UpdateEnhancements( invComp : CInventoryComponent )
    {
        playerEnhancements = invComp;

        // prevent interrupting acero effect
        if ( !aceroEffectActive ) {
            super.UpdateEnhancements( invComp );
        }
    }

    public function Initialize( actor : CActor )
    {
        super.Initialize( actor );
        if ( aceroEffectActive ) {
            PlayEffect( 'rune_blast_loop' );
        }
    }

    event OnGrab()
    {
        super.OnGrab();
        
        NTR_notify("[sword] OnGrab");

        if ( GetRainStrength() > 0 ) {
            activateAceroEffect( true );
        } else {
            activateAceroEffect( false );
        }

        AddTimer( 'UpdateAceroEffect', 5.0f, true);
    }
    
    event OnPut()
    {
        super.OnPut();
        
        NTR_notify("[sword] OnPut");

        RemoveTimer( 'UpdateAceroEffect' );
        activateAceroEffect( false );
    }

    timer function UpdateAceroEffect( time : float, id : int ) {
        NTR_notify("[sword] Rain strength: " + GetRainStrength());

        if ( GetRainStrength() > 0 ) {
            activateAceroEffect( true );
        } else {
            activateAceroEffect( false );
        }
    }

    function activateAceroEffect( activate : Bool ) {
        if ( activate && !aceroEffectActive ) {
            aceroEffectActive = true;
            restoredPlayerEnhancements = false;

            PlayEffect( 'rune_lvl3' );
            PlayEffect( 'rune_blast_loop' );
            PlayEffect( 'rune_elemental' );
            PlayEffect( 'runeword_placation' );

        } else if ( !activate && aceroEffectActive ) {
            aceroEffectActive = false;
            restoredPlayerEnhancements = false;

            PlayEffect( 'rune_blast_long' );
            /* StopEffectIfActive( 'rune_lvl3' );
            StopEffectIfActive( 'runeword_placation' );
            StopEffectIfActive( 'rune_dazhbog' ); */

        } else if ( !activate && !aceroEffectActive && !restoredPlayerEnhancements ) {
            aceroEffectActive = false;
            restoredPlayerEnhancements = true;

            // return player runes
            if ( playerEnhancements ) {
                UpdateEnhancements( playerEnhancements );
            }
        }
    }
}
