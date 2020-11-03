/*
class CCustomScent extends CGameplayEntity
{
	//import saved var isSaveable : bool;
	editable saved var isScentEnabled         : bool; default isScentEnabled = false;
	editable saved var scentPoints            : array<Vector>;
	editable saved var scentPointsDistance    : float; default scentPointsDistance = 0.5f;

	var currentDirection                 : int; default currentDirection = 1;
	var nextPoint                        : int; default nextPoint = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
		//isSaveable = true;
		AddTimer( 'UpdateScent', 0.1f, true , , , true, true );
		if (scentPoints.Size() < 2)
			LogChannel('UpdateScent', "[WARNING] Path contains less then two points!");
	}

	function setScentEnabled(enabled : bool) {
		isScentEnabled = enabled;
	}
	function setScentPoints(points : array<Vector>) {
		if (points.Size() > 0) {
			scentPoints = points;
			LogChannel('CCustomScent', "[OK] Set new scent points(" + scentPoints.Size() + ")");
		}
	}
	function setScentDistance(dist : float) {
		if (dist > 0.0f) {
			scentPointsDistance = dist;
			LogChannel('CCustomScent', "[OK] Set new dist(" + scentPointsDistance + ")");
		}
	}
	function FindNextPoint() {
		nextPoint += currentDirection;
		if (nextPoint == scentPoints.Size()) {
			nextPoint -= 2;
			currentDirection *= -1;
		}
		if (nextPoint == -1) {
			nextPoint += 2;
			currentDirection *= -1;
		}
	}
	function GetNextInterPoint() : Vector {
		var distToNext : float;
		var curPos : Vector;
		var ret    : Vector;

		if (scentPoints.Size() < 2) {
			return GetWorldPosition();
		}

		curPos = GetWorldPosition();
		distToNext = VecDistance(curPos, scentPoints[nextPoint]);
		if (distToNext < scentPointsDistance) {
			ret = scentPoints[nextPoint];
			FindNextPoint();
			return ret;
		} else {
			ret = GetWorldPosition() + (scentPoints[nextPoint] - GetWorldPosition()) / (distToNext / scentPointsDistance);
			return ret;
		}
	}

	timer function UpdateScent( time : float , id : int)
	{
		if (isScentEnabled && theGame.GetFocusModeController().IsActive()) {
			if (!IsEffectActive('focus_smell', false)) {
				PlayEffect('focus_smell');
			}
		} else {
			StopEffectIfActive('focus_smell');
		}
		Teleport(GetNextInterPoint());
	}
}	
*/