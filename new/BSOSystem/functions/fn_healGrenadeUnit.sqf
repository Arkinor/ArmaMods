params ["_unit"];

if (!local _unit) exitWith {};

if (isNil "ace_medical_treatment_fnc_findMostEffectiveWounds") exitWith {};

private _bodyParts = ["head", "body", "leftarm", "rightarm", "leftleg", "rightleg"];
{
    private _i = _foreachindex;
    private _hasWounds = false;
    private _effectiveness = -1;
    
    if (!isNil "ace_medical_treatment_fnc_findMostEffectiveWounds") then {
        private _wounds = [_unit, "ElasticBandage", _x] call ace_medical_treatment_fnc_findMostEffectiveWounds;
        if (count _wounds > 0) then {
            _hasWounds = true;
            {
                _y params ["_woundEffectiveness"];
                if (_woundEffectiveness > _effectiveness) then {
                    _effectiveness = _woundEffectiveness;
                };
            } forEach _wounds;
        };
    };
    
    if (_hasWounds && _effectiveness != -1) then {
        if (!isNil "ace_medical_treatment_fnc_bandageLocal") then {
            [_unit, _x, "ElasticBandage"] call ace_medical_treatment_fnc_bandageLocal;
        };
        private _bv = _unit getVariable["ace_medical_bloodvolume", 6];
        _unit setVariable["ace_medical_bloodvolume", (_bv + 0.08) min 6, true];
        private _pain = _unit getVariable["ace_medical_pain", 0];
        _unit setVariable["ace_medical_pain", ((_pain - 0.05) max 0) min 1, true];
    } else {
        private _bv = _unit getVariable["ace_medical_bloodvolume", 6];
        _unit setVariable["ace_medical_bloodvolume", (_bv + 0.02) min 6, true];
        private _pain = _unit getVariable["ace_medical_pain", 0];
        _unit setVariable["ace_medical_pain", ((_pain - 0.02) max 0) min 1, true];
        
        if ((_i == 4) || (_i == 5)) then {
            _unit setDamage 0;
        };
        
        if ((_i == 0) && !isNil "kat_airway_fnc_treatmentAdvanced_turnaroundHead" && (_unit getVariable ["kat_breathing_airwaystatus", 100] <= 95)) then {
            _unit setVariable ["kat_airway_occluded", false, true];
            [_unit, _unit] call kat_airway_fnc_treatmentAdvanced_turnaroundHead;
            if (!isNil "kat_airway_fnc_treatmentAdvanced_airwayLocal") then {
                [_unit, _unit, "Larynxtubus"] call kat_airway_fnc_treatmentAdvanced_airwayLocal;
            };
        };
        
        private _bd = _unit getVariable["ace_medical_fractures", [0, 0, 0, 0, 0, 0]];
        if ((_bd select _i) == 1) then {
            _bd set [_i, -1];
        };
    };
} forEach _bodyParts;

if (_unit getVariable "kat_breathing_pneumothorax" > 0) then {
    _unit setVariable ["kat_breathing_pneumothorax", 0, true];
    _unit setVariable ["kat_breathing_deepPenetratingInjury", false, true];
};

if (_unit getVariable["ace_medical_heartRate", 80] == 0) then {
    ["ace_medical_CPRSucceeded", _unit] call CBA_fnc_localEvent;
};

