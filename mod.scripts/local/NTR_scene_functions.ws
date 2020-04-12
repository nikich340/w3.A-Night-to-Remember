/*latent storyscene function teleportTriss( player : CStoryScenePlayer, tag : CName)
{	
	var choose : int;
	var trissNPC   : CNewNPC;
	
	choose = RandRange(9, 1);
	trissNPC = theGame.GetNPCByTag(tag);
	
	switch(choose) {
		case 2:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-5.9914569855, 16.1965332031, -0.5803833008) );
			break;
		case 3:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-6.1509609222, 20.0139160156, -0.7316284180) );
			break;
		case 4:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-9.6709680557, 12.0175781250, -0.5446777344) );
			break;
		case 5:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-12.9269695282, 11.5224609375, -0.5108032227) );
			break;
		case 6:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-4.3029670715, 7.1501464844, -0.2921752930) );
			break;
		case 7:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-4.5174674988, 3.7673339844, -0.2456665039) );
			break;
		case 8:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-1.7179527283, 11.9348144531, -0.2318725586) );
			break;
		case 9:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(1.1750526428, 11.5986328125, -0.2404174805) );
			break;
		default:
			trissNPC.Teleport( Vector(24.4257621765, -2107.7331542969, 126.1453247070) + Vector(-5.9749526978, 11.5041503906, -0.4548339844) );
			break;
	}
}*/
