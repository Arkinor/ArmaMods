//НЕ ЗАБЫТЬ ВЪЕБАТЬ СВОЙ ИНВИЗ, ЧУТКА ПОД РЕДАЧИТЬ, МБ ЧТО-НИБУДЬ ПРИДУМАЮ ДОБАВОЧНОЕ К НЕМУ

//МАССИВЫ
BSO_Cards_Array = [ 
    "BSO_System_ids_SOB",
    "BSO_System_ids_RC",
    "BSO_System_ids_ARF",
    "BSO_System_ids_ARC",
    "BSO_System_General_Zey",
    "BSO_System_ids_RC_Nexus",
    "BSO_System_ids_Dark",
    "BSO_System_ids_Henker"
];

BSO_Vehicle_Array = [
    "mti_armoury_vehicles_laati_mk2"
];

BSO_LAAT_AllowedClasses = [
    "mti_armoury_vehicles_laati_mk2",
    "B_T_arf_drone_dynemic_Loadout_F"
];

BSO_Item_Arrays = [
    "CamoNet_INDP_big_F",
    "CamoNet_INDP_F",
    "CamoNet_INDP_open_F",
    "CamoNet_ghex_big_F",
    "CamoNet_ghex_F",
    "CamoNet_ghex_open_F",
    "Land_MedicalTent_01_NATO_tropic_generic_open_F",
    "Land_MedicalTent_01_NATO_tropic_generic_outer_F"

];

//КОМПИЛИРУЕМ ЗВУКИ ЁПТ
BSO_System_PlaySounds = compile preprocessFileLineNumbers "\BSOSystem\createSoundGlobal.sqf";

//ФУНКЦИИ
//ВООБЩЕ НЕ ЕБУ ЧТО ЭТО ЗА ХУЕТА, НО КОГДА УЗНАЮ, ВОЗМОЖНО ПОПРАВЛЮ, УДАЛЮ ИЛИ ЕЩЁ КАКИЕ УЖАСНЫЕ ВЕЩИ СДЕЛАЮ С ЭТОЙ ЗАЛУПКОЙ
//Я УЗНАЛ ЧТО ЗА ЗАЛУПА И ОНА РАБОТАЕТ ВМЕСТЕ С ЗАКИДЫВАНИЕМ ГРАНАТЫ В ТЕХНИКУ, ПОКА ОСТАВЛЮ ТАК, КАК ЕСТЬ
BSO_System_fnc_GrenadeDamageVehicle = {
	params ["_vehicle"];
	if (isNull _vehicle || {!(_vehicle isKindOf "LandVehicle") && !(_vehicle isKindOf "Air") && !(_vehicle isKindOf "Ship")}) exitWith {};
	private _authorised = true;
	if (isServer && {remoteExecutedOwner > 0}) then {
		private _requester = objNull;
		{ if (owner _x == remoteExecutedOwner) exitWith { _requester = _x; }; } forEach allPlayers;
		if (isNull _requester || {_requester distance _vehicle > 6}) then { _authorised = false; };
		private _driver = driver _vehicle;
		if (!isNull _driver && {!isNull _requester} && {side _driver isEqualTo side _requester}) then { _authorised = false; };
	};
	if (!_authorised) exitWith {};
	if (_vehicle getVariable ["BSO_System_GrenadeDamaged", false]) exitWith {};

	_vehicle setVariable ["BSO_System_GrenadeDamaged", true, true];
	_vehicle setFuel 0;
	_vehicle engineOn false;

	private _all = getAllHitPointsDamage _vehicle;
	if (count _all >= 1) then {
		private _hitNames = _all select 0;
		{
			if (_x != "HitFuel" && {_x find "Fuel" == -1}) then {
				_vehicle setHitPointDamage [_x, 1, true];
			};
		} forEach _hitNames;
	};
	if (damage _vehicle < 0.85) then { _vehicle setDamage 0.85 };
};

//ОКЕЕЕЙ, ВРОДЕ МОЙ, А ВРОДЕ И ЧТО ЗА ХУЙНЯ, ЛАДНО, ПОКА ПРОПУСТИМ
BSO_System_fnc_RequestEvacLAAT = {
    if (!hasInterface || {isNull player} || {!alive player}) exitWith {};
    if !(player getVariable ["BSO_System_LAAT_Act_Active", true]) exitWith {
        hint "Эвакуационный LAAT ещё не готов";
    };
    private _hasNexusAccess = if (!isNil "BSO_Cards_Array" && {count BSO_Cards_Array > 5}) then {
        ((BSO_Cards_Array select 0) in items player) ||
        ((BSO_Cards_Array select 4) in items player) ||
        ((BSO_Cards_Array select 5) in items player)
    } else {
        false
    };
    if (!_hasNexusAccess) exitWith { hint "Нет доступа к эвакуационному LAAT"; };
    if (missionNamespace getVariable ["BSO_System_LAAT_MapSelectionPending", false]) exitWith {
        hint "Сначала завершите выбор точки эвакуации";
    };

    missionNamespace setVariable ["BSO_System_LAAT_MapSelectionPending", true, false];
    hint "Укажите на карте точку высадки. Закройте карту для отмены.";
    openMap true;
    private _handlerId = addMissionEventHandler ["MapSingleClick", {
        params ["_units", "_pos"];
        if !(missionNamespace getVariable ["BSO_System_LAAT_MapSelectionPending", false]) exitWith {};
        missionNamespace setVariable ["BSO_System_LAAT_MapSelectionPending", false, false];
        private _id = missionNamespace getVariable ["BSO_System_LAAT_MapHandler", -1];
        if (_id >= 0) then { removeMissionEventHandler ["MapSingleClick", _id]; };
        missionNamespace setVariable ["BSO_System_LAAT_MapHandler", -1, false];
        openMap false;
        
        
        
        [player, 1, "mti_armoury_vehicles_laati_mk2", _pos] call BSO_System_fnc_Laat;
        hint "Запрос передан. LAAT следует к вашей позиции.";
    }];
    missionNamespace setVariable ["BSO_System_LAAT_MapHandler", _handlerId, false];

    [_handlerId] spawn {
        params ["_id"];
        waitUntil {
            uiSleep 0.2;
            !visibleMap || !(missionNamespace getVariable ["BSO_System_LAAT_MapSelectionPending", false])
        };
        if (missionNamespace getVariable ["BSO_System_LAAT_MapSelectionPending", false]) then {
            missionNamespace setVariable ["BSO_System_LAAT_MapSelectionPending", false, false];
            removeMissionEventHandler ["MapSingleClick", _id];
            missionNamespace setVariable ["BSO_System_LAAT_MapHandler", -1, false];
            hint "Вызов LAAT отменён";
        };
    };
};

//МОЙ ИНВАЛИД, КОТОРОГО Я ТРОГАТЬ НЕ ХОЧУ, ЕГО И ТАК ПРОШЛЫЙ Я УЖЕ ВЫЕБАЛ И ВЫСУШИЛ, ЖАЛЬ ЕГО
BSO_System_fnc_Laat = {
    params ["_unit", "_evac", "_vechical", ["_dropPos", [], [[]]]];
    if (!isServer) exitWith {
        _this remoteExec ["BSO_System_fnc_Laat", 2];
    };
    if (isNull _unit || {!isPlayer _unit}) exitWith {};
    private _remoteOwner = if (isNil "remoteExecutedOwner") then { 2 } else { remoteExecutedOwner };
    if (_remoteOwner > 2 && {owner _unit != _remoteOwner}) exitWith {
        diag_log format ["[BSO LAAT] rejected spoofed requester remote=%1", _remoteOwner];
    };
    if !(_vechical isEqualType "") exitWith {};
    if !(isClass (configFile >> "CfgVehicles" >> _vechical)) exitWith {
        diag_log format ["[BSO LAAT] vehicle class is missing: %1", _vechical];
        format ["Класс техники %1 не найден. Проверьте подключение мода с LAAT.", _vechical] remoteExecCall ["hint", owner _unit];
    };
    if !(_vechical in BSO_LAAT_AllowedClasses) exitWith {
        diag_log format ["[BSO LAAT] rejected class %1", _vechical];
    };

    if (_evac isEqualTo 1 && {_dropPos isEqualType []} && {count _dropPos >= 2}) exitWith {
        private _cards = if (!isNil "BSO_Cards_Array") then { BSO_Cards_Array } else { [] };
        private _hasAccess = count _cards > 5 && {
            ((_cards select 0) in items _unit) ||
            ((_cards select 4) in items _unit) ||
            ((_cards select 5) in items _unit)
        };
        if (!_hasAccess) exitWith {
            diag_log format ["[BSO LAAT] access denied uid=%1", getPlayerUID _unit];
        };
        if (!((_dropPos select 0) isEqualType 0) || {!((_dropPos select 1) isEqualType 0)}) exitWith {
            diag_log format ["[BSO LAAT] invalid drop position uid=%1", getPlayerUID _unit];
        };
        private _worldSize = worldSize;
        if ((_dropPos select 0) < 0 || {(_dropPos select 1) < 0} || {(_dropPos select 0) > _worldSize} || {(_dropPos select 1) > _worldSize}) exitWith {
            diag_log format ["[BSO LAAT] out-of-bounds drop position uid=%1 pos=%2", getPlayerUID _unit, _dropPos];
        };
        if !(_unit getVariable ["BSO_System_LAAT_Act_Active", true]) exitWith {};

        _unit setVariable ["BSO_System_LAAT_Act_Active", false, true];
        private _pickupPos = getPosATL _unit;
        private _spawnPos = _pickupPos getPos [1800, random 360];
        _spawnPos set [2, 140];
        private _heli = createVehicle [_vechical, _spawnPos, [], 0, "FLY"];
        if (isNull _heli) exitWith {
            _unit setVariable ["BSO_System_LAAT_Act_Active", true, true];
            "Не удалось создать эвакуационный LAAT" remoteExecCall ["hint", owner _unit];
        };

        createVehicleCrew _heli;
        private _driver = driver _heli;
        if (isNull _driver) exitWith {
            deleteVehicle _heli;
            _unit setVariable ["BSO_System_LAAT_Act_Active", true, true];
            "У эвакуационного LAAT нет экипажа" remoteExecCall ["hint", owner _unit];
        };

        private _heliGroup = group _driver;
        _heliGroup setBehaviour "CARELESS";
        _heliGroup setCombatMode "BLUE";
        _heli setVariable ["BSO_System_LAAT_Unit_Owner", _unit, true];
        _heli setVariable ["BSO_System_LAAT_Destroy", false, true];
        _heli setVariable ["BSO_System_LAAT_Distance_While", true, true];
        _unit setVariable ["BSO_System_LAAT", _heli, true];

        private _pickupWp = _heliGroup addWaypoint [_pickupPos, 0];
        _pickupWp setWaypointType "MOVE";
        _pickupWp setWaypointSpeed "FULL";
        _pickupWp setWaypointBehaviour "CARELESS";
        _pickupWp setWaypointCompletionRadius 120;

        private _arrivalDeadline = time + 240;
        waitUntil {
            sleep 1;
            isNull _heli || {!alive _heli} || {!alive _unit} || {_heli distance2D _pickupPos < 180} || {time >= _arrivalDeadline}
        };
        if (isNull _heli || {!alive _heli} || {!alive _unit} || {time >= _arrivalDeadline}) exitWith {
            if (!isNull _heli) then { { deleteVehicle _x; } forEach crew _heli; deleteVehicle _heli; };
            deleteGroup _heliGroup;
            _unit setVariable ["BSO_System_LAAT", nil, true];
            [{ params ["_u"]; if (!isNull _u) then { _u setVariable ["BSO_System_LAAT_Act_Active", true, true]; }; }, [_unit], 120] call CBA_fnc_waitAndExecute;
        };

        _heli land "GET IN";
        private _landingDeadline = time + 90;
        waitUntil {
            sleep 1;
            isNull _heli || {!alive _heli} || {isTouchingGround _heli} || {(getPosATL _heli select 2) < 2.5} || {time >= _landingDeadline}
        };
        if (isNull _heli || {!alive _heli}) exitWith {
            if (!isNull _heli) then { { deleteVehicle _x; } forEach crew _heli; deleteVehicle _heli; };
            deleteGroup _heliGroup;
            _unit setVariable ["BSO_System_LAAT", nil, true];
            [{ params ["_u"]; if (!isNull _u) then { _u setVariable ["BSO_System_LAAT_Act_Active", true, true]; }; }, [_unit], 120] call CBA_fnc_waitAndExecute;
        };

        _heli setVariable ["BSO_System_LAAT_Distance_While", false, true];
        "Эвакуационный LAAT прибыл. Займите место, ожидание — 120 секунд." remoteExecCall ["hint", owner _unit];
        private _boardingDeadline = time + 120;
        waitUntil {
            sleep 1;
            isNull _heli || {!alive _heli} || {!alive _unit} || {vehicle _unit isEqualTo _heli} || {time >= _boardingDeadline}
        };
        if (isNull _heli || {!alive _heli} || {!alive _unit} || {vehicle _unit != _heli}) exitWith {
            if (!isNull _heli) then { { deleteVehicle _x; } forEach crew _heli; deleteVehicle _heli; };
            deleteGroup _heliGroup;
            _unit setVariable ["BSO_System_LAAT", nil, true];
            [{ params ["_u"]; if (!isNull _u) then { _u setVariable ["BSO_System_LAAT_Act_Active", true, true]; }; }, [_unit], 120] call CBA_fnc_waitAndExecute;
        };

        _heli land "NONE";
        private _drop = +_dropPos;
        _drop set [2, 0];
        private _dropWp = _heliGroup addWaypoint [_drop, 0];
        _dropWp setWaypointType "MOVE";
        _dropWp setWaypointSpeed "FULL";
        _dropWp setWaypointBehaviour "CARELESS";
        _dropWp setWaypointCompletionRadius 120;

        private _dropDeadline = time + 300;
        waitUntil {
            sleep 1;
            isNull _heli || {!alive _heli} || {_heli distance2D _drop < 180} || {time >= _dropDeadline}
        };
        if (!isNull _heli && {alive _heli}) then {
            _heli land "GET OUT";
            private _touchdownDeadline = time + 90;
            waitUntil {
                sleep 1;
                isNull _heli || {!alive _heli} || {isTouchingGround _heli} || {(getPosATL _heli select 2) < 2.5} || {time >= _touchdownDeadline}
            };
            if (!isNull _heli && {alive _heli}) then {
                "Точка высадки достигнута. Покиньте LAAT." remoteExecCall ["hint", owner _unit];
                sleep 45;
                { if (isPlayer _x) then { moveOut _x; }; } forEach crew _heli;
                { deleteVehicle _x; } forEach crew _heli;
                deleteVehicle _heli;
            };
        };
        if (!isNull _heli) then {
            { if (isPlayer _x) then { moveOut _x; }; } forEach crew _heli;
            { deleteVehicle _x; } forEach crew _heli;
            deleteVehicle _heli;
        };
        deleteGroup _heliGroup;
        _unit setVariable ["BSO_System_LAAT", nil, true];
        [{ params ["_u"]; if (!isNull _u) then { _u setVariable ["BSO_System_LAAT_Act_Active", true, true]; }; }, [_unit], 500] call CBA_fnc_waitAndExecute;
    };

    _pos = getPos _unit;
    _unit setVariable ["BSO_System_LAAT_Act_Active", false];
    private _spawnDist = if (_evac == 1) then { 20000 } else { 1000 };
    private _spawnOffset = [_spawnDist - random (2 * _spawnDist), _spawnDist - random (2 * _spawnDist), 100];
    private _spawnPos = _pos vectorAdd _spawnOffset;
    _heli = createVehicle [_vechical, _spawnPos, [], 0, "FLY"];
    if (isNull _heli) exitWith {
        _unit setVariable ["BSO_System_LAAT_Act_Active", true];
        _unit addItem "ACE_UAVBattery";
        hint "Ошибка: техника недоступна (класс не найден).";
    };
    _heli setVariable ["BSO_System_LAAT_Unit_Owner", _unit];
    _unit setVariable ["BSO_System_LAAT", _heli];
    _unit setVariable ["BSO_System_LAAT_Evac_CD", false];
    _heli setVariable ["BSO_System_LAAT_Destroy", false];
    _heli setVariable ["BSO_System_LAAT_Distance_While", true];
    createVehicleCrew _heli;
    _heli setVehicleAmmo 1;
    _groupPlayer = group _unit;
    _group = group driver _heli;
    _group addVehicle _heli;
    _group setBehaviour "CARELESS";
    _group setCombatMode "BLUE";
    _waypoint = _group addWaypoint [_pos, 0];
    _waypoint setWaypointType "SCRIPTED";
    _waypoint setWaypointScript "\x\zen\addons\ai\functions\fnc_waypointLand.sqf";
    
    waitUntil {
        if (isNil "_heli" || {isNull _heli}) exitWith { true };
        ((getPos _heli select 2) <= 3) || {(_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true}
    };
    _heli engineOn false;
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
    
    waitUntil {
        if (isNil "_heli" || {isNull _heli}) exitWith { true };
        (isTouchingGround _heli) || {(_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true}
    };
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
    _heli setVariable ["BSO_System_LAAT_Distance_While", nil];

    if (_evac == 1) then {
        _heli addAction ["Указать место посадки", {
            params ["_heli", "_unit", "_actionId"];
            openMap true;
            [] spawn {
                waitUntil {
                    sleep 0.1;
                    if (!visibleMap) exitWith {
                        onMapSingleClick "";
                        true
                    };
                    false;
                };
            };
            [_heli, _actionId] onMapSingleClick {
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
            if (!isNil {_heli getVariable "BSO_System_LAAT_Last_TCK"}) then {
            _target setVariable ["BSO_System_LAAT_Evac_CD", true];
            _target removeAction _actionId;
            } else {
                hintSilent "Вы не выбрали место куда вас эвакуировать";
            };
        }, nil, 1.5, true, false, "", "", 10];
        
        for "_i" from 120 to 0 step -1 do {
            {
                if (isPlayer _x) then {
                    hintSilent format ["Осталось до отлёта: %1 сек", _i];
                };
            } forEach units _groupPlayer;
            if ((_unit getVariable "BSO_System_LAAT_Evac_CD" == true) or (_heli getVariable "BSO_System_LAAT_Destroy" == true)) exitWith {};
            sleep 1;
        };
        _heli engineOn true;
        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};

        if (isNil { _heli getVariable "BSO_System_LAAT_Last_TCK" }) then {
            hintSilent "Вы не выбрали место куда вас эвакуировать";
            waitUntil {
                if (isNil "_heli" || {isNull _heli}) exitWith { true };
                if ((!isNil { _heli getVariable "BSO_System_LAAT_Last_TCK" }) || {(_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true}) then {
                    true
                } else {
                    false
                };
            };
        };

        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
        hintSilent "";
        _last_pos = _heli getVariable "BSO_System_LAAT_Last_TCK";
        _waypoint = _group addWaypoint [_last_pos, 0];
        _waypoint setWaypointType "SCRIPTED";
        _waypoint setWaypointScript "\x\zen\addons\ai\functions\fnc_waypointLand.sqf";
        
        waitUntil {
            if (isNil "_heli" || {isNull _heli}) exitWith { true };
            ((_heli distance _last_pos) < 100) || {(_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true}
        };
        _last_pos = _heli getVariable "BSO_System_LAAT_Last_TCK";
        _waypoint = _group addWaypoint [_last_pos, 0];
        _waypoint setWaypointType "SCRIPTED";
        _waypoint setWaypointScript "\x\zen\addons\ai\functions\fnc_waypointLand.sqf";    
        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
        waitUntil {
            if (isNil "_heli" || {isNull _heli}) exitWith { true };
            ((getPos _heli select 2) <= 2) || {(_heli getVariable ["BSO_System_LAAT_Destroy", false]) == true}
        };
        _heli engineOn false;
        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
        
        { 
            if ((vehicle _x == _heli) && (!(group _x == _group))) then { 
                moveOut _x; 
            };
        } forEach crew _heli;
        _heli lock true;
        _heli setVariable ["BSO_System_LAAT_Unit_Owner", nil];
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
                deleteVehicleCrew _heli;
                deleteVehicle _heli;
                [{
                    _this setVariable ["BSO_System_LAAT_Act_Active", true];
                }, _unit, 500] call CBA_fnc_waitAndExecute;
            }, [_heli, _unit], 100] call CBA_fnc_waitAndExecute;
        }, [_last_pos, _heli, _unit], 10] call CBA_fnc_waitAndExecute;
    } else {
        {
            if (isPlayer _x) then {
                ["Ваш боевой дрон прибыл!"] remoteExec ["hintSilent", _x];
            };
        } forEach units _groupPlayer;
        
        if (count crew _heli > 0) then {
            _group setBehaviour "AWARE";
            _group setCombatMode "RED";
            _group setFormation "WEDGE";
            
            _wp = _group addWaypoint [_pos, 100];
            _wp setWaypointType "SAD";
            _wp setWaypointSpeed "NORMAL";
            _wp setWaypointBehaviour "AWARE";
            
            _wp2 = _group addWaypoint [_pos, 200];
            _wp2 setWaypointType "CYCLE";
            _wp2 setWaypointSpeed "NORMAL";
            _wp2 setWaypointBehaviour "AWARE";
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
        
        _heli setVariable ["BSO_System_LAAT_Unit_Owner", nil];
        _unit setVariable ["BSO_System_LAAT_Evac_CD", nil];
        _heli setVariable ["BSO_System_LAAT_Destroy", nil];    
        [{
            _this setVariable ["BSO_System_LAAT_Act_Active", true];
        }, _unit, 600] call CBA_fnc_waitAndExecute;
    };
};

//ТОЖЕ САМОЕ, ЧТО И В ФУНКЦИИ НИЖЕ
BSO_System_fnc_spawner_items_act = {
	params ["_pl"];

	_actions = [];

	{
		_veh = _x;

		_class = format ["BSO_System_Vehicle_ACE_ACT_%1", _veh];
		_name = format ["Построить %1", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];

		_action = [
			_class,
			_name,
			"",
			{
                params ["_target", "_player", "_params"];
                _veh = _params select 0;
				[_veh, _player] spawn BSO_System_fnc_Items_spawn;
			},
			{
               ("ACE_Fortify" in items player)
			},
            {},
            [_veh]
		] call ACE_interact_menu_fnc_createAction;

		_actions pushBack [_action, [], _pl];

	}forEach BSO_Item_Arrays;

	(_actions)
};

//ТОЖЕ САМОЕ, ЧТО И В ФУНКЦИИ НИЖЕ
BSO_System_fnc_Items_spawn = {
    params ["_veh", ["_requester", objNull, [objNull]]];
    if (isNull _requester) then { _requester = player; };
    if (!isServer) exitWith {
        [_veh, _requester] remoteExecCall ["BSO_System_fnc_Items_spawn", 2];
    };
    if (isNull _requester || {!isPlayer _requester}) exitWith {};
    if (remoteExecutedOwner > 0 && {owner _requester != remoteExecutedOwner}) exitWith {};
    if !(_veh in BSO_Item_Arrays) exitWith { diag_log format ["[BSO Item] rejected class %1", _veh]; };
    _ppos = getpos _requester;
    _pdir = getDir _requester;
    _vehicle = createVehicle [_veh, [(_ppos select 0) + sin(_pdir) * 5, (_ppos select 1) + cos(_pdir) * 6, (_ppos select 2)], [], 0, "CAN_COLLIDE"];
    _vehicle setDir (_pdir + 90);
    _vehicle setDamage 0;
    hint format [" %1 готова", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];
};

//ПОКА СТРОЙ ПЛОЩАДКА ИДЁТ НАХУЙ, Я ТРОГАТЬ ДАННОЕ ЧУДО НЕ БУДУ, ТОЛЬКО В САМОМ КОНЦЕ, ВЪЕБУ СВОЁ СПАВН МЕНЮ ОБЖЕКТОВ, А ПОЧЕМУ БЫ И НЕТ?
BSO_System_fnc_Remove_Tent = {
    private _player = player;

    private _searchRadius = 15;
    private _targetTypes = BSO_Item_Arrays;

    private _playerPos = getPos _player;

    private _targets = nearestObjects [_playerPos, _targetTypes, _searchRadius];

    if (count _targets == 0) exitWith {
        hint "В радиусе нет палаток.";
    };

    {
        if !(_targetClass in BSO_Item_Array) exitWith {
            hint format ["%1 не является палаткой из списка.", _targetClass];
        };

        private _targetPos = getPos _x;
        private _currentDistance = _playerPos vectorDistance _targetPos;

        if (_currentDistance > _searchRadius) then {
            systemChat format ["%1 вне досягаемости.", _targetClass];
        } else {
            deleteVehicle _x;

            hint format ["%1 удалена", getText(configFile >> "CfgVehicles" >> _x >> "displayName")];
            systemChat format ["%1 удалена", getText(configFile >> "CfgVehicles" >> _x >> "displayName")];
        };
    } forEach _targets;
};

//ТОЖЕ ПОКА ХУЙ ЗАБЬЮ, РАБОТАЕТ И ХУЙ С НИМ, НА САМОМ ПОСЛЕДНЕМ ЭТАПЕ ЗАЙМУСЬ
BSO_System_fnc_Change_Uniform = {
	params ["_value"];
	switch (true) do {
		case (_value == 0): {
			profileNamespace setVariable ["Shadow_saved_headgear", headgear player];
			profileNamespace setVariable ["Shadow_saved_uniform", uniform player];
			profileNamespace setVariable ["Shadow_saved_vest", vest player];
			profileNamespace setVariable ["Shadow_saved_backpack", backpack player];
			saveProfileNamespace;
		};
		case (_value == 1): {
			oldHelm = headgear player;
			oldUni = uniform player;
			oldVest = vest player;
			oldBackpack = backpack player;
			oldUniItems = uniformItems player;
			oldVestItems = vestItems player;
			oldBackpackItems = backpackItems player;

			player setVariable ["saved_headgear", headgear player];
			player setVariable ["saved_uniform", uniform player];
			player setVariable ["saved_vest", vest player];
			player setVariable ["saved_backpack", backpack player];

			player setVariable ["shadowCamo", true];
			_saved_headgear = (profileNamespace getVariable "Shadow_saved_headgear");
			if (typeName _saved_headgear == "STRING") then {
				player addHeadgear _saved_headgear
			};
			_saved_uniform = (profileNamespace getVariable "Shadow_saved_uniform");
			if (typeName _saved_uniform == "STRING") then {
				player forceAddUniform _saved_uniform;
				{
					player addItemToUniform _x
				} forEach oldUniItems;
			};
			_saved_vest = (profileNamespace getVariable "Shadow_saved_vest");
			if (typeName _saved_vest == "STRING") then {
				player addVest _saved_vest;
				{
					player addItemToVest _x
				} forEach oldVestItems;
			};
			_saved_backpack = (profileNamespace getVariable "Shadow_saved_backpack");
			if (typeName _saved_backpack == "STRING") then {
				removeBackpack player;
				player addBackpack _saved_backpack;
				{
					player addItemToBackpack _x
				} forEach oldBackpackItems;
			};
		};
		case (_value == 2): {
			newUniItems = uniformItems player;
			newVestItems = vestItems player;
			newBackpackItems = backpackItems player;

			removeHeadgear player;
			removeUniform player;
			removeVest player;
			removeBackpack player;

			player addHeadgear oldHelm;
			player forceAddUniform oldUni;
			player addVest oldVest;
			player addBackpack oldBackpack;

			{
				player addItemToUniform _x
			} forEach newUniItems;
			{
				player addItemToVest _x
			} forEach newVestItems;
			{
				player addItemToBackpack _x
			} forEach newBackpackItems;

			player removeAction oldAction;
			player setVariable ["shadowCamo", false];
		};
	};
};

//ЕБАНЫЕ EH
addMissionEventHandler ["EntityKilled", {
    params ["_heli", "_killer", "_instigator"];
    if (!(isnil {
        _heli getVariable "BSO_System_LAAT_Unit_owner"
    })) then {
        _owner = _heli getVariable "BSO_System_LAAT_Unit_owner";
        _heli setVariable ["BSO_System_LAAT_distance_while", nil];
        _heli setVariable ["BSO_System_LAAT_Destroy", true];
        ["ЛААТ уничтожен! Эвакуация будет доступна через 2 минуты!"] remoteExec ["hint", _owner];
        [{
            _owner = _this select 0;
            _heli = _this select 1;
            _owner setVariable ["BSO_System_LAAT_Act_Active", true];
            deletevehicleCrew _heli;
            deletevehicle _heli;
        }, [_owner, _heli], 120] call CBA_fnc_waitandexecute;
    };
}];