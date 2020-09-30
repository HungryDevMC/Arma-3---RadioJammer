params ["_worldSize"];

_mapCenterPosition = [_worldSize / 2, _worldSize / 2, 0];

_tallTowerList = [_xpos,_ypos] nearObjects ["Land_TTowerBig_2_F", _worldSize];
_smallTowerList = [_xpos,_ypos] nearObjects ["Land_TTowerBig_1_F", _worldSize];
