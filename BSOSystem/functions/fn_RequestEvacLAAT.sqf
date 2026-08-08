if (!hasinterface || {
    isNull player
} || {
    !alive player
}) exitwith {};
if !(player getVariable ["BSO_System_LAAT_Act_Active", true]) exitwith {
    hint "Эвакуационный LAAT ещё не готов";
};
private _hasNexusAccess = if (!isnil "BSO_Cards_Array" && {
    count BSO_Cards_Array > 5
}) then {
    ((BSO_Cards_Array select 0) in items player) ||
    ((BSO_Cards_Array select 4) in items player) ||
    ((BSO_Cards_Array select 5) in items player)
} else {
    false
};
if (!_hasNexusAccess) exitwith {
    hint "Нет доступа к эвакуационному LAAT";
};
if (missionnamespace getVariable ["BSO_System_LAAT_MapselectionPending", false]) exitwith {
    hint "Сначала завершите выбор точки эвакуации";
};

missionnamespace setVariable ["BSO_System_LAAT_MapselectionPending", true, false];
hint "Укажите на карте точку высадки. Закройте карту для отмены.";
openMap true;
private _handlerId = addMissionEventHandler ["MapsingleClick", {
    params ["_units", "_pos"];
    if !(missionnamespace getVariable ["BSO_System_LAAT_MapselectionPending", false]) exitwith {};
    missionnamespace setVariable ["BSO_System_LAAT_MapselectionPending", false, false];
    private _id = missionnamespace getVariable ["BSO_System_LAAT_MapHandler", -1];
    if (_id >= 0) then {
        removeMissionEventHandler ["MapsingleClick", _id];
    };
    missionnamespace setVariable ["BSO_System_LAAT_MapHandler", -1, false];
    openMap false;
    
    [player, 1, "mti_armoury_vehicles_laati_mk2", _pos] call BSO_System_fnc_Laat;
    hint "Запрос передан. LAAT следует к вашей позиции.";
}];
missionnamespace setVariable ["BSO_System_LAAT_MapHandler", _handlerId, false];

[_handlerId] spawn {
    params ["_id"];
    waitUntil {
        uiSleep 0.2;
        !visibleMap || !(missionnamespace getVariable ["BSO_System_LAAT_MapselectionPending", false])
    };
    if (missionnamespace getVariable ["BSO_System_LAAT_MapselectionPending", false]) then {
        missionnamespace setVariable ["BSO_System_LAAT_MapselectionPending", false, false];
        removeMissionEventHandler ["MapsingleClick", _id];
        missionnamespace setVariable ["BSO_System_LAAT_MapHandler", -1, false];
        hint "Вызов LAAT отменён";
    };
};