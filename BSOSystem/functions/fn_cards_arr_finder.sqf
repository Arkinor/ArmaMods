params ["_arr_suf", "_pl"];

_basePrefix = "BSO_System_ids_";
_arr_cards = getArray (configFile >> "CfgPatches" >> "BSO_System_Main" >> "Cards_ids_arr");

_ret = false;

{
    _className = _x;

    if (count _className > count _basePrefix) then {
        
        _suf = _className select [count _basePrefix];

        if (_arr_suf findIf { _x isEqualTo _suf } != -1) then {
            
            if (_className in items _pl) exitWith {
                _ret = true;
            };
        };
    };
} forEach _arr_cards;

_ret