call compile preprocessFileLineNumbers "Mission\MapUtil.sqx.sqf";
call compile preprocessFileLineNumbers "Mission\RadioJammer.sqx.sqf";



[3000, 5000, 3.5] call Mission_RadioJammer_CreateJammers;








["JammerHandler", "OnSpeak", { private ["_radioJammerInstance", "_totalInterference"]; _radioJammerInstance = ([[["Mission_RadioJammer",["Mission.IRadioJammer"]]], [3000, objNull]] call cl_Mission_RadioJammer_constructor); _totalInterference = ([_radioJammerInstance, [param [0]]] call cl_Mission_RadioJammer_GetTotalInterferenceOfTowers); hint format ["Position of player: %1", (getPos param [0])]; }, objNull] call TFAR_fnc_addEventHandler;