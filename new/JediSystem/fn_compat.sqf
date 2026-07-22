/*
	MP / dedicated-server совместимость для JediSystem.
*/

if (isNil "JediSystem_fnc_remoteAnimSpeed") then {
	JediSystem_fnc_remoteAnimSpeed = {
		params ["_unit", "_coef"];
		if (isNull _unit) exitWith {};
		if (local _unit) then {
			_unit setAnimSpeedCoef _coef;
		} else {
			[_unit, _coef] remoteExec ["setAnimSpeedCoef", _unit, false];
		};
	};
};

if (isNil "JediSystem_fnc_serverEnableSim") then {
	JediSystem_fnc_serverEnableSim = {
		params ["_obj", "_enable"];
		if (isNull _obj) exitWith {};
		if (!isServer) exitWith {
			[_obj, _enable] remoteExecCall ["JediSystem_fnc_serverEnableSim", 2];
		};
		private _authorised = true;
		if (remoteExecutedOwner > 2) then {
			private _requester = objNull;
			{ if (owner _x == remoteExecutedOwner) exitWith { _requester = _x; }; } forEach allPlayers;
			if (isNull _requester || {_requester distance _obj > 30}) then { _authorised = false; };
		};
		if (!_authorised) exitWith {};
		_obj enableSimulationGlobal _enable;
	};
};

if (isNil "JediSystem_fnc_spawnVehicleAt") then {
	JediSystem_fnc_spawnVehicleAt = {
		params ["_vehClass", "_pos", "_dir", ["_requester", objNull]];
		if (!isServer) exitWith { objNull };
		if (isNull _requester || {!isPlayer _requester}) exitWith { objNull };
		if (remoteExecutedOwner > 0 && {owner _requester != remoteExecutedOwner}) exitWith { objNull };
		if (!(_vehClass isEqualType "") || {_vehClass isEqualTo ""}) exitWith { objNull };
		if (isNil "Vehicle_Array" || {!(_vehClass in Vehicle_Array)}) exitWith {
			diag_log format ["[JediSystem] rejected vehicle class %1", _vehClass];
			objNull
		};
		if (!(_pos isEqualType []) || {count _pos < 2}) exitWith { objNull };

		private _spawnPos = +_pos;
		if (count _spawnPos < 3) then { _spawnPos set [2, 0]; };

		private _vehicle = createVehicle [_vehClass, _spawnPos, [], 0, "CAN_COLLIDE"];
		if (isNull _vehicle) exitWith { objNull };

		_vehicle setPosATL _spawnPos;
		_vehicle setDir _dir;
		_vehicle setVariable ["JediSystem_spawned", true, true];

		if (!isNull _requester && {isPlayer _requester}) then {
			private _dn = getText (configFile >> "CfgVehicles" >> _vehClass >> "displayName");
			if (_dn isEqualTo "") then { _dn = _vehClass; };
			[format ["Техника %1 готова", _dn]] remoteExec ["hint", _requester];
		};

		_vehicle
	};
};

if (isNil "JediSystem_fnc_createEmpBomb") then {
	JediSystem_fnc_createEmpBomb = {
		params ["_pos"];
		if (!isServer) exitWith { objNull };
		if (!(_pos isEqualType []) || {count _pos < 2}) exitWith { objNull };
		private _bomb = "JLTS_explosive_emp_10_ammo" createVehicle _pos;
		if (!isNull _bomb) then {
			_bomb hideObjectGlobal true;
		};
		_bomb
	};
};

if (isNil "JediSystem_fnc_ionizStrike") then {
	JediSystem_fnc_ionizStrike = {
		params ["_creationPos", ["_requester", objNull]];
		if (!isServer) exitWith {};
		if (isNull _requester || {!isPlayer _requester}) exitWith {};
		if (remoteExecutedOwner > 0 && {owner _requester != remoteExecutedOwner}) exitWith {};
		if ((_requester distance2D _creationPos) > 40) exitWith {};
		if (!(_creationPos isEqualType []) || {count _creationPos < 2}) exitWith {};

		[_creationPos] remoteExec ["Particle_blesk_fnc_2", 0];
		[_creationPos] remoteExec ["Particle_blesk_fnc", 0];

		private _bomb = "JLTS_explosive_emp_10_ammo" createVehicle _creationPos;
		if (!isNull _bomb) then {
			_bomb hideObjectGlobal true;
			_bomb setDamage 1;
		};

		private _searchRadius = 25;
		private _targets = nearestObjects [_creationPos, ["CAManBase", "Man"], _searchRadius];
		if (!isNull _requester) then {
			_targets = _targets select {alive _x && {_x != _requester}};
		} else {
			_targets = _targets select {alive _x};
		};

		{
			if ((name _x find "B1" != -1) || (name _x find "В1" != -1) || (name _x find "Дройд" != -1) ||
				(name _x find "дройд" != -1) || (name _x find "droid" != -1) || (name _x find "Droid" != -1) ||
				(name _x find "B2" != -1) || (name _x find "B1-" != -1) || (name _x find "BX" != -1) ||
				(name _x find "OOM" != -1) || (name _x find "OR-" != -1) || (name _x find "BD-" != -1)) then {
				_x setDamage 1;
			};
		} forEach _targets;

		private _vehicles = nearestObjects [_creationPos, ["Car", "Tank", "Air", "HeliH", "Plane"], _searchRadius];
		{
			if (alive _x) then {
				_x setHitPointDamage ["hithull", 0.5, true];
				_x setHitPointDamage ["hitturret", 1, true];
				_x setHitPointDamage ["hitgun", 1, true];
				_x setHitPointDamage ["hitengine", 1, true];
			};
		} forEach _vehicles;
	};
};

true
