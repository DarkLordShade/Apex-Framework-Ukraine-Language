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
		'<t underline="true">Брiфинг</t><br/><t size="1">Захистiть %1 вiд протилежної сторони.</t><br/><br/><t underline="true">Правила</t><t size="1"><br/>%3</t><br/><br/><t underline="true">Персонал</t><br/><t size="1">%4</t><br/><br/><t underline="true">Teamspeak</t><br/><t size="1">%2</t><br/><br/><t underline="true">Гарячi клавiшi</t><br/><t size="1">[Home] - Меню гравця<br/>[End] - Берушi<br/>[4] - Поставити зброю на запобiжник<br/>[L.Ctrl]+[Reload] - Перепакувати магазини<br/>[V] - Стрибнути (пiд час бiгу)<br/>[U] - Керування групами<br/>[Space] - Вiдркити/Закрити дверi<br/>[J]x2 - Завдання</t>',
		worldName,
		(missionNamespace getVariable ['QS_missionConfig_commTS','']),
		(missionNamespace getVariable ['QS_missionConfig_splash_serverRules','']),
		(missionNamespace getVariable ['QS_missionConfig_splash_adminNames',''])
	];
	_ctrlSText1 ctrlSetStructuredText _text;
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