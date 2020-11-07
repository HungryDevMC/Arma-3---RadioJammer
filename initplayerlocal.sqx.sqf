call compile preprocessFileLineNumbers "Mission\RadioJammer.sqx.sqf";



private ["_radioJammerInstance", "_totalInterference", "_playerSpeaking"];

_playerSpeaking = param [0];






["JammerHandler", "OnSpeak", { _radioJammerInstance = ([[["Mission_RadioJammer",["Mission.IRadioJammer"]]], [3000, objNull]] call cl_Mission_RadioJammer_constructor); _totalInterference = ([_radioJammerInstance, [_playerSpeaking]] call cl_Mission_RadioJammer_GetTotalInterferenceOfTowers); hint format ["Total interference: %1", _totalInterference]; }, param [0]] call TFAR_fnc_addEventHandler;