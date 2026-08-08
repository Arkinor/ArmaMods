params ["_pl"];

_unit = cursorObject;

if (isNull _unit || !alive _unit || !(_unit isKindOf 'Man')) exitwith {
    hint 'Вы не навелись на живой организм';
};

_pl setVariable ['BSO_System_Personality_Scaner_Activ', false];

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
    case (side _unit == side _pl): {
        _side = "Отношение: Дружелюбное"
    };
    
    default {
        _side = "Отношение: Не определено"
    };
};

_ident = ["Идентификатор:%1", name _unit] call _form;
_prim = ["Основное оружие: %1", gettext(configFile >> "Cfgweapons" >> primaryWeapon _unit >> "displayname")] call _form;
_sec = ["Пускавая установка: %1", gettext(configFile >> "Cfgweapons" >> secondaryWeapon _unit >> "displayname")] call _form;
_hand = ["Вторичное оружие: %1", gettext(configFile >> "Cfgweapons" >> handgunWeapon _unit >> "displayname")] call _form;

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
] call BIS_fnc_typetext;

_pl setVariable ['BSO_System_Personality_Scaner_Activ', true];