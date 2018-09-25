/*
File: fn_atNameCheck.sqf
Author:

	Quiksilver

Last modified:

	20/12/2016 A3 1.66 by Quiksilver

Description:

	-
__________________________________________________*/

private [
	'_puid','_validated','_blacklistedString',
	'_reservedClients','_nameArray','_reservedName','_reservedUID'
];
_puid = _this select 0;
_validated = TRUE;
_blacklistedString = [
	'Fuck','Shit','Cunt','Bitch','Nigger','Prick','Fag','Phag',
	'Penis','Vagina','Asshole','Gay','Lesbian','Cvnt',
	'Sh1t','Shlt','G4y','Fvck','H4ck','N1gger','Nlgger','pussy','pvssy','puzzy','pvzzy',
	'rape','r4pe','r4p3','rapist','r4pist','r4p1st','Server','Admin','Administrator','User','user','Админ','Администратор','Адмін','Адміністратор'
];
{
	if ([_x,profileName,FALSE] call (missionNamespace getVariable 'QS_fnc_inString')) exitWith {
		if (userInputDisabled) then {
			disableUserInput FALSE;
		};
		['systemChat',(format ['Robocop кікнув %1 за заборонене ім’я користувача.',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
		endMission 'QS_RD_end_5';
		[
			(format ['Автоматично кікнуто за заборонене ім’я користувача ( %1 ).',_x]),
			'Robocop',
			TRUE,
			FALSE,
			(findDisplay 46),
			FALSE,
			FALSE
		] call (missionNamespace getVariable 'BIS_fnc_GUImessage');
		_validated = FALSE;
	};
} count _blacklistedString;
_reservedClients = [
	['varrkan_ua','76561198023185330'],
	['LordShade','76561198059570583']
];
{
	_nameArray = _reservedClients select _forEachIndex;
	_reservedName = _nameArray select 0;
	_reservedUID = _nameArray select 1;
	if (profileName == _reservedName) then {
		if (!(_puid isEqualTo _reservedUID)) exitWith {
			if (userInputDisabled) then {
				disableUserInput FALSE;
			};
			['systemChat',(format ['Robocop кікнув %1 за використання зарезервованого імені.',profileName])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
			endMission 'QS_RD_end_5';
			[
				'Автоматично кікнуто за використання зарезервованого імені.',
				'Robocop',
				TRUE,
				FALSE,
				(findDisplay 46),
				FALSE,
				FALSE
			] call (missionNamespace getVariable 'BIS_fnc_GUImessage');
			_validated = FALSE;
		};
	};
} forEach _reservedClients;
_validated;
