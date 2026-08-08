params ["_unit", "_evac", "_vechical", ["_dropPos", [], [[]]]];
if (!isServer) exitwith {
    _this remoteExec ["BSO_System_fnc_Laat", 2];
};
if (isNull _unit || {
    !isplayer _unit
}) exitwith {};
private _remoteowner = if (isnil "remoteExecutedOwner") then {
    2
} else {
    remoteExecutedOwner
};
if (_remoteowner > 2 && {
    owner _unit != _remoteowner
}) exitwith {
    diag_log format ["[BSO LAAT] rejected spoofed requester remote=%1", _remoteowner];
};
if !(_vechical isEqualtype "") exitwith {};
if !(isClass (configFile >> "Cfgvehicles" >> _vechical)) exitwith {
    diag_log format ["[BSO LAAT] vehicle class is missing: %1", _vechical];
    format ["Класс техники %1 не найден. Проверьте подключение мода с LAAT.", _vechical] remoteExecCall ["hint", owner _unit];
};
if !(_vechical in BSO_LAAT_AllowedClasses) exitwith {
    diag_log format ["[BSO LAAT] rejected class %1", _vechical];
};

if (_evac isEqualto 1 && {
    _dropPos isEqualtype []
} && {
    count _dropPos >= 2
}) exitwith {
    private _cards = if (!isnil "BSO_Cards_Array") then {
        BSO_Cards_Array
    } else {
        []
    };
    private _hasAccess = count _cards > 5 && {
        ((_cards select 0) in items _unit) ||
        ((_cards select 4) in items _unit) ||
        ((_cards select 5) in items _unit)
    };
    if (!_hasAccess) exitwith {
        diag_log format ["[BSO LAAT] access denied uid=%1", getplayerUID _unit];
    };
    if (!((_dropPos select 0) isEqualtype 0) || {
        !((_dropPos select 1) isEqualtype 0)
    }) exitwith {
        diag_log format ["[BSO LAAT] invalid drop position uid=%1", getplayerUID _unit];
    };
    private _worldSize = worldSize;
    if ((_dropPos select 0) < 0 || {
        (_dropPos select 1) < 0
    } || {
        (_dropPos select 0) > _worldSize
    } || {
        (_dropPos select 1) > _worldSize
    }) exitwith {
        diag_log format ["[BSO LAAT] out-of-bounds drop position uid=%1 pos=%2", getplayerUID _unit, _dropPos];
    };
    if !(_unit getVariable ["BSO_System_LAAT_Act_Active", true]) exitwith {};
    
    _unit setVariable ["BSO_System_LAAT_Act_Active", false, true];
    private _pickupPos = getPosATL _unit;
    private _spawnPos = _pickupPos getPos [1800, random 360];
    _spawnPos set [2, 140];
    private _heli = createvehicle [_vechical, _spawnPos, [], 0, "FLY"];
    if (isNull _heli) exitwith {
        _unit setVariable ["BSO_System_LAAT_Act_Active", true, true];
        "Не удалось создать эвакуационный LAAT" remoteExecCall ["hint", owner _unit];
    };
    
    createvehiclecrew _heli;
    private _driver = driver _heli;
    if (isNull _driver) exitwith {
        deletevehicle _heli;
        _unit setVariable ["BSO_System_LAAT_Act_Active", true, true];
        "У эвакуационного LAAT нет экипажа" remoteExecCall ["hint", owner _unit];
    };
    
    private _heligroup = group _driver;
    _heligroup setBehaviour "CARELESS";
    _heligroup setCombatMode "BLUE";
    _heli setVariable ["BSO_System_LAAT_Unit_owner", _unit, true];
    _heli setVariable ["BSO_System_LAAT_Destroy", false, true];
    _heli setVariable ["BSO_System_LAAT_distance_while", true, true];
    _unit setVariable ["BSO_System_LAAT", _heli, true];
    
    private _pickupWp = _heligroup addWaypoint [_pickupPos, 0];
    _pickupWp setwaypointType "move";
    _pickupWp setwaypointSpeed "FULL";
    _pickupWp setwaypointBehaviour "CARELESS";
    _pickupWp setwaypointCompletionRadius 120;
    
    private _arrivalDeadline = time + 240;
    waitUntil {
        sleep 1;
        isNull _heli || {
            !alive _heli
        } || {
            !alive _unit
        } || {
            _heli distance2D _pickupPos < 180
        } || {
            time >= _arrivalDeadline
        }
    };
    if (isNull _heli || {
        !alive _heli
    } || {
        !alive _unit
    } || {
        time >= _arrivalDeadline
    }) exitwith {
        if (!isNull _heli) then {
            {
                deletevehicle _x;
            } forEach crew _heli;
            deletevehicle _heli;
        };
        deletegroup _heligroup;
        _unit setVariable ["BSO_System_LAAT", nil, true];
        [{
            params ["_u"];
            if (!isNull _u) then {
                _u setVariable ["BSO_System_LAAT_Act_Active", true, true];
            };
        }, [_unit], 120] call CBA_fnc_waitandexecute;
    };
    
    _heli land "GET in";
    private _landingDeadline = time + 90;
    waitUntil {
        sleep 1;
        isNull _heli || {
            !alive _heli
        } || {
            istouchingGround _heli
        } || {
            (getPosATL _heli select 2) < 2.5
        } || {
            time >= _landingDeadline
        }
    };
    if (isNull _heli || {
        !alive _heli
    }) exitwith {
        if (!isNull _heli) then {
            {
                deletevehicle _x;
            } forEach crew _heli;
            deletevehicle _heli;
        };
        deletegroup _heligroup;
        _unit setVariable ["BSO_System_LAAT", nil, true];
        [{
            params ["_u"];
            if (!isNull _u) then {
                _u setVariable ["BSO_System_LAAT_Act_Active", true, true];
            };
        }, [_unit], 120] call CBA_fnc_waitandexecute;
    };
    
    _heli setVariable ["BSO_System_LAAT_distance_while", false, true];
    "Эвакуационный LAAT прибыл. Займите место, ожидание — 120 секунд." remoteExecCall ["hint", owner _unit];
    private _boardingDeadline = time + 120;
    waitUntil {
        sleep 1;
        isNull _heli || {
            !alive _heli
        } || {
            !alive _unit
        } || {
            vehicle _unit isEqualto _heli
        } || {
            time >= _boardingDeadline
        }
    };
    if (isNull _heli || {
        !alive _heli
    } || {
        !alive _unit
    } || {
        vehicle _unit != _heli
    }) exitwith {
        if (!isNull _heli) then {
            {
                deletevehicle _x;
            } forEach crew _heli;
            deletevehicle _heli;
        };
        deletegroup _heligroup;
        _unit setVariable ["BSO_System_LAAT", nil, true];
        [{
            params ["_u"];
            if (!isNull _u) then {
                _u setVariable ["BSO_System_LAAT_Act_Active", true, true];
            };
        }, [_unit], 120] call CBA_fnc_waitandexecute;
    };
    
    _heli land "NONE";
    private _drop = +_dropPos;
    _drop set [2, 0];
    private _dropWp = _heligroup addWaypoint [_drop, 0];
    _dropWp setwaypointType "move";
    _dropWp setwaypointSpeed "FULL";
    _dropWp setwaypointBehaviour "CARELESS";
    _dropWp setwaypointCompletionRadius 120;
    
    private _dropDeadline = time + 300;
    waitUntil {
        sleep 1;
        isNull _heli || {
            !alive _heli
        } || {
            _heli distance2D _drop < 180
        } || {
            time >= _dropDeadline
        }
    };
    if (!isNull _heli && {
        alive _heli
    }) then {
        _heli land "GET OUT";
        private _touchdownDeadline = time + 90;
        waitUntil {
            sleep 1;
            isNull _heli || {
                !alive _heli
            } || {
                istouchingGround _heli
            } || {
                (getPosATL _heli select 2) < 2.5
            } || {
                time >= _touchdownDeadline
            }
        };
        if (!isNull _heli && {
            alive _heli
        }) then {
            "Точка высадки достигнута. Покиньте LAAT." remoteExecCall ["hint", owner _unit];
            sleep 45;
            {
                if (isplayer _x) then {
                    moveOut _x;
                };
            } forEach crew _heli;
            {
                deletevehicle _x;
            } forEach crew _heli;
            deletevehicle _heli;
        };
    };
    if (!isNull _heli) then {
        {
            if (isplayer _x) then {
                moveOut _x;
            };
        } forEach crew _heli;
        {
            deletevehicle _x;
        } forEach crew _heli;
        deletevehicle _heli;
    };
    deletegroup _heligroup;
    _unit setVariable ["BSO_System_LAAT", nil, true];
    [{
        params ["_u"];
        if (!isNull _u) then {
            _u setVariable ["BSO_System_LAAT_Act_Active", true, true];
        };
    }, [_unit], 500] call CBA_fnc_waitandexecute;
};

_pos = getPos _unit;
_unit setVariable ["BSO_System_LAAT_Act_Active", false];
private _spawnDist = if (_evac == 1) then {
    20000
} else {
    1000
};
private _spawnOffset = [_spawnDist - random (2 * _spawnDist), _spawnDist - random (2 * _spawnDist), 100];
private _spawnPos = _pos vectorAdd _spawnOffset;
_heli = createvehicle [_vechical, _spawnPos, [], 0, "FLY"];
if (isNull _heli) exitwith {
    _unit setVariable ["BSO_System_LAAT_Act_Active", true];
    _unit addItem "ACE_UAVBattery";
    hint "Ошибка: техника недоступна (класс не найден).";
};
_heli setVariable ["BSO_System_LAAT_Unit_owner", _unit];
_unit setVariable ["BSO_System_LAAT", _heli];
_unit setVariable ["BSO_System_LAAT_Evac_CD", false];
_heli setVariable ["BSO_System_LAAT_Destroy", false];
_heli setVariable ["BSO_System_LAAT_distance_while", true];
createvehiclecrew _heli;
_heli setvehicleAmmo 1;
_groupplayer = group _unit;
_group = group driver _heli;
_group addvehicle _heli;
_group setBehaviour "CARELESS";
_group setCombatMode "BLUE";
_waypoint = _group addWaypoint [_pos, 0];
_waypoint setwaypointType "SCRIPTED";
_waypoint setwaypointScript "\x\zen\addons\ai\functions\fnc_waypointland.sqf";

waitUntil {
    if (isnil "_heli" || {
        isNull _heli
    }) exitwith {
        true
    };
    ((getPos _heli select 2) <= 3) || {
        (_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true
    }
};
_heli engineOn false;
if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};

waitUntil {
    if (isnil "_heli" || {
        isNull _heli
    }) exitwith {
        true
    };
    (istouchingGround _heli) || {
        (_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true
    }
};
if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};
_heli setVariable ["BSO_System_LAAT_distance_while", nil];

if (_evac == 1) then {
    _heli addAction ["Указать место посадки", {
        params ["_heli", "_unit", "_actionId"];
        openMap true;
        [] spawn {
            waitUntil {
                sleep 0.1;
                if (!visibleMap) exitwith {
                    onMapsingleClick "";
                    true
                };
                false;
            };
        };
        [_heli, _actionId] onMapsingleClick {
            _heli = _this select 0;
            _actionId = _this select 1;
            _heli setVariable ["BSO_System_LAAT_Last_TCK", _pos];
            _heli removeAction _actionId;
            openMap false;
            true;
        };
    }, nil, 1.5, true, false, "", "", 10];
    
    _heli addAction ["Высадить экипаж", {
        params ["_heli", "_caller", "_actionId"];
        {
            if (alive _x) then {
                _x moveOut _heli;
            };
        } forEach crew _heli;
        hint "Экипаж ЛААТ высажен";
    }, nil, 1.5, true, false, "", "", 10];
    
    _unit addAction ["Экстренный взлёт", {
        params ["_target", "_caller", "_actionId", "_arguments"];
        _heli = _target getVariable "BSO_System_LAAT";
        if (!isnil {
            _heli getVariable "BSO_System_LAAT_Last_TCK"
        }) then {
            _target setVariable ["BSO_System_LAAT_Evac_CD", true];
            _target removeAction _actionId;
        } else {
            hintSilent "Вы не выбрали место куда вас эвакуировать";
        };
    }, nil, 1.5, true, false, "", "", 10];
    
    for "_i" from 120 to 0 step -1 do {
        {
            if (isplayer _x) then {
                hintSilent format ["Осталось до отлёта: %1 сек", _i];
            };
        } forEach units _groupplayer;
        if ((_unit getVariable "BSO_System_LAAT_Evac_CD" == true) or (_heli getVariable "BSO_System_LAAT_Destroy" == true)) exitwith {};
        sleep 1;
    };
    _heli engineOn true;
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};
    
    if (isnil {
        _heli getVariable "BSO_System_LAAT_Last_TCK"
    }) then {
        hintSilent "Вы не выбрали место куда вас эвакуировать";
        waitUntil {
            if (isnil "_heli" || {
                isNull _heli
            }) exitwith {
                true
            };
            if ((!isnil {
                _heli getVariable "BSO_System_LAAT_Last_TCK"
            }) || {
                (_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true
            }) then {
                true
            } else {
                false
            };
        };
    };
    
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};
    hintSilent "";
    _last_pos = _heli getVariable "BSO_System_LAAT_Last_TCK";
    _waypoint = _group addWaypoint [_last_pos, 0];
    _waypoint setwaypointType "SCRIPTED";
    _waypoint setwaypointScript "\x\zen\addons\ai\functions\fnc_waypointland.sqf";
    
    waitUntil {
        if (isnil "_heli" || {
            isNull _heli
        }) exitwith {
            true
        };
        ((_heli distance _last_pos) < 100) || {
            (_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true
        }
    };
    _last_pos = _heli getVariable "BSO_System_LAAT_Last_TCK";
    _waypoint = _group addWaypoint [_last_pos, 0];
    _waypoint setwaypointType "SCRIPTED";
    _waypoint setwaypointScript "\x\zen\addons\ai\functions\fnc_waypointland.sqf";
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};
    waitUntil {
        if (isnil "_heli" || {
            isNull _heli
        }) exitwith {
            true
        };
        ((getPos _heli select 2) <= 2) || {
            (_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true
        }
    };
    _heli engineOn false;
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitwith {};
    
    {
        if ((vehicle _x == _heli) && (!(group _x == _group))) then {
            moveOut _x;
        };
    } forEach crew _heli;
    _heli lock true;
    _heli setVariable ["BSO_System_LAAT_Unit_owner", nil];
    [{
        _last_pos = _this select 0;
        _heli = _this select 1;
        _unit = _this select 2;
        _last_pos set [1, 10000];
        _waypoint = group driver _heli addWaypoint [_last_pos, 0];
        _unit setVariable ["BSO_System_LAAT_Evac_CD", nil];
        [{
            _heli = _this select 0;
            _unit = _this select 1;
            deletevehicleCrew _heli;
            deletevehicle _heli;
            [{
                _this setVariable ["BSO_System_LAAT_Act_Active", true];
            }, _unit, 500] call CBA_fnc_waitandexecute;
        }, [_heli, _unit], 100] call CBA_fnc_waitandexecute;
    }, [_last_pos, _heli, _unit], 10] call CBA_fnc_waitandexecute;
} else {
    {
        if (isplayer _x) then {
            ["Ваш боевой дрон прибыл!"] remoteExec ["hintSilent", _x];
        };
    } forEach units _groupplayer;
    
    if (count crew _heli > 0) then {
        _group setBehaviour "AWARE";
        _group setCombatMode "RED";
        _group setFormation "WEDGE";
        
        _wp = _group addWaypoint [_pos, 100];
        _wp setwaypointType "SAD";
        _wp setwaypointSpeed "NorMAL";
        _wp setwaypointBehaviour "AWARE";
        
        _wp2 = _group addWaypoint [_pos, 200];
        _wp2 setwaypointType "CYCLE";
        _wp2 setwaypointSpeed "NorMAL";
        _wp2 setwaypointBehaviour "AWARE";
    };
    
    _heli addAction ["Высадить экипаж", {
        params ["_heli", "_caller", "_actionId"];
        {
            if (alive _x) then {
                _x moveOut _heli;
            };
        } forEach crew _heli;
        hint "Экипаж высажен";
    }, nil, 1.5, true, false, "", "", 10];
    
    _heli setVariable ["BSO_System_LAAT_Unit_owner", nil];
    _unit setVariable ["BSO_System_LAAT_Evac_CD", nil];
    _heli setVariable ["BSO_System_LAAT_Destroy", nil];
    [{
        _this setVariable ["BSO_System_LAAT_Act_Active", true];
    }, _unit, 600] call CBA_fnc_waitandexecute;
};