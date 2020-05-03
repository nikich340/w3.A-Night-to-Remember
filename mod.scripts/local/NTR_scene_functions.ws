latent storyscene function NTRPlayMusicScene( player : CStoryScenePlayer, areaName : string, eventName : string) {
	if ( areaName == "toussaint" )
		theSound.InitializeAreaMusic( (EAreaName)AN_Dlc_Bob );
	else
		theSound.InitializeAreaMusic( AreaNameToType(areaName) );
	
	theSound.SoundEvent( eventName );
}