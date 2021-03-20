/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/
class CNTRWitcherSword extends CWitcherSword
{
	public       var                  swordAuthor : String;
    private saved var           aceroEffectActive : Bool;

    default                     aceroEffectActive = false;

    event OnSpawned( spawnData : SEntitySpawnData )
    {
        super.OnSpawned( spawnData );
        AddTimer( 'OnSpawnCheck', 1.0f, false);
    }

    public function ApplyOil( oilAbilityName : name )
    {
        /* oil fx is not good, disable it */
        //PlayEffect( GetOilFxName( oilAbilityName ) );
        return;
    }

    event OnGrab()
    {
        super.OnGrab();

        if ( GetRainStrength() > 0 ) {
            activateAceroEffect( true );
        }
        AddTimer( 'UpdateAceroEffect', 5.0f, true);
    }
    
    event OnPut()
    {
        super.OnPut();

        RemoveTimer( 'UpdateAceroEffect' );
        activateAceroEffect( false );
    }

    function useFakeOil() {
        var           ids : array<SItemUniqueId>;
        var thisId, playerSwordId : SItemUniqueId;
        var          slot : EEquipmentSlots;
        
        thisId = thePlayer.GetInventory().GetItemByItemEntity( this );
        
        if ( thisId != GetInvalidUniqueId() ) {
            ids = thePlayer.inv.AddAnItem('Acero fake oil', 1, true, true);
            thePlayer.ApplyOil(ids[0], thisId);
            thePlayer.inv.RemoveItem(ids[0]);

        }
    }

    function removeFakeOil() {
        var   oils : array<W3Effect_Oil>;
        var      i : int;
        var thisId : SItemUniqueId;

        thisId = thePlayer.GetInventory().GetItemByItemEntity( this );
        oils = thePlayer.inv.GetOilsAppliedOnItem( thisId );

        for (i = 0; i < oils.Size(); i += 1) {
            if (oils[i].GetOilItemName() == 'Acero fake oil') {
                thePlayer.RemoveEffect( oils[i] );
            }
        }
    }

    timer function OnSpawnCheck( time : float, id : int ) {
        var thisId : SItemUniqueId;

        thisId = thePlayer.GetInventory().GetItemByItemEntity( this );
        
        if ( thisId != GetInvalidUniqueId() && thePlayer.inv.IsItemHeld( thisId ) ) {
            if ( GetRainStrength() > 0 ) {
                activateAceroEffect( true );
            }
            AddTimer( 'UpdateAceroEffect', 5.0f, true);
        }
    }

    timer function UpdateAceroEffect( time : float, id : int ) {
        if ( GetRainStrength() > 0 ) {
            activateAceroEffect( true );
        } else {
            activateAceroEffect( false );
        }
    }

    function activateAceroEffect( activate : Bool ) {
        if ( activate && !aceroEffectActive ) {
            NTR_notify("activateAceroEffect: ACTIVATE!");
            aceroEffectActive = true;

            useFakeOil();
            PlayEffect('acero_charged');
        } else if ( !activate && aceroEffectActive ) {
            NTR_notify("activateAceroEffect: DEACTIVATE!");
            aceroEffectActive = false;

            removeFakeOil();
            StopEffectIfActive('acero_charged');
        }
    }
}
