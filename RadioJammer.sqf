#include "oop.h"

CLASS("RadioJammer")

	PUBLIC STATIC_VARIABLE("array", "RADIO_TOWERS");
	PUBLIC VARIABLE("SCALAR", "range");
	PUBLIC VARIABLE("OBJECT", "tower");
	PUBLIC VARIABLE("SCALAR", "destroyed");

	PUBLIC STATIC_VARIABLE("object", "tempTower");
	PUBLIC STATIC_VARIABLE("scalar", "tempRange");

	PUBLIC FUNCTION("ARRAY", "constructor") {
		MEMBER("range", _this select 0);
		MEMBER("tower", _this select 1);
		MEMBER("destroyed", 0);
		MEMBER("tempTower", nil);
		MEMBER("tempRange", nil);
	};
	PUBLIC FUNCTION("", "deconstructor") {};

	PUBLIC FUNCTION("ARRAY", "createJammers") {
		_worldSize = _this select 0;
		_smallRange = _this select 1;
		_largeRange = _this select 2;
		_mapCenterPosition = _worldSize / 2;

		_tallTowerList = [_mapCenterPosition, _mapCenterPosition] nearObjects ["Land_TTowerBig_2_F", _worldSize];
		_smallTowerList = [_mapCenterPosition, _mapCenterPosition] nearObjects ["Land_TTowerBig_1_F", _worldSize];

		{
			_towerObject = ["new", [_largeRange, _x]] call RadioJammer;
			MEMBER("RADIO_TOWERS", nil) pushBack _towerObject;

			_towerLocation = getPos _x;
			_towerMarker = createMarker ["JammerTowerTall", _towerLocation];
			_towerMarker setMarkerShape "ELLIPSE";
			_towerMarker 

			MEMBER("tempTower", _x);
			MEMBER("tempRange", _largeRange);

		} forEach _tallTowerList;

		{
			_towerObject = ["new", [_smallRange, _x]] call RadioJammer;
			MEMBER("RADIO_TOWERS", nil) pushBack _towerObject;

			_towerLocation = getPos _x;
			_towerMarker = createMarker ["JammerTowerSmall", _towerLocation];
			_towerMarker setMarkerType "hd_dot";

			MEMBER("tempTower", _x);
			MEMBER("tempRange", _smallRange);
			findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw",
			{
				_tempTowerPosition = getPos MEMBER("tempTower", nil);
				_tempRange = MEMBER("tempRange", nil);
				_this select 0 drawEllipse [
					_tempTowerPosition, _tempRange, _tempRange, 0, [255, 0, 0, 1], ""
				];
			}];
		} forEach _smallTowerList;
	};

ENDCLASS;
