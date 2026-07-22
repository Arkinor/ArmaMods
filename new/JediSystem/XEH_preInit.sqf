
call compile preprocessFileLineNumbers "\JediSystem\fn_compat.sqf";

JediSystem_fnc_deathTelekinesisGroundFx = {
    params [["_creationPos", [], [[]]]];
    if (count _creationPos < 3) exitWith {};
    private _effects = [];
    {
        _x params ["_shape", "_size"];
        private _effect = "#particlesource" createVehicleLocal _creationPos;
        _effect setParticleParams [_shape, "", "SpaceObject", 1, 10, [0,0,3], [0,0,0], 0.1, 1.276, 1, 0, [0,_size,0], [[1,1,1,1]], [1], 0.1, 0.05, "", "", "", 1, false, 0, []];
        _effect setParticleRandom [2, [30,30,3], [0,0,0], 0.2, _size / 2, [0,0,0,0], 2, 0, 10, 0];
        _effect setParticleCircle [30, [0,0,0.2]];
        _effect setDropInterval 0.3;
        _effects pushBack _effect;
    } forEach [
        ["\a3\Data_f\ParticleEffects\Universal\Mud",0.2],
        ["\a3\Data_f\ParticleEffects\Universal\StoneSmall",0.1],
        ["\a3\Data_f\ParticleEffects\Universal\Grass_volume",0.5],
        ["\a3\Data_f\ParticleEffects\Universal\GrassMesh",0.5],
        ["\a3\Data_f\ParticleEffects\Universal\TreePart",0.05]
    ];
    uiSleep 9.1;
    { deleteVehicle _x; } forEach _effects;
};

JediSystem_fnc_deathTelekinesisTargetFx = {
    params [["_unit", objNull, [objNull]]];
    if (isNull _unit) exitWith {};
    private _effect = "#particlesource" createVehicleLocal position _unit;
    _effect setParticleCircle [0, [0,0,0]];
    _effect setParticleRandom [0, [0.1,0,2], [0,0,0], 0, 0, [0,0,0,0], 0, 0];
    _effect setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d",1,0,1], "", "Billboard", 1, 1, [0,0,0], [0,0,0.1], 5, 10.5, 7.9, 0.0000001, [1,2,5], [[1,1,1,1],[1,1,1,1],[1,1,1,0]], [0.08], 1, 0, "", "", position _unit];
    _effect setDropInterval 0.1;
    [_effect, _unit] call BIS_fnc_attachToRelative;
    waitUntil { uiSleep 0.25; !alive _unit || {isNull _unit} };
    deleteVehicle _effect;
};

Cards_Array = [
	    "Jedis",				//0
		"Jedi_Tutaminis",		//1
		"Jedi_Stun",			//2 
		"Jedi_DeathTelekinez",	//3
		"Jedi_ioniz",			//4
		"Jedi_Delete_weapon",	//5 
		"Jedi_MiliKill",		//6
		"Jedi_SpeedUp",			//7 
		"Jedi_vehicle",			//8
		"Jedi_Heal",			//9
		"Jedi_Clone",			//10
		"Jedi_IonizShtorm",		//11 ///НЕТУ
		"Jedi_Exterminatus",	//12 
		"Jedi_fullMana",		//13 
		"Jedi_CheckMana",		//14 
		"Jedi_Ave_Arkinor",		//15
		"Jedi_ChangePlayerSide",//16
		"Jedi_Mili_battle",		//17
		"Jedi_Piro",			//18 НЕТУ
		"Jedi_IH",				//19	
        "Jedi_Telekinez"        //20		
];


// Массив с техникой для спавна
Vehicle_Array = [
	"MTI_Delta7_Base",
	"JMSLLTE_N1fighter_naboo_F",
    "OPTRE_Pelican_armed_CMA",
    "OPTRE_M494",
    "OPTRE_m1087_stallion_unsc_repair",
    "OPTRE_M12R_AA",
    "optre_catfish_gauss_f",
    "ARK_LAATi_Base",
    "MTI_Barc",
    "MTI_LAATi_Base"
];



// Функция проверки и удаления идентификаторов
fnc_Proverka_Delete_Ids = {
	if ((name _this find 'JP' != -1)
    or (name _this find 'JM' != -1)
    or (name _this find 'JK' != -1)
    or (name _this find 'IH' != -1)
    )
	exitWith {};

	{
		if (_x in Cards_Array) then {
			{
				player removeItem _x;
			} forEach (items player select {
				_x == _x
			});
		};
	} forEach (items player);
};




// Функция увеличения скорости игрока
fnc_Speedfocer_Act = {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

    if (player getVariable "speedofforce" == false) then {
        [player, "Jedi_Freeze_Over", 70, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [player, 10] call JediSystem_fnc_remoteAnimSpeed;
        player setVariable ["speedofforce", true];
        hint "Да осветит вас Сила в вашем долгом пути";
    } else {
        [player, "Jedi_Freeze_Over", 70, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [player, 1] call JediSystem_fnc_remoteAnimSpeed;
        player setVariable ["speedofforce", false];
        hint "Ваш путь закончен, пора отдохнуть";
    };};
    };



// функция добавления ACE action для спавна техники
fnc_Vehicle_jedi_card_act = {
	params ["_pl"];

	_actions = [];

	{
		_veh = _x;

		_class = format ["Vehicle_ACE_ACT_%1", _veh];
		_name = format ["Заспавнить %1", getText(configFile >> "CfgVehicles" >> _veh >> "displayName")];

		_action = [
			_class,
			_name,
			"",
			{
                params ["_target", "_player", "_params"];
                _veh = _params select 0;
				[_veh] spawn fnc_Vehicle_jedi_card;
			},
			{
               (Cards_Array select 8 in items player)
			},
            {},
            [_veh]
		] call ACE_interact_menu_fnc_createAction;

		_actions pushBack [_action, [], _pl];

	}forEach Vehicle_Array;

	(_actions)
};

// функция спавна техники
fnc_Vehicle_jedi_card = {
    params ["_veh"];
    if (!hasInterface) exitWith {};
    private _pl = player;
    private _ppos = getPosATL _pl;
    private _pdir = getDir _pl;
    private _spawnPos = [
        (_ppos select 0) + sin _pdir * 5,
        (_ppos select 1) + cos _pdir * 6,
        (_ppos select 2) + 1
    ];
    [_veh, _spawnPos, _pdir + 90, _pl] remoteExecCall ["JediSystem_fnc_spawnVehicleAt", 2];
};



// Функция смены одежды.
fnc_Change_Uniform = {
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


// Функция Удаления техники по курсору
fnc_delete_vehicle = {
    _del = cursorObject;
    deleteVehicle _del;
    hint "Техника удалена";
};

// Функция Починки техники по курсору
fnc_repair_vehicle = {
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
fnc_remove_crew = {
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



fnc_Close_Vehicle = {
    // Получаем цель таргета
    private _player = player;
    private _target = cursorObject;

    // // Проверяем, что цель живая и является одним из указанных типов
    // if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
    //     hint "Вы не навелись на живой транспорт.";
    // };

    // Позиции игрока и цели
    private _playerPos = getPos _player; // Позиция игрока
    private _targetPos = getPos _target; // Позиция предмета
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 10; // Задайте значение расстояния

    // Проверяем, находится ли цель в пределах досягаемости
    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
            [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            [_target, false] call JediSystem_fnc_serverEnableSim;

            systemChat "Техника заблокирована";

    };
};


fnc_Open_Vehicle = {
    // Получаем цель таргета
    private _player = player;
    private _target = cursorObject;

    // // Проверяем, что цель живая и является одним из указанных типов
    // if (isNull _target || !alive _target || !(_target isKindOf "Car" || _target isKindOf "Tank" || _target isKindOf "Air" || _target isKindOf "HeliH" || _target isKindOf "Plane")) exitWith {
    //     hint "Вы не навелись на живой транспорт.";
    // };

    // Позиции игрока и цели
    private _playerPos = getPos _player; // Позиция игрока
    private _targetPos = getPos _target; // Позиция предмета
    private _currentDistance = _playerPos vectorDistance _targetPos;

    private _distance = 10; // Задайте значение расстояния

    // Проверяем, находится ли цель в пределах досягаемости
    if (_currentDistance > _distance) then {
        systemChat "Цель вне досягаемости.";
    } else {
        [Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        [_target, true] call JediSystem_fnc_serverEnableSim;
        systemChat "Техника разблокирована";

    };
};


// // Функция для переворота техники
// fnc_flip_vehicle = {
//     _vehicle = cursorObject;
//     if (!isNull _vehicle && {_vehicle isKindOf "AllVehicles"}) then {
//         // Переворачиваем технику
//         _vehicle setPosASL [(getPosASL _vehicle select 0), (getPosASL _vehicle select 1), 0.5];
//         _vehicle setDamage 0;
//         hint "Техника перевернута в исходное положение";
//     } else {
//         hint "Нет техники под курсором";
//     };
// };


// Функция для смены стороны игрока
fnc_changePlayerSide = {
    private _player = player; 
    private _currentSide = side _player;
 
    [_player] joinSilent grpNull; 

    private _newSide = if (_currentSide == civilian) then { west } else { civilian }; 

    private _newGroup = createGroup _newSide; 
    [_player] joinSilent _newGroup;
 
    hint format ["Вы теперь на стороне: %1", side _player]; 
};

// Функция для смены стороны игрока синие
fnc_changePlayerBlue= {
  private _player = player;
  private _group = createGroup west;
  [_player] joinSilent _group; 
  hint "Маскировка снята";
};
// Функция для смены стороны игрока гражданские
fnc_changePlayerCiv= {
  private _player = player;
  private _group = createGroup civilian;
  [_player] joinSilent _group; 
  hint "Теперь все думают что вы гражданский";
};


//Дать по морде
fnc_Chapalax = {
    _nearestCharacter = cursorObject;

    if (isNull _nearestCharacter || !alive _nearestCharacter || !(_nearestCharacter isKindOf 'Man' || _nearestCharacter isKindOf 'CAManBase')) exitWith {
        hint 'Вы не навелись на живой организм';
    };
     // Разворачиваем цель к игроку
    _nearestCharacter setDir (getDir Player + 180); // 180 градусов для поворота на 180°

    [_nearestCharacter, "PT2_grunt_trapped_kneel"] remoteExec ["switchMove", 0];
    [Player, "AM_Kulak_walkF"] remoteExec ["switchMove", 0]; 
    sleep 1.5;
    
 
    
    [Player, "WBK_FISTS_GRAB_1_MAIN"] remoteExec ["switchMove", 0];
    [Player, "bat_type_hit_1", 100, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";   
    [_nearestCharacter, "WBK_FISTS_GRAB_1_VICTIM"] remoteExec ["switchMove", 0]; 
    sleep 1.5;

       // Разворачиваем цель к игроку
    _nearestCharacter setDir (getDir Player + 180); // 180 градусов для поворота на 180°
    [Player, "WBK_FISTS_GRAB_4_MAIN"] remoteExec ["switchMove", 0];
    [Player, "bat_type_hit_1", 100, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
    [_nearestCharacter, "WBK_FISTS_GRAB_4_VICTIM"] remoteExec ["switchMove", 0]; 
    sleep 1.5;

       // Разворачиваем цель к игроку
    _nearestCharacter setDir (getDir Player + 180); // 180 градусов для поворота на 180°
    [Player, "WBK_FISTS_GRAB_1_MAIN"] remoteExec ["switchMove", 0]; 
    sleep 0.2;
    [Player, "bat_type_hit_1", 100, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
    [_nearestCharacter, "WBK_Walker_Fall_Back_Moveset_3"] remoteExec ["switchMove", 0];
    
    sleep 4;
     // Разворачиваем цель к игроку
    _nearestCharacter setDir (getDir Player + 180); // 180 градусов для поворота на 180°
    [Player, "WBK_FISTS_GRAB_3_MAIN"] remoteExec ["switchMove", 0];
    [Player, "bat_type_hit_1", 100, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
    [_nearestCharacter, "WBK_FISTS_GRAB_3_VICTIM"] remoteExec ["switchMove", 0];
    [Player, ""] remoteExec ["switchMove", 0]; 
    sleep 1;
    [_nearestCharacter, true, 1, true] remoteExecCall ["ace_medical_fnc_setUnconscious", 0];
    sleep 5;
    [_nearestCharacter, false, 1, true] remoteExecCall ["ace_medical_fnc_setUnconscious", 0];


};



// Джедайское антиоглушение
fnc_Antiogl = {
    _unit = player;
    if (_unit getVariable "ACE_isUnconscious" == true) then {
            hint "Нет смерти, есть великая сила";

            _unit call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
            _unit setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",100,true];
            
        };
    };

//Тутаминис
fnc_JediTutaminis = {
  //Тутамис
  _player = Player;
  if (("Force_tir_1" in magazines _player) or ("Force_tir_2" in magazines _player) or ("Force_tir_3" in magazines _player) or ("Force_tir_Sith" in magazines _player))then{

     if (_player getVariable "IMS_LaF_ForceMana" > 0.45)then{
        _mana = _player getVariable "IMS_LaF_ForceMana";
        _mana=_mana-0.45;
        _player setVariable["IMS_LaF_ForceMana",_mana,true];
        
        _player setVariable["UpTutaminis",true,true];
        _player allowDamage false;
        [_player] call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
     
        if (!(isNil {_player getVariable "KG_FORCEHP"})) exitWith {};  
            _var = _player getVariable "IMS_LaF_ShotsToTakeOutOneGuy"; 
            hint "Нет эмоций - есть покой."; 
            _player setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",5000,true];
            [_player, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
            
            sleep 300; 
            _player setVariable["UpTutaminis",false,true];
            _player setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",_var,true]; 
            [_player, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
            _player setVariable ["KG_FORCEHP", nil];
           
        };
    };
}; 
     
fnc_JediClone = {

    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

    if (player getVariable "IMS_LaF_ForceMana" > 0.15)then{
        _mana = player getVariable "IMS_LaF_ForceMana";
        _mana=_mana-0.15;
        player setVariable["IMS_LaF_ForceMana",_mana,true];


        if (player getVariable ["KG_CLONE", false]) exitWith {};
            private _unitToPlay = player;
            private _var = _unitToPlay getVariable ["IMS_LaF_ShotsToTakeOutOneGuy", 100];
            _var = _var - 25;
            _unitToPlay setVariable ["IMS_LaF_ShotsToTakeOutOneGuy", _var, true];
            [player, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            player setVariable ["KG_CLONE", true, true];
        player spawn {
            _i = 0; 
            _uniform = getUnitLoadout  player;
            _position = getPos player;
            "B_soldier_Melee_SW" createUnit [position player, group player, "myUnit = this"];
            myUnit setUnitLoadout _uniform; 
            while {(alive myUnit) && (_i != 70)} do { 
            _i = _i +1; 
            sleep 1; 
            } ;
            [myUnit, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            deleteVehicle myUnit; 
            hint "Dark Clone sleeping";
            };
    sleep 30;
    hint "Клонирование готово";
    player setVariable ["KG_CLONE", false, true];
            };
        };
  };


///////////////////////////

fnc_JediStun = {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{
    _playerPos = getPos player; 

    // Определяем радиус поиска в 10 метров 
    _searchRadius = 10; 

    // Находим всех живых персонажей (игроков и ботов) в заданном радиусе 
    _targets = nearestObjects [player, ["CAManBase", "Man"], _searchRadius]; 

    // Фильтруем только живых персонажей и исключаем игрока из списка 
    _targets = _targets select {alive _x && _x != player}; 

    // Проверяем, есть ли живые персонажи в списке 
    if (count _targets == 0) exitWith { 
        hint "Нет ближайшего живого персонажа."; 
    }; 

    // Проигрывание анимации и звуков эффекта
    [player, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [player, "STAR_WARS_FIGHT_POWERS_PULL"] remoteExec ["switchMove", 0];

    sleep 1.5;

    // Восстанавливаем анимацию в зависимости от оружия
    if (currentWeapon player in IMS_Melee_Weapons) then {
        [player, "melee_armed_idle"] remoteExec ["switchMove", 0];
    } else {
        [player, ""] remoteExec ["switchMove", 0];
    };
    
    player allowDamage false;

    hint "Нет эмоций - есть покой. Всем"; 

    // Обработка всех целей на радиусе 10 метров
    {
        // Проверяем, что цель жива и не является игроком
        if (alive _x && (_x != player) && !(_x getVariable ["ACE_isUnconscious", false])) then {
           [_x, "bayonet_death_2"] remoteExec ["switchMove", 0]; 
        };
    } forEach _targets;

    sleep 3;
        // Обработка всех целей на радиусе 10 метров
    {
        // Проверяем, что цель жива и не является игроком
        if (alive _x && (_x != player) && !(_x getVariable ["ACE_isUnconscious", false])) then {
        
            [_x, true, 0, false] remoteExecCall ["ace_medical_fnc_setUnconscious", 0];
        };
    } forEach _targets;

    // Восстанавливаем возможность получения урона после всех атак
    sleep 1;
    player allowDamage true;


    };
};

fnc_JediHeal = {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{
    // _playerPos = getPos player; 
    // player call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
    [player] call ace_medical_treatment_fnc_fullHealLocal;
    player setVariable ["IMS_LaF_ShotsToTakeOutOneGuy",100,true];

    // Определяем радиус поиска в 6 метров 
    _searchRadius = 7; 

    // Находим всех живых персонажей (игроков и ботов) в заданном радиусе 
    _targets = nearestObjects [player, ["CAManBase", "Man"], _searchRadius]; 

    // Проверяем, есть ли живые персонажи в списке 
    if (count _targets == 0) exitWith { 
        hint "Нет ближайшего живого персонажа."; 
    }; 

    // Проигрывание анимации и звуков эффекта
    [player, "Jedi_Freeze_Over", 70, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    // [player, "WBK_Runner_InAir"] remoteExec ["switchMove", 0]; 
    [player, "STAR_WARS_FIGHT_POWERS_WAVE"] remoteExec ["switchMove", 0];

    player allowDamage false;
    sleep 2;
    hint "Нет смерти - есть Великая Сила."; 


    // Восстанавливаем анимацию в зависимости от оружия
    if (currentWeapon player in IMS_Melee_Weapons) then {
        [player, "melee_armed_idle"] remoteExec ["switchMove", 0];
    } else {
        [player, ""] remoteExec ["switchMove", 0];
    };
    
    // Обработка всех целей на радиусе 10 метров
    {
        [_x, "Jedi_Freeze_Over", 70, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        
        // Полное исцеление цели
        if (alive _x && _x != player) then {
            _x spawn {
            params ["_x"];
            // _x call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
            [_x] remoteExecCall ["ace_medical_treatment_fnc_fullHealLocal", _x];
            if (_x getVariable "ACE_isUnconscious" == true) then {

                // [_x, "WBK_Middle_GetUpUnconscious"] remoteExec ["switchMove", 0];
                // UnconsciousOutProne 
                // UnconsciousOutKneelLauncher
                [_x, "UnconsciousOutKneelLauncher"] remoteExec ["switchMove", 0];
                sleep 3;
                } else {
                    [_x, "WBK_Middle_hit_f_2_1"] remoteExec ["switchMove", 0]; 
                    sleep 1.5;
                    [_x, ""] remoteExec ["switchMove", 0]; 
            };
            // _x call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
            // [_x, 0] remoteExec ["setDamage", 0];

            };
         
        };
    } forEach _targets;

    // Восстанавливаем возможность получения урона после всех атак
    sleep 3;
    player allowDamage true;

    };
};
// PT2_stryder_embark_kneel_back

/////Скрипты с парткл эффектами

Particle_blesk_fnc = {
    params ["_p"];
    if (!hasInterface) exitWith {};
    if (isNull _p) exitWith {};

    private _ppos = if (_p isEqualType []) then { _p } else { getPosATL _p };
    private _Fires = "#particlesource" createVehicleLocal _ppos;  
    _Fires setParticleClass "Flareoslep";
    _Fires setParticleCircle [0, [0, 0, 0]];
    _Fires setLightColor [0.098, 0.098, 1];  
    _Fires setParticleRandom [0.5, [1, 1, 0.4], [0, 0, 4], 0, 0.5, [0, 0, 0, 0], 0, 0];
    _Fires setDropInterval 0.01;
    _Fires attachto [_p, [-0.1, 0.6, -0.5]];
    
    private _electro = "#particlesource" createVehicleLocal _ppos;   
    _electro setParticleCircle [0, [0, 0, 0]];   
    _electro setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   
    _electro setParticleParams [["\A3\data_f\blesk2", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 2], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _ppos];   
    _electro setDropInterval 0.01;   
    _electro attachTo [_p, [-0.1, 0.6, -0.5]];
    
    sleep 3;
    deleteVehicle _electro; 
    deleteVehicle _Fires; 
};

Particle_blesk_fnc_2 = {
    params ["_p"];
    if (!hasInterface) exitWith {};
    if (isNull _p) exitWith {};

    private _ppos = if (_p isEqualType []) then { _p } else { getPosATL _p };
    private _Fires = "#particlesource" createVehicleLocal _ppos;  
    _Fires setParticleClass "Flareoslep";
    _Fires setParticleCircle [20, [0, 0, 0]];
    _Fires setLightColor [0.098, 0.098, 1];  
    _Fires setParticleRandom [0.5, [1, 1, 0.4], [0, 0, 4], 0, 0.5, [0, 0, 0, 0], 0, 0];
    _Fires setDropInterval 0.0001;
    _Fires attachto [_p, [-0.1, 0.6, -0.5]];
    
    private _electro = "#particlesource" createVehicleLocal _ppos;   
    _electro setParticleCircle [20, [0, 0, 0]];   
    _electro setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   
    _electro setParticleParams [["\A3\data_f\blesk2", 1, 0, 1], "", "SpaceObject", 1, 0.7, [0, 0, 6], [0, 0, 0], 0, 20, 20, 0, [0.01, 0.01], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.3], 1, 0, "", "", _ppos];  
    _electro setDropInterval 0.0001;   
    _electro attachTo [_p, [-0.1, 0.6, -0.5]];


    // _zone = "#particlesource" createVehicle _ppos;
    // _zone setParticleClass "Flareoslep"; // Используем тот же класс частиц
    // _zone setParticleCircle [0, [0, 0, 0]]; // Устанавливаем радиус 25 метров
    // _zone setLightColor [0.9, 0.7, 1];  // Ярче синий цвет
    // _zone setParticleRandom [2, [1, 1, 0.6], [0, 0, 30], 0, 1, [0, 0, 0, 0], 0, 0]; // Увеличена вертикальная скорость
    // _zone setDropInterval 0.01; 
    // _zone setPos _ppos; 

    private _zone2 = "#particlesource" createVehicleLocal _ppos;   
    _zone2 setParticleCircle [0, [0, 0, 0]];   
    _zone2 setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   
    _zone2 setParticleParams [["\A3\data_f\blesk2", 1, 0, 1], "", "SpaceObject", 1, 0.7, [0, 0, 6], [0, 0, 0], 0, 20, 20, 0, [0.01, 0.01], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.3], 1, 0, "", "", _ppos];  
    _zone2 setDropInterval 0.01;   
    _zone2 attachTo [_p, [-0.1, 0.6, -0.5]];




    
    sleep 3;
    deleteVehicle _electro; 
    deleteVehicle _Fires; 
    // deleteVehicle _zone; 
    deleteVehicle _zone2; 
};





// в точке по взгляду от меня 25 метров создает инонный взрыв радиусом 20 метров, технику всю выбивает, юнитов красной стороны кидает в 300, дройдов убивает (тестились только Зас дройды)
Jedi_fnc_ioniz = {
     if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

     if (player getVariable "IMS_LaF_ForceMana" > 0.1)then{
        _mana = player getVariable "IMS_LaF_ForceMana";
        _mana=_mana-0.1;
        player setVariable["IMS_LaF_ForceMana",_mana,true];

        // Анимация ++

        [Player] remoteExec ["Particle_blesk_fnc", 0];

        
        // Получаем вектор направления взгляда игрока
        _viewDirection = eyeDirection Player;

        // Создаем позицию для взрывчатки на 25 метров в направлении взгляда игрока 
        _distance = 25; // Фиксированное расстояние
        _heightOffset = 0.5; // Высота, на которую поднимем объект
        _creationPos = getPos Player vectorAdd (_viewDirection vectorMultiply _distance);
        _creationPos set [2, (_creationPos select 2) + _heightOffset];

        [] spawn {
            [Player, "starWars_lightsaber_style1_attack_push"] remoteExec ["switchMove", 0];
            [Player, "FP_Wave", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
            sleep 1;
            if (currentWeapon player in IMS_Melee_Weapons) then {
                [player, "melee_armed_idle"] remoteExec ["switchMove", 0];
            } else {
                [player, ""] remoteExec ["switchMove", 0];
            };
        };

        [_creationPos, Player] remoteExecCall ["JediSystem_fnc_ionizStrike", 2];
        };
    };
};

//Удаляем оружие у врага из рук 
Jedi_fnc_Delete_weapon = {
     if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{


    _nearestCharacter = cursorObject;
    
 
	if (isNull _nearestCharacter || !alive _nearestCharacter || (!(_nearestCharacter isKindOf 'Man') or !(_nearestCharacter isKindOf 'CAManBase'))) exitWith {
		hint 'Вы не навелись на живой организм';
	};

    [] spawn {
    Player playActionNow "starWars_force_fireball";
	[Player, "Minusear", 35, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    sleep 2;
    };



    [_nearestCharacter] remoteExec ["Particle_blesk_fnc", 0];

    [_nearestCharacter, "A_PlayerDeathAnim_Electric"] remoteExec ["switchMove", 0];
    sleep 3; 

    [_nearestCharacter, "WBK_Walker_Hit_F_2_2"] remoteExec ["switchMove", 0];
    sleep 1; 


    [_nearestCharacter, "WBK_FISTS_Execution_main"] remoteExec ["switchMove", 0];
    sleep 2; 

    [_nearestCharacter, ""] remoteExec ["switchMove", 0];
    // Получаем названия оружия из слотов
    private _primaryWeapon = primaryWeapon _nearestCharacter; 
    private _handgunWeapon = handgunWeapon _nearestCharacter; 

    // Удаляем первичное оружие, если оно существует
    if (_primaryWeapon != "") then { 
        systemChat format ["Пытаемся выбросить первичное оружие %1 у %2.", _primaryWeapon, name _nearestCharacter]; 
        _nearestCharacter removeWeaponGlobal  _primaryWeapon; // Удаляем оружие из слота
     //   _weaponObject = createVehicle [_primaryWeapon, getPos _nearestCharacter, [], 0, "CAN_COLLIDE"]; // Создаем объект оружия на земле
        systemChat format ["Первичное оружие %1 выброшено у %2.", _primaryWeapon, name _nearestCharacter]; 
    } else {
        systemChat "Первичное оружие не может быть выброшено (не существует).";

    }; 
    // Удаляем пистолет, если он существует
    if (_handgunWeapon != "") then { 
        systemChat format ["Пытаемся выбросить пистолет %1 у %2.", _handgunWeapon, name _nearestCharacter]; 
        _nearestCharacter removeWeaponGlobal _handgunWeapon; // Удаляем пистолет из инвентаря
        //_weaponObject = createVehicle [_handgunWeapon, getPos _nearestCharacter, [], 0, "CAN_COLLIDE"]; // Создаем объект пистолета на земле
        systemChat format ["Пистолет %1 выброшен у %2.", _handgunWeapon, name _nearestCharacter];

    } else {
        systemChat "Пистолет не может быть выброшен (не существует).";
    };
    }; 
}; 



//Работает только на красную сторону которую найдет в радиусе 90 метров, на технику и юнитов
Jedi_fnc_IonizShtorm = {
    // if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

    //  if (player getVariable "IMS_LaF_ForceMana" > 0.48)then{
    //     _mana = player getVariable "IMS_LaF_ForceMana";
    //     _mana=_mana-0.48;
    //     player setVariable["IMS_LaF_ForceMana",_mana,true];

    // _player = player;
    // [_player, "FP_Wave", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  

    // _searchRadius = 100;  


    // [_player] spawn {
    //     params ["_player"];
    //     _ppos = getPos _player;
        
    //     // Создание огней на позиции игрока
    //     _Fires = "#particlesource" createVehicle _ppos;  
    //     _Fires setParticleClass "Flareoslep";
    //     _Fires setParticleCircle [0, [0, 0, 0]];
    //     _Fires setLightColor [0.098, 0.098, 1];  // цвет
    //     _Fires setParticleRandom [0.5, [1, 1, 0.4], [0, 0, 4], 0, 0.5, [0, 0, 009, 0], 0, 0];
    //     _Fires setDropInterval 0.01;
    //     _Fires attachto [_player, [-0.1, 0.6, -0.5]];
        
    //     private _electro = "#particlesource" createVehicleLocal _ppos;   
    //     _electro setParticleCircle [0, [0, 0, 0]];   
    //     _electro setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   
    //     _electro setParticleParams [["\A3\data_f\blesk2", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 2], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _ppos];   
    //     _electro setDropInterval 0.01;   
    //     _electro attachTo [_player, [-0.1, 0.6, -0.5]];
        
    //     sleep 1;
    //     deleteVehicle _electro; 
    //     deleteVehicle _Fires; 
    // };
    //  [_player, "WBK_Runner_InAir"] remoteExec ["switchMove", 0];
    // // Получаем ближайшие объекты (персонажи и техника)
    // _targets = nearestObjects [_player, ["CAManBase", "Man", "Car", "Tank", "Air", "HeliH", "Plane"], _searchRadius]; 
    // _targets = _targets select {alive _x && (_x != _player) && (getPos _x distance getPos _player >= 20)}; 

    // // Обработка всех целей на радиусе
    // {   
    // // if (side _x == east) then {
    
    // _creationPos = position _x;
    // if (_creationPos distance getPos _player >= 20) then  {
    // // Создаем бомбы на позиции найденных объектов
    // _bomb = "JLTS_explosive_emp_10_ammo" createVehicle _creationPos; 
    // _bomb hideObject true; // Скрываем объект от всех игроков

    // [_bomb, _creationPos] spawn {
    //     params ["_bomb", "_creationPos"];
        
    //     // Создаем огни на позиции взрывчатки
    //     _Fires = "#particlesource" createVehicle _creationPos;  
    //     _Fires setParticleClass "Flareoslep";
    //     _Fires setParticleCircle [0, [0, 0, 0]];
    //     _Fires setLightColor [0.7, 0.7, 1];  // Ярче синий цвет
    //     _Fires setParticleRandom [2, [1, 1, 0.6], [0, 0, 20], 0, 1, [0, 0, 0, 0], 0, 0];
    //     _Fires setDropInterval 0.002; // Уменьшение интервала для более частого появления
    //     _Fires setPos _creationPos; // Устанавливаем позицию огней на место взрывчатки

    //     // Создаем электрошок
    //     _electro = "#particlesource" createVehicle _creationPos;   
    //     _electro setParticleCircle [0, [0, 0, 0]];   
    //     _electro setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   
    //     _electro setParticleParams [["\A3\data_f\blesk2", 1, 0, 1], "", "SpaceObject", 1, 0.7, [0, 0, 6], [0, 0, 0], 0, 20, 20, 0, [0.01, 0.01], [[1, 1, 0.1, 1], [1, 1, 1, 1]], [0.3], 1, 0, "", "", _creationPos];   
    //     _electro setDropInterval 0.002;   
    //    // Устанавливаем позицию электрошока на место взрывчатки
    //     // _electro setPos _creationPos; 
    //     _electro setPos [_creationPos select 0, _creationPos select 1, (_creationPos select 2) - 2];
    //     sleep 0.5; // Держим огни 1 секунду
    //     deleteVehicle _electro; 
    //     deleteVehicle _Fires; 
    //     };
    //     // Устанавливаем урон, чтобы вызвать взрыв
    //     _bomb setDamage 1;
    //     sleep 1;
    //     if (alive _x && ((name _x find "B1" != -1) or (name _x find "В1" != -1) or (name _x find "B2" != -1) or (name _x find "BX" != -1) or (name _x find "OOM" != -1) or (name _x find "OR-" != -1) or (name _x find "BD-" != -1) )    ) then {
    //             _x setDamage 1;
    //     };

    //      [_x, ["hitengine", 1]] remoteExec ["setHitPointDamage", 0]; // Устанавливаем урон на двигатель
    //      [_x, ["hitturret", 1]] remoteExec ["setHitPointDamage", 0]; // Устанавливаем урон на пушку

    //     };
    // } forEach _targets;
    // hint "Все микрохемы отправились на свалку, милорд";
    // [_player, ""] remoteExec ["switchMove", 0];

// };
// };
};


//луч огня

Firekilltarget = {
    params ["_x"];
    [_x] spawn {
        params ["_x"];
        // [_x, "Agni_Loop", 100, 25] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        // _rndWybuch = ["flamethrower_burning_1","flamethrower_burning_2","flamethrower_burning_3","flamethrower_burning_4","flamethrower_burning_7","flamethrower_tankExplodePre_1","flamethrower_tankExplodePre_2"] call BIS_fnc_SelectRandom;
        // [_x, _rndWybuch] remoteExec ["switchMove", 0];
       
        _FlameForObj1 = "#particlesource" createVehicleLocal position _x;    
        _FlameForObj1 setParticleClass "BigDestructionFire";  
        _FlameForObj1 attachto [_x,[0,0,0]];
        _LightForObj1 = "#lightpoint" createVehicleLocal (getpos _x);  
        _LightForObj1 setLightAmbient [0, 0, 0];  
        _LightForObj1 setLightColor [1, 0.45, 0.15];  
        _LightForObj1 setLightBrightness 3;
        _LightForObj1 attachto [_x,[0,0,0.3]];
        sleep 2;
        deleteVehicle _FlameForObj1;
        deleteVehicle _LightForObj1;    

        };
};

createFireballdps = {
       params ["_unit"];

    // Создаем огненный шар на позиции игрока
        _unit allowDamage false;
        _wbk_fireball = "#particlesource" createVehicleLocal position _unit;    
        _wbk_fireball setParticleClass "IEDFlameF";   
        // _wbk_fireball setParticleClass "BigDestructionFire"; 
        // _wbk_fireball setParticleCircle [0.5, [0, 2, 2]];  
      
        // _wbk_fireball setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 2, [0, 0, 0, 0], 0, 0];   

        _wbk_fireball setParticleRandom [
        0, 
        [0, 0, 1],      // Начальная скорость: оставить [0, 0, 1] для движения вверх
        [0, 0, 0],      // Конечная скорость: оставить [0, 0, 0] для статичности
        0.4, 2,         // Минимальная и максимальная скорость: изменено на 0.5 и 3 для большей динамики
        [0.4, 0.4, 0.4, 0], // Упругость: добавлено значение 0.5 для создания эффекта объема
        0,               // Угол наклона: оставить без изменений
        3,             // Угловая скорость: добавлено значение 0.5 для легкого вращения
        1               // Случайный угол наклона: оставить без изменений
        ];


    _wbk_fireball setDropInterval 0.000000001;


    _searchRadius = 1.5; // Установите радиус столкновения
 
      while {_unit getVariable "firefire" == true} do {
        for "_i" from 2 to 50 do {
       
           _viewDirection = eyeDirection _unit;

            // Получаем координаты X и Z из вектора направления
            _xCoord = _viewDirection select 0; // X координата
            _yCoord = _viewDirection select 1; // Y координата 
            _zCoord = _viewDirection select 2; // Z координата

            // Привязываем огненный шар к правой руке игрока с использованием координат вектора направления
            _wbk_fireball attachTo [_unit, [0, _i, _zCoord], "RightHand"];

                // Определяем позицию огненного шара
            _fireballPos = getPos _wbk_fireball;

            // Поиск ближайших объектов в радиусе
            _targets = nearestObjects [_fireballPos, ["CAManBase", "Man"], _searchRadius];

            // Проверка на столкновение с объектами
            {
                if (alive _x and !(Cards_Array select 18 in items _x)) then {
                    systemChat format ["Сожжен %1 ",name _x];
                    _x setDamage 1; // Уничтожаем объект
                    _rndScream = ["jarka_scream_1","jarka_scream_2","jarka_scream_3","jarka_scream_4"] call BIS_fnc_SelectRandom;
                    [_x, _rndScream, 100, 10] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
                    [_x] remoteExec ["Firekilltarget", 0];

                   } else {
                    // systemChat format ["Защищен %1 ",name _x];
                }     
            } forEach _targets; // Применяем к найденным объектам

        };  
    };

    [_unit, "B2_SupperBattleDroid_hit"] remoteExec ["switchMove", 0];

    // Удаляем огненный шар и источник света
    deleteVehicle _wbk_fireball;
};


Jedi_fnc_Fire = {

    _unit = player;
    [_unit, "Agni_Loop", 120, 35] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    [_unit, "STAR_WARS_FIGHT_POWERS_CRYOORPYRO"] remoteExec ["switchMove", 0];
    sleep 2;
    [_unit, "B2_SupperBattleDroid_walk"] remoteExec ["switchMove", 0];
    [_unit] spawn {
     params ["_unit"];   
    _unit setVariable ["firefire", true];
    sleep 10;
    _unit setVariable ["firefire", false];
    };

    _unit spawn {
         params ["_unit"]; 
    [_unit, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
   
    [_unit] spawn createFireballdps;
    };
    // [_unit, ""] remoteExec ["switchMove", 0];


};







Jedi_fnc_fullMana = {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{
        player setVariable["IMS_LaF_ForceMana",0.5,true];
        mana = player getVariable "IMS_LaF_ForceMana";
        systemChat format ["Переменная %1.", mana];
    };
};

Jedi_fnc_CheckMana = {
    if ((("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player)))then{
        mana = player getVariable "IMS_LaF_ForceMana";
        systemChat format ["Переменная %1.", mana];
    };
};

Jedi_fnc_Exterminatus= {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

     if (player getVariable "IMS_LaF_ForceMana" > 0.48)then{
        _mana = player getVariable "IMS_LaF_ForceMana";
        _mana=_mana-0.48;
        player setVariable["IMS_LaF_ForceMana",_mana,true];

    _player = player;
    [_player, "FP_Wave", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  

    _searchRadius = 500;  

     [_player, "STAR_WARS_FIGHT_POWERS_WAVE"] remoteExec ["switchMove", 0];
     sleep 1.5; 
    _targets = nearestObjects [player, ["CAManBase", "Man"], _searchRadius]; 
    _targets = _targets select {alive _x && (_x != _player)}; 
    [_player, "WBK_Runner_InAir"] remoteExec ["switchMove", 0];
    // Обработка всех целей на радиусе
    {   
        [_x, "starWars_force_podniati_victim_anim"] remoteExec ["switchMove", 0];
    } forEach _targets;
    sleep 2; 

    {   
        [_x, "WBK_Smasher_Execution"] remoteExec ["switchMove", 0];
    } forEach _targets;
    sleep 7;

    { 
        _x setDamage 1;     
    } forEach _targets;

    {   
        [_x, "UnconsciousReviveArms_Base"] remoteExec ["switchMove", 0];
    } forEach _targets;
    sleep 2;
    

    _targets = nearestObjects [player, ["Car", "Tank", "Air", "HeliH", "Plane"], _searchRadius]; 
    _targets = _targets select {alive _x && (_x != _player)}; 
    _player playActionNow "starWars_force_fireball";
    sleep 1;
    {  
     sleep 0.5;
     _x setDamage 1; 
    } forEach _targets;

    [_player, "flamethrower_burning_3"] remoteExec ["switchMove", 0];
     sleep 3;

    [_player, ""] remoteExec ["switchMove", 0];
    hint "Всем пизда нахуй";

};
};
};


fnc_Ave_Arkinor= {
    _player = Player;

 
    // [_player, "WBK_SecretAnim_Dance"] remoteExec ["switchMove", 0];
    //  sleep 5; 
    [_player, "starWars_lightsaber_style2_in"] remoteExec ["switchMove", 0];
    sleep 1;
    [_player, "starWars_lightsaber_style2_loop"] remoteExec ["switchMove", 0];

    // Получаем вектор направления взгляда игрока
    _viewDirection = eyeDirection _player;

    // Создаем позицию для взрывчатки на 25 метров в направлении взгляда игрока 
    _distance = 7; // Фиксированное расстояние
    _heightOffset = 1; // Высота, на которую поднимем объект
    _creationPos = getPos _player vectorAdd (_viewDirection vectorMultiply _distance);
    _creationPos set [2, (_creationPos select 2) + _heightOffset]; // Поднимаем позицию на высоту
    _searchRadius = 10;

    // Находим всех живых персонажей (игроков и ботов) в заданном радиусе 
    _targets = nearestObjects [_creationPos, ["CAManBase", "Man"], _searchRadius]; 
    _targets = _targets select {alive _x && (_x != _player)}; 

    // Обработка всех целей
    {
        if (alive _x && !(_x getVariable ["ACE_isUnconscious", false])) then {
                [_x, "UnconsciousMedicFromUnarmed"] remoteExec ["switchMove", 0]; 
                [_x, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
        }
    } forEach _targets;
    sleep 3; 
 
};



Jedi_fnc_DeathTelekinez = {
    if (("Force_tir_1" in magazines player) or ("Force_tir_2" in magazines player) or ("Force_tir_3" in magazines player) or ("Force_tir_Sith" in magazines player))then{

    if (player getVariable "IMS_LaF_ForceMana" > 0.1)then{
    _mana = player getVariable "IMS_LaF_ForceMana";
    _mana=_mana-0.3;
    player setVariable["IMS_LaF_ForceMana",_mana,true];
    _player = player;

    _viewDirection = eyeDirection _player;
    _distance = 15;
    _heightOffset = 0.5;
    _creationPos = getPos _player vectorAdd (_viewDirection vectorMultiply _distance);
    _creationPos set [2, (_creationPos select 2) + _heightOffset];
    _searchRadius = 14;


    _targets = nearestObjects [_creationPos, ["CAManBase", "Man", "Car", "Tank", "Air", "HeliH", "Plane"], _searchRadius];

    _targets = _targets select {
        alive _x && (_x != _player) && {
            if ( _x isKindOf "Man") then {
                side _x != west
            } else {
                ({side _x != west} count crew _x > 0)
            }
        }
    };
    _elementCount = count _targets;
    
    if (_elementCount == 0) exitWith {
		systemChat 'Нет доступных целей';
	};


     // Проверяем наличие доступных целей
    if (count _targets > 0) then {
        {
            _type = typeOf _x; // Получаем тип объекта
            systemChat format ["Наши враги: %1", _type]; // Выводим тип в системный чат
        } forEach _targets;
    }; 

    [_player, "starWars_force_fireball"] remoteExec ["playActionNow", 0];

    [_creationPos] remoteExecCall ["JediSystem_fnc_deathTelekinesisGroundFx", 0, false];

    {
    _unit = _x;

    [_unit] remoteExecCall ["JediSystem_fnc_deathTelekinesisTargetFx", 0, false];
    [_unit, "Star_Wars_KaaTirs_attack_execution_victim"] remoteExec ["switchMove", 0];
    } forEach _targets;

    [_player, "Star_Wars_KaaTirs_executionOnCreature_jedi"] remoteExec ["switchMove", 0];


    // Обработка урона для целей
    {
    private _target = _x;
    
    if (_target isKindOf "Man") then {
        [_target, "WBK_Smasher_Execution"] remoteExec ["switchMove", 0];
    } else {
        // Для техники: поднимаем её плавно
        private _startPos = getPosATL _target;
        private _endPos = _startPos vectorAdd [0, 0, 10];
        
        _target allowDamage false; // Отключаем повреждения, пока объект поднимается

        [
            _target,
            _startPos,
            _endPos,
            5 // Время подъема в секундах
        ] spawn {
            params ["_obj", "_from", "_to", "_time"];
            
            private _progress = 0;
            while {_progress < 1} do {
                _progress = _progress + (1 / (_time * 25)); // Частота обновления - 50 раз в секунду
                _obj setPosATL ((_from vectorMultiply (1 - _progress)) vectorAdd (_to vectorMultiply _progress));
                
                sleep 0.02; // Ждем между итерациями
            };

            _obj allowDamage true; // Включаем повреждения после завершения подъема
        };
    };
    } forEach _targets;

    sleep 6;

    [_player, "FP_Wave", 10, 15] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";
    {
    _x setDamage 1;
    } forEach _targets;

    sleep 1;
    [_player, ""] remoteExec ["switchMove", 0];
};
};
};

///Разворачивает предмет
Jedi_fnc_Upheaval = {
     _player = player;

    // Проверка наличия необходимых предметов у игрока
    if (("Force_tir_1" in magazines _player) or ("Force_tir_2" in magazines _player) or ("Force_tir_3" in magazines _player) or ("Force_tir_Sith" in magazines _player)) then {

        // Проверка достаточности маны
        if (_player getVariable "IMS_LaF_ForceMana" > 0.4) then {
            // Получаем текущее количество маны
            _mana = _player getVariable "IMS_LaF_ForceMana";
            _mana = _mana - 0; // Уменьшаем ману
            _player setVariable ["IMS_LaF_ForceMana", _mana, true];


            // Получаем объект под курсором
            _target = cursorObject;

            if (!isNull _target) then {
                // Отключаем повреждения на предмет
                _target allowDamage false;

                // Начальная высота и позиция
                private _startPos = getPosATL _target; // Получаем начальную позицию предмета

                // Устанавливаем переменную для управления телекинезом
                _player setVariable ['Upheaval', true, true];

                // Цикл для перемещения предмета с помощью взгляда
                while {(_player getVariable ["Upheaval", false])} do {
                    // Обновляем направление взгляда
                    private _viewDirection = eyeDirection _player;

                    // Позиция предмета, учитывая направление взгляда
                    // Перемещаем предмет относительно начальной позиции
                    _newPos = _startPos vectorAdd [(_viewDirection select 0) * 1.5, (_viewDirection select 1) * 1.5, 0];

                    // Устанавливаем новую позицию предмета
                    _target setPosATL _newPos;

                    // Поворот предмета в сторону игрока
                    _target setDir (getDir _player);

                    // Задержка на 0.1 секунды перед следующим обновлением
                    sleep 0.01; // Обновляем каждые 0.1 секунды
                };

                // Включаем повреждения после завершения управления
                _target allowDamage true;
            } else {
                // Если нет доступного предмета под курсором, выводим сообщение
                systemChat "Нет доступного предмета под курсором.";
            };
        };
    };
};

// Функция телекинеза для поднятия предмета и привязки к взгляду
Jedi_fnc_Telekinez = {
    // Сохраняем ссылку на игрока
     _player = player;

    // Проверяем, есть ли у игрока предметы с определенными названиями в инвентаре
    if (("Force_tir_1" in magazines _player) or ("Force_tir_2" in magazines _player) or ("Force_tir_3" in magazines _player) or ("Force_tir_Sith" in magazines _player)) then {

        // Проверяем, достаточно ли маны для выполнения телекинеза
        if (_player getVariable "IMS_LaF_ForceMana" > 0.4) then {
      
            // Получаем текущее количество маны игрока
            _mana = _player getVariable "IMS_LaF_ForceMana";
            // Уменьшаем ману на 0.4
            _mana = _mana - 0; 
            // Устанавливаем обновленное значение маны обратно игроку
            _player setVariable ["IMS_LaF_ForceMana", _mana, true];


            // Отключаем повреждения на предмет, который будет поднят
            _target = cursorObject;

            // Проверяем, существует ли объект под курсором
            if (!isNull _target) then {
                [_player, "FP_Pull", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
                // Запрещаем повреждения для этого объекта
                _target allowDamage false;

                // Плавный подъем предмета
                private _startPos = getPosATL _target;
                private _heightOffset = 3; // Высота подъема
                private _endPos = _startPos vectorAdd [0, 1, _heightOffset];
                [_player, "B2_SupperBattleDroid_walk"] remoteExec ["switchMove", 0];

                [
                    _target,
                    _startPos,
                    _endPos,
                    3 // Время подъема в секундах
                ] spawn {
                    params ["_obj", "_from", "_to", "_time"];
                    private _progress = 0;
                    while {_progress < 1} do {
                        _progress = _progress + (1 / (_time * 25)); // Частота обновления - 50 раз в секунду
                        _obj setPosATL ((_from vectorMultiply (1 - _progress)) vectorAdd (_to vectorMultiply _progress));
                        sleep 0.01; // Ждем между итерациями
                    };
                };

                sleep 3;
                // Устанавливаем переменную для управления телекинезом
                _player setVariable ['telekinez', true, true];

                // Получаем позиции игрока и предмета
                private _playerPos = getPos _player; // Позиция игрока
                private _targetPos = getPos _target; // Позиция предмета

                // Вычисляем дистанцию между игроком и предметом
                private _distance = _playerPos vectorDistance _targetPos;
                // systemChat format ["Дистанция до предмета: %.2f метров", _distance];

                // Цикл для перемещения предмета с помощью взгляда
                while {(_player getVariable ["telekinez", false])} do {
                    // Обновляем направление взгляда игрока
                    private _viewDirection = eyeDirection _player;

                    // Увеличиваем расстояние до предмета
                    _newPos = getPos _player vectorAdd [(_viewDirection select 0) * _distance, (_viewDirection select 1) * _distance, (_viewDirection select 2) + _heightOffset];
                    // _newPos = getPos _player vectorAdd [(_viewDirection select 0) * _distance, (_viewDirection select 1) * _distance,  _heightOffset];

                    // Устанавливаем новую позицию предмета
                    _target setPosATL _newPos;

                    private _playerPos = getPos _player; // Позиция игрока
                    private _targetPos = getPos _target; // Позиция предмета
                    private _currentDistance = _playerPos vectorDistance _targetPos;

                        // Проверяем, если текущее расстояние больше начального + 3
                    if (_currentDistance > _distance + 3) then {
                        _player setVariable ['telekinez', false, true]; // Останавливаем телекинез
                        systemChat "Предмет слишком далеко, управление отменено.";
                    };

                    // Поворот предмета в сторону игрока
                    // _target setDir (getDir _player);

                    sleep 0.02; 
                };

                // Включаем повреждения после завершения управления
                _target allowDamage true;
                [_player, ""] remoteExec ["switchMove", 0];
            } else {
                // Если нет доступного предмета под курсором, выводим сообщение
                systemChat "Нет доступного предмета под курсором.";
            };
        };
    };
};


Jedi_fnc_MiliKill = {
 
    _nearestCharacter = cursorObject;

	if (isNull _nearestCharacter) exitWith {
		hint 'Вы не навелись на живой организм';
	};


    player playActionNow "starWars_force_fireball";
    [Player, "bat_type_hit_1", 100, 12] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
       {
        try {
            [_nearestCharacter, "Star_Wars_KaaTirs_attack_execution_victim"] remoteExec ["switchMove", 0];
        } catch {
        };
    } forEach [true]; // Просто для структуры, можно использовать пустой массив
    [_nearestCharacter, "bat_type_hit_1", 100, 12] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"; 
    sleep 3; 
    [Player, ""] remoteExec ["switchMove", 0];
    _nearestCharacter setDamage 1;
};

Jedi_fnc_IH_Run = {
    // params ["_unit"]; // Получаем параметр _unit
    _unit = player;

    // Проверяем, запущен ли скрипт
    if (_unit getVariable "ihscript" == true) then {
        _unit setVariable ["ihscript", false, true];
        systemChat "System IH Activated! CD 75 sec"; 
        _unit say3D "ACE_hit_Male06ENG_high_1";
       
        // Запуск таймера
        [_unit] spawn {
             params ["_unit"]; // Получаем параметр _unit
            sleep 60;
            _unit setVariable ["ihscript", true, true];
            systemChat "System IH ready!";
        };

        // Запуск основного скрипта

            [_unit, 1.3] call JediSystem_fnc_remoteAnimSpeed;

            for "_i" from 0 to 101 do {
                if (!alive _unit) exitWith {}; // Проверяем, жив ли _unit
                
                // Пропускаем шаг, если значение >= 75
                if (_unit getVariable ["IMS_LaF_ShotsToTakeOutOneGuy", 0] >= 100) then {
                    sleep 1; // Задержка перед следующим шагом
                    continue; // Пропускаем текущую итерацию
                };

                _mana = _unit getVariable ["IMS_LaF_ShotsToTakeOutOneGuy", 0];
                _mana = _mana + 1;
                _unit setVariable ["IMS_LaF_ShotsToTakeOutOneGuy", _mana, true];
                _unit call ace_medical_treatment_fnc_fullHealLocal; // Применяем лечение
                sleep 1; // Задержка в 1 секунду
            };
            [_unit, 1] call JediSystem_fnc_remoteAnimSpeed;
            systemChat "System IH reloading: 2:20 minutes";

    };
};


// Новый репульсор
Jedi_fnc_push= {
    _player = player;


    _viewDirection = eyeDirection _player;
    _distance = 6;
    _heightOffset = 2;
    _creationPos = getPos _player vectorAdd (_viewDirection vectorMultiply _distance);
    _creationPos set [2, (_creationPos select 2) + _heightOffset];
    _searchRadius = 6;

    _targets = nearestObjects [_creationPos, ["CAManBase", "Man"], _searchRadius];
    _targets = _targets select {alive _x && (_x != _player)};
    // [_player, "wood_block_1", 100, 12] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";  
    // [_player, "STAR_WARS_FIGHT_KNIFE_3"] remoteExec ["switchMove", 0];

    [_player, "starWars_lightsaber_style1_attack_push"] remoteExec ["switchMove", 0]; 
    [_player, "FP_Wave", 10, 7] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf";

    sleep 1;

    {
        if (alive _x && !(_x getVariable ["ACE_isUnconscious", false])) then {
            [_x, "A_PlayerDeathAnim_heavy_3"] remoteExec ["switchMove", 0];
            [_x, "leg_empty1", 100, 3] execVM "\WebKnight_StarWars_Mechanic\createSoundGlobal.sqf"
        }
    } forEach _targets;

    if (currentWeapon _player in IMS_Melee_Weapons) then {
        [_player, "melee_armed_idle"] remoteExec ["switchMove", 0];
    } else {
        [_player, ""] remoteExec ["switchMove", 0];
    };

    // {
    //     // if (alive _x && !(_x getVariable ["ACE_isUnconscious", false])) then {
    //     //     [_x, true, 60, true] remoteExecCall ["ace_medical_fnc_setUnconscious", 0];
    //     // }
    // } forEach _targets;

};


// [_unit, ""] remoteExec ["switchMove", 0];





// // Запуск функции с игроком в качестве параметра
// _unit = Player;

// // Массив для вызова функций
// _arr = [createFireball, createFireball2, createFireball3, createFireball4];

// // Запускаем каждую функцию асинхронно в отдельном потоке
// {
//    [] spawn {
//        params ["_func"]; // Получаем функцию из массива
//        [_unit] spawn _func; // Вызываем функцию с параметром игрока
//    };
// } forEach _arr;

// // Асинхронный вызов анимации switchMove
// [] spawn {
//    [_unit, "STAR_WARS_FIGHT_POWERS_OTHER_HEAL"] remoteExec ["switchMove", 0];
// };


