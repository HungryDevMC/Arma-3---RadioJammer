

cl_Mission_MapUtil_constructor = { _this select 0 };

Mission_MapUtil_GetBuildingsOfTypeOnMap = {  params ["_buildingType"]; scopeName "GetBuildingsOfTypeOnMap";
    private ["_buildingsOnMap", "_worldObject"];
    _buildingsOnMap = [];
    {
        _worldObject = _x;
        if ([_buildingType, format ["%1", _worldObject]] call BIS_fnc_inString) then {
            _buildingsOnMap pushBack _worldObject; };
    } forEach 
    allMissionObjects "ALL";
    (_buildingsOnMap) breakOut "GetBuildingsOfTypeOnMap"; };