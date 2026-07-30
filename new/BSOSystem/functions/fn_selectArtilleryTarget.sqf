private _hasHenkerCard = ((count BSO_Cards_Array) > 7) && ((BSO_Cards_Array select 7) in items player);
if (((name player) find "1171" < 0) && !_hasHenkerCard) exitWith {
    hint "Артподдержка недоступна";
};

BSO_artillery_selecting = true;
BSO_artillery_originalMapEH = -1;

openMap true;
hint "Выберите цель для артподдержки на карте";

private _mapCtrl = (findDisplay 12) displayCtrl 51;
BSO_artillery_originalMapEH = _mapCtrl getVariable ["mouseButtonDown", -1];
_mapCtrl ctrlRemoveAllEventHandlers "mouseButtonDown";

private _eh = _mapCtrl ctrlAddEventHandler ["mouseButtonDown", {
    params ["_control", "_button", "_xPos", "_yPos"];
    
    if (_button == 0 && {!isNil "BSO_artillery_selecting"} && {BSO_artillery_selecting}) then {
        private _pos = _control ctrlMapScreenToWorld [_xPos, _yPos];
        
        _control ctrlRemoveAllEventHandlers "mouseButtonDown";
        if (BSO_artillery_originalMapEH != -1) then {
            _control ctrlAddEventHandler ["mouseButtonDown", BSO_artillery_originalMapEH];
        };
        
        BSO_artillery_selecting = nil;
        openMap false;
        
        hint "Цель выбрана. Начинается артподдержка...";
        
        [_pos, player] remoteExecCall ["BSO_System_fnc_artilleryStrike", 2];
    };
}];

private _display = (findDisplay 12);
_display displayAddEventHandler ["Unload", {
    if (!isNil "BSO_artillery_selecting") then {
        private _mapCtrl = (findDisplay 12) displayCtrl 51;
        if (!isNull _mapCtrl) then {
            _mapCtrl ctrlRemoveAllEventHandlers "mouseButtonDown";
            if (BSO_artillery_originalMapEH != -1) then {
                _mapCtrl ctrlAddEventHandler ["mouseButtonDown", BSO_artillery_originalMapEH];
            };
        };
        BSO_artillery_selecting = nil;
    };
}];

