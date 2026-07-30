if (!hasInterface) exitWith {};

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

["ace_arsenal_displayClosed", {
    _unit = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}] call CBA_fnc_addEventHandler;

player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}];

player addEventHandler ["InventoryOpened", {
    params ["_unit", "_container"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
}];

player setVariable ["BSO_System_Invis_Active", false, true];
player setVariable ["BSO_System_Invis_LastDeactivate", 0, true];
player setVariable ["BSO_System_Invis_AutoDeactivateTime", 0, true];
player setVariable ["BSO_System_Invis_Energy_Max", 3000, true];
player setVariable ["BSO_System_Invis_Energy", 3000, true];

player addEventHandler ["InventoryClosed", {
    params ["_unit", "_container"];
    _unit spawn BSO_System_fnc_Proverka_Delete_Ids;
    _unit call BSO_System_fnc_Update_Invis_Actions;
}];

player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    if (_item == (BSO_Cards_Array select 6)) then {
        _unit call BSO_System_fnc_Update_Invis_Actions;
    };
}];

player addEventHandler ["Put", {
    params ["_unit", "_container", "_item"];
    if (_item == (BSO_Cards_Array select 6)) then {
        _unit call BSO_System_fnc_Update_Invis_Actions;
    };
}];

player addEventHandler ["Fired", {
    params ["_unit"];
    if (_unit getVariable ["BSO_System_Invis_Active", false]) then {
        [_unit, true] call BSO_System_fnc_Deactivate_Invis;
    };
}];

player addEventHandler ["Hit", {
    params ["_unit", "_source", "_damage"];
    if (_unit getVariable ["BSO_System_Invis_Active", false] && _damage > 0) then {
        [_unit, true] call BSO_System_fnc_Deactivate_Invis;
    };
}];

player addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage"];
    if (_unit getVariable ["BSO_System_Stimulator_Activ", false]) exitWith {0};
    if (_unit getVariable ["BSO_System_Invis_Active", false] && _damage > 0) then {
        [_unit, true] call BSO_System_fnc_Deactivate_Invis;
    };
    _damage
}];

player addEventHandler ["GetInMan", {
    params ["_unit"];
    if (_unit getVariable ["BSO_System_Invis_Active", false]) then {
        [_unit, true] call BSO_System_fnc_Deactivate_Invis;
    };
}];

player call BSO_System_fnc_Update_Invis_Actions;

[] spawn {
    private _nextEnergyNetSync = 0;
    while {true} do {
        sleep 1;
        if (!alive player) then { } else {

        private _maxEnergy = player getVariable ["BSO_System_Invis_Energy_Max", 3000];
        private _energy    = player getVariable ["BSO_System_Invis_Energy", _maxEnergy];
        private _isInvis   = player getVariable ["BSO_System_Invis_Active", false];

        private _drainPerSec = 5;
        private _regenPerSec = 4;

        if (_isInvis) then {
            private _nearUnits = allUnits select {
                _x != player &&
                alive _x &&
                (player distance _x) < 2 &&
                !((BSO_Cards_Array select 6) in items _x)
            };
            
            if (count _nearUnits > 0) then {
                [player, true] call BSO_System_fnc_Deactivate_Invis;
            } else {
                _energy = _energy - _drainPerSec;
                if (_energy <= 0) then {
                    _energy = 0;
                    [player, true] call BSO_System_fnc_Deactivate_Invis;
                } else {
                    private _effects = player getVariable ["BSO_System_SmokeEffect", []];
                    if (typeName _effects == "ARRAY" && count _effects > 0) then {
                        private _speed = vectorMagnitude velocity player;
                        private _isRunning = _speed > 3;
                        private _dropInterval = if (_isRunning) then {0.08} else {0.15};
                        {
                            if (!isNull _x) then {
                                _x setDropInterval _dropInterval;
                            };
                        } forEach _effects;
                    };
                };
            };
        } else {
            if (_energy < _maxEnergy) then {
                _energy = _energy + _regenPerSec;
                if (_energy > _maxEnergy) then {_energy = _maxEnergy;};
            };
        };

        player setVariable ["BSO_System_Invis_Energy", _energy, false];
        if (time >= _nextEnergyNetSync || {_energy <= 0} || {_energy >= _maxEnergy}) then {
            player setVariable ["BSO_System_Invis_Energy", _energy, true];
            _nextEnergyNetSync = time + 5;
        };
        player call BSO_System_fnc_Update_Invis_Actions;
        };
    };
};

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

        if (((getNumber (configFile >> 'CfgWeapons' >> (vest player) >> 'MJOLNIR_Shield_Off')) == 1) && (player getVariable "OPTRE_suit_mode" == "armor")) then {
            player setVariable ["OPTRE_suit_mode", "none"];
        };

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

[] spawn {
    waitUntil {!isNull findDisplay 46};
    
    
    if (isClass (configFile >> "CfgPatches" >> "LucasMods")) exitWith {};
    disableSerialization;

    private _disp = findDisplay 46;

    private _bgMain = _disp ctrlCreate ["RscText", 8158175175417301];
    private _bgMainPos = [
        0.03 * safeZoneW + safeZoneX,
        0.045 * safeZoneH + safeZoneY,
        0.24 * safeZoneW,
        0.105 * safeZoneH
    ];
    _bgMain ctrlSetPosition _bgMainPos;
    _bgMain ctrlSetBackgroundColor [0.015,0.035,0.05,0.9];
    _bgMain ctrlCommit 0;

    private _bgBorder1 = _disp ctrlCreate ["RscText", 8158175175417304];
    _bgBorder1 ctrlSetPosition [
        (_bgMainPos select 0),
        (_bgMainPos select 1),
        (_bgMainPos select 2),
        0.002 * safeZoneH
    ];
    _bgBorder1 ctrlSetBackgroundColor [0.27,0.75,1,0.95];
    _bgBorder1 ctrlCommit 0;

    private _bgBorder2 = _disp ctrlCreate ["RscText", 8158175175417305];
    _bgBorder2 ctrlSetPosition [
        (_bgMainPos select 0),
        (_bgMainPos select 1) + (_bgMainPos select 3) - 0.001 * safeZoneH,
        (_bgMainPos select 2),
        0.001 * safeZoneH
    ];
    _bgBorder2 ctrlSetBackgroundColor [0.27,0.75,1,0.28];
    _bgBorder2 ctrlCommit 0;

    private _bgBorder3 = _disp ctrlCreate ["RscText", 8158175175417306];
    _bgBorder3 ctrlSetPosition [
        (_bgMainPos select 0),
        (_bgMainPos select 1),
        0.002 * safeZoneW,
        (_bgMainPos select 3)
    ];
    _bgBorder3 ctrlSetBackgroundColor [0.27,0.75,1,0.8];
    _bgBorder3 ctrlCommit 0;

    private _bgBorder4 = _disp ctrlCreate ["RscText", 8158175175417307];
    _bgBorder4 ctrlSetPosition [
        (_bgMainPos select 0) + (_bgMainPos select 2) - 0.001 * safeZoneW,
        (_bgMainPos select 1),
        0.001 * safeZoneW,
        (_bgMainPos select 3)
    ];
    _bgBorder4 ctrlSetBackgroundColor [0.27,0.75,1,0.2];
    _bgBorder4 ctrlCommit 0;

    private _barBg = _disp ctrlCreate ["RscText", 8158175175417308];
    private _barBgPos = [
        (_bgMainPos select 0) + 0.01 * safeZoneW,
        (_bgMainPos select 1) + 0.05 * safeZoneH,
        (_bgMainPos select 2) - 0.02 * safeZoneW,
        0.018 * safeZoneH
    ];
    _barBg ctrlSetPosition _barBgPos;
    _barBg ctrlSetBackgroundColor [0.02,0.07,0.09,0.95];
    _barBg ctrlCommit 0;

    private _bar = _disp ctrlCreate ["RscText", 8158175175417302];
    private _barPos = [
        (_barBgPos select 0) + 0.002 * safeZoneW,
        (_barBgPos select 1) + 0.002 * safeZoneH,
        (_barBgPos select 2) - 0.004 * safeZoneW,
        (_barBgPos select 3) - 0.004 * safeZoneH
    ];
    _bar ctrlSetPosition _barPos;
    _bar ctrlSetBackgroundColor [0.27,0.75,1,1];
    _bar ctrlCommit 0;

    private _txtLabel = _disp ctrlCreate ["RscText", 8158175175417309];
    _txtLabel ctrlSetPosition [
        (_bgMainPos select 0) + 0.01 * safeZoneW,
        (_bgMainPos select 1) + 0.008 * safeZoneH,
        0.16 * safeZoneW,
        0.024 * safeZoneH
    ];
    _txtLabel ctrlSetText "PHOENIX // STEALTH CORE";
    _txtLabel ctrlSetTextColor [0.55,0.88,1,1];
    _txtLabel ctrlSetFont "EtelkaMonospaceProBold";
    _txtLabel ctrlSetFontHeight 0.019;
    _txtLabel ctrlSetShadow 2;
    _txtLabel ctrlCommit 0;

    private _txt = _disp ctrlCreate ["RscText", 8158175175417303];
    _txt ctrlSetPosition [
        (_bgMainPos select 0) + (_bgMainPos select 2) - 0.075 * safeZoneW,
        (_bgMainPos select 1) + 0.007 * safeZoneH,
        0.065 * safeZoneW,
        0.025 * safeZoneH
    ];
    _txt ctrlSetText "ENERGY 100%";
    _txt ctrlSetTextColor [0.55,0.88,1,1];
    _txt ctrlSetFont "EtelkaMonospaceProBold";
    _txt ctrlSetFontHeight 0.018;
    _txt ctrlSetShadow 2;
    _txt ctrlCommit 0;

    private _txtStatus = _disp ctrlCreate ["RscText", 8158175175417310];
    _txtStatus ctrlSetPosition [
        (_bgMainPos select 0) + 0.01 * safeZoneW,
        (_bgMainPos select 1) + 0.076 * safeZoneH,
        0.22 * safeZoneW,
        0.02 * safeZoneH
    ];
    _txtStatus ctrlSetText "STL-01  •  FIELD READY";
    _txtStatus ctrlSetTextColor [0.55,0.88,1,0.9];
    _txtStatus ctrlSetFont "EtelkaMonospacePro";
    _txtStatus ctrlSetFontHeight 0.016;
    _txtStatus ctrlSetShadow 1;
    _txtStatus ctrlCommit 0;

    private _barBaseWidth = (_barPos select 2);
    private _lastShown = true;

	    while {true} do {
	        uiSleep 0.2;
        if (!alive player) then { } else {

        private _hasDarkCard =
            ((BSO_Cards_Array select 4) in items player) ||
            ((BSO_Cards_Array select 6) in items player) ||
            ("JLTS_intel_briefcase" in items player) ||
            (player getVariable ["tts_cloak_isCloaked", false]) ||
            (player getVariable ["shadowCamo", false]);
        
        if (_hasDarkCard != _lastShown) then {
            _bgMain ctrlShow _hasDarkCard;
            _bgBorder1 ctrlShow _hasDarkCard;
            _bgBorder2 ctrlShow _hasDarkCard;
            _bgBorder3 ctrlShow _hasDarkCard;
            _bgBorder4 ctrlShow _hasDarkCard;
            _barBg ctrlShow _hasDarkCard;
            _bar ctrlShow _hasDarkCard;
            _txtLabel ctrlShow _hasDarkCard;
            _txt ctrlShow _hasDarkCard;
            _txtStatus ctrlShow _hasDarkCard;
            _lastShown = _hasDarkCard;
        };
        
        if (_hasDarkCard) then {

        private _maxEnergy = player getVariable ["BSO_System_Invis_Energy_Max", 3000];
        private _energy    = player getVariable ["BSO_System_Invis_Energy", _maxEnergy];
        private _isInvis   = player getVariable ["BSO_System_Invis_Active", false];
        private _isOptical = player getVariable ["tts_cloak_isCloaked", false];
        private _isShadow = player getVariable ["shadowCamo", false];
        private _autoDeactivateTime = player getVariable ["BSO_System_Invis_AutoDeactivateTime", 0];
        
        if (_energy > _maxEnergy) then { _energy = _maxEnergy; };
        if (_energy < 0) then { _energy = 0; };

        private _pct = (_energy max 0) / (_maxEnergy max 1);

        private _newBarPos = +_barPos;
        _newBarPos set [2, _barBaseWidth * _pct];
        _bar ctrlSetPosition _newBarPos;
        _bar ctrlCommit 0;

        private _col = if (_isInvis) then {
            [0.25,0.95,0.78,1]
        } else {
            if (_isOptical) then {
                [0.3,0.82,1,1]
            } else {
                if (_isShadow) then {
                    [0.35,0.55,1,1]
                } else {
                    if (_pct <= 0.2) then {
                        [0.8,0.2,0.2,1]
                    } else {
                        if (_pct <= 0.5) then {
                            [0.9,0.7,0.2,1]
                        } else {
                            [0.27,0.75,1,1]
                        };
                    };
                };
            };
        };
        _bar ctrlSetBackgroundColor _col;

        private _borderCol = if (_isInvis) then {[0.25,0.95,0.78,1]} else {if (_isOptical) then {[0.3,0.82,1,1]} else {if (_isShadow) then {[0.35,0.55,1,1]} else {[0.27,0.75,1,0.8]}}};
        _bgBorder1 ctrlSetBackgroundColor _borderCol;
        _bgBorder2 ctrlSetBackgroundColor _borderCol;
        _bgBorder3 ctrlSetBackgroundColor _borderCol;
        _bgBorder4 ctrlSetBackgroundColor _borderCol;
        _bgBorder1 ctrlCommit 0;
        _bgBorder2 ctrlCommit 0;
        _bgBorder3 ctrlCommit 0;
        _bgBorder4 ctrlCommit 0;

        _txt ctrlSetText format ["ENERGY %1%%", round (_pct * 100)];
        _txt ctrlSetTextColor _col;
        _txt ctrlCommit 0;

        private _status = if (_isInvis) then {
            "CLOAK FIELD  •  ACTIVE"
        } else {
            if (_isOptical) then {
                "OPTICAL CLOAK  •  ACTIVE"
            } else {
                if (_isShadow) then {
                    "SHADOW CAMO  •  ACTIVE"
                } else {
                    private _cooldownLeft = ceil ((30 - (time - _autoDeactivateTime)) max 0);
                    if (_cooldownLeft > 0) then {
                        format ["RECHARGE  •  %1S", _cooldownLeft]
                    } else {
                        if (_pct < 0.19) then {
                            "LOW ENERGY  •  RECOVERING"
                        } else {
                            "STL-01  •  FIELD READY"
                        };
                    };
                };
            };
        };
        _txtStatus ctrlSetText _status;
        _txtStatus ctrlSetTextColor (if (_isInvis) then {[0.25,0.95,0.78,1]} else {if (_isOptical) then {[0.3,0.82,1,1]} else {if (_isShadow) then {[0.35,0.55,1,1]} else {[0.55,0.88,1,0.9]}}});
        _txtStatus ctrlCommit 0;
        if (_isInvis || {_isOptical} || {_isShadow}) then {
            private _pulseAlpha = 0.65 + (0.25 * ((sin (time * 240) + 1) / 2));
            private _pulseColor = if (_isInvis) then {[0.25,0.95,0.78,_pulseAlpha]} else {if (_isOptical) then {[0.3,0.82,1,_pulseAlpha]} else {[0.35,0.55,1,_pulseAlpha]}};
            _bgBorder1 ctrlSetBackgroundColor _pulseColor;
            _bgBorder1 ctrlCommit 0;
        };
        };
        };
    };
};
