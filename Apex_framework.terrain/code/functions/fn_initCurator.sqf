/*/
File: fn_initCurator.sqf
Author:

	Quiksilver

Last Modified:

	23/04/2017 A3 1.68 by Quiksilver

Description:


_______________________________________________________/*/

params ['_type'];
if (_type isEqualTo 0) then {
	if (!isDedicated) exitWith {};
	params ['','_client','_puid','_cid'];
	if (!isNull (getAssignedCuratorLogic _client)) exitWith {diag_log '***** CURATOR ***** Client already has curator module assigned *****';};
	_logicGrp = createGroup [sideLogic,TRUE];
	_logicGrp setVariable ['isCuratorModuleGroup',TRUE,TRUE];
	_module = _logicGrp createUnit ['ModuleCurator_F',[-1000,-1000,0],[],0,'NONE'];
	missionNamespace setVariable [
		'QS_analytics_entities_created',
		((missionNamespace getVariable 'QS_analytics_entities_created') + 1),
		FALSE
	];
	_module setSkill 0;
	_module allowDamage FALSE;
	_module enableStamina FALSE;
	_module enableFatigue FALSE;
	_module disableAI 'ALL';
	_module addCuratorPoints 1;
	_module setVehicleVarName (format ['%1',(name _client)]);
	{
		_module setVariable _x;
	} forEach [
		['owner',_puid,FALSE],
		['Addons',3,FALSE],
		['forced',0,FALSE],
		['name','Zeus',FALSE],
		['channels',[],FALSE],
		['showNotification',FALSE,FALSE],
		['birdType','',FALSE],
		['QS_cleanup_protected',TRUE,FALSE],
		['QS_curator_modules',[],TRUE],
		['QS_curator_markers',[],TRUE]
	];
	[_module,'Init'] call (missionNamespace getVariable 'BIS_fnc_moduleInit');
	sleep 3;
	for '_x' from 0 to 1 step 0 do {
		_client assignCurator _module;
		if ((getAssignedCuratorUnit _module) isEqualTo _client) exitWith {
			[1,_module] remoteExec ['QS_fnc_initCurator',_cid,FALSE];
		};
		if ((isNull _module) || (isNull _client)) exitWith {};
		sleep 2;
	};
	_module addEventHandler [
		'Local',
		{
			params ['_object','_isLocal'];
			if (_isLocal) then {
				if (!isNull _object) then {
					if (!isNil {_object getVariable 'QS_curator_modules'}) then {
						if ((_object getVariable 'QS_curator_modules') isEqualType []) then {
							{
								if (!isNull _x) then {
									missionNamespace setVariable [
										'QS_analytics_entities_deleted',
										((missionNamespace getVariable 'QS_analytics_entities_deleted') + 1),
										FALSE
									];
									deleteVehicle _x;
								};
							} count (_object getVariable 'QS_curator_modules');
						};
					};
					if (!isNil {_object getVariable 'QS_curator_markers'}) then {
						if ((_object getVariable 'QS_curator_markers') isEqualType []) then {
							private _allMapMarkers = allMapMarkers;
							{
								if (_x in _allMapMarkers) then {
									deleteMarker _x;
								};
							} count (_object getVariable 'QS_curator_markers');
						};
					};
					missionNamespace setVariable [
						'QS_analytics_entities_deleted',
						((missionNamespace getVariable 'QS_analytics_entities_deleted') + 1),
						FALSE
					];
					deleteVehicle _object;
				};
			};
		}
	];
	_module removeCuratorAddons [
		'a3_modules_f_curator_respawn',
		'a3_modules_f_curator_multiplayer',
		'a3_modules_f_kart',
		'a3_modules_f_mark_firingdrills',
		'a3_modules_f_curator_intel',
		'a3_modules_f_curator_environment',
		'a3_modules_f_curator_effects',
		'a3_characters_f_bootcamp',
		'a3_structures_f_bootcamp_vr_blocks',
		'a3_structures_f_bootcamp_vr_coverobjects',
		'a3_structures_f_bootcamp_vr_helpers',
		'a3_structures_f_exp_a_vr_blocks',
		'a3_structures_f_exp_a_vr_helpers',
		'a3_structures_f_mark_vr_helpers',
		'a3_structures_f_mark_vr_shapes',
		'a3_structures_f_mark_vr_targets',
		'a3_structures_f_heli_vr_helpers',
		'a3_modules_f_curator_lightning',
		'a3_data_f_curator_respawn',
		'curatoronly_modules_f_curator_environment',
		'curatoronly_modules_f_curator_lightning'
	];
	diag_log format ['***** CURATOR ***** Module created for %1 ( %2 ) *****',(name _client),_puid];
};
if (_type isEqualTo 1) then {
	if (isServer || !hasInterface) exitWith {};
	_module = getAssignedCuratorLogic player;
	if (!isNull _module) then {
		[_module,'Init'] call (missionNamespace getVariable 'BIS_fnc_moduleInit');
		{
			_module removeAllEventHandlers _x;
		} forEach [
			'curatorFeedbackMessage',
			'curatorPinged',
			'curatorObjectPlaced',
			'curatorObjectEdited',
			'curatorWaypointPlaced',
			'curatorObjectDoubleClicked',
			'curatorGroupDoubleClicked',
			'curatorWaypointDoubleClicked',
			'curatorMarkerDoubleClicked'
		];
		{
			_module addEventHandler _x;
		} forEach [
			['curatorFeedbackMessage',{_this call (missionNamespace getVariable 'BIS_fnc_showCuratorFeedbackMessage');}],
			/*/['curatorPinged',{_this call (missionNamespace getVariable 'BIS_fnc_curatorPinged');}],/*/
			['curatorObjectPlaced',{_this call (missionNamespace getVariable 'BIS_fnc_curatorObjectPlaced');}],
			['curatorObjectEdited',{_this call (missionNamespace getVariable 'BIS_fnc_curatorObjectEdited');}],
			['curatorWaypointPlaced',{_this call (missionNamespace getVariable 'BIS_fnc_curatorWaypointPlaced');}],
			['curatorObjectDoubleClicked',{(_this select 1) call (missionNamespace getVariable 'BIS_fnc_showCuratorAttributes');}],
			['curatorGroupDoubleClicked',{(_this select 1) call (missionNamespace getVariable 'BIS_fnc_showCuratorAttributes');}],
			['curatorWaypointDoubleClicked',{(_this select 1) call (missionNamespace getVariable 'BIS_fnc_showCuratorAttributes');}],
			['curatorMarkerDoubleClicked',{(_this select 1) call (missionNamespace getVariable 'BIS_fnc_showCuratorAttributes');}],
			['curatorGroupPlaced',(missionNamespace getVariable 'QS_fnc_clientEventCuratorGroupPlaced')],
			['curatorMarkerPlaced',(missionNamespace getVariable 'QS_fnc_clientEventCuratorMarkerPlaced')],
			['curatorObjectPlaced',(missionNamespace getVariable 'QS_fnc_clientEventCuratorObjectPlaced')],
			['curatorObjectRegistered',(missionNamespace getVariable 'QS_fnc_clientEventCuratorObjectRegistered')],
			['curatorObjectDeleted',(missionNamespace getVariable 'QS_fnc_clientEventCuratorObjectDeleted')],
			['curatorWaypointPlaced',(missionNamespace getVariable 'QS_fnc_clientEventCuratorWaypointPlaced')]
		];
		[_module,[-1,-2,0]] call (missionNamespace getVariable 'BIS_fnc_setCuratorVisionModes');
		{
			_module setVariable _x;
		} forEach [
			['QS_curator_modules',[],TRUE],
			['QS_curator_markers',[],TRUE]
		];
		_module disableAI 'ALL';
		private _actionID = -1;
		if (!isNil {missionNamespace getVariable 'QS_airdefense_laptop'}) then {
			if (!isNull (missionNamespace getVariable 'QS_airdefense_laptop')) then {
				_laptop = missionNamespace getVariable 'QS_airdefense_laptop';
				_actionID = _laptop addAction [
					'Призупинити побiчнi мiсiї',
					{
						params ['_actionTarget','','_actionID',''];
						private ['_result'];
						if (!(missionNamespace getVariable 'QS_smSuspend')) then {
							_result = ['Призупинити побiчнi мiсiї','Побiчнi мiсiї','Призупинити','Вiдмiнити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
							if (_result) then {
								missionNamespace setVariable ['QS_smSuspend',TRUE,TRUE];
								50 cutText ['Другоряднi мiсiї вiдкладено','PLAIN DOWN',0.5];
								_actionTarget setUserActionText [_actionID,'Продовжити другоряднi мiсiї',(format ["<t size='3'>%1</t>",'Поновити другоряднi мiсiї'])];
								['systemChat',(format ['%1 (персонал) вiдклав другоряднi мiсii',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
							};
						} else {
							_result = ['Продовжити другоряднi мiсiї','Другоряднi мiсiї','Продовжити','Вiдмiнити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
							if (_result) then {
								missionNamespace setVariable ['QS_smSuspend',FALSE,TRUE];
								50 cutText ['Призупинити другоряднi мiсiї','PLAIN DOWN',0.5];
								_actionTarget setUserActionText [_actionID,'Призупинити другоряднi мiсiї',(format ["<t size='3'>%1</t>",'Призупинити другоряднi мiсiї'])];
								['systemChat',(format ['%1 (персонал) призупинив другоряднi мiсiї',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
							};
						};
					},
					[],
					50,
					TRUE,
					TRUE,
					'',
					'(!isNull (getAssignedCuratorLogic player))',
					5,
					FALSE
				];
				_laptop setUserActionText [_actionID,((_laptop actionParams _actionID) select 0),(format ["<t size='3'>%1</t>",((_laptop actionParams _actionID) select 0)])];
				_actionID2 = _laptop addAction [
					'Призупинити основнi мiсiї',
					{
						params ['_actionTarget','','_actionID',''];
						private ['_result'];

						if (!((missionNamespace getVariable ['QS_missionConfig_aoType','']) isEqualTo 'NONE')) then {
							if (!(missionNamespace getVariable ['QS_customAO_GT_active',FALSE])) then {
								if (!(missionNamespace getVariable 'QS_aoSuspended')) then {
									_result = ['Призупинити основнi мiсiї','Основнi мiсiї','Призупинити','Вiдмiнити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
									if (_result) then {
										missionNamespace setVariable ['QS_aoSuspended',TRUE,TRUE];
										missionNamespace setVariable ['QS_aoCycleVar',TRUE,TRUE];
										missionNamespace setVariable ['QS_forceDefend',-1,TRUE];
										50 cutText ['Основнi мiсiї призупинено, зачекайте ...','PLAIN DOWN',0.5];
										_actionTarget setUserActionText [_actionID,'Продовжити основнi мiсiї',(format ["<t size='3'>%1</t>",'Продовжити основнi мiсiї'])];
										['systemChat',(format ['%1 (персонал) призупинив основнi мiсiї',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
									};
								} else {
									_result = ['Продовжити основнi мiсiї','Основнi мiсiї','Продовжити','Вiдмiнити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
									if (_result) then {
										missionNamespace setVariable ['QS_aoSuspended',FALSE,TRUE];
										missionNamespace setVariable ['QS_aoCycleVar',FALSE,TRUE];
										50 cutText ['Основнi мiсiї поновлено, зачекайте ...','PLAIN DOWN',0.5];
										_actionTarget setUserActionText [_actionID,'Призупинити основнi мiсiї',(format ["<t size='3'>%1</t>",'Призупинити основнi мiсiї'])];
										['systemChat',(format ['%1 (персонал) поновив основнi мiсiї',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
									};
								};
							} else {
								50 cutText ['Не можна призупинити цю мiсiю','PLAIN DOWN',0.5];
							};
						} else {
							50 cutText ['Основнi мiсiї вимкнено в конфiгурацiї сервера, спроба виконання циклу не вдалась','PLAIN DOWN',0.5];
						};
					},
					[],
					50,
					TRUE,
					TRUE,
					'',
					'(!isNull (getAssignedCuratorLogic player))',
					5,
					FALSE
				];
				_laptop setUserActionText [_actionID2,((_laptop actionParams _actionID2) select 0),(format ["<t size='3'>%1</t>",((_laptop actionParams _actionID2) select 0)])];
				_actionID3 = _laptop addAction [
					'Основну мiсiю в цикл',
					{
						params ['_actionTarget','','_actionID',''];
						private ['_result'];
						if (!((missionNamespace getVariable ['QS_missionConfig_aoType','']) isEqualTo 'NONE')) then {
							if (!(missionNamespace getVariable ['QS_customAO_GT_active',FALSE])) then {
								if (diag_tickTime < (player getVariable ['QS_client_aoCycleCooldown',-1])) exitWith {
									50 cutText [(format ['Занадто швидко, будь ласка, зачекайте %1с',(round((player getVariable ['QS_client_aoCycleCooldown',-1]) - diag_tickTime))]),'PLAIN',0.5];
								};
								player setVariable ['QS_client_aoCycleCooldown',(diag_tickTime + 60),FALSE];
								if (!(missionNamespace getVariable ['QS_aoSuspended',FALSE])) then {
									_result = ['Основну мiсiю в цикл','Основнi мiсiї','Цикл','Вiдмiнити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
									if (_result) then {
										missionNamespace setVariable ['QS_aoCycleVar',TRUE,TRUE];
										['systemChat',(format ['%1 (staff) запустив основну мiсiю в циклi',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
										50 cutText ['Основна мiсiя зациклюється, зачекайте...','PLAIN DOWN',0.5];
									} else {
										50 cutText ['Вiдмiна спроби зациклювання','PLAIN DOWN',0.5];
									};
								} else {
									50 cutText ['Основнi мiсiї призупинено, спроба зациклювання не вдалась','PLAIN DOWN',0.5];
								};
							} else {
								50 cutText ['Не можна призупинити цю мiсiю','PLAIN DOWN',0.5];
							};
						} else {
							50 cutText ['Основнi мiсiї вимкнено в конфiгурацiї сервера, спроба виконання циклу не вдалась','PLAIN DOWN',0.5];
						};
					},
					[],
					50,
					TRUE,
					TRUE,
					'',
					'(!isNull (getAssignedCuratorLogic player))',
					5,
					FALSE
				];
				_laptop setUserActionText [_actionID3,((_laptop actionParams _actionID3) select 0),(format ["<t size='3'>%1</t>",((_laptop actionParams _actionID3) select 0)])];
			};
		};
	};
};
