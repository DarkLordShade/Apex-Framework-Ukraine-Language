/*
File: fn_eventRTKilled.sqf
Author:

	Quiksilver

Last modified:

	5/12/2018 A3 1.86 by Quiksilver

Description:

	Event Radio Tower Killed
__________________________________________________*/

params ['_object','_killer'];
{
	_x setMarkerAlpha 0;
	_x setMarkerPos [-5000,-5000,0];
} forEach ['QS_marker_radioMarker','QS_marker_radioCircle'];
_radioTowerDownText = parseText "<t align='center' size='2.2'>Радіовежу</t><br/><t size='1.5' color='#08b000' align='center'>ЗНИЩЕНО</t><br/>____________________<br/>Ворожу радіовежу знищено! Неперевершена робота, хлопці!<br/><br/><t size='1.2' color='#08b000' align='center'> Тепер ворог не зможе викликати підкріплення!</t><br/>";
//['hint',_radioTowerDownText] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
['QS_IA_TASK_AO_1'] call (missionNamespace getVariable 'BIS_fnc_deleteTask');
['CompletedSub',['Ворожу радіовежу знищено!']] remoteExec ['QS_fnc_showNotification',-2,FALSE];
if (!isNull _killer) then {
	if (isPlayer _killer) then {
		_name = name _killer;
		if ((random 1) > 0.5) then {
			['sideChat',[WEST,'HQ'],(format ['%1 знищив радіовежу! Гарна робота, солдати!',_name])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
		} else {
			['sideChat',[WEST,'HQ'],(format ['%1 зніс вежу! Неперевершена робота, хлопці!',_name])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
		};
		if ((!(_killer getUnitTrait 'uavhacker')) && (!(_killer getUnitTrait 'QS_trait_pilot')) && (!(_killer getUnitTrait 'QS_trait_fighterPilot'))) then {
			(missionNamespace getVariable 'QS_leaderboards_session_queue') pushBack ['TOWER',(getPlayerUID _killer),(name _killer),1];
		};
	};
};
