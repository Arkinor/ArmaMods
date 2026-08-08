params ["_pl"];

["heal_ui_green", ""] spawn BSO_System_fnc_ctrl_filling;

hintSilent format["Автохил %1", _pl getVariable "BSO_System_Auto_Heal_Active"];

while {(_pl getVariable ["BSO_System_Auto_Heal_Active", true])} do {
    if (not alive _pl) exitwith {};
    
    _bodyParts = ["head", "body", "leftarm", "rightarm", "leftleg", "rightleg"];
    {
        _i = _forEachindex;
        _wounds = [_pl, "ElasticBandage", _x] call ace_medical_treatment_fnc_findMostEffectiveWounds;
        {
            _y params ["_effectiveness"];
            _pl setVariable ["phoenix_effectiveness", _effectiveness];
        } forEach _wounds;
        
        if (_pl getVariable "phoenix_effectiveness" != -1) then {
            [_pl, _x, "ElasticBandage"] call ace_medical_treatment_fnc_bandagelocal;
            _bv = _pl getVariable["ace_medical_bloodvolume", 6];
            _pl setVariable["ace_medical_bloodvolume", (_bv + 0.05) min 6, true];
            _pain = _pl getVariable["ace_medical_pain", 0];
            _pl setVariable["ace_medical_pain", ((_pain - 0.025) max 0) min 1, true];
            sleep 7;
        } else {
            _bv = _pl getVariable["ace_medical_bloodvolume", 6];
            _pl setVariable["ace_medical_bloodvolume", (_bv + 0.01) min 6, true];
            _pain = _pl getVariable["ace_medical_pain", 0];
            _pl setVariable["ace_medical_pain", ((_pain - 0.01) max 0) min 1, true];
            sleep 2;
            
            if ((_i == 4) || (_i == 5)) then {
                _pl setDamage 0;
            };
            if ((_i == 0) && (_pl getVariable ["kat_breathing_airwaystatus", 100] <= 95)) then {
                _pl setVariable ["kat_airway_occluded", false, true];
                [_pl, _pl] call kat_airway_fnc_treatmentAdvanced_turnaroundHead;
                [_pl, _pl, "Larynxtubus"] call kat_airway_fnc_treatmentAdvanced_airwaylocal;
                sleep 2;
            };
            _bd = _pl getVariable["ace_medical_fractures", [0, 0, 0, 0, 0, 0]];
            if ((_bd select _i) == 1) then {
                _bd set [_i, -1];
                sleep 9;
            };
        };
    } forEach _bodyParts;
    
    if (_pl getVariable "kat_breathing_pneumothorax" > 0) then {
        _pl setVariable ["kat_breathing_pneumothorax", 0, true];
        _pl setVariable ["kat_breathing_deepPenetratinginjury", false, true];
    };
    
    if (_pl getVariable["ace_medical_heartRate", 80] == 0) then {
        ["ace_medical_CPRSucceeded", _pl] call CBA_fnc_localEvent;
        sleep 25;
    };
};