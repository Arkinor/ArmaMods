params ["_pl", "_timerCD"];

if ((gestureState _pl == "BSO_System_Gest_Heal") or
!(alive _pl) or
(lifeState _pl == "inCAPACITATED")) exitwith {};

if (stance _pl == "PRONE") exitwith {
    systemChat "You heal yourself while prone";
};

[_pl, "BSO_System_armor_TakingBattery", 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

_stim = "JLTS_GH_drugs_electrolit" createvehicle [0, 0, 0];

_stim attachto [_pl, [0.01, -0.1, 0.02], "LeftHand", true];

_y =0;
_p = 180;
_r = 0;
_stim setvectorDirAndUp [
    [sin _y * cos _p, cos _y * cos _p, sin _p],
    [[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D
];

_pl playGesture "BSO_System_Gest_Heal";

uiSleep 0.5;

if !(gestureState _pl == "BSO_System_Gest_Heal") exitwith {
    deletevehicle _stim;
};

[_pl, "BSO_System_openSyringe", 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

uiSleep 0.5;

if !(gestureState _pl == "BSO_System_Gest_Heal") exitwith {
    deletevehicle _stim;
};

[_pl, "BSO_System_useSyringe", 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

[_pl, _timerCD] spawn {
    params ["_pl", "_timerCD"];
    
    if (_pl getVariable ["BSO_System_Stimulator_Activ", false]) exitwith {};
    
    [_pl] call ace_medical_treatment_fnc_fullHeallocal;
    
    _pl setVariable ["ace_medical_allowdamage", false, true];
    
    _pl setVariable ["BSO_System_Stimulator_Activ", true];

    ["stim_ui_green", ""] spawn BSO_System_fnc_ctrl_filling;
    
    [{
        _pl = _this#0;
        _pl setVariable ["ace_medical_allowdamage", true, true];
        ["stim_ui_yellow", "stim_ui_green"] spawn BSO_System_fnc_ctrl_filling;
        [
            {
                _this#0 setVariable ["BSO_System_Stimulator_Activ", false];
                ["", "stim_ui_yellow"] spawn BSO_System_fnc_ctrl_filling;
            },
            [_pl],
            60
        ] call CBA_fnc_waitandexecute;
    }, [_pl], 60] call CBA_fnc_waitandexecute;
};

uiSleep 0.1;

_pl setVariable ["ace_medical_bodypartdamage", nil, true];

uiSleep 0.33;

deletevehicle _stim;

if !(gestureState _pl == "BSO_System_Gest_Heal") exitwith {};

[_pl, "BSO_System_Swing_1", 5] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
