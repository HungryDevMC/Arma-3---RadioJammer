#include "oop.h"

CLASS("RadioJammer")

	PUBLIC STATIC_VARIABLE("code", "INSTANCE");
	MEMBER("INSTANCE", NEW(RadioJammer, [nil, nil]));
	PUBLIC STATIC_VARIABLE("array", "RADIO_TOWERS");	
	PRIVATE VARIABLE("SCALAR", "range");
	PRIVATE VARIABLE("OBJECT", "position");
	PRIVATE VARIABLE("SCALAR", "destroyed");

	PUBLIC FUNCTION("ARRAY", "constructor") {
		MEMBER("range", _this select 0);	
		MEMBER("position", _this select 1);
		MEMBER("isDestroyed", 0);
	};
	PUBLIC FUNCTION("", "deconstructor") {};

	PUBLIC FUNCTION("ARRAY", "createJammers") {
		_worldSize = _this select 0;
		_smallRange = _this select 1;
		_largeRange = _this select 2;
		_mapCenterPosition = [_worldSize / 2, _worldSize / 2, 0];

		_tallTowerList = [_mapCenterPosition, _mapCenterPosition] nearObjects ["Land_TTowerBig_2_F", _worldSize];
		_smallTowerList = [_mapCenterPosition, _mapCenterPosition] nearObjects ["Land_TTowerBig_1_F", _worldSize];

		{
			MEMBER("cacheTower", NEW(RadioJammer, [_largeRange, getPos _x]));
		} forEach _tallTowerList

		{
			MEMBER("cacheTower", NEW(RadioJammer, [_smallRange, getPos _x]));
		} forEach _smallTowerList
	};

	PUBLIC FUNCTION("CODE", "cacheTower") {
		MEMBER("RADIO_TOWERS", _this) pushBack "RADIO_TOWERS";
		private _towerPosition = MEMBER("position", nil);
		private _towerRange = MEMBER("range", nil);
		drawEllipse [_towerPosition, _towerRange, _towerRange, 360, [255, 0, 0, 0.5], "#(rgb,255,0,0)color(1,0,0,1)"]
	};
}

ENDCLASS;