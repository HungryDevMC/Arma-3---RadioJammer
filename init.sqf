#include "oop.h"

call compile preprocessFileLineNumbers "RadioJammer.sqf";
["createJammers", [20000, 3000, 5000]] call RadioJammer.INSTANCE;