["JammerHandler", "OnSpeak", {
    _radioJammerInstance = ["new", [nil, nil]] call OO_RADIOJAMMER;
    _totalInterference = ["totalInterferenceOfTowers", _this select 0] call _radioJammerInstance;
    //hint format["Total interference: %1", _totalInterference];

}, _this select 0] call TFAR_fnc_addEventHandler;
