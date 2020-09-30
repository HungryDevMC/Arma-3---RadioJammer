call compile preprocessFileLineNumbers "RadioJammer.sqf";
sleep 5;

_radioJammerInstance = ["new", [nil, nil]] call RadioJammer;
["createJammers", [20000, 3000, 5000]] call _radioJammerInstance;