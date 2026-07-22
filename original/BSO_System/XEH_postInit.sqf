// Устанавливаем начальные переменные для игрока
player setVariable ["cooldownArmorArc", 0];
player setVariable ["BSO_System_Auto_Heal_Act_Active", true];
player setVariable ["tts_cloak_isCloaked", false, true];
player setVariable ["tts_cloak_cloakDisabled", false, true];
player setVariable ["tts_cloak_duration", 20, true];
player setVariable ["tts_cloak_cooldown", 30, true];
player setVariable ["tts_cloak_hasActions", true, true];
player setVariable ["BSO_System_AutoBacta", false];
player setVariable ["BSO_System_LAAT_Act_Active", true];
player setVariable ["BSO_System_Stimulator_Activ", false];
player setVariable ["BSO_System_Auto_Heal_Active", false];


player setVariable ["bigspeed", false];
player setVariable ["Meditatia", false];


// player setVariable ["BSO_System_Auto_Heal_Active", false];

// Добавляем обработчик события закрытия арсенала
["ace_arsenal_displayClosed", {
    _unit = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}] call CBA_fnc_addEventHandler;

// Добавляем обработчики событий для инвентаря и взятия предметов
player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}];

player addEventHandler ["InventoryOpened", {
    params ["_unit", "_container"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}];

player addEventHandler ["InventoryClosed", {
    params ["_unit", "_container"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}];






// ["ace_unconscious", {
//     params ["_unit"]; // Получаем юнита, который упал в бессознательное состояние

//     // Проверяем, что событие относится к игроку на данной машине
//     if (!local _unit) exitWith {};

//     // Проверяем, что это именно текущий игрок
//     if (_unit != player) exitWith {};

//     sleep 3;
//     if (_unit getVariable ["cooldownArmorArc", false] == false) then {
        
//     // Проверяем наличие необходимых предметов у игрока
//     if (("JLTS_drugs_bacta_red" in items _unit) && 
//         (BSO_Cards_Array select 0 in items _unit)) then {
        
//         // Проверяем, что автоматическое лечение ещё не запущено
//         if (_unit getVariable ["BSO_System_AutoBacta", false] == false) then {
//             [_unit] spawn BSO_System_fnc_Auto_Bacta; // Запускаем функцию
//         };
//     };
//     };
// }] call CBA_fnc_addEventHandler;


// ["ace_unconscious", {
//     if ((isNil { player getVariable "BSO_System_Stimulator_Activ" }) && 
//         ("JLTS_drugs_bacta_red" in items player) && 
//         (BSO_Cards_Array select 0 in items player)) then {
//         _unit = player;
//         [] spawn BSO_System_fnc_Auto_Bacta;
        
//     };
// }] call CBA_fnc_addEventHandler;


["ace_unconscious", {
    if ((player getVariable "ACE_isUnconscious" == true) && 
        (player getVariable "BSO_System_Stimulator_Activ" == false) && 
        ("JLTS_drugs_bacta_red" in items player) && 
        (count BSO_Cards_Array > 0 && (BSO_Cards_Array select 0) in items player)) then {
        [] spawn BSO_System_fnc_Auto_Bacta;        
    };
}] call CBA_fnc_addEventHandler;





[] spawn {
    waitUntil {
        !isNull findDisplay 46
    };
    disableSerialization;

    // Создание UI элементов
    _BSO_System_UI_1 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417141];
    _BSO_System_UI_1 ctrlSetPosition [(0.196354 * safeZoneW + safeZoneX), (0.06 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_1 ctrlCommit 0;

    _BSO_System_UI_2 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417142];
    _BSO_System_UI_2 ctrlSetPosition [(0.276563 * safeZoneW + safeZoneX), (0.115 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_2 ctrlCommit 0;

    _BSO_System_UI_3 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417143];
    _BSO_System_UI_3 ctrlSetPosition [(0.333854 * safeZoneW + safeZoneX), (0.137 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_3 ctrlCommit 0;

    _BSO_System_UI_4 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417144];
    _BSO_System_UI_4 ctrlSetPosition [(0.620312 * safeZoneW + safeZoneX), (0.137 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_4 ctrlCommit 0;

    _BSO_System_UI_5 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417145];
    _BSO_System_UI_5 ctrlSetPosition [(0.677604 * safeZoneW + safeZoneX), (0.115 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_5 ctrlCommit 0;

    _BSO_System_UI_6 = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417146];
    _BSO_System_UI_6 ctrlSetPosition [(0.757813 * safeZoneW + safeZoneX), (0.06 * safeZoneH + safeZoneY), (0.0458333 * safeZoneW), (0.055 * safeZoneH)];
    _BSO_System_UI_6 ctrlCommit 0;

    _BSO_System_UI_Laat = findDisplay 46 ctrlCreate ["RscPictureKeepAspect", 8158175175417147];
    _BSO_System_UI_Laat ctrlSetPosition [0.0416667 * safeZoneW + safeZoneX, 0.258 * safeZoneH + safeZoneY, 0.0859375 * safeZoneW, 0.121 * safeZoneH];
    _BSO_System_UI_Laat ctrlCommit 0;

    _BSO_System_UI_Laat_Text = findDisplay 46 ctrlCreate ["RscText", 8158175175417148];
    _BSO_System_UI_Laat_Text ctrlSetPosition [0.00729169 * safeZoneW + safeZoneX, 0.357 * safeZoneH + safeZoneY, 0.189062 * safeZoneW, 0.033 * safeZoneH];
    _BSO_System_UI_Laat_Text ctrlCommit 0;

    // Обрабатываем состояние UI каждый кадр
    _handle = [{

        // Убирает щит
        if (((getNumber (configFile >> 'CfgWeapons' >> (vest player) >> 'MJOLNIR_Shield_Off')) == 1) && (player getVariable "OPTRE_suit_mode" == "armor")) then {
            player setVariable ["OPTRE_suit_mode", "none"];
        };

		// Функция для корректного обновления всех контролов в UI
        _text_set = {
            params [
                ["_expectedText", "", [""]],
                ["_text", "", [""]],
                "_BSO_System_CTRL_Array"
            ];
            private _textsSet = [];

            {
                _ctrl = _x;
                _currentText = ctrlText _ctrl;

                private _alreadySet = _textsSet findIf {
                    _x isEqualTo _expectedText
                } != -1;

                if (_alreadySet) exitWith {};

                if ((_currentText isEqualTo _expectedText) or (_currentText isEqualTo _text) or ((_expectedText isEqualTo "") && ((_currentText isEqualTo _text))) or (_currentText isEqualTo "")) then {
                    _ctrl ctrlSetText _expectedText;
                    _ctrl ctrlCommit 0;
                    _textsSet pushBack _expectedText;
                };
            } forEach _BSO_System_CTRL_Array;
        };

		// Убераем два последних элемента из массива и разделяем на свои переменные
        _BSO_System_CTRL_Array = _this select 0;
        _lastTwoElements = _BSO_System_CTRL_Array select [count _BSO_System_CTRL_Array - 2, 2];
        _BSO_System_CTRL_Array = _BSO_System_CTRL_Array select [0, count _BSO_System_CTRL_Array - 2];
        _BSO_System_UI_Laat = _lastTwoElements select 0;
        _BSO_System_UI_Laat_Text = _lastTwoElements select 1;

		// Вспомогательная функция для удаления всех контролов в UI для корректного отображения
        _clearElements = {
            params ["_BSO_System_CTRL_Array", "_BSO_System_UI_Laat", "_BSO_System_UI_Laat_Text"];
            _needClear = false;
            {
                if (ctrlText _x == "") exitWith {_needClear = true};
            } forEach _BSO_System_CTRL_Array;

            if (_needClear) then {
                {
                    _x ctrlSetText "";
                    _x ctrlCommit 0;
                } forEach _BSO_System_CTRL_Array + [_BSO_System_UI_Laat, _BSO_System_UI_Laat_Text];
            };
        };

        [_BSO_System_CTRL_Array, _BSO_System_UI_Laat, _BSO_System_UI_Laat_Text] call _clearElements;        

		// // Обработка иконки стимулятора для UI
        // if (!(isNil {
        //     player getVariable "BSO_System_Stimulator_Activ"
        // })) then {
        //     ["\BSO_System\data\stim_ui_green.paa","",_BSO_System_CTRL_Array] call _text_set;
        //     // ["\BSO_System\data\bacta_ui_red.paa","",_BSO_System_CTRL_Array] call _text_set;
        // } else {
        //     if (player getVariable "cooldownArmorArc" > 0) then {
        //         ["\BSO_System\data\stim_ui_yellow.paa", "\BSO_System\data\stim_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
        //         // ["", "\BSO_System\data\bacta_ui_red.paa",_BSO_System_CTRL_Array] call _text_set;
        //     } else {
        //         ["", "\BSO_System\data\stim_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        //     };
        // };

		// // Обработка иконки скорости для UI
        // if (player getVariable "BSO_System_SpeedUP_Handler_less" == true) then {
        //     ["\BSO_System\data\speed_ui_green.paa", "\BSO_System\data\speed_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        // } else {
        //     if (!(isNil {
        //         player getVariable "bigspeed"
        //     })) then {
        //         ["\BSO_System\data\speed_ui_yellow.paa", "\BSO_System\data\speed_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
        //     } else {
        //         ["", "\BSO_System\data\speed_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        //     };
        // };

		// Обработка иконки лечения для UI
        if (player getVariable "BSO_System_Auto_Heal_Active" == true) then {
            ["\BSO_System\data\heal_ui_green.paa", "\BSO_System\data\heal_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        } else {
            if (player getVariable "BSO_System_Auto_Heal_Act_Active" == false) then {
                ["\BSO_System\data\heal_ui_yellow.paa", "\BSO_System\data\heal_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
            } else {
                ["", "\BSO_System\data\heal_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
            };
        };

		// Обработка иконки Бакты для UI
        if (player getVariable "BSO_System_AutoBacta" == true) then {
            ["\BSO_System\data\bacta_ui_yellow.paa","",_BSO_System_CTRL_Array] call _text_set;
        } else {
            ["", "\BSO_System\data\bacta_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        };

		// Обработка дистанции от игрока до ЛААТа UI
        _heli = player getVariable "BSO_System_LAAT";
        if (!(isNil {
            _heli getVariable "BSO_System_LAAT_Distance_While"
        })) then {
            _BSO_System_UI_Laat ctrlSetText "\BSO_System\data\laat_ui_black.paa";
            _BSO_System_UI_Laat ctrlCommit 0;
            _distance = _heli distance player;
            _BSO_System_UI_Laat_Text ctrlSetText format ["Расстояние от ЛААТа до вас: %1 м", _distance];
            _BSO_System_UI_Laat_Text ctrlCommit 0;
        } else {
            _BSO_System_UI_Laat ctrlSetText "";
            _BSO_System_UI_Laat ctrlCommit 0;
            _BSO_System_UI_Laat_Text ctrlSetText "";
            _BSO_System_UI_Laat_Text ctrlCommit 0;
        };

		// Обработка иконки ЛААТа для UI
        if (!(isNil {
            _heli getVariable "BSO_System_LAAT_Unit_Owner"
        })) then {
            ["\BSO_System\data\laat_ui_green.paa", "\BSO_System\data\laat_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        } else {
            if (player getVariable "BSO_System_LAAT_Act_Active" == false) then {
                ["\BSO_System\data\laat_ui_yellow.paa", "\BSO_System\data\laat_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
            } else {
                ["", "\BSO_System\data\laat_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
            };
        };

        // Обработчик иконки Машины для UI
        _veh = vehicle player;
        if (!isNil {_veh getVariable "BSO_System_Vehicle_Defender"} && (_veh != player) && (BSO_Cards_Array select 0 in items player)) then {
            ["\BSO_System\data\car_ui_red.paa", "", _BSO_System_CTRL_Array] call _text_set;
        } else {
            ["", "\BSO_System\data\car_ui_red.paa", _BSO_System_CTRL_Array] call _text_set;
        }; 
    }, 0.1, [_BSO_System_UI_1, _BSO_System_UI_2, _BSO_System_UI_3, _BSO_System_UI_4, _BSO_System_UI_5, _BSO_System_UI_6, _BSO_System_UI_Laat, _BSO_System_UI_Laat_Text]] call CBA_fnc_addPerFrameHandler;
};