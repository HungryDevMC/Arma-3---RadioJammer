






cl_Mission_RadioJammer_Range_PropIndex = 1;
cl_Mission_RadioJammer_Tower_PropIndex = 2;
cl_Mission_RadioJammer_Destroyed_PropIndex = 3;

cl_Mission_RadioJammer_constructor = { params ["_class_fields", "_this"]; params ["_range", "_towerObject"]; 

    _class_fields set [1, _range];
    _class_fields set [2, _towerObject];
    _class_fields set [3, false]; _class_fields };



Mission_RadioJammer_CreateJammers = {  params ["_smallRange", "_largeRange", "_interference"]; 
    private ["_smallTowerList", "_tallTowerList", "_jammerTowerObject", "_mapUtil"];
    Mission_RadioJammer_RADIO_TOWERS = [];
    Mission_RadioJammer_INTERFERENCE = _interference;

    _mapUtil = ([[["Mission_MapUtil",[]]], []] call cl_Mission_MapUtil_constructor);
    _smallTowerList = ["ttowerbig_1_f"] call Mission_MapUtil_GetBuildingsOfTypeOnMap;
    {
        _jammerTowerObject = ([[["Mission_RadioJammer",["Mission.IRadioJammer"]]], [_smallRange, _x]] call cl_Mission_RadioJammer_constructor);
        Mission_RadioJammer_RADIO_TOWERS pushBack _jammerTowerObject;
        ([_jammerTowerObject, []] call cl_Mission_RadioJammer_DrawRangeOnMap);
    } forEach _smallTowerList;

    _tallTowerList = ["ttowerbig_2_f"] call Mission_MapUtil_GetBuildingsOfTypeOnMap;
    {
        _jammerTowerObject = ([[["Mission_RadioJammer",["Mission.IRadioJammer"]]], [_largeRange, _x]] call cl_Mission_RadioJammer_constructor);
        Mission_RadioJammer_RADIO_TOWERS pushBack _jammerTowerObject;
        ([_jammerTowerObject, []] call cl_Mission_RadioJammer_DrawRangeOnMap);
    } forEach _tallTowerList; };



cl_Mission_RadioJammer_IsObjectInRangeOfTower = { params ["_class_fields", "_this"]; params ["_objectToCheck"]; scopeName "IsObjectInRangeOfTower";
    private ["_distanceBetween", "_isInRange"];
    _distanceBetween = ([_class_fields, [_objectToCheck]] call cl_Mission_RadioJammer_GetDistanceToJammer);
    _isInRange = _distanceBetween <= (_class_fields select 1);
    (_isInRange) breakOut "IsObjectInRangeOfTower"; };



cl_Mission_RadioJammer_GetDistanceToJammer = { params ["_class_fields", "_this"]; params ["_objectInRange"]; scopeName "GetDistanceToJammer";
    private ["_distance"];
    _distance = (getPos _objectInRange) distance (getPos (_class_fields select 2));
    hint format ["Distance to tower: %1", _distance];
    (_distance) breakOut "GetDistanceToJammer"; };



cl_Mission_RadioJammer_GetInterferenceOfTower = { params ["_class_fields", "_this"]; params ["_objectInterfered"]; scopeName "GetInterferenceOfTower";
    private ["_distanceBetween", "_defaultInRange", "_multiplierOfDistance", "_totalInterference"];
    _distanceBetween = ([_class_fields, [_objectInterfered]] call cl_Mission_RadioJammer_GetDistanceToJammer);

    _defaultInRange = Mission_RadioJammer_INTERFERENCE / 2;
    _multiplierOfDistance = ((_class_fields select 1) - _distanceBetween) / (_class_fields select 1);
    _totalInterference = (Mission_RadioJammer_INTERFERENCE * _multiplierOfDistance) + _defaultInRange;
    (_totalInterference) breakOut "GetInterferenceOfTower"; };



cl_Mission_RadioJammer_GetTowersInRangeOfObject = { params ["_class_fields", "_this"]; params ["_objectToCheck"]; scopeName "GetTowersInRangeOfObject";
    private ["_towersInRange", "_jammer", "_isInRange"];
    _towersInRange = [];
    {
        _jammer = _x;
        _isInRange = ([_jammer, [_objectToCheck]] call cl_Mission_RadioJammer_IsObjectInRangeOfTower);
        if ((_isInRange isEqualTo true) && ((_jammer select 3) isEqualTo false)) then {
            _towersInRange append [_jammer]; };
    } forEach Mission_RadioJammer_RADIO_TOWERS;

    (_towersInRange) breakOut "GetTowersInRangeOfObject"; };



cl_Mission_RadioJammer_DrawRangeOnMap = { params ["_class_fields", "_this"];
    private ["_towerMarker", "_towerMarkerOverlay", "_towerLocation"];
    _towerLocation = getPos (_class_fields select 2);
    _towerMarker = createMarker [format ["jammerTower%1", (_class_fields select 2)], _towerLocation];
    _towerMarker setMarkerShape "ELLIPSE";
    _towerMarker setMarkerColor "ColorOPFOR";
    _towerMarker setMarkerSize [(_class_fields select 1), (_class_fields select 1)];
    _towerMarker setMarkerBrush "Solid";
    _towerMarker setMarkerAlpha 0.25;

    _towerMarkerOverlay = createMarker [format ["jammerTowerOverlay%1", (_class_fields select 2)], _towerLocation];
    _towerMarkerOverlay setMarkerShape "ELLIPSE";
    _towerMarkerOverlay setMarkerColor "ColorBlack";
    _towerMarkerOverlay setMarkerSize [(_class_fields select 1), (_class_fields select 1)];
    _towerMarkerOverlay setMarkerBrush "FDiagonal"; };



cl_Mission_RadioJammer_GetTotalInterferenceOfTowers = { params ["_class_fields", "_this"]; params ["_objectInRange"]; scopeName "GetTotalInterferenceOfTowers";
    private ["_towersInRange", "_totalInterference", "_towerInterference"];
    _towersInRange = ([_class_fields, [_objectInRange]] call cl_Mission_RadioJammer_GetTowersInRangeOfObject);

    _totalInterference = 0;
    _towerInterference = 0;
    {
        _towerInterference = ([_class_fields, [_objectInRange]] call cl_Mission_RadioJammer_GetInterferenceOfTower);

        _totalInterference = _totalInterference + _towerInterference;
    } forEach _towersInRange;
    (_totalInterference) breakOut "GetTotalInterferenceOfTowers"; };