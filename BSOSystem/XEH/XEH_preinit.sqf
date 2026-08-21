BSO_System_fnc_GrenadeDamageVehicle = {
	params ["_vehicle"];
	if (isNull _vehicle || {!(_vehicle isKindOf "LandVehicle") && !(_vehicle isKindOf "Air") && !(_vehicle isKindOf "Ship")}) exitWith {};
	_authorised = true;
	if (isServer && {remoteExecutedOwner > 0}) then {
		_requester = objNull;
		{ if (owner _x == remoteExecutedOwner) exitWith { _requester = _x; }; } forEach allPlayers;
		if (isNull _requester || {_requester distance _vehicle > 6}) then { _authorised = false; };
		_driver = driver _vehicle;
		if (!isNull _driver && {!isNull _requester} && {side _driver isEqualTo side _requester}) then { _authorised = false; };
	};
	if (!_authorised) exitWith {};
	if (_vehicle getVariable ["BSO_System_GrenadeDamaged", false]) exitWith {};

	_vehicle setVariable ["BSO_System_GrenadeDamaged", true, true];
	_vehicle setFuel 0;
	_vehicle engineOn false;

	_all = getAllHitPointsDamage _vehicle;
	if (count _all >= 1) then {
		_hitNames = _all select 0;
		{
			if (_x != "HitFuel" && {_x find "Fuel" == -1}) then {
				_vehicle setHitPointDamage [_x, 1, true];
			};
		} forEach _hitNames;
	};
	if (damage _vehicle < 0.85) then { _vehicle setDamage 0.85 };
};