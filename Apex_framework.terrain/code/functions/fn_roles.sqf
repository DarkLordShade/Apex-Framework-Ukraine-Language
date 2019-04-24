/*/
File: fn_roles.sqf
Author:

	Quiksilver

Last Modified:

	24/04/2019 A3 1.90 by Quiksilver

Description:

	Roles System
________________________________________/*/

params ['_type'];
if (_type isEqualTo 'HANDLE') exitWith {
	(uiNamespace getVariable ['QS_roles_handler',[]]) pushBack (_this # 1);
	if ((uiNamespace getVariable ['QS_roles_PFH',0]) isEqualTo 0) then {
		uiNamespace setVariable ['QS_roles_PFH',(addMissionEventHandler ['EachFrame',(missionNamespace getVariable 'QS_fnc_eventEachFrame')])];
	};
};
if (_type isEqualTo 'GET_ROLE_COUNT') exitWith {
	params [
		'',
		['_role',''],
		['_side',sideEmpty],
		['_returnText',FALSE]
	];
	private _occupied = 0;
	private _capacity = 0;
	private _waiting_occupied = 0;
	private _waiting_capacity = 0;
	private _return = [[_occupied,_capacity,_waiting_occupied,_waiting_capacity],'( 0 / 0 )'] select _returnText;
	_side_ID = _side call (missionNamespace getVariable 'QS_fnc_sideID');
	private _role_index_data = [];
	_playerCount = count allPlayers;
	{
		_role_index_data = _x;
		if (((_role_index_data # 0) # 0) isEqualTo _role) exitWith {
			_capacity = count ((_role_index_data # 1) select {(_playerCount >= (_x # 1))});
			{
				if (!((_x # 0) isEqualTo '')) then {
					_occupied = _occupied + 1;
				};
			} forEach (_role_index_data # 1);
			_waiting_capacity = count (_role_index_data # 2);
			{
				if (!((_x # 0) isEqualTo '')) then {
					_waiting_occupied = _waiting_occupied + 1;
				};
			} forEach (_role_index_data # 2);
		};
	} forEach ((missionNamespace getVariable 'QS_unit_roles') # _side_ID);
	if (_returnText) then {
		if (!( [_occupied,_capacity] isEqualTo [0,0] )) then {
			_return = format ['( %1 / %2 )',_occupied,_capacity,_waiting_occupied];
		};
	} else {
		_return = [_occupied,_capacity,_waiting_occupied,_waiting_capacity];
	};
	_return;
};
if (_type isEqualTo 'GET_ROLE_DISPLAYNAME') exitWith {
	params [
		'',
		['_role',''],
		['_unit',objNull]
	];
	private _return = 'Rifleman';
	if (_role isEqualTo '') then {
		if (!isNull _unit) then {
			_role = _unit getVariable ['QS_unit_role','rifleman'];
		};
	};
	_table_index = (missionNamespace getVariable 'QS_roles_UI_info') findIf {((_x # 0) isEqualTo _role)};
	if (!(_table_index isEqualTo -1)) then {
		_return = ((missionNamespace getVariable 'QS_roles_UI_info') # _table_index) # 1;
	};
	_return;
};
if (_type isEqualTo 'GET_ROLE_ICON') exitWith {
	params [
		'',
		['_role',''],
		['_unit',objNull]
	];
	private _return = 'a3\Ui_f\data\GUI\Cfg\RespawnRoles\assault_ca.paa';
	if (_role isEqualTo '') then {
		if (!isNull _unit) then {
			_role = _unit getVariable ['QS_unit_role','rifleman'];
		};
	};
	_table_index = (missionNamespace getVariable 'QS_roles_UI_info') findIf {((_x # 0) isEqualTo _role)};
	if (!(_table_index isEqualTo -1)) then {
		_return = ((missionNamespace getVariable 'QS_roles_UI_info') # _table_index) # 2;
	};
	_return;
};
if (_type isEqualTo 'GET_ROLE_ICONMAP') exitWith {
	params [
		'',
		['_role',''],
		['_unit',objNull]
	];
	private _return = 'a3\ui_f\data\map\vehicleicons\iconMan_ca.paa';
	if (_role isEqualTo '') then {
		if (!isNull _unit) then {
			_role = _unit getVariable ['QS_unit_role','rifleman'];
		};
	};
	_table_index = (missionNamespace getVariable 'QS_roles_UI_info') findIf {((_x # 0) isEqualTo _role)};
	if (!(_table_index isEqualTo -1)) then {
		_return = ((missionNamespace getVariable 'QS_roles_UI_info') # _table_index) # 3;
	};
	_return;
};
if (_type isEqualTo 'GET_ROLE_DESCRIPTION') exitWith {
	params [
		'',
		['_role','rifleman']
	];
	([_role] call (missionNamespace getVariable 'QS_fnc_roleDescription'));
};
if (_type isEqualTo 'HANDLE_CONNECT') exitWith {
	params ['','_data'];
	_data params ['_unit','_jip','_cid','_uid','_profileName'];
	(uiNamespace getVariable ['QS_roles_handler',[]]) pushBack ['HANDLE_REQUEST_ROLE',_uid,(missionNamespace getVariable ['QS_roles_defaultSide',WEST]),(missionNamespace getVariable ['QS_roles_defaultRole','rifleman']),_unit];
};
if (_type isEqualTo 'HANDLE_DISCONNECT') exitWith {
	params ['','_data'];
	_data params ['','','_uid',''];
	diag_log (format ['***** QS ROLES ***** Handle Disconnect * %1 *****',_data]);
	_roles = missionNamespace getVariable 'QS_unit_roles';
	_side_ID = _side call (missionNamespace getVariable 'QS_fnc_sideID');
	private _roles_side = [];
	private _prior_role_index = -1;
	private _prior_queue_index = -1;
	private _roles_side_ID = 0;
	private _roles_role = [];
	{
		_roles_side = _x;
		_roles_side_ID = _forEachIndex;
		if (!(_roles_side isEqualTo [])) then {
			{
				_roles_role = _x;
				_roles_role params [
					'_role_data',
					'_role_manifest',
					'_role_queue'
				];
				_prior_role_index = _role_manifest findIf {((_x # 0) isEqualTo _uid)};
				if (!(_prior_role_index isEqualTo -1)) then {
					_role_manifest set [_prior_role_index,['',((_role_manifest # _prior_role_index) # 1)]];
					_roles_role set [1,_role_manifest];
					_roles_side set [_forEachIndex,_roles_role];
					(missionNamespace getVariable 'QS_unit_roles') set [_roles_side_ID,_roles_side];
					missionNamespace setVariable ['QS_unit_roles',(missionNamespace getVariable 'QS_unit_roles'),TRUE];
				};
				_prior_queue_index = _role_queue findIf {((_x # 0) isEqualTo _uid)};
				if (!(_prior_queue_index isEqualTo -1)) then {
					_role_queue set [_prior_role_index,['',-1]];
					_roles_role set [2,_role_queue];
					_roles_side set [_forEachIndex,_roles_role];
					(missionNamespace getVariable 'QS_unit_roles') set [_roles_side_ID,_roles_side];
					missionNamespace setVariable ['QS_unit_roles',(missionNamespace getVariable 'QS_unit_roles'),TRUE];
				};
			} forEach _roles_side;
		};
	} forEach _roles;
};
if (_type isEqualTo 'REQUEST_ROLE') exitWith {
	params [
		'',
		'_uid',
		'_side',
		'_role',
		'_unit',
		'_clientOwner'
	];
	if (diag_tickTime >= (uiNamespace getVariable ['QS_RSS_requestCooldown',-1])) then {
		uiNamespace setVariable ['QS_RSS_requestCooldown',(diag_tickTime + 3)];
		private _allowRequest = TRUE;
		if (uiNamespace getVariable ['QS_client_roles_menu_canSelectRole',FALSE]) then {
			_roleCount = ['GET_ROLE_COUNT',_role,_side,FALSE] call (missionNamespace getVariable 'QS_fnc_roles');
			if ((_roleCount # 0) < (_roleCount # 1)) then {
				if (!(((player getVariable ['QS_unit_role','rifleman']) isEqualTo _role) && ((player getVariable ['QS_unit_side',WEST]) isEqualTo _side))) then {

				} else {
					_allowRequest = FALSE;
					(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Вже у обраній ролі',[],-1,TRUE,'Role Selection',FALSE];
				};
			} else {
				_allowRequest = FALSE;
				(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Максимальна кількість гравців у обраній ролі',[],-1,TRUE,'Role Selection',FALSE];
			};
		} else {
			if ((!(_side isEqualTo (player getVariable ['QS_unit_side',WEST]))) && (!(missionNamespace getVariable ['QS_RSS_client_canSideSwitch',FALSE]))) then {
				_allowRequest = FALSE;
				(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Неможливо змінити фракцію',[],-1,TRUE,'Role Selection',FALSE];
			} else {
				_allowRequest = FALSE;
				(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Неможливо обрати роль',[],-1,TRUE,'Role Selection',FALSE];
			};
		};

		if (_role in ['pilot_plane','pilot_cas']) then {
			if ((missionNamespace getVariable ['QS_missionConfig_CAS',2]) isEqualTo 0) then {
				_allowRequest = FALSE;
				(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Роль пілота повітряної підтримки вимкнено в налаштуваннях місії.',[],-1,TRUE,'Role Selection',FALSE];
			};
			if ((missionNamespace getVariable ['QS_missionConfig_CAS',2]) in [1,3]) then {
				if (!(_uid in (['CAS'] call (missionNamespace getVariable 'QS_fnc_whitelist')))) then {
					(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,'Не в білому списку для ролі Пілота Повітрянної Пядтримки (зверніться до адмінів щоб потрапити до білого списку!)',[],-1,TRUE,'Role Selection',FALSE];
					_allowRequest = FALSE;
				};
			};
			if ((missionNamespace getVariable ['QS_missionConfig_CAS',2]) isEqualTo 3) then {
				if ((player getVariable ['QS_client_casAllowance',0]) >= (missionNamespace getVariable ['QS_CAS_jetAllowance_value',3])) then {
					(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,5,-1,(format ['Досягнуто ліміту на кількість Пілотів Літака ( %1 )',(missionNamespace getVariable ['QS_CAS_jetAllowance_value',3])]),[],-1,TRUE,'Role Selection',FALSE];
					_allowRequest = FALSE;
				};
			};
		};
		if (_allowRequest) then {
			[15,_uid,_side,_role,_unit,_clientOwner] remoteExec ['QS_fnc_remoteExec',2,FALSE];
		};
	};
};
if (_type isEqualTo 'HANDLE_REQUEST_ROLE') exitWith {
	params [
		'',
		['_uid',''],
		['_side',WEST],
		['_role','rifleman'],
		['_unit',objNull]
	];
	if (_uid isEqualTo '') then {
		_uid = getPlayerUID _unit;
	};
	diag_log 'QS ROLES ***** SETTING ROLE * 0 *****';
	_pCnt = count allPlayers;
	_roles = missionNamespace getVariable 'QS_unit_roles';
	_side_ID = _side call (missionNamespace getVariable 'QS_fnc_sideID');
	private _roles_side = [];
	private _prior_role_index = -1;
	private _prior_queue_index = -1;
	private _roles_side_ID = 0;
	private _roles_role = [];
	{
		_roles_side = _x;
		_roles_side_ID = _forEachIndex;
		if (!(_roles_side isEqualTo [])) then {
			{
				_roles_role = _x;
				_roles_role params [
					'_role_data',
					'_role_manifest',
					'_role_queue'
				];
				_prior_role_index = _role_manifest findIf {((_x # 0) isEqualTo _uid)};
				if (!(_prior_role_index isEqualTo -1)) then {
					_role_manifest set [_prior_role_index,['',((_role_manifest # _prior_role_index) # 1)]];
					_roles_role set [1,_role_manifest];
					_roles_side set [_forEachIndex,_roles_role];
					(missionNamespace getVariable 'QS_unit_roles') set [_roles_side_ID,_roles_side];
				};
				_prior_queue_index = _role_queue findIf {((_x # 0) isEqualTo _uid)};
				if (!(_prior_queue_index isEqualTo -1)) then {
					_role_queue set [_prior_role_index,['',-1]];
					_roles_role set [2,_role_queue];
					_roles_side set [_forEachIndex,_roles_role];
					(missionNamespace getVariable 'QS_unit_roles') set [_roles_side_ID,_roles_side];
				};
			} forEach _roles_side;
		};
	} forEach _roles;
	_roles = missionNamespace getVariable 'QS_unit_roles';
	private _roles_side = _roles # _side_ID;
	_role_data_index = _roles_side findIf {(((_x # 0) # 0) isEqualTo _role)};
	(_roles_side # _role_data_index) params [
		'_role_data',
		'_role_units',
		'_role_queue'
	];
	_available_role_index = _role_units findIf {(((_x # 0) isEqualTo '') && (((_x # 1) isEqualTo -1) || (_pCnt > (_x # 1))))};
	if (_available_role_index isEqualTo -1) exitWith {
		diag_log (format ['***** QS ROLES ***** no role available ***** %1 *****',_role_data]);
	};
	_available_role = _role_units # _available_role_index;
	diag_log 'QS ROLES ***** SETTING ROLE * 1 *****';
	_role_data params [
		'_role_data_role',
		'_role_data_side',
		'_role_data_min',
		'_role_data_max',
		'_role_data_availabilityCoef',
		'_whitelist_value',
		'_queue_capacity'
	];
	if (!(_role_data_side isEqualTo _side)) exitWith {
		diag_log (format ['***** QS ROLES ***** unit request side ( %1 ) not role side ( %2 )',_side,_role_data_side]);
	};
	_available_role set [0,_uid];
	_role_units set [_available_role_index,_available_role];
	_roles_side set [_role_data_index,[_role_data,_role_units,_role_queue]];
	(missionNamespace getVariable 'QS_unit_roles') set [_side_ID,_roles_side];
	missionNamespace setVariable ['QS_unit_roles',(missionNamespace getVariable 'QS_unit_roles'),TRUE];
	missionNamespace setVariable ['QS_RSS_refreshUI',TRUE,TRUE];
	if (!((side (group _unit)) isEqualTo _side)) then {
		if ((count (allGroups select {((side _x) isEqualTo _side)})) >= 100) then {
			{
				if (local _x) then {
					if ((side _x) isEqualTo _side) then {
						if (((units _x) findIf {(alive _x)}) isEqualTo -1) then {
							deleteGroup _x;
						};
					};
				};
			} forEach allGroups;
		};
		[_unit] joinSilent (createGroup [_side,TRUE]);
		if (!(_side isEqualTo (_unit getVariable ['QS_unit_side',WEST]))) then {
			_txt = format ['%1 перемкнуто з %2 до %3',(name _unit),(_unit getVariable ['QS_unit_side',WEST]),_side];
			_txt remoteExec ['systemChat',-2,FALSE];
			remoteExec ['QS_fnc_clientEventRespawn',_unit,FALSE];
		};
		_unit setVariable ['QS_unit_side',_side,TRUE];
	};
	_unit setVariable ['QS_unit_role',_role,TRUE];
	[16,_role] remoteExec ['QS_fnc_remoteExec',_unit,FALSE];
	if (_role isEqualTo 'pilot_plane') then {
		if (!((missionNamespace getVariable ['QS_missionConfig_CAS',2]) isEqualTo 0)) then {
			missionNamespace setVariable ['QS_fighterPilot',_unit,TRUE];
		};
	};
	diag_log (format ['***** QS ROLES ***** Setting %1 role from %2 to %3 *****',_uid,(_unit getVariable 'QS_unit_role'),_role]);
};
if (_type isEqualTo 'INIT_ROLE') exitWith {
	params ['','_role'];
	playSound 'orange_choice_select';
	comment 'rifleman';
	private _traitsData = [
		[['medic',FALSE,FALSE]],
		[['uavhacker',FALSE,FALSE]],
		[['engineer',FALSE,FALSE]],
		[['explosiveSpecialist',FALSE,FALSE]],
		[['audibleCoef',1,FALSE]],
		[['camouflageCoef',1,FALSE]],
		[['loadCoef',1,FALSE]],
		[['QS_trait_leader',FALSE,TRUE]],
		[['QS_trait_pilot',FALSE,TRUE]],
		[['QS_trait_AT',FALSE,TRUE]],
		[['QS_trait_gunner',FALSE,TRUE]],
		[['QS_trait_HQ',FALSE,TRUE]],
		[['QS_trait_fighterPilot',FALSE,TRUE]],
		[['QS_trait_cas',FALSE,TRUE]],
		[['QS_trait_JTAC',FALSE,TRUE]],
		[['QS_trait_LMG',FALSE,TRUE]],
		[['QS_trait_MMG',FALSE,TRUE]],
		[['QS_trait_Sniper',FALSE,TRUE]]
	];
	comment 'autorifleman';
	if (_role in ['autorifleman','o_autorifleman']) then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1.5,FALSE]],
			[['camouflageCoef',1.5,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',TRUE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'machine gunner';
	if (_role isEqualTo 'machine_gunner') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',2,FALSE]],
			[['camouflageCoef',2,FALSE]],
			[['loadCoef',1.25,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',TRUE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'missile soldiers';
	if (_role in ['rifleman_lat','rifleman_hat','rifleman_aa','rifleman_missile']) then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',TRUE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'medic';
	if (_role isEqualTo 'medic') then {
		_traitsData = [
			[['medic',TRUE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'engineer';
	if (_role isEqualTo 'engineer') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',TRUE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'sniper';
	if (_role isEqualTo 'sniper') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',0.5,FALSE]],
			[['camouflageCoef',0.5,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',TRUE,TRUE]]
		];
	};
	comment 'jtac';
	if (_role isEqualTo 'jtac') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',0.75,FALSE]],
			[['camouflageCoef',0.75,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',TRUE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'mortar gunner';
	if (_role isEqualTo 'mortar_gunner') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',TRUE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',TRUE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'uav operator';
	if (_role isEqualTo 'uav') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',TRUE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',FALSE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'heli pilot';
	if (_role isEqualTo 'pilot_heli') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',TRUE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',TRUE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'plane pilot';
	if (_role isEqualTo 'pilot_plane') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',FALSE,TRUE]],
			[['QS_trait_fighterPilot',TRUE,TRUE]],
			[['QS_trait_cas',TRUE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	comment 'commander';
	if (_role isEqualTo 'commander') then {
		_traitsData = [
			[['medic',FALSE,FALSE]],
			[['uavhacker',FALSE,FALSE]],
			[['engineer',FALSE,FALSE]],
			[['explosiveSpecialist',FALSE,FALSE]],
			[['audibleCoef',1,FALSE]],
			[['camouflageCoef',1,FALSE]],
			[['loadCoef',1,FALSE]],
			[['QS_trait_leader',FALSE,TRUE]],
			[['QS_trait_pilot',FALSE,TRUE]],
			[['QS_trait_AT',FALSE,TRUE]],
			[['QS_trait_gunner',FALSE,TRUE]],
			[['QS_trait_HQ',TRUE,TRUE]],
			[['QS_trait_fighterPilot',FALSE,TRUE]],
			[['QS_trait_cas',TRUE,TRUE]],
			[['QS_trait_JTAC',FALSE,TRUE]],
			[['QS_trait_LMG',FALSE,TRUE]],
			[['QS_trait_MMG',FALSE,TRUE]],
			[['QS_trait_Sniper',FALSE,TRUE]]
		];
	};
	private _trait = '';
	private _traitValue = nil;
	private _isCustom = FALSE;
	private _traitData = [];
	_fn_initTrait = missionNamespace getVariable 'QS_fnc_initTrait';
	{
		_traitData = _x;
		_traitData params ['_traitParams'];
		_traitParams params ['_trait','_traitValue','_isCustom'];
		if (_traitValue isEqualType 0) then {
			if (!((player getUnitTrait _trait) isEqualTo _traitValue)) then {
				player setUnitTrait _traitParams;
				[_role,_traitParams] call _fn_initTrait;
			};
		} else {
			if (_traitValue isEqualType TRUE) then {
				if (_traitValue) then {
					if (!(player getUnitTrait _trait)) then {
						player setUnitTrait _traitParams;
						[_role,_traitParams] call _fn_initTrait;
					};
				} else {
					if (player getUnitTrait _trait) then {
						player setUnitTrait _traitParams;
						[_role,_traitParams] call _fn_initTrait;
					};
				};
			};
		};
	} forEach _traitsData;
	call (missionNamespace getVariable 'QS_fnc_clientArsenal');
	missionNamespace setVariable ['QS_client_arsenalData',([(player getVariable ['QS_unit_side',WEST]),_role] call (missionNamespace getVariable 'QS_data_arsenal')),FALSE];
	['SET_SAVED_LOADOUT',_role] call (missionNamespace getVariable 'QS_fnc_roles');
	call (missionNamespace getVariable 'QS_fnc_respawnPilot');
	uiNamespace setVariable ['QS_client_respawnCooldown',diag_tickTime + 30];
};
if (_type isEqualTo 'SET_DEFAULT_LOADOUT') exitWith {
	params ['','_role',['_save',FALSE]];
	uiNamespace setVariable ['QS_RSS_requestCooldown',(diag_tickTime + 3)];
	_loadout_index = (missionNamespace getVariable 'QS_roles_defaultLoadouts') findIf {(_role isEqualTo (_x # 0))};
	if (_loadout_index isEqualTo -1) then {
		if (!((getUnitLoadout player) isEqualTo (((missionNamespace getVariable 'QS_roles_defaultLoadouts') # 0) # 1))) then {
			player setUnitLoadout [(((missionNamespace getVariable 'QS_roles_defaultLoadouts') # 0) # 1),TRUE];
		} else {
			systemChat 'завантаження вже застосовано';
		};
	} else {
		if (!((getUnitLoadout player) isEqualTo (((missionNamespace getVariable 'QS_roles_defaultLoadouts') # _loadout_index) # 1))) then {
			player setUnitLoadout [(((missionNamespace getVariable 'QS_roles_defaultLoadouts') # _loadout_index) # 1),TRUE];
		} else {
			systemChat 'завантаження вже застосовано';
		};
	};
	if (_save) then {
		_QS_playerRole = player getVariable ['QS_unit_role','rifleman'];
		missionNamespace setVariable ['QS_revive_arsenalInventory',(getUnitLoadout player),FALSE];
		private _QS_savedLoadouts = profileNamespace getVariable [(format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))]),[]];
		_QS_loadoutIndex = (_QS_savedLoadouts findIf {((_x # 0) isEqualTo _QS_playerRole)});
		_a = [_QS_playerRole,(getUnitLoadout player)];
		if (_QS_loadoutIndex isEqualTo -1) then {
			_QS_savedLoadouts pushBack _a;
		} else {
			_QS_savedLoadouts set [_QS_loadoutIndex,_a];
		};
		profileNamespace setVariable [(format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))]),_QS_savedLoadouts];
		saveProfileNamespace;
	};
};
if (_type isEqualTo 'SET_SAVED_LOADOUT') exitWith {
	params ['',['_role','rifleman']];
	private _customLoadout = FALSE;
	if ((((missionNamespace getVariable ['QS_missionConfig_aoType','CLASSIC']) in ['CLASSIC','SC','GRID']) && ((player getVariable ['QS_unit_side',WEST]) isEqualTo WEST)) || {(!((missionNamespace getVariable ['QS_missionConfig_aoType','CLASSIC']) in ['CLASSIC','SC','GRID']))}) then {
		if (!isNil {profileNamespace getVariable (format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))])}) then {
			if ((profileNamespace getVariable (format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))])) isEqualType []) then {
				if (!((profileNamespace getVariable (format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))])) isEqualTo [])) then {
					_QS_loadoutIndex = (profileNamespace getVariable (format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))])) findIf {((_x # 0) isEqualTo _role)};
					if (!(_QS_loadoutIndex isEqualTo -1)) then {
						player setUnitLoadout [(((profileNamespace getVariable (format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))])) # _QS_loadoutIndex) # 1),TRUE];
						_customLoadout = TRUE;
					};
				};
			} else {
				profileNamespace setVariable [(format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))]),[]];
				saveProfileNamespace;
			};
		} else {
			profileNamespace setVariable [(format ['QS_RSS_loadouts_%1',(['arid','tropic'] select (worldName in ['Tanoa']))]),[]];
			saveProfileNamespace;
		};
	};
	if (!(_customLoadout)) then {
		['SET_DEFAULT_LOADOUT',_role] call (missionNamespace getVariable 'QS_fnc_roles');
	};
};
if (_type isEqualTo 'INIT_SYSTEM') exitWith {

	{
		missionNamespace setVariable _x;
	} forEach [
		['QS_roles_data',(missionNamespace getVariable 'QS_roles_data'),TRUE],
		['QS_roles_UI_info',(missionNamespace getVariable 'QS_roles_UI_info'),TRUE],
		['QS_roles_defaultLoadouts',(missionNamespace getVariable 'QS_roles_defaultLoadouts'),TRUE],
		['QS_fnc_roleDescription',(missionNamespace getVariable 'QS_fnc_roleDescription'),TRUE]
	];
	// To do: compileFinal
	QS_unit_roles = [ [ ] , [ ] , [ ] , [ ] ];
	private _data_roles = QS_roles_data;
	private _data_roles_side = [];
	private _role_to_add = [];
	private _sideID = 0;
	private _data_role = [];
	private _role = '';
	private _min_slots = 0;
	private _max_slots = 0;
	private _slots = [];
	private _slot_unlocked = 0;
	private _side_roles = [];
	private _role_side = sideEmpty;
	private _slot_availability_coef = 0;
	private _slot_availability_at = 0;
	private _i = 0;
	{
		_sideID = _forEachIndex;
		_data_roles_side = _data_roles # _forEachIndex;
		if (!(_data_roles_side isEqualTo [])) then {
			{
				_data_role = _x;
				_data_role params [
					'_role',
					'_role_side',
					'_min_slots',
					'_max_slots',
					'_slot_availability_coef',
					'_whitelist_value',
					'_queue_capacity'
				];
				_slots = [];
				_i = 0;
				_slot_availability_at = -1;
				for '_i' from 0 to (_max_slots - 1) step 1 do {
					if (!(_slot_availability_coef isEqualTo -1)) then {
						if (_i >= _min_slots) then {
							_slot_availability_at = _slot_availability_at + _slot_availability_coef;
						};
					};
					_slots pushBack ['',([_slot_availability_at,-1] select (_i < _min_slots))];
				};
				_queue = [];
				_i = 0;
				for '_i' from 0 to (_queue_capacity - 1) step 1 do {
					_queue pushBack ['',-1];
				};
				_role_to_add = [];
				_role_to_add pushBack _data_role;
				_role_to_add pushBack _slots;
				_role_to_add pushBack _queue;
				_side_roles = QS_unit_roles # _sideID;
				_side_roles pushBack _role_to_add;
				QS_unit_roles set [_sideID,_side_roles];
			} forEach _data_roles_side;
		};
	} forEach _data_roles;
};
