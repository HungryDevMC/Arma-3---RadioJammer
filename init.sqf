call compile preprocessFileLineNumbers "OO_RADIOJAMMER.sqf";
sleep 1;

_radioJammerInstance = ["new", [nil, nil]] call OO_RADIOJAMMER;
["createJammers", [3000, 5000]] call _radioJammerInstance;
