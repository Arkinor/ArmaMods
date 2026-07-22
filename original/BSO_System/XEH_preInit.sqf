// Массив с идентификаторами карточек BSO

BSO_Cards_Array = [ 
    "BSO_System_ids_SOB",                  		//0
    "BSO_System_ids_RC",                    	//1
    "BSO_System_ids_ARF",                       //2
    "BSO_System_ids_ARC",                       //3 
    "BSO_System_General_Zey" 				    //4
];



// Массив с техникой для спавна
BSO_Vehicle_Array = [
    ""
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
// Компиляция скрипта для проигрывания звуков
BSO_System_PlaySounds = compile preprocessFileLineNumbers "\BSO_System\createSoundGlobal.sqf";



// Функция проверки и удаления идентификаторов
BSO_System_fnc_Proverka_Delete_Ids = {
	if ((name _this find 'ARF' != -1)
	or (name _this find 'ARC' != -1)
	or (name _this find 'RC' != -1)
	or (name _this find 'SOB' != -1)

    )
	exitWith {};

	{
		if (_x in BSO_Cards_Array) then {
			{
				player removeItem _x;
			} forEach (items player select {
				_x == _x
			});
		};
	} forEach (items player);
};




// _unit removeItem "JLTS_drugs_bacta_red";
// BSO_System_fnc_Auto_Bacta = {
//     if (player getVariable "ACE_isUnconscious" == true) then {
//         if (player getVariable "BSO_System_AutoBacta" == false) then {
//             systemChat "[SYS] Бакта использована, ожидайте";
//             [{
//                 player call ace_medical_treatment_fnc_fullHealLocal;
//                 player setVariable ["BSO_System_AutoBacta", true];
//                 [{
//                     player setVariable ["BSO_System_AutoBacta", false];
//                 }, [], 300] call CBA_fnc_waitAndExecute;
//             }, [], 13] call CBA_fnc_waitAndExecute;
//         } else {
//             systemChat "[SYS] Лежать и не вставать, бакта перезаряжается";
//             [{
//                 player getVariable "BSO_System_AutoBacta" == false
//             }, {
//                 [] spawn BSO_System_fnc_Auto_Bacta;
//             }, [], 300] call CBA_fnc_waitUntilAndExecute;
//         };
//     };
// };



// Получаем значение переменной\
// _autoBactaValue = "JLTS_drugs_bacta_red" in items player;
// systemChat format ["Значение переменной JLTS_drugs_bacta_red: %1", _autoBactaValue];

// _autoBactaValue = BSO_Cards_Array select 0 in items player;
// systemChat format ["Значение переменной BSO_Cards_Array: %1", _autoBactaValue];

// _autoBactaValue = player getVariable "BSO_System_Stimulator_Activ";
// systemChat format ["Значение переменной BSO_System_Stimulator_Activ: %1", _autoBactaValue];

// _autoBactaValue = player getVariable "BSO_System_AutoBacta";
// systemChat format ["Значение переменной BSO_System_AutoBacta: %1", _autoBactaValue];


BSO_System_fnc_Auto_Bacta = {
    // Проверяем, без сознания ли игрок
    if (player getVariable "ACE_isUnconscious" == true) then {
        // Проверяем, не использовалась ли бакта ранее
        if (player getVariable "BSO_System_AutoBacta" == false) then {


            hint "[SYS] Бакта использована, ожидайте"; 
            
            [{ 
            [player] call ace_medical_treatment_fnc_fullHealLocal; // Лечение игрока
            player setVariable ["BSO_System_AutoBacta", true]; // Устанавливаем флаг использования бакты
            }, [], 20] call CBA_fnc_waitAndExecute;

            // Запланированное выполнение через 300 секунд
            [{ 
                hint "[SYS] Бакта готова"; // Уведомление о готовности бакты
                player setVariable ["BSO_System_AutoBacta", false]; // Сбрасываем флаг
            }, [], 900] call CBA_fnc_waitAndExecute;
        };
    };
};

// Функция авто-лечения игрока
BSO_System_fnc_Auto_Heal_Act = {

    hintSilent format["Автохил %1", player getVariable "BSO_System_Auto_Heal_Active"];
    


    // Цикл для авто-лечения различных частей тела игрока
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
                // Лечение раненой части тела
                [player, _x, "ElasticBandage"] call ace_medical_treatment_fnc_bandageLocal;
                _bv = player getVariable["ace_medical_bloodvolume", 6];
                player setVariable["ace_medical_bloodvolume", (_bv + 0.05) min 6, true];
                _pain = player getVariable["ace_medical_pain", 0];
                player setVariable["ace_medical_pain", ((_pain - 0.025) max 0) min 1, true];
                sleep 7;
            } else {
                // Если часть тела здорова
                _bv = player getVariable["ace_medical_bloodvolume", 6];
                player setVariable["ace_medical_bloodvolume", (_bv + 0.01) min 6, true];
                _pain = player getVariable["ace_medical_pain", 0];
                player setVariable["ace_medical_pain", ((_pain - 0.01) max 0) min 1, true];
                sleep 2;

                // Лечение от повреждений
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

        // Лечение от пневмоторакса
        if (player getVariable "kat_breathing_pneumothorax" > 0) then {
            player setVariable ["kat_breathing_pneumothorax", 0, true];
            player setVariable ["kat_breathing_deepPenetratingInjury", false, true];
        };

        // Проверка на наличие сердечного ритма и применение сердечно-легочной реанимации
        if (player getVariable["ace_medical_heartRate", 80] == 0) then {
            ["ace_medical_CPRSucceeded", player] call CBA_fnc_localEvent;
            sleep 25;
        };
    };

  
};


// Функция надевания масхалата
BSO_System_fnc_Mashalat_nadet = {
    params ["_halat"];

    // Проверка на уже надетую форму
    if (!(isNil { player getVariable 'BSO_System_Uniform'})) exitWith {
        player forceAddUniform _halat;
    };

    // Условия для надевания масхалата в зависимости от наличия карточек
    // if ((BSO_Cards_Array select 3 in items player) or (BSO_Cards_Array select 5 in items player) or (BSO_Cards_Array select 7 in items player)) exitWith {
        _uniform = uniform player;
        _item = uniformItems player;
        _arr = [_uniform, _item];
        player setVariable ["BSO_System_Uniform", _arr];
        player forceAddUniform _halat;
        // player setCaptive true;
        player call BSO_System_fnc_changePlayerCiv;
    // };

    // if (BSO_Cards_Array select 2 in items player) exitWith {
    //     _uniform = uniform player;
    //     _item = uniformItems player;
    //     _arr = [_uniform, _item];
    //     player setVariable ["BSO_System_Uniform", _arr];
    //     player forceAddUniform _halat;
    //     // player setCaptive true;
    //     player call BSO_System_fnc_changePlayerCiv;
    //     player setUnitTrait ["audibleCoef", 0.025];
    //     player setUnitTrait ["camouflageCoef", 0.025];
    // };
};

// Функция выбора масхалата
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
            // player setCaptive false;
            player call BSO_System_fnc_changePlayerBlue;
        };
    };
};


BSO_System_fnc_Close_Vehicle = {
    // Получаем цель таргета
    private _player = player;
    private _target = cursorObject;

    // Проверяем, что цель живая и является одним из указанных типов
    if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
        hint "Вы не навелись на живой транспорт.";
    };

    // Позиции игрока и цели
    private _playerPos = getPos _player; // Позиция игрока
    private _targetPos = getPos _target; // Позиция предмета
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 5; // Задайте значение расстояния

    // Проверяем, находится ли цель в пределах досягаемости
    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
            [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            // Выключаем моделирование
            [_target, false] remoteExec ["enableSimulationGlobal", 0];

            systemChat "Техника заблокирована";

    };
};


BSO_System_fnc_Open_Vehicle = {
    // Получаем цель таргета
    private _player = player;
    private _target = cursorObject;

    // Проверяем, что цель живая и является одним из указанных типов
    if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
        hint "Вы не навелись на живой транспорт.";
    };

    // Позиции игрока и цели
    private _playerPos = getPos _player; // Позиция игрока
    private _targetPos = getPos _target; // Позиция предмета
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 5; // Задайте значение расстояния

    // Проверяем, находится ли цель в пределах досягаемости
    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
        [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_target, true] remoteExec ["enableSimulationGlobal", 0];  
        systemChat "Техника разблокирована";

    };
};





// Функция вызова эвакуационного ЛААТ
BSO_System_fnc_Laat = {
    params ["_unit", "_evac","_vechical"];
    _pos = getPos _unit;
    _unit setVariable ["BSO_System_LAAT_Act_Active", false];
    _heli = createVehicle [_vechical, [(_pos select 0) + random [-20000, 0, 20000], (_pos select 1) + random [-20000, 0, 20000], (_pos select 2) + 100], [], 0, "FLY"];
    _heli setVariable ["BSO_System_LAAT_Unit_Owner", _unit];
    _unit setVariable ["BSO_System_LAAT", _heli];
    _unit setVariable ["BSO_System_LAAT_Evac_CD", false];
    _heli setVariable ["BSO_System_LAAT_Destroy", false];
    _heli setVariable ["BSO_System_LAAT_Distance_While", true];
    createVehicleCrew _heli;
    _groupPlayer = group _unit;
    _group = group driver _heli;
    _group addVehicle _heli;
    _group setBehaviour "CARELESS";
    _group setCombatMode "BLUE";
    _waypoint = _group addWaypoint [_pos, 0];
    _waypoint setWaypointType "SCRIPTED";
    _waypoint setWaypointScript "\x\zen\addons\ai\functions\fnc_waypointLand.sqf";
    
    // Ожидание пока ЛААТ не сядет
    waitUntil {
        ((getPos _heli select 2) <= 3) or (_heli getVariable "BSO_System_LAAT_Destroy")
    };
    _heli engineOn false;
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
    
    // Ожидание касания земли
    waitUntil {
        (isTouchingGround _heli) or (_heli getVariable "BSO_System_LAAT_Destroy")
    };
    if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
    _heli setVariable ["BSO_System_LAAT_Distance_While", nil];

    if (_evac == 1) then {
        // Добавление действий для указания места посадки и экстренного взлета
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
        
        // Отсчет времени до взлета
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
                if ((!isNil { _heli getVariable "BSO_System_LAAT_Last_TCK" }) or (_heli getVariable "BSO_System_LAAT_Destroy" == true)) then {
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
            ((_heli distance _last_pos) < 100) or (_heli getVariable "BSO_System_LAAT_Destroy")
        };
        _last_pos = _heli getVariable "BSO_System_LAAT_Last_TCK";
        _waypoint = _group addWaypoint [_last_pos, 0];
        _waypoint setWaypointType "SCRIPTED";
        _waypoint setWaypointScript "\x\zen\addons\ai\functions\fnc_waypointLand.sqf";    
        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
        waitUntil {
            ((getPos _heli select 2) <= 2) or (_heli getVariable "BSO_System_LAAT_Destroy")
        };
        _heli engineOn false;
        if (_heli getVariable "BSO_System_LAAT_Destroy" == true) exitWith {};
        
        // Высадка экипажа и удаление ЛААТ
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
                hintSilent "Ваш убер прибыл!";
            };
        } forEach units _groupPlayer;        
        // deleteVehicleCrew _heli;
        _heli setVariable ["BSO_System_LAAT_Unit_Owner", nil];
        _unit setVariable ["BSO_System_LAAT_Evac_CD", nil];
        _heli setVariable ["BSO_System_LAAT_Destroy", nil];    
        [{
            _this setVariable ["BSO_System_LAAT_Act_Active", true];
        }, _unit, 600] call CBA_fnc_waitAndExecute;
    };
};

// функция добавления ACE action для спавна техники
BSO_System_fnc_Vehicle_jedi_card_act = {
	params ["_pl"];

	_actions = [];

	{
		_veh = _x;

		_class = format ["BSO_System_Vehicle_ACE_ACT_%1", _veh];
		_name = format ["Заспавнить %1", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];

		_action = [
			_class,
			_name,
			"",
			{
                params ["_target", "_player", "_params"];
                _veh = _params select 0;
				[_veh] spawn BSO_System_fnc_Vehicle_spawn;
			},
			{
               (BSO_Cards_Array select 0 in items player)
			},
            {},
            [_veh]
		] call ACE_interact_menu_fnc_createAction;

		_actions pushBack [_action, [], _pl];

	}forEach BSO_Vehicle_Array;

	(_actions)
};

BSO_System_fnc_Vehicle_spawn = {
    params ["_veh"];
    _ppos = getpos player;
    _pdir = getDir player;
    _vehicle = createVehicle [_veh, [(_ppos select 0) + sin(_pdir) * 5, (_ppos select 1) + cos(_pdir) * 6, (_ppos select 2) + 1], [], 0, "CAN_COLLIDE"];
    _vehicle setDir (_pdir + 90);
    // Выключаем моделирование
    [_vehicle, false] remoteExec ["enableSimulationGlobal", 0];
    hint format [" %1 готова", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];
};




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
				[_veh] spawn BSO_System_fnc_Items_spawn;
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



BSO_System_fnc_Items_spawn = {
    params ["_veh"];
    _ppos = getpos player;
    _pdir = getDir player;
    _vehicle = createVehicle [_veh, [(_ppos select 0) + sin(_pdir) * 5, (_ppos select 1) + cos(_pdir) * 6, (_ppos select 2)], [], 0, "CAN_COLLIDE"];
    _vehicle setDir (_pdir + 90);
    // Выключаем моделирование
    // [_vehicle, false] remoteExec ["enableSimulationGlobal", 0];
    _vehicle setDamage 0; // Отключает урон, устанавливая его на 0
    hint format [" %1 готова", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];
};





BSO_System_fnc_Remove_Tent = {
    // Получаем игрока
    private _player = player;

    // Параметры поиска
    private _searchRadius = 15; // Радиус поиска
    private _targetTypes = BSO_Item_Arrays;

    // Получаем позиции игрока
    private _playerPos = getPos _player;

    // Находим все объекты в заданном радиусе
    private _targets = nearestObjects [_playerPos, _targetTypes, _searchRadius];
    // _targets = _targets select {alive _x}; // Оставляем только живые объекты

    // Проверяем, есть ли найденные объекты
    if (count _targets == 0) exitWith {
        hint "В радиусе нет палаток.";
    };

    // Обрабатываем каждый найденный объект
    {
        // // Получаем класс объекта
        // private _targetClass = typeOf _x; // Получаем имя класса напрямую
        // systemChat format ["Значение переменной _targetClass: %1", _targetClass];

        // Проверяем, есть ли класс в массиве
        if !(_targetClass in BSO_Item_Array) exitWith {
            hint format ["%1 не является палаткой из списка.", _targetClass];
        };

        // Позиции цели
        private _targetPos = getPos _x; // Позиция предмета
        private _currentDistance = _playerPos vectorDistance _targetPos;

        // Проверяем, находится ли цель в пределах досягаемости
        if (_currentDistance > _searchRadius) then {
            systemChat format ["%1 вне досягаемости.", _targetClass];
        } else {
            // Удаляем объект
            deleteVehicle _x;

            hint format ["%1 удалена", getText(configFile >> "CfgVehicles" >> _x >> "displayName")];
            systemChat format ["%1 удалена", getText(configFile >> "CfgVehicles" >> _x >> "displayName")];
        };
    } forEach _targets;
};




// Функция Удаления техники по курсору
BSO_System_fnc_delete_vehicle = {
    _del = cursorObject;
    deleteVehicle _del;
    hint "Техника удалена";
};

// Функция Починки техники по курсору
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

// Функция удаления экипажа из техники по курсору
BSO_System_fnc_remove_crew = {
    _vehicle = cursorObject;
    if (isNil {_vehicle}) exitWith {};
    
    // Получаем экипаж
    {
        if (alive _x) then {
            _x moveOut _vehicle; // Удаляем из техники
        };
    } forEach crew _vehicle;

    hint "Экипаж удален";
};



// Функция смены одежды.
BSO_System_fnc_Change_Uniform = {
	params ["_value"];
	switch (true) do {
		case (_value == 0): { // сохранение одежды.
			profileNamespace setVariable ["Shadow_saved_headgear", headgear player];
			profileNamespace setVariable ["Shadow_saved_uniform", uniform player];
			profileNamespace setVariable ["Shadow_saved_vest", vest player];
			profileNamespace setVariable ["Shadow_saved_backpack", backpack player];
			saveProfileNamespace;
		};
		case (_value == 1): { // Переключение одежды на сохранённую.
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
		case (_value == 2): { // переключение одежды на старую.
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

// Функция автоугонки.
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
				[_mine, true] remoteExec ["hideObjectglobal", 0, true];
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

// Функция Сканера Личности
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


// Функция для смены стороны игрока
BSO_System_fnc_changePlayerSide = {
    private _player = player; 
    private _currentSide = side _player;
 
    [_player] joinSilent grpNull; 

    private _newSide = if (_currentSide == civilian) then { west } else { civilian }; 

    private _newGroup = createGroup _newSide; 
    [_player] joinSilent _newGroup;
 
    hint format ["Вы теперь на стороне: %1", side _player]; 
};

// Функция для смены стороны игрока синие
BSO_System_fnc_changePlayerBlue= {
  private _player = player;
  private _group = createGroup west;
  [_player] joinSilent _group; 
  hint "Маскировка снята";
};
// Функция для смены стороны игрока гражданские
BSO_System_fnc_changePlayerCiv= {
  private _player = player;
  private _group = createGroup civilian;
  [_player] joinSilent _group; 
  hint "Теперь все думают что вы гражданский";
};

// Функция увеличения скорости игрока
fnc_BSO_Speed_Act = {
   
    if (player getVariable "bigspeed" == false) then {
        player say3D "ACE_hit_Male06ENG_high_1";
        [player, 1.5] remoteExec ["setAnimSpeedCoef", 0];
        player setVariable ["bigspeed", true];
        hint "быстрые ноги чапалах не получат";
    } else {
        [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        // [player, "Jedi_Freeze_Over", 70, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [player, 1] remoteExec ["setAnimSpeedCoef", 0];
        player setVariable ["bigspeed", false];
        hint "пора отдохнуть";
    };};

//отключает тряску рук и усталость на минуту
fnc_BSO_Meditatia_Act = {
    if (player getVariable "Meditatia" == false) then {
    player say3D "ACE_hit_Male06ENG_high_1";
    player enableFatigue false;
    player setCustomAimCoef 0;

        player setVariable ["Meditatia", true];
        hint "Тренировки помогают вам сосредоточиться";

        [{
            player enableFatigue true;
            player setCustomAimCoef 3;
            player setVariable ["Meditatia", false];
        }, [], 60] call CBA_fnc_waitAndExecute;
    };
};


//не используется
// Функция активации стимулятора
BSO_System_fnc_Stimulator_Act = {
    params ["_timerCD"];
    _player = player;
    _player setVariable ["BSO_System_Stimulator_Activ", true];
    _cooldownArmorArc = _player getVariable ["cooldownArmorArc", 0];
    _timerUpTime = 45;
    
    if (_cooldownArmorArc == 0) then {
        _player say3D "ACE_hit_Male06ENG_high_1";
        _endUptimeArmor = time + _timerUpTime;
        _player setVariable ["cooldownArmorArc", _timerCD];
        
        // Цикл лечения игрока в течение действия стимулятора
        while { time <= _endUptimeArmor && alive _player } do {
            sleep 1;
            [_player] call ace_medical_treatment_fnc_fullHealLocal;
        };
        
        // Установка переменных после окончания действия стимулятора
        _player setVariable ["BSO_System_Stimulator_Activ", nil];
        hint format ["Стимулятор не используется, идёт КД %1", _timerCD];
        
        // Отсчет времени до окончания кулдауна
        for [{ private _i = _timerCD }, { _i >= 0 }, { _i = _i - 1 }] do {
            sleep 1;
            _player setVariable ["cooldownArmorArc", _i];
        };
    };
};


// WBK scripts from E.P.S.M mod
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








// Добавление обработчика событий на убийство сущности
addMissionEventHandler ["EntityKilled", {
    params ["_heli", "_killer", "_instigator"];
    if (!(isNil { _heli getVariable "BSO_System_LAAT_Unit_Owner" })) then {
        _owner = _heli getVariable "BSO_System_LAAT_Unit_Owner";
        _heli setVariable ["BSO_System_LAAT_Distance_While", nil];
        _heli setVariable ["BSO_System_LAAT_Destroy", true];
        ["ЛААТ уничтожен! Эвакуация будет доступна через 2 минуты!"] remoteExec ["hint", _owner];
        [{
            _owner = _this select 0;
            _heli = _this select 1;
            _owner setVariable ["BSO_System_LAAT_Act_Active", true];
            deleteVehicleCrew _heli;
            deleteVehicle _heli;            
        }, [_owner, _heli], 120] call CBA_fnc_waitAndExecute;
    };
}
];





