if (!hasInterface) exitWith {};

//ПОЗЖЕ БУДУ ВЫРЕЗАТЬ ЭТУ ЗАЛУПУ, ЭТО БРЕД ДЕЛАТЬ МИЛЛИОН ПЕРЕМЕННЫХ КОТОРЫЕ ОПРЕДЕЛЯЮТСЯ С САМОГО НАЧАЛА, НУЖНО ПРИДУМАТЬ ЧТО-ТО НОВОЕ С ЭТИМИ ЕБАНЫМИ ПЕРЕМЕННЫМИ, СУКА, РОТ ЕБАЛ ЭТИХ ПЕРЕМЕННЫХ.
player setVariable ["cooldownArmorArc", 0];
player setVariable ["BSO_System_Auto_Heal_Act_Active", true];
player setVariable ["BSO_System_AutoBacta", false];
player setVariable ["BSO_System_LAAT_Act_Active", true];
player setVariable ["BSO_System_Stimulator_Activ", false];
player setVariable ["BSO_System_Auto_Heal_Active", false];
player setVariable ["bigspeed", false];

//РАБОТА С КАРТОЧКАМИ
["ace_arsenal_displayClosed", {
    ACE_player spawn BSO_System_fnc_Proverka_Delete_Ids;
}] call CBA_fnc_addEventHandler;

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
    _unit call BSO_System_fnc_Update_Invis_Actions;
}];

//ПОКА НЕ ЕБУ, НО КОГДА БУДУ ЕБАТЬ, БУДУ РАБОТАТЬ
//ТЕПЕРЬ Я ЕБУ, НО ПОКА ТРОГАТЬ НЕ БУДУ
["ace_unconscious", {
    if ((player getVariable "ACE_isUnconscious" == true) &&
        (player getVariable "BSO_System_Stimulator_Activ" == false) &&
        (
            (
                ((toLower (name player)) find "fantar" >= 0)
                || ((toLower (name player)) find "lucas" >= 0)
            ) ||
            (
                ("JLTS_drugs_bacta_red" in items player) &&
                (count BSO_Cards_Array > 0 && (BSO_Cards_Array select 0) in items player)
            )
        )
    ) then {
        [] spawn BSO_System_fnc_Auto_Bacta;
    };
}] call CBA_fnc_addEventHandler;

//ПОЙДЁТ НА ПЕРЕПИСЬ, ИДЕИ УЖЕ ЕСТЬ.
//СДЕЛАТЬ БОЛЕЕ АВТОМАТИЗИРОВАННУЮ СИСТЕМУ БЕЗ ПОСЛЕДНИХ ДВУХ ХУЁВ.
//ПЕРЕНЕСУ ЭТО ВСЁ ЛИБО В БОКОВЫЕ СТОРОНЫ ЭКРАНА, ЛИБО ПРИДУМАЮ ДРУГОЕ ПОЗИЦИОНИРОВАНИЕ ЭЛЕМЕНТОВ ДЛЯ УДОБСТВА В ИПОЛЬЗОВАНИИ, ВОЗМОЖНО ДАЖЕ ДОБАВЛЮ НАСТРОЙКУ ПОД СЕБЯ ЧЕРЕЗ ВАНИЛЬНЫЕ НАСТРОЙКИ ХУДА.
//ЭТОТ ИНВАЛИД МНЕ ОЧЕНЬ СИЛЬНО НРАВИЛСЯ, Я ДАЖЕ ГОРДИЛСЯ ИМ, НО УВЫ И АХ, ОН НЕ ПОДХОДИТ ПОД РЕАЛИИ ПРОФ ПРОГРАММИНГА ИН ЗЕ ВОРЛД ПО ЭТОМУ ПРОЩАЙ МАЛЫШ, НО ТЫ БУДЕШЬ ПЕРЕПИСАН.
[] spawn {
    waitUntil {
        !isNull findDisplay 46
    };
    disableSerialization;

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

    _handle = [{

        //Отключение щита в ОПТР, НАХУЙ НЕ ТРОГАТЬ, ХУЙНЯ СТРАННАЯ И РАБОТАЕТ ЧЕРЕЗ ТРИ ПИЗДЫ КОЛЕНА
        // if (((getNumber (configFile >> 'CfgWeapons' >> (vest player) >> 'MJOLNIR_Shield_Off')) == 1) && (player getVariable "OPTRE_suit_mode" == "armor")) then {
        //     player setVariable ["OPTRE_suit_mode", "none"];
        // };

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

        _BSO_System_CTRL_Array = _this select 0;
        _lastTwoElements = _BSO_System_CTRL_Array select [count _BSO_System_CTRL_Array - 2, 2];
        _BSO_System_CTRL_Array = _BSO_System_CTRL_Array select [0, count _BSO_System_CTRL_Array - 2];
        _BSO_System_UI_Laat = _lastTwoElements select 0;
        _BSO_System_UI_Laat_Text = _lastTwoElements select 1;

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

        if (player getVariable "BSO_System_Auto_Heal_Active" == true) then {
            ["\BSOSystem\data\heal_ui_green.paa", "\BSOSystem\data\heal_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        } else {
            if (player getVariable "BSO_System_Auto_Heal_Act_Active" == false) then {
                ["\BSOSystem\data\heal_ui_yellow.paa", "\BSOSystem\data\heal_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
            } else {
                ["", "\BSOSystem\data\heal_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
            };
        };

        if (player getVariable "BSO_System_AutoBacta" == true) then {
            ["\BSOSystem\data\bacta_ui_yellow.paa","",_BSO_System_CTRL_Array] call _text_set;
        } else {
            ["", "\BSOSystem\data\bacta_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        };

        _heli = player getVariable "BSO_System_LAAT";
        if (!(isNil {
            _heli getVariable "BSO_System_LAAT_Distance_While"
        })) then {
            _BSO_System_UI_Laat ctrlSetText "\BSOSystem\data\laat_ui_black.paa";
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

        if (!(isNil {
            _heli getVariable "BSO_System_LAAT_Unit_Owner"
        })) then {
            ["\BSOSystem\data\laat_ui_green.paa", "\BSOSystem\data\laat_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
        } else {
            if (player getVariable "BSO_System_LAAT_Act_Active" == false) then {
                ["\BSOSystem\data\laat_ui_yellow.paa", "\BSOSystem\data\laat_ui_green.paa",_BSO_System_CTRL_Array] call _text_set;
            } else {
                ["", "\BSOSystem\data\laat_ui_yellow.paa",_BSO_System_CTRL_Array] call _text_set;
            };
        };

        _veh = vehicle player;
        if (!isNil {_veh getVariable "BSO_System_Vehicle_Defender"} && (_veh != player) && (BSO_Cards_Array select 0 in items player)) then {
            ["\BSOSystem\data\car_ui_red.paa", "", _BSO_System_CTRL_Array] call _text_set;
        } else {
            ["", "\BSOSystem\data\car_ui_red.paa", _BSO_System_CTRL_Array] call _text_set;
        }; 
    }, 0.1, [_BSO_System_UI_1, _BSO_System_UI_2, _BSO_System_UI_3, _BSO_System_UI_4, _BSO_System_UI_5, _BSO_System_UI_6, _BSO_System_UI_Laat, _BSO_System_UI_Laat_Text]] call CBA_fnc_addPerFrameHandler;
};

//НАХУЙЯ ЭТО В МОЁМ БСО СИСТЕМЕ, АЛО НАХУЙ, НАХУЯ ДОБАВЛЯТЬ ВСЯКУЮ ЗАЛУПУ В ЭТОТ ДОМ ИНВАЛИДОВ
[] spawn {
	waitUntil { !isNull player && { alive player } };
	private _radius = 5;
	private _vehicleTypes = ["LandVehicle"];
	while { true } do {
		sleep 2;
		if (!alive player) then {
			sleep 5;
		} else {
			private _nearVehs = (getPos player) nearEntities [_vehicleTypes, _radius];
			{
				private _veh = _x;
				private _driver = driver _veh;
				private _noBlueSlot = isNull _driver || { side _driver != west };
				if (alive _veh && _noBlueSlot && { !(_veh getVariable ["BSO_System_GrenadeActionAdded", false]) }) then {
					private _id = _veh addAction [
						"<t color='#ff6600'>Закинуть гранату</t>",
						{
							params ["_target"];
							[_target] remoteExec ["BSO_System_fnc_GrenadeDamageVehicle", 2];
							hint "Граната закинута...";
						},
						nil,
						6,
						false,
						true,
						"",
						"alive _target && { !(_target getVariable ['BSO_System_GrenadeDamaged', false]) } && { (isNull (driver _target)) || { side (driver _target) != west } }",
						3
					];
					_veh setVariable ["BSO_System_GrenadeActionAdded", true];
					_veh setVariable ["BSO_System_GrenadeActionId", _id];
				};
			} forEach _nearVehs;
		};
	};
};