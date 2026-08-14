params ["_pl"];

if (_pl getVariable "ACE_isUnconscious" == true) then {
    if (_pl getVariable "BSO_System_AutoBacta" == false) then {
        hint "[SYS] Бакта использована, ожидайте";

        ["bacta_ui_green", ""] spawn BSO_System_fnc_ctrl_filling;

        [{
			_pl = _this;
            [_pl] call ace_medical_treatment_fnc_fullHeallocal;
            _pl setVariable ["BSO_System_AutoBacta", true];
            ["bacta_ui_yellow", "bacta_ui_green"] spawn BSO_System_fnc_ctrl_filling;
        }, _pl, 20] call CBA_fnc_waitandexecute;
        
        [{
            hint "[SYS] Бакта готова";
            _this setVariable ["BSO_System_AutoBacta", false];
            ["", "bacta_ui_yellow"] spawn BSO_System_fnc_ctrl_filling;
        }, _pl, 900] call CBA_fnc_waitandexecute;
    };
};