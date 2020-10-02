#include "oop.h"

CLASS("OO_RADIOJAMMER")

	PRIVATE STATIC_VARIABLE("array", "RADIOTOWERS");
	PRIVATE STATIC_VARIABLE("scalar", "INTERFERENCE");
	PUBLIC VARIABLE("scalar", "range");
	PUBLIC VARIABLE("object", "tower");
	PUBLIC VARIABLE("scalar", "destroyed");

	PUBLIC FUNCTION("array", "constructor") {
		MEMBER("range", _this select 0);
		MEMBER("tower", _this select 1);
		MEMBER("destroyed", 0);
	};

	PUBLIC FUNCTION("", "deconstructor") {};

	PRIVATE FUNCTION("string", "getBuildingOfTypeOnMap") {
			_buildingsOnMap = [];
			{
				if([_this, format ["%1",_x]] call BIS_fnc_inString) then {
					_buildingsOnMap append [_x];
				};
			}forEach allMissionObjects "ALL";
			_buildingsOnMap;
	};

	PUBLIC FUNCTION("object", "objectInRangeOfTower") {
			_distanceBetween = MEMBER("distanceToJammer", _this);
			_towerRange = MEMBER("range", nil);
			_inRange = 0;
			//hint format["Distance: %1, tower range: %2", _distanceBetween, _towerRange];
			if((_distanceBetween <= _towerRange)) then {
				_inRange = 1;
			};
			_inRange;
	};

	PRIVATE FUNCTION("object", "distanceToJammer") {
			private _tower = "tower" call _radiojammer;
			hint format["Tower: %1, object: %2", _tower, getPos _this];
			_distance = (getPos _this) distance (getPos _tower);
			//hint format["Distance: %1", str _distance];
			_distance;
	};

	PRIVATE FUNCTION("object", "towersInRange") {
			_towersInRange = [];
			{
					_towerObject = "tower" call _x;
					_towerDestroyed = "destroyed" call _x;
					_isInRange = ["objectInRangeOfTower", _this] call _x;
					//hint format["Player is in range of tower: %1 and is not destroyed: %2", _isInRange isEqualTo 1, _towerDestroyed isEqualTo 0];
					if((_isInRange isEqualTo 1) && (_towerDestroyed isEqualTo 0)) then {
							hint format ["Adding tower to list"];
							_towersInRange append [_x];
					};
			}forEach MEMBER("RADIOTOWERS", nil);
			_towersInRange;
	};

	PRIVATE FUNCTION("object", "calculateInterferenceOfTower") {
			_distanceBetween = MEMBER("distanceToJammer", _this);
			_interference = MEMBER("INTERFERENCE", nil);
			_towerRange = MEMBER("range", nil);
			((_interference * ((_towerRange - _distanceBetween) / _towerRange)) + (_interference / 2));
	};

	PUBLIC FUNCTION("", "drawRangeOnMap") {
			private _towerObject = MEMBER("tower", nil);
			private _towerLocation = getPos _towerObject;
			private _jammerRadius = MEMBER("range", nil);
			_towerMarker = createMarker [format["jammerTower%1", _towerObject], _towerLocation];
			_towerMarker setMarkerShape "ELLIPSE";
			_towerMarker setMarkerColor "ColorOPFOR";
			_towerMarker setMarkerSize [_jammerRadius, _jammerRadius];
			_towerMarker setMarkerBrush "Solid";
			_towerMarker setMarkerAlpha 0.25;

			_towerMarkerOverlay = createMarker [format["jammerTowerOverlay%1", _towerObject], _towerLocation];
			_towerMarkerOverlay setMarkerShape "ELLIPSE";
			_towerMarkerOverlay setMarkerColor "ColorBlack";
			_towerMarkerOverlay setMarkerSize [_jammerRadius, _jammerRadius];
			_towerMarkerOverlay setMarkerBrush "FDiagonal";
	};

	PUBLIC FUNCTION("object", "totalInterferenceOfTowers") {
			_towersInRange = MEMBER("towersInRange", _this);
			//hint format["Towers in range: %1", _towerRange];
			_totalInterference = 0;
			{
					_towerInterference = MEMBER("calculateInterferenceOfTower", _this);
					_totalInterference = _totalInterference + _towerInterference;
			}forEach _towersInRange;
			_totalInterference;
	};

	PUBLIC FUNCTION("array", "createJammers") {
		_smallRange = _this select 0;
		_largeRange = _this select 1;
		MEMBER("INTERFERENCE", 3.5);
		MEMBER("RADIOTOWERS", []);

		_smallTowerList = MEMBER("getBuildingOfTypeOnMap", "ttowerbig_1_f");
		{
			_jammerTowerObject = ["new", [_smallRange, _x]] call OO_RADIOJAMMER;
			MEMBER("RADIOTOWERS", nil) pushback _jammerTowerObject;
			"drawRangeOnMap" call _jammerTowerObject;
		}forEach _smallTowerList;

		_tallTowerList = MEMBER("getBuildingOfTypeOnMap", "ttowerbig_2_f");
		{
			_jammerTowerObject = ["new", [_largeRange, _x]] call OO_RADIOJAMMER;
			MEMBER("RADIOTOWERS", nil) pushback _jammerTowerObject;
			"drawRangeOnMap" call _jammerTowerObject;
		}forEach _tallTowerList;
	};

ENDCLASS;
