params ["_targetPos", "_caller"];

if (!isServer) exitWith {
    [_targetPos, player] remoteExecCall ["BSO_System_fnc_artilleryStrike", 2];
};

if (isNull _caller || {!isPlayer _caller}) exitWith {};
if (remoteExecutedOwner > 0 && {owner _caller != remoteExecutedOwner}) exitWith {
    diag_log format ["[BSO Artillery] rejected spoofed caller remote=%1", remoteExecutedOwner];
};
private _hasHenkerCard = ((count BSO_Cards_Array) > 7) && ((BSO_Cards_Array select 7) in items _caller);
if (((name _caller) find "1171" < 0) && !_hasHenkerCard) exitWith {
    ["Артподдержка недоступна"] remoteExecCall ["hint", _caller];
};

private _pos = [0,0,0];
switch (true) do {
    case (_targetPos isEqualType objNull): {
        _pos = getPosATL _targetPos;
    };
    case (_targetPos isEqualType ""): {
        _pos = getMarkerPos _targetPos;
    };
    case (_targetPos isEqualType []): {
        if (count _targetPos >= 3) then {
            _pos = _targetPos;
        } else {
            if (count _targetPos >= 2) then {
                _pos = [_targetPos select 0, _targetPos select 1, 0];
            };
        };
    };
    default {
        _pos = [0,0,0];
    };
};
if (!(_pos isEqualType []) || {count _pos < 2}) exitWith {
    ["Ошибка: неверная позиция цели для артподдержки"] remoteExecCall ["hint", _caller];
};

private _cd = 600;
private _uid = getPlayerUID _caller;
private _key = format ["BSO_Artillery_Last_%1", _uid];
private _last = missionNamespace getVariable [_key, -1];
if (_last >= 0 && {(time - _last) < _cd}) exitWith {
    private _left = ceil (_cd - (time - _last));
    [format ["Артподдержка на КД. Осталось: %1 сек", _left]] remoteExecCall ["hint", _caller];
};
missionNamespace setVariable [_key, time];

private _strikeRadius = 50;
private _shellCount = 8;
private _delayBetweenShells = 2;

private _markerName = format ["BSO_Artillery_%1", round(time)];
private _marker = createMarker [_markerName, _pos];
_marker setMarkerType "mil_destroy";
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Артподдержка";
_marker setMarkerSize [1, 1];

[format ["Артподдержка по координатам %1", mapGridPosition _pos]] remoteExecCall ["hint", 0];
diag_log format ["[BSO_Artillery] Start: caller=%1 uid=%2 pos=%3 shells=%4 radius=%5", name _caller, _uid, _pos, _shellCount, _strikeRadius];

sleep 30;

for "_i" from 1 to _shellCount do {
    private _angle = random 360;
    private _distance = random _strikeRadius;
    private _posZ = if (count _pos > 2) then { _pos select 2 } else { 0 };
    private _shellPos = [
        (_pos select 0) + (_distance * cos _angle),
        (_pos select 1) + (_distance * sin _angle),
        _posZ
    ];

    [_shellPos] spawn {
        params ["_targetShellPos"];
        if (!(_targetShellPos isEqualType []) || {count _targetShellPos < 2}) exitWith {};

        uiSleep (0.6 + random 0.8);

        private _explosion = "Bo_GBU12_LGB" createVehicle _targetShellPos;
        _explosion setDamage 1;
        
        private _light = "#lightpoint" createVehicle _targetShellPos;
        _light setLightBrightness 10;
        _light setLightAmbient [1, 0.5, 0];
        _light setLightColor [1, 0.5, 0];
        
        sleep 0.5;
        deleteVehicle _light;
        
        {
            if (!isNull _x && {_x distance _targetShellPos < 15}) then {
                _x setDamage ((damage _x) + 0.3);
            };
        } forEach (nearestObjects [_targetShellPos, ["All"], 15]);
        
        {
            if (!isNull _x && {alive _x} && {_x distance _targetShellPos < 20}) then {
                private _damage = (1 - ((_x distance _targetShellPos) / 20)) * 0.5;
                _x setDamage ((damage _x) + _damage);
                
                if (isPlayer _x) then {
                    ["Вы получили урон от артподдержки!"] remoteExecCall ["hint", _x];
                };
            };
        } forEach allUnits;
    };
    
    if (_i == 1) then {
        [format ["Артподдержка: %1 снарядов", _shellCount]] remoteExecCall ["hint", 0];
    };
    
    sleep _delayBetweenShells;
};

[_markerName] spawn {
    params ["_marker"];
    sleep 30;
    deleteMarker _marker;
};

["Артподдержка завершена"] remoteExecCall ["hint", 0];

