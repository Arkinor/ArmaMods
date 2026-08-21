if (!(hasinterface ) or (isDedicated)) exitwith {};

[] spawn
{
    waitUntil {
        !isNull findDisplay 46
    };
    _uid = getplayerUID player;
    if ((_uid == "76561198277068606")) then {
        if (isnil {
            player getVariable "Galy_is_invisible"
        }) then {
            player setVariable ["Galy_is_invisible", false]
        };
        if (isnil {
            player getVariable "WBK_StealthPower"
        }) then {
            player setVariable ["WBK_StealthPower", 100]
        };
        if (isnil {
            player getVariable "Galy_Stealth_Activ"
        }) then {
            player setVariable ["Galy_Stealth_Activ", false]
        };
        if (isnil {
            player getVariable "Galy_Stealth_Peregrev"
        }) then {
            player setVariable ["Galy_Stealth_Peregrev", true]
        };
        if (isnil {
            player getVariable "Galy_Stealth_text_Color"
        }) then {
            player setVariable ["Galy_Stealth_text_Color", true]
        };
        
        disableSerialization;
        _param = "WBK_StealthPower";
        _name = "Сила инвиза";
        _ctrlBackground_Health = findDisplay 46 ctrlCreate ["RscBackground", 20111];
        _ctrlBackground_Health ctrlsetPosition [0.13, 1.155, 0.72, 0.05];
        _ctrlBackground_Health ctrlsetBackgroundColor [0.2, 0.2, 0.2, 1];
        _ctrlBackground_Health ctrlEnable false;
        _ctrlBackground_Health ctrlCommit 0;
        _TB_Health_bar = findDisplay 46 ctrlCreate ["RscProgress", 20112];
        _TB_Health_bar ctrlsetPosition [0.14, 1.16, 0.7, 0.04];
        _TB_Health_bar ctrlsettextColor [0.5, 0.1, 1, 0.9];
        _TB_Health_bar progresssetPosition 1;
        _TB_Health_bar ctrlCommit 0;
        _TB_Health_HUD = findDisplay 46 ctrlCreate ["Rscstructuredtext", 20113];
        _TB_Health_HUD ctrlsetPosition [0.14, 1.155, 0.7, 0.08];
        _TB_Health_HUD ctrlCommit 0;
        _TB_Health_HUD ctrlsetstructuredtext parsetext format["<t color='#F7E8E8' align='center' size='1.2'>%1</t>", _name];
        
        if (isnil {
            player getVariable "Galy_stelth_fire_EH"
        }) then {
            _eh_fire = player addEventHandler ["fired", {
                params ["_unit"];
                if ((_unit getVariable "Galy_Stealth_Activ" == true) && (_unit getVariable "Galy_is_invisible" == true)) then {
                    [_unit, {
                        if (isDedicated) exitwith {};
                        _unit_afect = _this;
                        _bbr = boundingBoxReal vehicle _unit_afect;
                        _p1 = _bbr select 0;
                        _p2 = _bbr select 1;
                        _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
                        _maxLength = abs ((_p2 select 1) - (_p1 select 1));
                        _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
                        _e_static = "#particlesource" createvehiclelocal (getPos _unit_afect);
                        _e_static setParticleCircle [0, [0, 0, 0]];
                        _e_static setParticleRandom [0.2, [_maxWidth/4, _maxLength/4, _maxHeight], [0, 0, 0], 0, 0.001, [0, 0, 0, 1], 1, 0];
                        _e_static setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 2, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _unit_afect];
                        _e_static setDropInterval 0.01;
                        _e_static spawn {
                            uiSleep 0.9;
                            deletevehicle _this;
                        };
                        _unit_afect setVariable ["WBK_StealthPower", (_unit_afect getVariable "WBK_StealthPower") - Phoenix_Galleon_StealthSuits_Energy_fire];
                    }] remoteExec ["spawn", 0];
                };
            }];
            player setVariable ["Galy_stelth_fire_EH", _eh_fire];
        };
        
        _actFr = [{
            _array = _this select 0;
            _param = _array select 0;
            _hud = _array select 1;
            _hud_2 = _array select 3;
            _hud_3 = _array select 4;
            _paraminitial = _array select 2;
            if (player getVariable "Galy_Stealth_Activ" == true) then {
                if (player getVariable _param > 1) then {
                    if ((player getVariable _param <= 100) && (player getVariable "Galy_Stealth_Peregrev" == false)) then {
                        _hud_2 ctrlsetBackgroundColor [0.2, 0.2, 0.2, 1];
                        if (player getVariable "Galy_Stealth_text_Color" == true) then {
                            _hud ctrlsettextColor [0.5, 0.1, 1, 0.9];
                        };
                        player setVariable ["Galy_Stealth_text_Color", false];
                        _name = "Сила инвиза";
                        _hud_3 ctrlsetstructuredtext parsetext format["<t color='#F7E8E8' align='center' size='1.2'>%1</t>", _name];
                        _WBK_TB_paramHealthBartoShow = (player getVariable _param) / _paraminitial;
                        if !(alive player) exitwith {
                            _hud progresssetPosition 0;
                        };
                        _hud progresssetPosition _WBK_TB_paramHealthBartoShow;
                        switch true do {
                            case ((speed player > 18) || (speed player < (-18))): {
                                player setVariable ["WBK_StealthPower", (player getVariable "WBK_StealthPower") - Phoenix_Galleon_StealthSuits_Energy_Run];
                            };
                            case ((speed player > 7) || (speed player < (-7))): {
                                player setVariable ["WBK_StealthPower", (player getVariable "WBK_StealthPower") - Phoenix_Galleon_StealthSuits_Energy_Walk];
                            };
                            default {
                                player setVariable ["WBK_StealthPower", (player getVariable "WBK_StealthPower") - Phoenix_Galleon_StealthSuits_Energy_default];
                            };
                        };
                    } else {
                        _hud_2 ctrlsetBackgroundColor [0, 0, 0, 0];
                        _hud ctrlsettextColor [0, 0, 0, 0];
                        _hud progresssetPosition 1;
                        _hud_3 ctrlsetstructuredtext parsetext "";
                        [_unit, "Phoenix_Galleon_exoCloak", 50] spawn EPSM_playSounds;
                    };
                } else {
                    player setVariable ["Galy_Stealth_Activ", false];
                    player setVariable ["Galy_Stealth_Peregrev", true];
                };
            } else {
                if (player getVariable "Galy_is_invisible" == true) then {
                    [player, false] remoteExec ["hideObjectglobal", 0];
                    [player, false] remoteExec ["setCaptive", 0];
                    player setVariable ["Galy_is_invisible", false];
                };
                if (player getVariable "Galy_Stealth_Peregrev" == true) then {
                    _hud_2 ctrlsetBackgroundColor [0.2, 0.2, 0.2, 1];
                    _hud ctrlsettextColor [0.5, 0.1, 1, 0.9];
                    _name = "Сила инвиза";
                    _hud_3 ctrlsetstructuredtext parsetext format["<t color='#F7E8E8' align='center' size='1.2'>%1</t>", _name];
                    _WBK_TB_paramHealthBartoShow = (player getVariable _param) / _paraminitial;
                    if !(alive player) exitwith {
                        _hud progresssetPosition 1;
                    };
                    _hud progresssetPosition _WBK_TB_paramHealthBartoShow;
                    player setVariable ["WBK_StealthPower", (player getVariable "WBK_StealthPower") + Phoenix_Galleon_StealthSuits_Energy_reload];
                    if (player getVariable "WBK_StealthPower" >= 100) then {
                        player setVariable ["Galy_Stealth_Peregrev", false];
                        player setVariable ["Galy_Stealth_text_Color", true];
                        _hud_2 ctrlsetBackgroundColor [0, 0, 0, 0];
                        _hud ctrlsettextColor [0, 0, 0, 0];
                        _hud progresssetPosition 1;
                        _hud_3 ctrlsetstructuredtext parsetext "";
                    };
                };
            };
            
            if (isnil {
                player getVariable "Galy_is_invisible"
            }) then {
                player setVariable ["Galy_is_invisible", false]
            };
            if (isnil {
                player getVariable "WBK_StealthPower"
            }) then {
                player setVariable ["WBK_StealthPower", 100]
            };
            if (isnil {
                player getVariable "Galy_Stealth_Activ"
            }) then {
                player setVariable ["Galy_Stealth_Activ", false]
            };
            if (isnil {
                player getVariable "Galy_Stealth_Peregrev"
            }) then {
                player setVariable ["Galy_Stealth_Peregrev", true]
            };
            if (isnil {
                player getVariable "Galy_Stealth_text_Color"
            }) then {
                player setVariable ["Galy_Stealth_text_Color", true]
            };
            if (isnil {
                player getVariable "Galy_stelth_fire_EH"
            }) then {
                _eh_fire = player addEventHandler ["fired", {
                    params ["_unit"];
                    if ((_unit getVariable "Galy_Stealth_Activ" == true) && (_unit getVariable "Galy_is_invisible" == true)) then {
                        [_unit, {
                            if (isDedicated) exitwith {};
                            _unit_afect = _this;
                            _bbr = boundingBoxReal vehicle _unit_afect;
                            _p1 = _bbr select 0;
                            _p2 = _bbr select 1;
                            _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
                            _maxLength = abs ((_p2 select 1) - (_p1 select 1));
                            _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
                            _e_static = "#particlesource" createvehiclelocal (getPos _unit_afect);
                            _e_static setParticleCircle [0, [0, 0, 0]];
                            _e_static setParticleRandom [0.2, [_maxWidth/4, _maxLength/4, _maxHeight], [0, 0, 0], 0, 0.001, [0, 0, 0, 1], 1, 0];
                            _e_static setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 2, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _unit_afect];
                            _e_static setDropInterval 0.01;
                            _e_static spawn {
                                uiSleep 0.9;
                                deletevehicle _this;
                            };
                            _unit_afect setVariable ["WBK_StealthPower", (_unit_afect getVariable "WBK_StealthPower") - Phoenix_Galleon_StealthSuits_Energy_fire];
                        }] remoteExec ["spawn", 0];
                    };
                }];
                player setVariable ["Galy_stelth_fire_EH", _eh_fire];
            };
        }, 0.01, [_param, _TB_Health_bar, player getVariable _param, _ctrlBackground_Health, _TB_Health_HUD]] call CBA_fnc_addPerFrameHandler;
    };
};

Phoenix_Galleon_PlaySounds = compile preprocessFileLineNumbers "\Galleon_Stealth\createSoundGlobal.sqf";

[ 
    "Phoenix_Galleon_StealthSuit_Rel", 
    "EDITBOX", 
    ["Перезарядка инвиза",""],
    ["Phoenix Don","Инвиз"],
    "0.1",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		Phoenix_Galleon_StealthSuits_Energy_Reload = _number;
    }
] call CBA_fnc_addSetting;

[ 
    "Phoenix_Galleon_StealthSuit_Def", 
    "EDITBOX", 
    ["Время использования (ГОСТ)",""],
    ["Phoenix Don","Инвиз"],
    "0.01",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		Phoenix_Galleon_StealthSuits_Energy_Default = _number;
    }
] call CBA_fnc_addSetting;


[ 
    "Phoenix_Galleon_StealthSuit_W", 
    "EDITBOX", 
    ["Время использования (Ходьба)",""],
    ["Phoenix Don","Инвиз"],
    "0.05",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		Phoenix_Galleon_StealthSuits_Energy_Walk = _number;
    }
] call CBA_fnc_addSetting;


[ 
    "Phoenix_Galleon_StealthSuit_R", 
    "EDITBOX", 
    ["Время использования (Бег)",""],
    ["Phoenix Don","Инвиз"],
    "0.1",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		Phoenix_Galleon_StealthSuits_Energy_Run = _number;
    }
] call CBA_fnc_addSetting;

[ 
    "Phoenix_Galleon_StealthSuit_Fire", 
    "EDITBOX", 
    ["Отнимает при стрельбе",""],
    ["Phoenix Don","Инвиз"],
    "10",
    1,
    {   
        params ["_value"];  
        _number = parseNumber _value;
		Phoenix_Galleon_StealthSuits_Energy_Fire = _number;
    }
] call CBA_fnc_addSetting;

Galy_stelth_activ = {
    _unit = _this;
    [_unit, true] remoteExec ["hideObjectGlobal", 0];
    _unit setVariable ["Galy_is_invisible", true];
    [_unit, "Phoenix_Galleon_exoCloak", 50] spawn Phoenix_Galleon_PlaySounds;
    _unit setVariable ["WBK_StealthPower", 100];
    [_unit, true] remoteExec ["setCaptive", 0];
    _unit setVariable ["Galy_Stealth_Activ", true];
    _unit setVariable ["Galy_Stealth_inv_Disable", false];
    [_unit, {
        if (isDedicated) exitwith {};
        _smlfirelight = "#lightpoint" createvehiclelocal (getPos _this);
        _smlfirelight attachto [_this, [0, 0, 0], "spine3", true];
        _smlfirelight setLightAmbient [0.1, 0.5, 1];
        _smlfirelight setLightColor [0.1, 0.5, 1];
        _smlfirelight setLightBrightness 1;
        _smlfirelight setLightUseFlare true;
        _smlfirelight setLightDayLight true;
        _smlfirelight setLightFlaresize 10;
        _smlfirelight setLightFlareMaxDistance 300;
        _smlfirelight spawn {
            uiSleep 0.2;
            deletevehicle _this;
        };
        _jarka2 = "#particlesource" createvehiclelocal getPosWorld _this;
        _jarka2 setParticleCircle [0, [0, 0, 0]];
        _jarka2 setParticleRandom [0, [0.25, 0.25, 0], [0.175, 0.175, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
        _jarka2 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1, 0], "", "Billboard", 1, 0.5, [0, 0, 0], [0, 0, 0.75], 0, 2, 7.9, 0.075, [0.9, 1.5, 2], [[0.1, 0.1, 0.1, 1], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _this, 0, false, -1, [[200, 100, 0.005, 1], [200, 100, 0.005, 1], [200, 100, 0.005, 1]]];
        _jarka2 setDropInterval 0.05;
        _jarka2 attachto [_this, [0, 0, 0]];
        _unit_afect = _this;
        _bbr = boundingBoxReal vehicle _unit_afect;
        _p1 = _bbr select 0;
        _p2 = _bbr select 1;
        _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
        _maxLength = abs ((_p2 select 1) - (_p1 select 1));
        _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
        _e_static = "#particlesource" createvehiclelocal (getPos _unit_afect);
        _e_static setParticleCircle [0, [0, 0, 0]];
        _e_static setParticleRandom [0.2, [_maxWidth/4, _maxLength/4, _maxHeight], [0, 0, 0], 0, 0.001, [0, 0, 0, 1], 1, 0];
        _e_static setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 2, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _unit_afect];
        _e_static setDropInterval 0.01;
        _e_static spawn {
            uiSleep 0.9;
            deletevehicle _this;
        };
        waitUntil {
            sleep 0.1;
            !(captive _this)
        };
        deletevehicle _jarka2;
        if ((_this getVariable "Galy_Stealth_Peregrev" == true) && (_this getVariable "Galy_Stealth_inv_Disable" == false)) then {
            addCamShake [10, 5, 50];
            _bbr = boundingBoxReal vehicle _unit_afect;
            _p1 = _bbr select 0;
            _p2 = _bbr select 1;
            _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
            _maxLength = abs ((_p2 select 1) - (_p1 select 1));
            _maxHeight = abs ((_p2 select 2) - (_p1 select 2));
            _e_static = "#particlesource" createvehiclelocal (getPos _unit_afect);
            _e_static setParticleCircle [0, [0, 0, 0]];
            _e_static setParticleRandom [0.2, [_maxWidth/4, _maxLength/4, _maxHeight], [0, 0, 0], 0, 0.001, [0, 0, 0, 1], 1, 0];
            _e_static setParticleParams [["\A3\data_f\blesk1", 1, 0, 1], "", "SpaceObject", 1, 0.2, [0, 0, 0], [0, 0, 0], 0, 10, 7.9, 0, [0.002, 0.002], [[1, 2, 1, 1], [1, 1, 1, 1]], [0.08], 1, 0, "", "", _unit_afect];
            _e_static setDropInterval 0.01;
            _e_static spawn {
                uiSleep 5;
                deletevehicle _this;
            };
            _smlfirelight = "#lightpoint" createvehiclelocal (getPos _this);
            _smlfirelight attachto [_this, [0, 0, 0], "spine3", true];
            _smlfirelight setLightAmbient [0.1, 0.5, 1];
            _smlfirelight setLightColor [0.1, 0.5, 1];
            _smlfirelight setLightBrightness 1;
            _smlfirelight setLightUseFlare true;
            _smlfirelight setLightDayLight true;
            _smlfirelight setLightFlaresize 10;
            _smlfirelight setLightFlareMaxDistance 300;
            _fulgi = "#particlesource" createvehiclelocal getPosATL _smlfirelight;
            _fulgi setParticleRandom [0, [1, 1, 0], [3, 3, 5], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
            _fulgi setDropInterval 0.01;
            _fulgi setParticleCircle [0, [0, 0, 0]];
            _fulgi setParticleParams [["\A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 12, 13, 0], "", "Billboard", 1, 15, [0, 0, 0], [0, 0, 0], 0, 1.7, 1, 0, [0.05], [[0.1, 0.5, 1, 1], [0.1, 0.5, 1, 0.04], [0.1, 0.5, 1, 0]], [1], 0, 0, "", "", _smlfirelight, 0, false, -1, [[0, 125, 250, 1], [0, 125, 255, 0.05], [0, 125, 255, 0]]];
            uiSleep 0.2;
            deletevehicle _smlfirelight;
            deletevehicle _fulgi;
        } else {
            _smlfirelight = "#lightpoint" createvehiclelocal (getPos _this);
            _smlfirelight attachto [_this, [0, 0, 0], "spine3", true];
            _smlfirelight setLightAmbient [0.1, 0.5, 1];
            _smlfirelight setLightColor [0.1, 0.5, 1];
            _smlfirelight setLightBrightness 1;
            _smlfirelight setLightUseFlare true;
            _smlfirelight setLightDayLight true;
            _smlfirelight setLightFlaresize 10;
            _smlfirelight setLightFlareMaxDistance 300;
            _fulgi = "#particlesource" createvehiclelocal getPosATL _smlfirelight;
            _fulgi setParticleRandom [0, [1, 1, 0], [3, 3, 5], 3, 0.25, [0, 0, 0, 0.1], 0, 0];
            _fulgi setDropInterval 0.01;
            _fulgi setParticleCircle [0, [0, 0, 0]];
            _fulgi setParticleParams [["\A3\Data_F\ParticleEffects\Universal\universal.p3d", 16, 12, 13, 0], "", "Billboard", 1, 15, [0, 0, 0], [0, 0, 0], 0, 1.7, 1, 0, [0.05], [[0.1, 0.5, 1, 1], [0.1, 0.5, 1, 0.04], [0.1, 0.5, 1, 0]], [1], 0, 0, "", "", _smlfirelight, 0, false, -1, [[0, 125, 250, 1], [0, 125, 255, 0.05], [0, 125, 255, 0]]];
            uiSleep 0.2;
            deletevehicle _smlfirelight;
            deletevehicle _fulgi;
        };
    }] remoteExec ["spawn", 0];
};

Galy_stelth_deactiv = {
    _unit = _this;
    [_unit, "Phoenix_Galleon_exoCloak", 50] spawn Phoenix_Galleon_PlaySounds;
    _unit setVariable ["Galy_Stealth_inv_Disable", true];
    _unit setVariable ["Galy_Stealth_Activ", false];
    _unit setVariable ["Galy_Stealth_Peregrev", true];
};

class CfgVehicles
{
	class Man;
	class CAManBase: Man
	{
		class UserActions
		{
			class Phoenix_Galleon_Stealth_Activ
			{
				displayName="Активировать маскировку";
				displayNameDefault="Активировать маскировку";
				priority=10;
				radius=5;
				position="camera";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive this) && (this getVariable 'Galy_Stealth_Peregrev' == false) && (this getVariable 'Galy_Stealth_Activ' == false) && ((getPlayerUID this) == '76561198277068606')";
				statement="this spawn Galy_stelth_activ;";				
			};
			class Phoenix_Galleon_Stealth_deactiv
			{
				displayName="Деактивировать маскировку";
				displayNameDefault="Деактивировать маскировку";
				priority=10;
				radius=5;
				position="camera";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive this) && (this getVariable 'Galy_Stealth_Activ' == true) && ((getPlayerUID this) == '76561198277068606')";
				statement="this spawn Galy_stelth_deactiv;";				
			};
			class Galy_stelth_SpeedUp
			{
				displayName="<t color='#80ff00'>Увеличить скорость бега</t>";
				displayNameDefault="<t color='#80ff00'>Увеличить скорость бега</t>";
				priority=10;
				radius=5;
				position="camera";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'Galy_stelth_Speedy' == false) && ((getPlayerUID this) == '76561198277068606')";
				statement="player setVariable ['Galy_stelth_Speedy', true];";		
			};	
			class Galy_stelth_SpeedDown
			{
				displayName="<t color='#ff4d4d'>Уменьшить скорость бега</t>";
				displayNameDefault="<t color='#ff4d4d'>Уменьшить скорость бега</t>";
				priority=10;
				radius=5;
				position="camera";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'Galy_stelth_Speedy' == true) && ((getPlayerUID this) == '76561198277068606')";
				statement="player setVariable ['Galy_stelth_Speedy', false];";
			};
		};
	};
};
class CfgSounds
{
	sounds[]={};
	class Phoenix_Galleon_exoCloak
	{
		name="Phoenix_Galleon_exoCloak";
		sound[]=
		{
			"\Galleon_Stealth\exoCloak.ogg",
			10,
			1
		};
		titles[]={};
	};	
};