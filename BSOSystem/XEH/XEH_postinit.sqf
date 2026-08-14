if (!hasInterface) exitWith {};

1555 cutRsc ["RscDisplay_BSO_System", "PLAIN"];

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
}];

["ace_unconscious", {	
	params ["_unit", "_isUnconscious"];

    if ((_isUnconscious) &&
        (_unit getVariable "BSO_System_Stimulator_Activ" == false) &&
        (
            (
                ((toLower (name _unit)) find "fantar" >= 0)
                || ((toLower (name _unit)) find "lucas" >= 0)
            ) ||
            (
                ("JLTS_drugs_bacta_red" in items _unit) &&
                (count BSO_Cards_Array > 0 && (BSO_Cards_Array select 0) in items _unit)
            )
        )
    ) then {
        [_unit] spawn BSO_System_fnc_Auto_Bacta;
    };
}] call CBA_fnc_addEventHandler;

player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	if (_vehicle getVariable ["BSO_System_vehicle_Defender", true]) then {
		["car_ui_red", ""] spawn BSO_System_fnc_ctrl_filling;
	};
}];

player addEventHandler ["GetOutMan", {
	params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
	if (_vehicle getVariable ["BSO_System_vehicle_Defender", true]) then {
		["", "car_ui_red"] spawn BSO_System_fnc_ctrl_filling;
	};
	if (isNil {_vehicle getVariable "BSO_System_vehicle_Defender"}) then {
		["", "car_ui_red"] spawn BSO_System_fnc_ctrl_filling;
	};
}];

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