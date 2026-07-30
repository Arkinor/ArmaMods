params ["_pos"];

if (!isServer) exitWith {};

private _light = createVehicle ['Chemlight_green', _pos, [], 0, 'CAN_COLLIDE'];
_light setPosATL _pos;

private _smoke = createVehicle ['SmokeShellGreen', _pos, [], 0, 'CAN_COLLIDE'];
_smoke setPosATL _pos;

[_light, _smoke, _pos] spawn {
    params ["_light", "_smoke", "_healPos"];
    private _healDuration = 5;
    private _startTime = time;
    private _notifiedUnits = [];
    
    while { (time - _startTime) < _healDuration } do {
        if (isNull _light || isNull _smoke) exitWith {};
        
        private _units = _healPos nearEntities ['Man', 3];
        {
            private _unit = _x;
            if (alive _unit && isDamageAllowed _unit) then {
                if (!(_unit in _notifiedUnits)) then {
                    _notifiedUnits pushBack _unit;
                    if (isPlayer _unit) then {
                        if (!isNil "lucas_fnc_showNotification") then {
                            ["Это бакта граната, вы получаете лечение", "success", 3] remoteExecCall ["lucas_fnc_showNotification", _unit];
                        } else {
                            ["Это бакта граната, вы получаете лечение"] remoteExecCall ["hint", _unit];
                        };
                    };
                };
                [_unit] remoteExecCall ["BSO_System_fnc_healGrenadeUnit", _unit];
            };
        } forEach _units;
        
        sleep 0.5;
    };
    
    if (!isNull _light) then {
        deleteVehicle _light;
    };
    if (!isNull _smoke) then {
        deleteVehicle _smoke;
    };
};

