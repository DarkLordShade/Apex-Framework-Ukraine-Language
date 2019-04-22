/*/
File: fn_clientMenuEntry.sqf
Author:
	
	Quiksilver
	
Last Modified:

	5/12/2017 A3 1.78 by Quiksilver

Description:

	Client Entry Menu
	
	(missionNamespace getVariable ['QS_missionConfig_splash_adminNames',''])
	['QS_missionConfig_splash_adminNames',_staffNames,TRUE],
	
__________________________________________________________/*/
disableSerialization;
_type = _this select 0;
if (_type isEqualTo 'onLoad') then {
	_display = _this select 1;
	_ctrlTitle = _display displayCtrl 1802;
	_ctrlTitle ctrlSetText briefingName;
	_ctrlSText1 = _display displayCtrl 1806;
	private _text = '';
	_text = parseText format [
		'<t underline="true">Бріфинг</t><br/><t size="1">Захистіть %1 від протилежної сторони.</t><br/><br/><t underline="true">Правила</t><t size="1"><br/>%3</t><br/><br/><t underline="true">Персонал</t><br/><t size="1">%4</t><br/><br/><t underline="true">Teamspeak</t><br/><t size="1">%2</t><br/><br/><t underline="true">Гарячі клавіші</t><br/><t size="1">[Home] - Меню гравця<br/>[End] - Беруші<br/>[4] - Поставити зброю на запобіжник<br/>[L.Ctrl]+[Reload] - Перепакувати магазини<br/>[V] - Стрибнути (під час бігу)<br/>[U] - Керування групами<br/>[Space] - Відркити/Закрити двері<br/>[J]x2 - Завдання</t>',
		worldName,
		(missionNamespace getVariable ['QS_missionConfig_commTS','']),
		(missionNamespace getVariable ['QS_missionConfig_splash_serverRules','']),
		(missionNamespace getVariable ['QS_missionConfig_splash_adminNames',''])
	];
	_ctrlSText1 ctrlSetStructuredText _text;
	
	// DEV BUILD 1.1.4
	[
		'This is an experimental development build.<br/><br/>We are testing a new Role Selection System menu.<br/><br/>Please report any related issues to your server admin.',
		'Development Build 1.1.4',
		(selectRandom ['Thanks','Gotcha','Roger','Cool story bro','Yes','Nice']),
		(selectRandom ['Cool story bro','Yes','Nice','Thanks','Gotcha','Roger']),
		(findDisplay 46),
		FALSE,
		FALSE
	] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
	
};
if (_type isEqualTo 'B1') then {
	closeDialog 0;
};
if (_type isEqualTo 'onUnload') then {
	0 spawn {
		uiSleep 0.1;
		createDialog 'QS_client_dialog_menu_roles';
	};
};