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

//МОЯ ЗАЛУПА ПЕРЕЁБАНАЯ ДОНАТНЫМИ СКРИПТАМИ, НУ ДА ХУЙ С НИМИ, БЕЗ ИЗМЕНЕНИЙ.
BSO_System_fnc_Proverka_Delete_Ids = {
	if ((name _this find 'ARF' != -1)
	or (name _this find 'ARC' != -1)
	or (name _this find 'RC' != -1)
	or (name _this find 'SOB' != -1)
	or (name _this find 'DARK' != -1)
	or (name _this find 'HENKER' != -1)
	) exitWith {};

	{
		if (_x in BSO_Cards_Array && {_x != "BSO_System_ids_Henker"}) then {
			private _card = _x;
			private _n = { _x == _card } count (items player);
			for "_i" from 1 to _n do { player removeItem _card };
		};
	} forEach (items player);
};

//НУ, ПЕРЕПИСЫВАТЬ НЕ НАДО, НО ПОСМОТРИМ
BSO_System_fnc_Auto_Bacta = {
    if (player getVariable "ACE_isUnconscious" == true) then {
        if (player getVariable "BSO_System_AutoBacta" == false) then {

            hint "[SYS] Бакта использована, ожидайте"; 
            
            [{ 
            [player] call ace_medical_treatment_fnc_fullHealLocal;
            player setVariable ["BSO_System_AutoBacta", true];
            }, [], 20] call CBA_fnc_waitAndExecute;

            [{ 
                hint "[SYS] Бакта готова";
                player setVariable ["BSO_System_AutoBacta", false];
            }, [], 900] call CBA_fnc_waitAndExecute;
        };
    };
};

//ОСТАЁШЬСЯ ТУТ ДО ЛУЧШИХ ВРЕМЁН, ПО ИДЕЕ ДАЖЕ ПЕРЕПИСЫВАТЬ НЕ НАДО
BSO_System_fnc_Auto_Heal_Act = {

    hintSilent format["Автохил %1", player getVariable "BSO_System_Auto_Heal_Active"];

    while { (player getVariable "BSO_System_Auto_Heal_Active") } do {

        if (not alive player) exitwith{};

        _bodyParts = ["head", "body", "leftarm", "rightarm", "leftleg", "rightleg"];
        {
            _i = _foreachindex;
            _wounds = [player, "ElasticBandage", _x] call ace_medical_treatment_fnc_findMostEffectiveWounds;
            {
                _y params ["_effectiveness"];
                player setVariable ["phoenix_effectiveness", _effectiveness];
            } forEach _wounds;

            if (player getVariable "phoenix_effectiveness" != -1) then {
                [player, _x, "ElasticBandage"] call ace_medical_treatment_fnc_bandageLocal;
                _bv = player getVariable["ace_medical_bloodvolume", 6];
                player setVariable["ace_medical_bloodvolume", (_bv + 0.05) min 6, true];
                _pain = player getVariable["ace_medical_pain", 0];
                player setVariable["ace_medical_pain", ((_pain - 0.025) max 0) min 1, true];
                sleep 7;
            } else {
                _bv = player getVariable["ace_medical_bloodvolume", 6];
                player setVariable["ace_medical_bloodvolume", (_bv + 0.01) min 6, true];
                _pain = player getVariable["ace_medical_pain", 0];
                player setVariable["ace_medical_pain", ((_pain - 0.01) max 0) min 1, true];
                sleep 2;

                if ((_i == 4) || (_i == 5)) then {
                    player setDamage 0;
                };
                if ((_i == 0) && (player getVariable ["kat_breathing_airwaystatus", 100] <= 95)) then {
                    player setVariable ["kat_airway_occluded", false, true];
                    [player, player] call kat_airway_fnc_treatmentAdvanced_turnaroundHead;
                    [player, player, "Larynxtubus"] call kat_airway_fnc_treatmentAdvanced_airwayLocal;
                    sleep 2;
                };
                _bd = player getVariable["ace_medical_fractures", [0, 0, 0, 0, 0, 0]];
                if ((_bd select _i) == 1) then {
                    _bd set [_i, -1];
                    sleep 9;
                };
            };
        } forEach _bodyParts;

        if (player getVariable "kat_breathing_pneumothorax" > 0) then {
            player setVariable ["kat_breathing_pneumothorax", 0, true];
            player setVariable ["kat_breathing_deepPenetratingInjury", false, true];
        };

        if (player getVariable["ace_medical_heartRate", 80] == 0) then {
            ["ace_medical_CPRSucceeded", player] call CBA_fnc_localEvent;
            sleep 25;
        };
    };

  
};

//О, МОИ МАСКХАЛАТИКИ, ГОРЖУСЬ ТЕМ ПИДОРОМ, КТО СДЕЛАЛ ЭТО В ПРОШЛОМ :)
BSO_System_fnc_Mashalat_nadet = {
    params ["_halat"];

    if (!(isNil { player getVariable 'BSO_System_Uniform'})) exitWith {
        player forceAddUniform _halat;
    };

        _uniform = uniform player;
        _item = uniformItems player;
        _arr = [_uniform, _item];
        player setVariable ["BSO_System_Uniform", _arr];
        player forceAddUniform _halat;
        player call BSO_System_fnc_changePlayerCiv;
};

BSO_System_fnc_Mashalat = {
    params ["_value"];
    switch (true) do {
        case (_value == 1): {
            ["U_B_FullGhillie_ard"] spawn BSO_System_fnc_Mashalat_nadet;
        };
        case (_value == 2): {
            ["U_B_FullGhillie_lsh"] spawn BSO_System_fnc_Mashalat_nadet;
        };
        case (_value == 3): {
            ["U_B_FullGhillie_sard"] spawn BSO_System_fnc_Mashalat_nadet;
        };
        case (_value == 4): {
            ["U_B_T_FullGhillie_tna_F"] spawn BSO_System_fnc_Mashalat_nadet;
        };
        case (_value == 5): {
            _arr = player getVariable "BSO_System_Uniform";
            _uniform = _arr select 0;
            _items = _arr select 1;
            player forceAddUniform _uniform;
            {
                player addItemToUniform _x;
            } forEach _items;
            player setVariable ["BSO_System_Uniform", nil];
            player setUnitTrait ["audibleCoef", 1];
            player setUnitTrait ["camouflageCoef", 1];
            player call BSO_System_fnc_changePlayerBlue;
        };
    };
};

//ОКЕЕЕЙ, А НАХУЯ? ЕСТЬ ЖЕ ДЕФЕНДЕР, НУ ЛАДНО, ВЫРЕЖУ НАХУЙ ЧУРКУ
BSO_System_fnc_Close_Vehicle = {
    private _player = player;
    private _target = cursorObject;

    if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
        hint "Вы не навелись на живой транспорт.";
    };

    private _playerPos = getPos _player;
    private _targetPos = getPos _target;
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 5;

    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
            [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_target, false] remoteExec ["enableSimulationGlobal", 2];

            systemChat "Техника заблокирована";

    };
};

BSO_System_fnc_Open_Vehicle = {
    private _player = player;
    private _target = cursorObject;

    if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
        hint "Вы не навелись на живой транспорт.";
    };

    private _playerPos = getPos _player;
    private _targetPos = getPos _target;
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 5;

    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
        [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_target, true] remoteExec ["enableSimulationGlobal", 2];  
        systemChat "Техника разблокирована";

    };
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

//НУ ВОТ МАМА НЕ УЧИЛА НАХУЙ УДАЛЯТЬ НАХУЙ ФУНКЦИИ НЕ ИСПОЛЬЗУЕМЫЕ
BSO_System_fnc_Vehicle_jedi_card_act = {
	params ["_pl"];
	[]
};

//ОПЯТЬ ЧИТЫ, ОНИ ПОКА ПОД ВОПРОСОМ УДАЛЕНИЯ НАХУЙ, МНЕ ТУТ ЧИТЫ НАХУЙ НЕ НУЖНЫ, ПШЛИ НАХУЙ, ПОТОМ ПО НОВОЙ ДОБАВЛЯТЬ БУДЕТЕ, МНЕ ПОХУЙ
BSO_System_fnc_Vehicle_spawn = {
    params ["_veh", ["_requester", objNull, [objNull]]];
    if (isNull _requester) then { _requester = player; };
    if (!isServer) exitWith {
        [_veh, _requester] remoteExecCall ["BSO_System_fnc_Vehicle_spawn", 2];
    };
    if (isNull _requester || {!isPlayer _requester}) exitWith {};
    if (remoteExecutedOwner > 0 && {owner _requester != remoteExecutedOwner}) exitWith {};
    if !(_veh in BSO_Vehicle_Array) exitWith { diag_log format ["[BSO Vehicle] rejected class %1", _veh]; };
    _ppos = getpos _requester;
    _pdir = getDir _requester;
    _vehicle = createVehicle [_veh, [(_ppos select 0) + sin(_pdir) * 5, (_ppos select 1) + cos(_pdir) * 6, (_ppos select 2) + 1], [], 0, "CAN_COLLIDE"];
    _vehicle setDir (_pdir + 90);
    
    createVehicleCrew _vehicle;
    _vehicle setVehicleAmmo 1;

    if (_veh isEqualTo "mti_armoury_drones_paap_aa") then {
        for "_i" from 1 to 3 do {
            _vehicle addMagazineTurret ["mti_armoury_mag_paap", [0]];
        };
    };
    
    if (count crew _vehicle > 0) then {
        _group = group driver _vehicle;
        _group setBehaviour "AWARE";
        _group setCombatMode "RED";
        _group setFormation "WEDGE";
        
        _wp = _group addWaypoint [_ppos, 50];
        _wp setWaypointType "SAD";
        _wp setWaypointSpeed "NORMAL";
        _wp setWaypointBehaviour "AWARE";
    };
    

    [_vehicle, true] remoteExec ["enableSimulationGlobal", 2];
    

    _vehicle addAction ["Высадить экипаж", {
        params ["_vehicle", "_caller", "_actionId"];
        {
            if (alive _x) then {
                _x moveOut _vehicle;
            };
        } forEach crew _vehicle;
        hint "Экипаж высажен";
    }, nil, 1.5, true, false, "", "", 10];
    
    hint format [" %1 готова и готова к бою", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];
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

//ЧИТЫ
BSO_System_fnc_delete_vehicle = {
    _del = cursorObject;
    deleteVehicle _del;
    hint "Техника удалена";
};

//ЧИТЫ
BSO_System_fnc_repair_vehicle = {
    _vehicle = cursorObject;
    if (!isNull _vehicle && {_vehicle isKindOf "AllVehicles"}) then {
    _vehicle setDamage 0;
    _vehicle setFuel 1;
    _vehicle setVehicleAmmo 1;
    hint "Техника отремонтирована";
    } else {
    hint "Нет техники под курсором";
    };
};

//ТАААК, ЛАДНО, ОКЕЙ, ДВЕ ФУНКЦИИ НА УДАЛЕНИЕ ЭКИПАЖА, ЛАДНО, ХУЙ С НИМ
BSO_System_fnc_remove_crew = {
    _vehicle = cursorObject;
    if (isNil {_vehicle}) exitWith {};
    
    {
        if (alive _x) then {
            _x moveOut _vehicle;
        };
    } forEach crew _vehicle;

    hint "Экипаж удален";
};

//ЁБАНЫЕ ЧИТЫ, НУ ЛИБО ЭТО ЧТО-ТО ИЗ МОЕГО О ЧЁМ Я ЗАБЫЛ, ХУЙ С НИМ, ПОКА БЕЗ ИЗМЕНЕНИЙ
BSO_System_fnc_remove_laat_crew = {
    _heli = player getVariable "BSO_System_LAAT";
    if (isNil {_heli}) exitWith {
        hint "У вас нет активного ЛААТ";
    };
    
    if (!alive _heli) exitWith {
        hint "ЛААТ уничтожен";
    };
    
    {
        if (alive _x) then {
            _x moveOut _heli;
        };
    } forEach crew _heli;

    hint "Экипаж ЛААТ высажен";
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

//КТО-ТО МНЕ СКАЖЕТ НАХУЯ Я СДЕЛАЛ АСЕ АКШЕОНЕ В ОТДЕЛЬНОЙ ФУНКЦИИ? НЕТ? НУ ЛАДНО, НА ПЕРЕПИСЬ.
BSO_System_fnc_Vehicle_Defender = {
	params ["_pl"];
	_actions = [];
	_action_defender = [
		"BSO_System_Vehicle_Defender",
		"Активировать противоугонную систему",
		"",
		{
			_veh = vehicle player;
			_veh setVariable ["BSO_System_Vehicle_Defender", true];
			_EH_Veh = _veh addEventHandler ["Engine", {
				params ["_vehicle", "_engineState"];
				_mine = createvehicle ["Bo_GBU12_LGB", position _vehicle, [], 0, "CAN_COLLIDE"];
				[_mine, true] remoteExec ["hideObjectGlobal", 2, false];
				_mine attachTo [_vehicle];
				_mine setDamage 1;
			}];
			_veh setVariable ["BSO_System_Vehicle_EventHandler", _EH_Veh];
		},
       
		{
			(vehicle player != player) && (isNil {
				vehicle player getVariable 'BSO_System_Vehicle_Defender'
			}) && (driver vehicle player isEqualTo player) && ((isEngineOn vehicle player) == false) and
             (BSO_Cards_Array select 0 in items player)
		}
	] call ACE_interact_menu_fnc_createAction;

	_action_defuse = [
		"BSO_System_Vehicle_Defender_Defuse",
		"Деактивировать противоугонную систему",
		"",
		{
			_veh = vehicle player;
			_E_H = _veh getVariable "BSO_System_Vehicle_EventHandler";
			_veh removeEventHandler ["Engine", _E_H];
			_veh setVariable ["BSO_System_Vehicle_Defender", nil];
			_veh setVariable ["BSO_System_Vehicle_EventHandler", nil];
		},
    
		{
			(vehicle player != player) && (!isNil {
				vehicle player getVariable 'BSO_System_Vehicle_Defender'
			}) && (driver vehicle player isEqualTo player) && ((isEngineOn vehicle player) == false) and
            (BSO_Cards_Array select 0 in items player)
		}
	] call ACE_interact_menu_fnc_createAction;
	_actions append [ [_action_defender, [], _pl], [_action_defuse, [], _pl] ];
	(_actions)
};

//МОЕГО ИНВАЛИДА ПОНЁРФИЛИ, НУ ДА ПОХУЙ, ПУСТЬ ЛЕЖИТ ТАКИМ, КАКОЙ ЕСТЬ, МБ ЛЕТ ЧЕРЕЗ 5 ПРИДЁТ ИДЕЯ СДЕЛАТЬ ЧТО-ТО АДЕКВАТНОЕ
BSO_System_fnc_Personality_Scaner = {
	_unit = cursorObject;

	if (isNull _unit || !alive _unit || !(_unit isKindOf 'Man')) exitWith {
		hint 'Вы не навелись на живой организм';
	};

	player setVariable ['BSO_System_Personality_Scaner_Activ', false];

	_form = {
		params [
			["_text", "Ошибка", [""]],
			["_check", "nil", [""]]
		];

		if (_check == "") then {
			_check = "Не имеется";
		};

		format [_text, _check];
	};

	private ["_idc", "_side"];

	switch (true) do {
		case ("JLTS_ids_gar_army" in items _unit): {
			_idc = "Идентификация: Боец ВАР"
		};

		case ("JLTS_ids_rep_civ" in items _unit): {
			_idc = "Идентификация: Гражданин Республики"
		};

		default {
			_idc = "Идентификация: Лицо не опознано"
		};
	};

	switch (true) do {
		case (side _unit == side player): {
			_side = "Отношение: Дружелюбное"
		};

		default {
			_side = "Отношение: Не определено"
		};
	};

	_ident = ["Идентификатор:%1", name _unit] call _form;
    _prim = ["Основное оружие: %1", getText(configFile >> "CfgWeapons" >> primaryWeapon _unit >> "displayName")] call _form;
    _sec = ["Пускавая установка: %1", getText(configFile >> "CfgWeapons" >> secondaryWeapon _unit >> "displayName")] call _form;
    _hand = ["Вторичное оружие: %1", getText(configFile >> "CfgWeapons" >> handgunWeapon _unit >> "displayName")] call _form;


	[
		[
			[_ident, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>"],
			[_idc, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>"],
			[_side, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>"],
			[_prim, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>"],
			[_sec, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>"],
			[_hand, "<t align = 'right' shadow = '1' size = '0.5' font='PuristaBold'>%1</t><br/>", 15]
		],
		0,
		safeZoneY + safeZoneH / 2
	] call BIS_fnc_typeText;

	player setVariable ['BSO_System_Personality_Scaner_Activ', true];
};

//ПОСМОТРЮ, НО ПОКА Я ЭТУ ХУЙНЮ ТРОГАТЬ НЕ БУДУ, ВОЗМОЖНО НА САМОМ КОНЕЧНОМ ЭТАПЕ ЧИСТКИ ЧТО-ТО ДА И ПРИДУМАЮ
BSO_System_fnc_changePlayerSide = {
    private _player = player; 
    private _currentSide = side _player;
 
    [_player] joinSilent grpNull; 

    private _newSide = if (_currentSide == civilian) then { west } else { civilian }; 

    private _newGroup = createGroup _newSide; 
    [_player] joinSilent _newGroup;
 
    hint format ["Вы теперь на стороне: %1", side _player]; 
};

BSO_System_fnc_changePlayerBlue= {
  private _player = player;
  private _group = createGroup west;
  [_player] joinSilent _group; 
  hint "Маскировка снята";
};

BSO_System_fnc_changePlayerCiv= {
  private _player = player;
  private _group = createGroup civilian;
  [_player] joinSilent _group; 
  hint "Теперь все думают что вы гражданский";
};

//ЁБАНЫЕ СПИДЫ, КТО ИХ ТРОГАЛ? ЛАДНО, ХУЙ С НИМИ, ПОТОМ ТОЖЕ ПЕРЕПИШУ НАХУЙ, А ТО ЭТО ПИЗДЕЦ ЗВИЗДЕЦ
fnc_BSO_Speed_Act = {
   
    private _unit = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];

    if ((_unit getVariable ["bigspeed", false]) == false) then {
        _unit say3D "ACE_hit_Male06ENG_high_1";
        [_unit, 1.5] remoteExec ["setAnimSpeedCoef", 0];
        _unit setVariable ["bigspeed", true, true];

        private _ehId = [
            {
                params ["_args", "_deltaTime", "_handleId"];
                private _u = _args select 0;
                if (!alive _u || !(_u getVariable ["bigspeed", false])) exitWith {
                    [_handleId] call CBA_fnc_removePerFrameHandler;
                };
                [_u, 1.5] remoteExec ["setAnimSpeedCoef", 0];
            },
            0.5,
            [_unit]
        ] call CBA_fnc_addPerFrameHandler;
        _unit setVariable ["BSO_Speed_EH", _ehId];

        hint "быстрые ноги чапалах не получат";
    } else {
        [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        private _ehId = _unit getVariable ["BSO_Speed_EH", -1];
        if (_ehId != -1) then { [_ehId] call CBA_fnc_removePerFrameHandler; };
        [_unit, 1] remoteExec ["setAnimSpeedCoef", 0];
        _unit setVariable ["bigspeed", false, true];
        _unit setVariable ["BSO_Speed_EH", nil];
        hint "пора отдохнуть";
    };
};

//ПОД ПЕРИПИСЬ СУКУ, Я ТЕБЯ ВЫЕБУ И ВЫСУШУ БЛЯТЬ, БУДЕШЬ У МЕНЯ РАБОТАТЬ ПО НОВОМУ И С ОПТИМИЗАЦИЕЙ ДУРА ЕБАНАЯ
BSO_System_fnc_Stimulator_Act = {
    params ["_timerCD"];
    if (!hasInterface || {isNull player} || {!alive player}) exitWith {};

    private _player = player;
    private _cooldown = (_timerCD max 30) min 3600;
    if ((_player getVariable ["cooldownArmorArc", 0]) > 0) exitWith {
        hint "Стимулятор ещё не готов";
    };
    if (_player getVariable ["BSO_System_Stimulator_Activ", false]) exitWith {};

    private _wasDamageAllowed = isDamageAllowed _player;
    private _endTime = time + 45;
    _player setVariable ["cooldownArmorArc", _cooldown, false];
    _player setVariable ["BSO_System_Stimulator_Activ", true, true];
    _player allowDamage false;
    _player say3D "ACE_hit_Male06ENG_high_1";
    [_player] call ace_medical_treatment_fnc_fullHealLocal;
    hint "Стимулятор активирован: неуязвимость на 45 секунд";

    while {alive _player && {time < _endTime} && {_player getVariable ["BSO_System_Stimulator_Activ", false]}} do {
        sleep 3;
        if (alive _player) then {
            [_player] call ace_medical_treatment_fnc_fullHealLocal;
        };
    };

    if (!isNull _player) then {
        _player allowDamage _wasDamageAllowed;
        _player setVariable ["BSO_System_Stimulator_Activ", false, true];
    };
    hint format ["Действие стимулятора завершено. Перезарядка: %1 сек.", _cooldown];

    for "_remaining" from _cooldown to 1 step -1 do {
        if (isNull _player) exitWith {};
        _player setVariable ["cooldownArmorArc", _remaining, false];
        sleep 1;
    };
    if (!isNull _player) then {
        _player setVariable ["cooldownArmorArc", 0, false];
    };
};

BSO_System_AdvancedArmour_Heal = {
	params ["_pl", "_timerCD"];
	if (
	(gestureState _pl == "BSO_System_Gest_Heal") or
	!(alive _pl) or 
	(lifeState _pl == "INCAPACITATED")
	) exitWith {};
	if (stance _pl == "PRONE") exitWith {systemChat "You heal yourself while prone";};
	_pl playActionNow "BSO_System_Gest_Heal";
	[_pl,"BSO_System_armor_TakingBattery",15] spawn BSO_System_PlaySounds;
	_stim = "JLTS_GH_drugs_electrolit" createVehicle [0,0,0];
	_stim attachTo [_pl,[0.01,-0.1,0.02],"LeftHand",true]; 
	_y =0;          
	_p = 180;          
	_r  = 0;          
	_stim setVectorDirAndUp [                 
			[sin _y * cos _p, cos _y * cos _p, sin _p],                 
			[[sin _r, -sin _p, cos _r * cos _p], -_y] call BIS_fnc_rotateVector2D                 
	];  
	player playActionNow "BSO_System_Gest_Heal";
	uisleep 0.5;
	if !(gestureState _pl == "BSO_System_Gest_Heal") exitWith {deleteVehicle _stim;};
	[_pl,"BSO_System_openSyringe",15] spawn BSO_System_PlaySounds;
	uisleep 0.5;
	if !(gestureState _pl == "BSO_System_Gest_Heal") exitWith {deleteVehicle _stim;};
	[_pl,"BSO_System_useSyringe",15] spawn BSO_System_PlaySounds;
	[_timerCD] spawn BSO_System_fnc_Stimulator_Act;
	uiSleep 0.1;
	_pl setVariable ["ace_medical_bodypartdamage",nil,true];
	uisleep 0.33;
	deleteVehicle _stim;
	if !(gestureState _pl == "BSO_System_Gest_Heal") exitWith {};
	[_pl,"BSO_System_Swing_1",5] spawn BSO_System_PlaySounds;
};

//К ЭТОЙ ЗАЛУПЕ Я НЕ ПРИТРОНУСЬ, ТРОГАТЬ ЕЁ НЕ БУДУ И ВООБЩЕ ЭТО ПИЗДЕЦ, ПУСТЬ ЛЕЖИТ, ЕСЛИ РАБОТАЕТ, ТО ПУСКАЙ, НЕ БУДЕТ РАБОТАТЬ, МНЕ ПОХУЙ
BSO_System_fnc_AutoAim_Enable = {
    private _uid = getPlayerUID player;
    if (_uid != "76561198447827807") exitWith { hint "Недостаточно прав"; };

    private _unit = player;
    if (_unit getVariable ["BSO_AutoAim_Active", false]) exitWith { hint "Автонаведение уже активно"; };

    _unit setVariable ["BSO_AutoAim_Active", true, true];

    private _ehId = [
        {
            params ["_args", "_dt", "_hid"]; 
            private _u = _args select 0;
            if (!alive _u || !(_u getVariable ["BSO_AutoAim_Active", false])) exitWith {
                [_hid] call CBA_fnc_removePerFrameHandler;
            };

            private _side = side _u;
            private _pos = eyePos _u;
            private _enemies = allUnits select { alive _x && (_x != _u) && (side _x != _side) };
            if (_enemies isEqualTo []) exitWith { _u doWatch objNull; };

            private _target = objNull;
            private _minDist = 1e9;
            {
                private _d = _pos distanceSqr (eyePos _x);
                if (_d < _minDist) then {
                    if ([_u, "FIRE"] checkVisibility [eyePos _u, eyePos _x] > 0.05) then {
                        _minDist = _d;
                        _target = _x;
                    };
                };
            } forEach _enemies;

            if (!isNull _target) then {
                _u reveal _target;
                _u doWatch _target;
                private _veh = vehicle _u;
                if (_veh != _u) then {
                    _veh doTarget _target;
                };
            } else {
                _u doWatch objNull;
            };
        },
        0.05,
        [player]
    ] call CBA_fnc_addPerFrameHandler;

    _unit setVariable ["BSO_AutoAim_EH", _ehId];

    if (isNil { _unit getVariable "BSO_AutoAim_Fired_EH" }) then {
        private _firedId = _unit addEventHandler ["FiredMan", {
            params ["_shooter", "_weapon", "_muzzle", "_mode", "_ammo", "_mag", "_projectile"]; 
            if (isNull _projectile) exitWith {};
            if (!(_shooter getVariable ["BSO_AutoAim_Active", false])) exitWith {};
            [_shooter, _projectile] call BSO_System_fnc_AutoAim_trackProjectile;
        }];
        _unit setVariable ["BSO_AutoAim_Fired_EH", _firedId, true];
    };

    BSO_System_fnc_AutoAim_attachVehEH = {
        params ["_unit"];
        private _veh = vehicle _unit;
        if (_veh == _unit) exitWith {};
        if (!isNil { _veh getVariable "BSO_AutoAim_VEH_EH" }) exitWith {};
        private _id = _veh addEventHandler ["Fired", {
            params ["_veh", "_weapon", "_muzzle", "_mode", "_ammo", "_mag", "_projectile"]; 
            if (isNull _projectile) exitWith {};
            private _sh = effectiveCommander _veh;
            if (isNull _sh) then { _sh = driver _veh; };
            if (_sh != player) exitWith {};
            if (!(player getVariable ["BSO_AutoAim_Active", false])) exitWith {};
            [player, _projectile] call BSO_System_fnc_AutoAim_trackProjectile;
        }];
        _veh setVariable ["BSO_AutoAim_VEH_EH", _id, true];
    };

    [] call BSO_System_fnc_AutoAim_attachVehEH;

    if (isNil { _unit getVariable "BSO_AutoAim_Move_EHs" }) then {
        private _gin = _unit addEventHandler ["GetInMan", {
            params ["_unit", "_role", "_veh", "_turret"]; 
            [_unit] call BSO_System_fnc_AutoAim_attachVehEH;
        }];
        private _gout = _unit addEventHandler ["GetOutMan", {
            params ["_unit", "_role", "_veh", "_turret"]; 
            private _id = _veh getVariable ["BSO_AutoAim_VEH_EH", -1];
            if (_id != -1) then { _veh removeEventHandler ["Fired", _id]; _veh setVariable ["BSO_AutoAim_VEH_EH", nil, true]; };
        }];
        _unit setVariable ["BSO_AutoAim_Move_EHs", [_gin, _gout], true];
    };
    hint "Автонаведение: ВКЛ";
};

BSO_System_fnc_AutoAim_Disable = {
    private _uid = getPlayerUID player;
    if (_uid != "76561198447827807") exitWith {};
    private _unit = player;
    private _ehId = _unit getVariable ["BSO_AutoAim_EH", -1];
    if (_ehId != -1) then { [_ehId] call CBA_fnc_removePerFrameHandler; };
    _unit setVariable ["BSO_AutoAim_EH", nil, true];
    private _firedId = _unit getVariable ["BSO_AutoAim_Fired_EH", -1];
    if (_firedId != -1) then { _unit removeEventHandler ["FiredMan", _firedId]; };
    _unit setVariable ["BSO_AutoAim_Fired_EH", nil, true];
    private _veh = vehicle _unit;
    if (_veh != _unit) then {
        private _vid = _veh getVariable ["BSO_AutoAim_VEH_EH", -1];
        if (_vid != -1) then { _veh removeEventHandler ["Fired", _vid]; _veh setVariable ["BSO_AutoAim_VEH_EH", nil, true]; };
    };
    private _moveEHs = _unit getVariable ["BSO_AutoAim_Move_EHs", []];
    if ((count _moveEHs) == 2) then {
        _unit removeEventHandler ["GetInMan", (_moveEHs select 0)];
        _unit removeEventHandler ["GetOutMan", (_moveEHs select 1)];
        _unit setVariable ["BSO_AutoAim_Move_EHs", nil, true];
    };
    _unit setVariable ["BSO_AutoAim_Active", false, true];
    _unit doWatch objNull;
    hint "Автонаведение: ВЫКЛ";
};

BSO_System_fnc_AutoAim_trackProjectile = {
    params ["_shooter", "_proj"];
    private _side = side _shooter;
    private _pickTarget = {
        private _candidates = allUnits select { alive _x && (_x != _shooter) && (side _x != _side) };
        if (_candidates isEqualTo []) exitWith { objNull };
        private _eye = eyePos _shooter;
        private _dir = eyeDirection _shooter;
        private _best = objNull; private _bestScore = 1e9;
        {
            private _to = (eyePos _x) vectorDiff _eye;
            private _dist = _eye distance (eyePos _x);
            if (_dist <= 600) then {
                private _angle = acos ((vectorNormalized _to) vectorDotProduct _dir);
                if (_angle <= 30) then {
                    if ([_shooter, "FIRE"] checkVisibility [_eye, eyePos _x] > 0.01) then {
                        private _score = _angle * 0.5 + (_dist / 600);
                        if (_score < _bestScore) then { _bestScore = _score; _best = _x; };
                    };
                };
            };
        } forEach _candidates;
        _best
    };

    private _pfh = [
        {
            params ["_args", "_dt", "_hid"]; 
            _args params ["_sh", "_p", "_picker"];
            if (isNull _p) exitWith { [_hid] call CBA_fnc_removePerFrameHandler; };
            private _tgt = call _picker;
            if (isNull _tgt) exitWith {};
            private _speed = vectorMagnitude velocity _p;
            private _to = (eyePos _tgt) vectorDiff (getPosASL _p);
            private _dir = vectorNormalized _to;
            private _up = vectorUp _p;
            _p setVectorDirAndUp [_dir, _up];
            _p setVelocity (_dir vectorMultiply (_speed max 50));
        },
        0,
        [_shooter, _proj, _pickTarget]
    ] call CBA_fnc_addPerFrameHandler;
};

BSO_System_fnc_AutoAim_Toggle = {
    private _uid = getPlayerUID player;
    if (_uid != "76561198447827807") exitWith { hint "Недостаточно прав"; };
    private _unit = player;
    if (_unit getVariable ["BSO_AutoAim_Active", false]) then {
        [] call BSO_System_fnc_AutoAim_Disable;
    } else {
        [] call BSO_System_fnc_AutoAim_Enable;
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