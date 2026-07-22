// Устанавливаем начальные переменные для игрока
player setVariable ["speedofforce", false];
player setVariable ["firefire", false];
player setVariable ["ihscript", true];
player setVariable ["telekinez", false];
player setVariable ["Upheaval", false];
player setVariable ["UpTutaminis", false];




// Добавляем обработчик события закрытия арсенала
["ace_arsenal_displayClosed", {
    _unit = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];
    _unit spawn fnc_Proverka_Delete_Ids;
}] call CBA_fnc_addEventHandler;

// Добавляем обработчики событий для инвентаря и взятия предметов
player addEventHandler ["Take", {
    params ["_unit", "_container", "_item"];
    _unit spawn fnc_Proverka_Delete_Ids;
}];

player addEventHandler ["InventoryOpened", {
    params ["_unit", "_container"];
    _unit spawn fnc_Proverka_Delete_Ids;
}];

player addEventHandler ["InventoryClosed", {
    params ["_unit", "_container"];
    _unit spawn fnc_Proverka_Delete_Ids;
}];





// Добавляем обработчик события потери сознания
["ace_unconscious", {
        if ((Cards_Array select 0 in items player)) then {
            // Вызываем другую функцию, если карта джедая в инвентаре
            [] spawn fnc_Antiogl; // Замените на нужную функцию
        };
}] call CBA_fnc_addEventHandler;

