params ["_pl"];

if (_pl getVariable ["BSO_Sys_speed_toggle", false]) then {
    [_pl, "minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_pl, 1] remoteExec ["setanimspeedCoef", 0];
    _pl setVariable ["BSO_Sys_speed_toggle", false];
    ["", "speed_ui_green"] spawn BSO_System_fnc_ctrl_filling;
} else {
    _pl say3D "ACE_hit_Male06ENG_high_1";
    [_pl, 1.5] remoteExec ["setanimspeedCoef", 0];
    _pl setVariable ["BSO_Sys_speed_toggle", true];
    ["speed_ui_green", ""] spawn BSO_System_fnc_ctrl_filling;
};