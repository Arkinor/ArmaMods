_BSO_System_fnc_Mashalat_nadet = {
    params ["_halat", "_pl"];
    
    if (!(isnil {
        _pl getVariable 'BSO_System_uniform'
    })) exitwith {
        _pl forceAdduniform _halat;
    };
    
    _uniform = uniform _pl;
    _item = uniformItems _pl;
    _arr = [_uniform, _item];
    _pl setVariable ["BSO_System_uniform", _arr];
    _pl forceAdduniform _halat;
    [_pl] call BSO_System_fnc_changePlayerSide;
};

params ["_value", "_pl"];

switch (true) do {
    case (_value == 1): {
        ["U_B_FullGhillie_ard", _pl] spawn _BSO_System_fnc_Mashalat_nadet;
    };
    case (_value == 2): {
        ["U_B_FullGhillie_lsh", _pl] spawn _BSO_System_fnc_Mashalat_nadet;
    };
    case (_value == 3): {
        ["U_B_FullGhillie_sard", _pl] spawn _BSO_System_fnc_Mashalat_nadet;
    };
    case (_value == 4): {
        ["U_B_T_FullGhillie_tna_F", _pl] spawn _BSO_System_fnc_Mashalat_nadet;
    };
    case (_value == 5): {
        _arr = _pl getVariable "BSO_System_uniform";
        _uniform = _arr#0;
        _items = _arr#1;
        _pl forceAdduniform _uniform;
        {
            _pl addItemtouniform _x;
        } forEach _items;
        _pl setVariable ["BSO_System_uniform", nil];
        _pl setUnitTrait ["audibleCoef", 1];
        _pl setUnitTrait ["camouflageCoef", 1];
        [_pl] call BSO_System_fnc_changePlayerSide;
    };
};