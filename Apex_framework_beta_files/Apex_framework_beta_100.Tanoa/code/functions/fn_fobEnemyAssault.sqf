/*
File: fn_fobEnemyAssault.sqf
Author:

	Quiksilver
	
Last modified:

	23/05/2016 ArmA 3 1.58 by Quiksilver
	
Description:

	FOB Enemy Assault
__________________________________________________*/

private [
	'_pos','_base','_foundSpawnPos',"_spawnPosDefault","_reinforceGroup","_infTypes","_infType",
	"_destination","_count","_wp",'_playerSelected','_arr','_playerPos','_ticker','_attackPos','_QS_array'
];

_QS_array = [];

/*/================================================ FIND POSITION/*/

_pos = _this select 0;
_base = markerPos 'QS_marker_base_marker';
_foundSpawnPos = FALSE;
while {!_foundSpawnPos} do {
	_spawnPosDefault = [_pos,500,850,5,0,0.5,0] call (missionNamespace getVariable 'QS_fnc_findSafePos');
	if ((count _spawnPosDefault) > 0) then {
		if (({((_x distance _spawnPosDefault) < 350)} count allPlayers) isEqualTo 0) then {
			if ((_spawnPosDefault distance _base) > 1200) then {
				_foundSpawnPos = TRUE;
			};
		};
	};
};

/*/================================================ SELECT + SPAWN UNITS/*/

_infTypes = ['OG_ReconSentry','OG_InfAssaultTeam','OG_SniperTeam_M','OG_InfAssaultTeam','OG_ReconSentry'];
_infType = selectRandom _infTypes;
_reinforceGroup = [_spawnPosDefault,(random 360),EAST,_infType,FALSE] call (missionNamespace getVariable 'QS_fnc_spawnGroup');

/*/================================================ MANAGE UNITS/*/

_attackPos = [];
if ((random 1) > 0.3) then {
	if ((random 1) > 0.3) then {
		if ((random 1) > 0.5) then {
			[_reinforceGroup,(missionNamespace getVariable 'QS_module_fob_centerPosition'),TRUE] call (missionNamespace getVariable 'QS_fnc_taskAttack');
			[_reinforceGroup,(currentWaypoint _reinforceGroup)] setWaypointCompletionRadius 50;
		} else {
			_wp = _reinforceGroup addWaypoint [(missionNamespace getVariable 'QS_module_fob_centerPosition'),75];
			_wp setWaypointType 'MOVE';
			_wp setWaypointBehaviour 'AWARE';
			_wp setWaypointCombatMode 'YELLOW';
			_wp setWaypointCompletionRadius 25;
			_wp setWaypointSpeed 'FULL';
		};
	} else {
		_playerSelected = objNull;
		_arr = [(missionNamespace getVariable 'QS_module_fob_centerPosition'),600,[WEST],allPlayers,0] call (missionNamespace getVariable 'QS_fnc_serverDetector');
		if ((count _arr) > 0) then {
			_arr = _arr call (missionNamespace getVariable 'QS_fnc_arrayShuffle');
			{
				if (alive _x) then {
					if ((_x isKindOf 'Man') || {(_x isKindOf 'LandVehicle')}) then {
						_playerSelected = _x;
					};
				};
			} count _arr;
		};
		if (!isNull _playerSelected) then {
			_playerPos = getPosATL _playerSelected;
			[_reinforceGroup,_playerPos,TRUE] call (missionNamespace getVariable 'QS_fnc_taskAttack');
			[_reinforceGroup,(currentWaypoint _reinforceGroup)] setWaypointCompletionRadius 50;
		} else {
			[_reinforceGroup,(missionNamespace getVariable 'QS_module_fob_centerPosition'),TRUE] call (missionNamespace getVariable 'QS_fnc_taskAttack');
			[_reinforceGroup,(currentWaypoint _reinforceGroup)] setWaypointCompletionRadius 50;
		};
	};
	_attackPos = missionNamespace getVariable 'QS_module_fob_centerPosition';
} else {
	_destination = [_pos,600,50,10] call (missionNamespace getVariable 'QS_fnc_findOverwatchPos');
	if ((count _destination) isEqualTo 0) then {
		_ticker = 0;
		while {((count _destination) isEqualTo 0)} do {
			_destination = [_pos,600,50,10] call (missionNamespace getVariable 'QS_fnc_findOverwatchPos');
			_ticker = _ticker + 1;
			if (_ticker > 30) exitWith {_destination = _pos;};
		};
	};
	[_reinforceGroup,_destination,TRUE] call (missionNamespace getVariable 'QS_fnc_taskAttack');
	_wp = _reinforceGroup addWaypoint [(missionNamespace getVariable 'QS_module_fob_centerPosition'),75];
	_wp setWaypointType 'SAD';
	_wp setWaypointBehaviour 'AWARE';
	_wp setWaypointCombatMode 'RED';
	_wp setWaypointCompletionRadius 100;
	_wp setWaypointSpeed 'FULL';
	_attackPos = _destination;
};
[(units _reinforceGroup),1] call (missionNamespace getVariable 'QS_fnc_serverSetAISkill');
_QS_array = missionNamespace getVariable 'QS_module_fob_assaultArray';
{
	0 = _QS_array pushBack _x;
	_x enableStamina FALSE;
	_x disableAI 'AUTOCOMBAT';
	[_x] call (missionNamespace getVariable 'QS_fnc_setCollectible');
} count (units _reinforceGroup);
missionNamespace setVariable ['QS_module_fob_assaultArray',_QS_array,TRUE];
_reinforceGroup enableAttack FALSE;
_reinforceGroup lockWP TRUE;
_reinforceGroup setVariable ['QS_AI_Groups',['QS_ATTACK',_attackPos],FALSE];
_count = count (units _reinforceGroup);
_count;