/*/
File: fn_aoTaskKill
Author:

	Quiksilver

Last Modified:

	6/12/2017 A3 1.78 by Quiksilver

Description:

	-
_____________________________________________________________/*/

params ['_entityPos'];
private _testPosition = [0,0,0];
private _positionFound = FALSE;
private _allPlayers = allPlayers;
private _basePosition = markerPos 'QS_marker_base_marker';
private _fobPosition = markerPos 'QS_marker_module_fob';
private _enemyUnit = objNull;
private _enemyGrp = grpNull;
private _minRadius = 800;
private _maxRadius = 1800;
private _timeout = diag_tickTime + 15;
_worldName = worldName;
for '_x' from 0 to 1 step 0 do {
	_testPosition = ['RADIUS',_entityPos,_maxRadius,'LAND',[2,0,-1,-1,0,FALSE,objNull],FALSE,[_entityPos,_maxRadius,'(1 + forest)',15,3],[],FALSE] call (missionNamespace getVariable 'QS_fnc_findRandomPos');
	if ((_testPosition distance2D _entityPos) > _minRadius) then {
		if ((_testPosition distance2D _basePosition) > 1000) then {
			if ((_testPosition distance2D _fobPosition) > 300) then {
				if (!([_testPosition,50,8] call (missionNamespace getVariable 'QS_fnc_waterInRadius'))) then {
					_positionFound = TRUE;
				};
			};
		};
	};
	if (_positionFound) exitWith {};
	if (diag_tickTime > _timeout) exitWith {};
};
if (diag_tickTime > _timeout) exitWith {};
_testPosition set [2,0];
_unitTypes = [
	['O_V_Soldier_M_hex_F','O_V_Soldier_hex_F'],
	['O_V_Soldier_ghex_F','O_V_Soldier_M_ghex_F']
] select (_worldName isEqualTo 'Tanoa');
_enemyGrp = createGroup [EAST,TRUE];
_enemyUnit = _enemyGrp createUnit [(selectRandom _unitTypes),_testPosition,[],0,'CAN_COLLIDE'];
_enemyUnit setVehiclePosition [(getPosWorld _enemyUnit),[],0,'NONE'];
_enemyUnit allowDamage FALSE;
_enemyUnit spawn {
	uiSleep 5;
	_this allowDamage TRUE;
};
_enemyGrp enableAttack TRUE;
_enemyUnit setAnimSpeedCoef 1.15;
_enemyUnit enableFatigue FALSE;
_enemyUnit enableStamina FALSE;
_enemyUnit addEventHandler [
	'FiredMan',
	{
		(_this select 0) setVehicleAmmo 1;
	}
];
private _primaryWeapon = '';
if ((random 1) > 0.5) then {
	_primaryWeapon = ['srifle_GM6_camo_F','srifle_GM6_ghex_F'] select (_worldName isEqualTo 'Tanoa');
	[_enemyUnit,_primaryWeapon,6] call (missionNamespace getVariable 'QS_fnc_addWeapon');
	_enemyUnit addPrimaryWeaponItem 'optic_Nightstalker';
} else {
	_primaryWeapon = ['srifle_DMR_02_sniper_F','srifle_DMR_02_F'] select (_worldName isEqualTo 'Tanoa');
	[_enemyUnit,_primaryWeapon,6] call (missionNamespace getVariable 'QS_fnc_addWeapon');
	_enemyUnit addPrimaryWeaponItem 'optic_Nightstalker';
	_enemyUnit addPrimaryWeaponItem (['muzzle_snds_338_sand','muzzle_snds_338_black'] select (_worldName isEqualTo 'Tanoa'));
};
_enemyUnit setVariable ['QS_hidden',TRUE,TRUE];
_enemyUnit setSkill 1;
_enemyUnit setSkill ['spotTime',1];
_enemyUnit setSkill ['aimingAccuracy',1];
_enemyUnit setSkill ['spotDistance',1];
_enemyUnit allowFleeing 0;
_enemyUnit selectWeapon (primaryWeapon _enemyUnit);
_enemyUnit setVariable ['QS_curator_disableEditability',TRUE,TRUE];
if ((random 1) > 0.5) then {
	_enemyUnit setUnitPosWeak 'MIDDLE';
};
private _radialIncrement = 45;
private _radialStart = round (random 360);
_radialOffset = 50 + (random [75,100,125]);
private _radialPatrolPositions = [];
private _patrolPosition = _testPosition getPos [_radialOffset,_radialStart];
if (!surfaceIsWater _patrolPosition) then {
	_radialPatrolPositions pushBack _patrolPosition;
};
for '_x' from 0 to 2 step 1 do {
	_radialStart = _radialStart + _radialIncrement;
	_patrolPosition = _testPosition getPos [_radialOffset,_radialStart];
	if (!surfaceIsWater _patrolPosition) then {
		_radialPatrolPositions pushBack _patrolPosition;
	};
};
_enemyGrp setBehaviourStrong 'AWARE';
_enemyGrp setCombatMode 'RED';
if ((random 1) > 0.333) then {
	_enemyGrp setVariable ['QS_AI_GRP',TRUE,FALSE];
	_enemyGrp setVariable ['QS_AI_GRP_CONFIG',['GENERAL','INFANTRY',(count (units _enemyGrp))],FALSE];
	_enemyGrp setVariable ['QS_AI_GRP_DATA',[],FALSE];
	_enemyGrp setVariable ['QS_AI_GRP_TASK',['PATROL',_radialPatrolPositions,diag_tickTime,-1],FALSE];
	_enemyGrp setVariable ['QS_AI_GRP_PATROLINDEX',0,FALSE];
};
_taskPosition = _testPosition getPos [(50 + (random 100)),(random 360)];
_description = format ['Вбити снайпера.<br/><br/>Медичнi працiвники IDAP що працюють в цiй частинi %1 наляканi снайперським обстрiлами. Вирушайте туди та нейтралiзуйте цiль.<br/><br/>Це завдання сплине через 20 хвилин.<br/><br/>Завдання позначено не точно.',_worldName];
_taskType = 'kill';
_taskID = format ['QS_DYNTASK_%1_%2',_taskType,(round (random 10000))];
_taskTimeout = diag_tickTime + 1200;
_array = [
	_taskID,
	'ADD',
	_taskType,
	[
		[
			[_enemyUnit],
			{
				params ['_entity'];
				(alive _entity)
			},
			[
				_taskID,
				TRUE,
				[
					_description,
					'Вбити',
					'Вбити'
				],
				_taskPosition,
				'CREATED',
				0,
				TRUE,
				TRUE,
				'kill',
				FALSE
			]
		],
		[
			[_enemyUnit],
			{
				params ['_entity'];
				(!alive _entity)
			}
		],
		[
			[_enemyUnit],
			{
				FALSE
			}
		],
		[
			[_enemyUnit,_taskTimeout],
			{
				params ['_entity','_taskTimeout'];
				private _c = FALSE;
				if ((diag_tickTime > _taskTimeout) && (alive _entity)) then {
					_entity setUnitPos 'DOWN';
					_entity spawn {uiSleep 5;deleteVehicle _this;};
					_c = TRUE;
				};
				_c;
			}
		]
	],
	[]
];
(missionNamespace getVariable 'QS_module_dynamicTasks_add') pushBack _array;
