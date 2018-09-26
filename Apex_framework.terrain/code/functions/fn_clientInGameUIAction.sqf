/*/
File: fn_clientInGameUIAction.sqf
Author:

	Quiksilver

Last modified:

	5/05/2018 A3 1.82 by Quiksilver

Description:

	-
______________________________________________/*/

if (_this isEqualTo []) exitWith {TRUE};
if (!(diag_tickTime > (player getVariable 'QS_client_uiLastAction'))) exitWith {TRUE};
player setVariable ['QS_client_uiLastAction',(diag_tickTime + 1),FALSE];
params ['_QS_actionTarget','_QS_player','_QS_actionIndex','_QS_actionName','_QS_actionText','_QS_actionPriority','_QS_actionShownWindow','_QS_actionHiddenOnUse','_QS_actionShortcutName','_QS_actionVisibility','_QS_actionEventName'];
private _QS_c = FALSE;
if (((animationState player) in [
	'ainvpknlmstpslaywrfldnon_medicother','ainvppnemstpslaywrfldnon_medicother','ainvppnemstpslaywnondnon_medicother','ainvpknlmstpslaywnondnon_medicother',
	'ainvpknlmstpslaywnondnon_medic','ainvpknlmstpslaywrfldnon_medic','ainvpknlmstpslaywpstdnon_medic','ainvppnemstpslaywnondnon_medic','ainvppnemstpslaywrfldnon_medic',
	'ainvppnemstpslaywpstdnon_medic'
]) && (!((toLower _QS_actionText) in ['cancel']))) exitWith {
	50 cutText ['Зайнятий','PLAIN DOWN',0.333];
	_QS_c = TRUE;
	_QS_c;
};
if (!((lifeState player) in ['HEALTHY','INJURED'])) exitWith {
	50 cutText ['Недієздатний','PLAIN DOWN',0.333];
	_QS_c = TRUE;
	_QS_c;
};
if ((!(((attachedObjects player) findIf {((!isNull _x) && (!(_x isKindOf 'Sign_Sphere10cm_F')))}) isEqualTo -1)) && (!((toLower _QS_actionText) in [
	'відпустити','відчепити','завантажити','втягнути вантажні троси','подовжити вантажні троси','вкоротити вантажні троси','відпустити вантажні троси','випустити вантажні троси','приєднати вантажні троси','скинути вантажні троси','підняти вантажні троси','release','load','retract cargo ropes','extend cargo ropes','shorten cargo ropes','release cargo','deploy cargo ropes','attach to cargo ropes','drop cargo ropes','pickup cargo ropes'
])) && (!(_QS_actionName in ['OpenParachute']))) exitWith {
	50 cutText ['Зайнятий','PLAIN DOWN',0.333];
	_QS_c = TRUE;
	_QS_c;
};
private _exit = FALSE;
private _text = '';
_QS_module_opsec = (call (missionNamespace getVariable ['QS_missionConfig_AH',{1}])) isEqualTo 1;
if (_QS_actionName isEqualTo 'User') then {
	if (!((_this select 4) isEqualTo '')) then {
		if (_QS_module_opsec) then {
			if (!((getPlayerUID player) in (['DEVELOPER'] call (missionNamespace getVariable 'QS_fnc_whitelist')))) then {
				_whitelistedActions = [] call (missionNamespace getVariable 'QS_data_actions');
				if ((!((_this select 4) in _whitelistedActions)) && (!(['ROBOCOP',(_this select 4),FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))) && (!(['Put Explosive Charge',(_this select 4),FALSE] call (missionNamespace getVariable 'QS_fnc_inString')))) then {
					_exit = TRUE;
					[
						40,
						[
							time,
							serverTime,
							(name player),
							profileName,
							profileNameSteam,
							(getPlayerUID player),
							2,
							(format ['Non-whitelisted scroll action text: "%1"',(_this select 4)]),
							player,
							productVersion
						]
					] remoteExec ['QS_fnc_remoteExec',2,FALSE];
					_co = player;
					removeAllActions _co;
				};
			};
		};
	};
};
if (_exit) exitWith {TRUE;};
if (['GetIn',_QS_actionName,FALSE] call (missionNamespace getVariable 'QS_fnc_inString')) then {
	if (!((attachedObjects player) isEqualTo [])) then {
		if (!(((attachedObjects player) findIf {((alive _x) && (_x isKindOf 'CAManBase'))}) isEqualTo -1)) then {
			50 cutText ['Відпустити / завантажити, перш ніж входити','PLAIN DOWN',0.75];
			_QS_c = TRUE;
		};
	};
};
if (_QS_c) exitWith {_QS_c;};
if (_QS_actionName isEqualTo 'HealSoldier') exitWith {
	if (!(((attachedObjects player) findIf {((alive _x) && (_x isKindOf 'CAManBase'))}) isEqualTo -1)) then {
		50 cutText ['Не можемо вилікувати в цей час','PLAIN DOWN'];
		_QS_c = TRUE;
	};
	if ((lifeState _QS_actionTarget) isEqualTo 'INCAPACITATED') then {
		_QS_c = TRUE;
		50 cutText [(format ['%1 потрібна евакуація. Лікування не відбулося!',(name _QS_actionTarget)]),'PLAIN DOWN'];
	};
	if (!isNil {_QS_actionTarget getVariable 'QS_noHeal'}) then {
		_QS_c = TRUE;
		50 cutText ['Його не можна лікувати','PLAIN DOWN'];
	};
	if (!(_QS_c)) then {
		if (isPlayer _QS_actionTarget) then {
			[63,[5,[(format ['Вас лікує %1',profileName]),'PLAIN DOWN',0.5]]] remoteExec ['QS_fnc_remoteExec',_QS_actionTarget,FALSE];
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'RepairVehicle') exitWith {
	if (!(((crew _QS_actionTarget) findIf {(alive _x)}) isEqualTo -1)) then {
		{
			if ((side _x) in ([player] call (missionNamespace getVariable 'QS_fnc_enemySides'))) exitWith {
				_QS_c = TRUE;
				50 cutText ['Не можна ремонтувати активну техніку ворогів','PLAIN',0.5];
			};
		} count (crew _QS_actionTarget);
	};
	if (!(_QS_c)) then {
		if (!isNil {_QS_actionTarget getVariable 'QS_RD_noRepair'}) then {
			_QS_c = TRUE;
			50 cutText ['Цю техніку не можливо відремонтувати','PLAIN DOWN'];
		} else {
			if (!isNull (effectiveCommander _QS_actionTarget)) then {
				if (isPlayer _QS_actionTarget) then {
					if (alive _QS_actionTarget) then {
						if (!(_QS_actionTarget isEqualTo (vehicle player))) then {
							[63,[5,[(format ['Ваш автомобіль ремонтує %1',profileName]),'PLAIN DOWN',0.5]]] remoteExec ['QS_fnc_remoteExec',(effectiveCommander _QS_actionTarget),FALSE];
						};
					};
				};
			};
			if ((fuel (_this select 0)) isEqualTo 0) then {
				0 = [_this select 0] spawn {
					_v = _this select 0;
					uiSleep 5;
					if (local _v) then {
						_v setFuel (0.03 + (random 0.03));
					} else {
						['setFuel',_v,(0.03 + (random 0.03))] remoteExec ['QS_fnc_remoteExecCmd',_v,FALSE];
					};
					_dn = getText (configFile >> 'CfgVehicles' >> (typeOf (_this select 0)) >> 'displayName');
					50 cutText [(format ['%1 перезаправлено',_dn]),'PLAIN DOWN',0.75];
				};
			};
			if ((_this select 0) isKindOf 'Helicopter') then {
				(_this select 0) setHit ['tail_rotor_hit',0];
			};
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'UseMagazine') exitWith {
	if ((cameraOn distance (markerPos 'QS_marker_base_marker')) < 300) then {
		50 cutText ['Вибухівку заборонено поблизу бази','PLAIN'];
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'UseContainerMagazine') exitWith {
	if ((cameraOn distance (markerPos 'QS_marker_base_marker')) < 300) then {
		50 cutText ['Вибухівку заборонено поблизу бази','PLAIN'];
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'StartTimer') exitWith {

};
if (_QS_actionName isEqualTo 'Eject') exitWith {
	if ((vehicle player) isKindOf 'Air') then {
		if (player isEqualTo (driver (vehicle player))) then {
			_QS_c = TRUE;
			0 spawn {
				private _result = ['Eject?','Eject warning','Eject','Cancel',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
				if (_result) then {
					player action ['eject',(vehicle player)];
				};
			};
		} else {
			if (!(isTouchingGround (vehicle player))) then {
				if (((vectorMagnitude (velocity (vehicle player))) * 3.6) > 25) then {
					_QS_c = TRUE;
					0 spawn {
						private _result = ['Eject?','Eject warning','Eject','Cancel',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
						if (_result) then {
							player action ['eject',(vehicle player)];
						};
					};
				};
			};
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInPilot') exitWith {
	if ((!((toLower (typeOf player)) in ['b_pilot_f','b_helipilot_f','b_t_pilot_f','b_t_helipilot_f','b_fighter_pilot_f'])) && (!(player getUnitTrait 'QS_trait_pilot')) && (!(player getUnitTrait 'QS_trait_fighterPilot'))) then {
		_text = format ['ROBOCOP: Сидіння пілота тільки для Пілотів! Ви ***** %1 *****. Грайте свою роль або оберіть іншу!',(getText (configFile >> 'CfgVehicles' >> (typeOf player) >> 'displayName'))];
		(missionNamespace getVariable 'QS_managed_hints') pushBack [1,FALSE,8,-1,_text,[],-1];
		_QS_c = TRUE;
	};
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || (!((secondaryWeapon player) isEqualTo '')) || (!((handgunWeapon player) isEqualTo ''))) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'В цій техніці зброя не дозволена',[],-1];
			_QS_c = TRUE;
		};
	};
	if ((!isNil {player getVariable 'QS_tto'}) && ((player getVariable 'QS_tto') > 3)) then {
		_QS_c = TRUE;
	};
	if ((toLower (typeOf _QS_actionTarget)) in [
		'b_plane_cas_01_f',
		'b_plane_cas_01_dynamicloadout_f',
		'b_plane_cas_01_cluster_f',
		'b_plane_fighter_01_f',
		'b_plane_fighter_01_stealth_f',
		'b_plane_fighter_01_cluster_f',
		'o_plane_cas_02_f',
		'o_plane_cas_02_dynamicloadout_f',
		'o_plane_cas_02_cluster_f',
		'o_plane_fighter_02_f',
		'o_plane_fighter_02_stealth_f',
		'o_plane_fighter_02_cluster_f',
		'i_plane_fighter_03_aa_f',
		'i_plane_fighter_03_cas_f',
		'i_plane_fighter_03_dynamicloadout_f',
		'i_plane_fighter_03_cluster_f',
		'i_plane_fighter_04_f',
		'i_plane_fighter_04_cluster_f'
	]) then {
		if (!(player getUnitTrait 'QS_trait_fighterPilot')) then {
			_QS_c = TRUE;
			_text = 'Тільки пілот винищувача (Роль в лобі) може використовувати цей літак';
			50 cutText [_text,'PLAIN',0.5];
		};
	};
	if (player getUnitTrait 'QS_trait_fighterPilot') then {
		if (!((toLower (typeOf _QS_actionTarget)) in [
			'b_plane_cas_01_f',
			'b_plane_cas_01_dynamicloadout_f',
			'b_plane_cas_01_cluster_f',
			'b_plane_fighter_01_f',
			'b_plane_fighter_01_stealth_f',
			'b_plane_fighter_01_cluster_f',
			'o_plane_cas_02_f',
			'o_plane_cas_02_dynamicloadout_f',
			'o_plane_cas_02_cluster_f',
			'o_plane_fighter_02_f',
			'o_plane_fighter_02_stealth_f',
			'o_plane_fighter_02_cluster_f',
			'i_plane_fighter_03_aa_f',
			'i_plane_fighter_03_cas_f',
			'i_plane_fighter_03_dynamicloadout_f',
			'i_plane_fighter_03_cluster_f',
			'i_plane_fighter_04_f',
			'i_plane_fighter_04_cluster_f',
			'i_c_plane_civil_01_f'
		])) then {
			_QS_c = TRUE;
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInCargo') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || {(!((secondaryWeapon player) isEqualTo ''))} || {(!((handgunWeapon player) isEqualTo ''))}) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'В цій техніці зброя не дозволена',[],-1];
			_QS_c = TRUE;
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInDriver') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || {(!((secondaryWeapon player) isEqualTo ''))} || {(!((handgunWeapon player) isEqualTo ''))}) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'В цій техніці зброя не дозволена',[],-1];
			_QS_c = TRUE;
		};
	};
	if ((!isNil {player getVariable 'QS_tto'}) && ((player getVariable 'QS_tto') > 3)) then {
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInGunner') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || {(!((secondaryWeapon player) isEqualTo ''))} || {(!((handgunWeapon player) isEqualTo ''))}) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'В цій техніці зброя не дозволена',[],-1];
			_QS_c = TRUE;
		};
	};
	if ((!isNil {player getVariable 'QS_tto'}) && ((player getVariable 'QS_tto') > 3)) then {
		_QS_c = TRUE;
	};
	if (player getUnitTrait 'QS_trait_pilot') then {
		if ((count allPlayers) > 20) then {
			if ((player distance (markerPos 'QS_marker_base_marker')) < 1000) then {
				_QS_c = TRUE;
			};
		};
	};
	if (player getUnitTrait 'QS_trait_fighterPilot') then {
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInCommander') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || {(!((secondaryWeapon player) isEqualTo ''))} || {(!((handgunWeapon player) isEqualTo ''))}) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'В цій техніці зброя не дозволена',[],-1];
			_QS_c = TRUE;
		};
	};
	if ((!isNil {player getVariable 'QS_tto'}) && ((player getVariable 'QS_tto') > 3)) then {
		_QS_c = TRUE;
	};
	if (player getUnitTrait 'QS_trait_pilot') then {
		if ((count allPlayers) > 20) then {
			if ((player distance (markerPos 'QS_marker_base_marker')) < 1000) then {
				_QS_c = TRUE;
			};
		};
	};
	if (player getUnitTrait 'QS_trait_fighterPilot') then {
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'GetInTurret') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		if ((!((primaryWeapon player) isEqualTo '')) || {(!((secondaryWeapon player) isEqualTo ''))} || {(!((handgunWeapon player) isEqualTo ''))}) then {
			50 cutText ['В цій техніці зброя не дозволена','PLAIN DOWN'];
			_QS_c = TRUE;
		};
	};
	if ((!isNil {player getVariable 'QS_tto'}) && ((player getVariable 'QS_tto') > 3)) then {
		_QS_c = TRUE;
	};
	if (['Copilot',(_this select 4),FALSE] call (missionNamespace getVariable 'QS_fnc_inString')) then {
		if (!((typeOf (_this select 0)) in ['B_Heli_Light_01_F','B_Heli_Light_01_stripped_F','I_Heli_light_03_F','I_Heli_light_03_unarmed_F','I_Heli_light_03_dynamicLoadout_F'])) then {
			if ((count allPlayers) > 20) then {
				if (!((typeOf player) in ['B_Helipilot_F','B_pilot_F','B_T_Helipilot_F','B_T_pilot_F'])) then {
					_QS_c = TRUE;
				};
			};
		};
	};
	if (player getUnitTrait 'QS_trait_pilot') then {
		if ((count allPlayers) > 20) then {
			if ((player distance (markerPos 'QS_marker_base_marker')) < 1000) then {
				_QS_c = TRUE;
			};
		};
	};
	if (_QS_actionTarget isKindOf 'StaticMortar') then {
		if ((isNull (attachedTo _QS_actionTarget)) || {((!isNull (attachedTo _QS_actionTarget)) && ((attachedTo _QS_actionTarget) isKindOf 'AllVehicles'))}) then {
			if (!(player getUnitTrait 'QS_trait_gunner')) then {
				private _currentMortarGunnerName = 'Slot available';
				private _currentMortarGunners = [];
				_currentMortarGunners = allPlayers select {(_x getUnitTrait 'QS_trait_gunner')};
				if (!(_currentMortarGunners isEqualTo [])) then {
					_currentMortarGunnerName = name (_currentMortarGunners select 0);
				};
				50 cutText [(format ['Тільки Мк6 мінометники (%1) можуть використовувати міномети.',_currentMortarGunnerName]),'PLAIN DOWN',0.75];
				_QS_c = TRUE;
			};
		};
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'MoveToTurret') then {
	if (player getUnitTrait 'QS_trait_pilot') then {
		if ((count allPlayers) > 20) then {
			if ((player distance (markerPos 'QS_marker_base_marker')) < 1000) then {
				_QS_c = TRUE;
			};
		};
	};
};
if (_QS_actionName isEqualTo 'Gear') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'DropWeapon') exitWith {
	if (!isNil {(_this select 0) getVariable 'QS_RD_vehicle_ICRC'}) then {
		_QS_c = TRUE;
	};
	_QS_c;
};
if (_QS_actionName isEqualTo 'Assemble') then {
	if ((cameraOn isEqualTo (vehicle player)) && ((player distance2D (markerPos 'QS_marker_base_marker')) < 300)) then {
		_QS_c = TRUE;
		50 cutText ['Монтаж озброєння заборонено поблизу бази','PLAIN'];
	};
	if (!(['Disassemble',_QS_actionText,FALSE] call (missionNamespace getVariable 'QS_fnc_inString'))) then {
		if (!isNil {player getVariable 'QS_client_assembledWeapons'}) then {
			private _assembledWeapons = player getVariable 'QS_client_assembledWeapons';
			if (({(alive _x)} count _assembledWeapons) > 2) then {
				50 cutText ['Максимум 3 зібрані зброї за один раз (включаючи дронів в рюкзаку)','PLAIN DOWN',1];
				_QS_c = TRUE;
			};
		};
	};
};
if (_QS_actionName in ['TouchOffMines','TouchOff']) then {
	private ['_playersNearby','_count','_mine'];
	_count = 0;
	{
		_mine = _x;
		if (!isNull _mine) then {
			if (mineActive _mine) then {
				_playersNearby = [(getPosATL _mine),30,[WEST],allPlayers,0] call (missionNamespace getVariable 'QS_fnc_serverDetector');
				if ((count _playersNearby) > 1) then {
					{
						if ((([objNull,'GEOM'] checkVisibility [(getPosASL (vehicle _x)),[((getPosASL _mine) select 0),((getPosASL _mine) select 1),(((getPosASL _mine) select 2)+0.5)]]) > 0) || {(([objNull,'VIEW'] checkVisibility [(getPosASL (vehicle _x)),[((getPosASL _mine) select 0),((getPosASL _mine) select 1),(((getPosASL _mine) select 2)+0.5)]]) > 0)}) then {
							_count = _count + 1;
							if ((player targets [TRUE,30,[],0,(getPosATL _mine)]) isEqualTo []) then {
								_QS_c = TRUE;
							};
						};
					} forEach _playersNearby;
					if (_QS_c) then {
						50 cutText [(format ['%1 гравці занадто близько (30m) до однієї або декількох ваших вибухівок. Підрив не відбувся!',_count]),'PLAIN DOWN',1];
					};
				};
			};
			if (_count > 1) then {
				if ((player getVariable ['QS_tto',0]) > 1) then {
					deleteVehicle _x;
				};
			};
		};
	} forEach (getAllOwnedMines player);
};
if (_QS_actionName isEqualTo 'UseMagazine') then {
	getCursorObjectParams params [
		'_cursorObject',
		'',
		'_cursorObjectDistance'
	];
	if (_cursorObject isKindOf 'Air') then {
		if (_cursorObjectDistance < 5) then {
			if (!(player getUnitTrait 'QS_trait_pilot')) then {
				_nCargo = getNumber (configFile >> 'CfgVehicles' >> (typeOf _cursorObject) >> 'transportSoldier');
				if (_nCargo > 0) then {
					if (!(((crew _cursorObject) findIf {((alive _x) && (isPlayer _x))}) isEqualTo -1)) then {
						if ((player targets [TRUE,30,[],0,(getPosATL _cursorObject)]) isEqualTo []) then {
							50 cutText ['Не можу виконати зараз','PLAIN DOWN',0.5];
							_QS_c = TRUE;
						};
					};
				};
			};
		};
	};
};
if (_QS_actionName isEqualTo 'DisAssemble') then {
	private _assembledWeapons = player getVariable ['QS_client_assembledWeapons',[]];
	if (!(_assembledWeapons isEqualTo [])) then {
		if (_QS_actionTarget in _assembledWeapons) then {
			_assembledWeapons deleteAt (_assembledWeapons find _QS_actionTarget);
			player setVariable ['QS_client_assembledWeapons',_assembledWeapons,FALSE];
		};
	};
	if (!isNull (attachedTo _QS_actionTarget)) then {
		if ((attachedTo _QS_actionTarget) isKindOf 'Man') then {
			50 cutText ['Не можу виконати зараз','PLAIN DOWN',0.5];
			_QS_c = TRUE;
		};
	};
};
if (_QS_actionName in ['TakeVehicleControl','MoveToPilot']) then {
	if (!(player getUnitTrait 'QS_trait_pilot')) then {
		if ((vehicle player) isKindOf 'Air') then {
			if (!((typeOf (vehicle player)) in ['B_Heli_Light_01_F','B_Heli_Light_01_stripped_F'])) then {
				if ((count allPlayers) > 20) then {
					_QS_c = TRUE;
				};
			};
		};
	};
	if (player getUnitTrait 'QS_trait_fighterPilot') then {
		_QS_c = TRUE;
	};
};
if (_QS_actionName isEqualTo 'AutoHover') then {
	_v = vehicle player;
	if (_v isKindOf 'Helicopter') then {
		if (!(isAutoHoverOn _v)) then {
			if (((count (crew _v))) > 1) then {
				if (isNil {player getVariable 'QS_client_lastAutoHoverMsg'}) then {
					player setVariable ['QS_client_lastAutoHoverMsg',TRUE,FALSE];
					0 spawn {
						uiSleep 5;
						player setVariable ['QS_client_lastAutoHoverMsg',nil,FALSE];
					};
					_arrayToSend = (crew _v) select {((!(_x isEqualTo player)) && (alive _x) && (isPlayer _x))};
					if (!(_arrayToSend isEqualTo [])) then {
						[63,[5,[(format ['Ваш пілот ( %1 ) увімкнув автопілот!',profileName]),'PLAIN DOWN',0.3]]] remoteExec ['QS_fnc_remoteExec',_arrayToSend,FALSE];
					};
				};
			};
		};
	};
};
if (_QS_actionName isEqualTo 'UAVTerminalHackConnection') then {
	if (!local _QS_actionTarget) then {
		_text = format ['%1 (%2) has hacked a(n) %3!',profileName,(getText (configFile >> 'CfgVehicles' >> (typeOf player) >> 'displayName')),(getText (configFile >> 'CfgVehicles' >> (typeOf _QS_actionTarget) >> 'displayName'))];
		['systemChat',_text] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
	};
	_QS_actionTarget spawn {
		uiSleep 1;
		if (!((crew _this) isEqualTo [])) then {
			(group (driver _this)) setVariable ['QS_HComm_grp',FALSE,TRUE];
		};
	};
};
if (_QS_actionName isEqualTo 'OpenBag') then {
	if (isNull (objectParent player)) then {
		if ((((vectorMagnitude (velocity (vehicle player))) * 3.6) > 2) || {(((vectorMagnitude (velocity (vehicle _QS_actionTarget))) * 3.6) > 2)}) then {
			_QS_c = TRUE;
			50 cutText ['Не можна це робити під час руху','PLAIN DOWN',0.75];
		};
	};
};
if (_QS_actionName isEqualTo 'UserType') then {
	_actionTextLower = toLower _QS_actionText;
	if (_actionTextLower in ['open door','close door','open hatch','close hatch']) then {
		private _info = 2 call (missionNamespace getVariable 'QS_fnc_getDoor');
		_info params ['_house','_door'];
		if (isNull _house) exitWith {};
		private _getDoorAnimations = [_house, _door] call (missionNamespace getVariable 'QS_fnc_getDoorAnimations');
		_getDoorAnimations params ['_animations','_lockedVariable'];
		if (_animations isEqualTo []) exitWith {};
		if (diag_tickTime > (missionNamespace getVariable ['QS_interact_doorLastOpenTime',(diag_tickTime - 1)])) then {
			missionNamespace setVariable ['QS_interact_doorLastOpenTime',(diag_tickTime + 1),FALSE];
			2 call (missionNamespace getVariable 'QS_fnc_clientInteractDoor');
		};
	} else {
		if (_actionTextLower in ['beacons on','beacons off']) then {
			if (_actionTextLower isEqualTo 'beacons on') then {
				//comment 'Beacons on';
				[] call (missionNamespace getVariable 'QS_fnc_clientInteractUtilityOffroad');
			} else {
				//comment 'Beacons off';
				(vehicle player) setVariable ['Utility_Offroad_Beacons',FALSE,TRUE];
			};
		};
	};
};
if (_QS_actionName in ['ListRightVehicleDisplay','NextModeRightVehicleDisplay']) then {
	_QS_c = TRUE;
	50 cutText ['Будь ласка, привязуйте ці дії до клавіш. [Esc]>>[Configure]>>[Controls]>>[Keyboard]>>[Common]>>[Panels]. За замовчуванням клавіші [ та ]','PLAIN DOWN',2];
};
if (_QS_actionName isEqualTo 'UnloadUnconsciousUnits') then {
	if (isNull (objectParent player)) then {
		50 cutText ['Непритомний пасажир вивантажений','PLAIN DOWN',0.5];
	} else {
		50 cutText ['Має бути на ногах','PLAIN DOWN',0.5];
		_QS_c = TRUE;
	};
	if (!isNull (isVehicleCargo _QS_actionTarget)) then {
		50 cutText ['Не можу зробити цього разу','PLAIN DOWN',0.5];
		_QS_c = TRUE;

	};
	if (surfaceIsWater (getPosWorld _QS_actionTarget)) then {
		50 cutText ['Не можу зробити це тут','PLAIN DOWN',0.5];
		_QS_c = TRUE;
	};
	if (!isNull (ropeAttachedTo _QS_actionTarget)) then {
		50 cutText ['Не можна зробити це зараз','PLAIN DOWN',0.5];
		_QS_c = TRUE;
	};
};
if (_QS_actionName isEqualTo 'HookCargo') then {
	if (!('SlingLoadDisplay' in ((infoPanel 'left') + (infoPanel 'right')))) then {
		if ('EmptyDisplay' in (infoPanel 'left')) then {
			setInfoPanel ['left','SlingLoadDisplay'];
		} else {
			if ('EmptyDisplay' in (infoPanel 'right')) then {
				setInfoPanel ['right','SlingLoadDisplay'];
			} else {
				setInfoPanel ['left','SlingLoadDisplay'];
			};
		};
	};
};
if (_QS_actionName isEqualTo 'UnhookCargo') then {
	_vehicle = cameraOn;
	if (local _vehicle) then {
		if (!('SlingLoadDisplay' in ((infoPanel 'left') + (infoPanel 'right')))) then {
			if ('EmptyDisplay' in (infoPanel 'left')) then {
				setInfoPanel ['left','SlingLoadDisplay'];
			} else {
				if ('EmptyDisplay' in (infoPanel 'right')) then {
					setInfoPanel ['right','SlingLoadDisplay'];
				} else {
					setInfoPanel ['left','SlingLoadDisplay'];
				};
			};
		};
		_heliplayer = if (isNull (missionNamespace getVariable ['bis_fnc_moduleRemoteControl_unit',objNull])) then {player} else {(missionNamespace getVariable ['bis_fnc_moduleRemoteControl_unit',objNull])};
		if ((_heliplayer isEqualTo (driver _vehicle)) || {((_vehicle isKindOf 'heli_transport_04_base_f') && (_heliplayer isEqualTo (_vehicle turretUnit [1])))}) then {
			if (!isNull (getSlingLoad _vehicle)) then {
				if ((getSlingLoad _vehicle) in (attachedObjects _vehicle)) then {
					_QS_c = TRUE;
					['DOWN'] call (missionNamespace getVariable 'QS_fnc_slingRope');
				};
			};
		};
	} else {
		_QS_c = TRUE;
	};
};
if (_QS_actionText in ['   ','Зброя на запобіжнику']) then {
	_QS_c = TRUE;
};
_QS_c;
