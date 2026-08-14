params ["_pl"];

if (isnil {
    vehicle _pl getVariable 'BSO_System_vehicle_Defender'
}) then {
    _veh = vehicle _pl;
    _veh setVariable ["BSO_System_vehicle_Defender", true];
    _EH_Veh = _veh addEventHandler ["Engine", {
        params ["_vehicle", "_engineState"];
        _mine = createvehicle ["Bo_GBU12_LGB", position _vehicle, [], 0, "CAN_COLLIDE"];
        [_mine, true] remoteExec ["hideObjectglobal", 2, false];
        _mine attachto [_vehicle];
        _mine setDamage 1;
    }];
    _veh setVariable ["BSO_System_vehicle_EventHandler", _EH_Veh];
    ["car_ui_red", ""] spawn BSO_System_fnc_ctrl_filling;
} else {
    _veh = vehicle _pl;
    _E_H = _veh getVariable "BSO_System_vehicle_EventHandler";
    _veh removeEventHandler ["Engine", _E_H];
    _veh setVariable ["BSO_System_vehicle_Defender", nil];
    _veh setVariable ["BSO_System_vehicle_EventHandler", nil];
    ["", "car_ui_red"] spawn BSO_System_fnc_ctrl_filling;
};