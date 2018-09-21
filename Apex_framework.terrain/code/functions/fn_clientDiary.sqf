/*/
File: fn_clientDiary.sqf
Author:

	Quiksilver

Last Modified:

	6/12/2017 A3 1.78 by Quiksilver

Description:

	-

License Notes:

	Part of the EULA for this framework is to ensure this file executes as normal.

__________________________________________________________/*/

/*/========== Create Diary Subjects (this is the order they appear in the map tabs)/*/

{
	player createDiarySubject _x;
} forEach [
	['QS_diary_hotkeys','Key Bindings'],
	['QS_diary_rules','Rules'],
	['QS_diary_radio','Radio Channels'],
	['QS_diary_roles','Roles'],
	['QS_diary_mods','Mods'],
	['QS_diary_teamspeak','Teamspeak'],
	['QS_diary_leaderboards','Leaderboards'],
	['QS_diary_gitmo','Gitmo'],
	['QS_diary_fobs','FOBs'],
	['QS_diary_revive','Revive'],
	['QS_diary_inventory','Inventory']
];

/*/========== Create Diary Records/*/

if ((missionNamespace getVariable ['QS_missionConfig_aoType','']) isEqualTo 'GRID') then {
	_description = format ['After the war between NATO and CSAT ended in an uneasy truce, an opportunistic insurgency sponsored by surrounding nations crushed local militias and moved in to fill the power vacuum.<br/><br/>They have been destabilizing the region and threatening to pull NATO and CSAT back into open conflict on %1.<br/><br/>Moving around using an old wartime tunnel network, they have thus far thwarted low-cost attempts to destroy the insurgency with drone warfare.<br/><br/>In a last ditch effort, NATO has deployed boots on the ground to root out the determined enemy and bring peace to %1.',worldName];
	player createDiaryRecord [
		'Diary',
		[
			(format ['%1 Campaign',worldName]),
			_description
		]
	];
};

/*/================================= RADIO CHANNELS/*/

player createDiaryRecord [
	'QS_diary_radio',
	[
		'Загальний канал',
		'Підключіться до Загального каналу для голосового звязку.<br/><br/>Передача музики та інших неголосних звуків не дозволяється на цьому каналі.<br/><br/>.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канал Взводів',
		'Приєднуйтесь до канал взводу (Альфа, Браво або Чарлі) для спілкування в групі.<br/><br/>Одночасно можна підключитись лише до одного каналу.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канали AO',
		'If you are subscribed to these channels, you will automatically be added to these channels when within 2km of the Primary AO, and 1km of the Secondary AO (side mission). When you leave this area, you will no longer be able to receive or transmit on it.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канал авіації',
		'Пілоти та оператор БПЛА активні на цьому каналі.<br/><br/>Тільки пілоти та Оператор БПЛА можуть спілкуватись на цьому каналі.<br/><br/>Якщо ви не є пілотом або оператором БПЛА, ви можете прослухати цей канал, якщо ви знаходитесь в башті керування повітряним рухом або ЦТО (маркер на карті).'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Додатковий канал',
		'Голосовий звязок відключений на додатковому каналі<br/><br/>Використовуйте Загальний канал для передачі голосу всім гравцям на сервері.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Огляд',
		'Бета v0.9<br/><br/>Для використання в грі доступні цілий ряд користувацьких радіоканалів.<br/><br/>Щоб зайти: натисніть [Home] >> [Comm-Link] >> [Radio Management]<br/><br/>Для передачі голосових повідомлень потрібна рація..<br/><br/>Передача музики чи звуку дозволена лише в прямий канал і транспортний канал.<br/><br/>Спам набридлива поведінка призведе до адміністративних дій щодо порушника.'
	]
];

/*/================================= INVENTORY/*/

player createDiaryRecord [
	'QS_diary_inventory',
	[
		'Редагування інвентарю',
		'Near the Crate Area and Inventory markers at base, you are able to easily customize the inventory of vehicles and ammo crates'
	]
];

/*/================================= REVIVE/*/

player createDiaryRecord [
	'QS_diary_revive',
	[
		'Медичні транспортні засоби',
		'Щоб підняти солдата просто завантажте його в медичний транспорт (HEMTT медичний, Медичний модуль Taru і  т.і.)<br/><br/>Транспорт повинен мати потрібну кількість квитків на відродженняВідродження гравців використовує квитки.<br/>Квитки на відродження пожуть бути відновлені на Сервісних маркерах на базі.<br/>Кількість квитків на відродження відповідає кількості місць в транспорті.'
	]
];

/*/================================= FOBs/*/

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Загальне',
		(format ['Forward Operating Bases (Передові Оперативні Бази - ПОБ) розкидані навкруги %1.<br/><br/>Даякі послуги доступні на цих ПОБах, а також вони є об’єктами підвищеного інтересу супротивника.',worldName])
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Послуги радару',
		'Коли ПОБ активний та утримується вашими силами - ворожі карти та радари будуть для вас доступними.<br/><br/>Для взаємодії з ПОБами всередині головного будинку розміщено ноутбуки.<br/>Коли певні типи транспорту/ящиків підпадають під радіус дії ПОБа вони можуть активувати певні сервіси.<br/>'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Відродження',
		'Відродження на ПОБах можливе коли дотримуються певні умови:<br/><br/>
		- ПОБ має працювати та утримуватися вашою фракцією<br/>
		- Ви повинні активувати ваше персональне відродження на ПОБі. Це можна зробити з терминалу ПОБ в головній будівлі<br/>
		- Ви не є пілотом<br/>
		- На ПОБі є більше ніж 0 квитків на відродження<br/>
		- Ви не відроджувались там за останні 3 хвилини'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Транспортні послуги',
		'Декілька транспортних послуг доступні на ПОБах для повітрянного та наземного транспорту:<br/><br/>
		- Відродження - Приведіть HEMTT Mover або HEMTT Box на ПОБ для активації послуги респавну транспорту<br/>
		- Ремонт - Приведіть ремонтну вантажівку або модуль на ПОБ для активації послуг ремонту<br/>
		- Заправка - Приведіть заправщик або модуль для активації послуг заправки<br/>
		- Спорядження - Приведіть вантажівку зі спорядженням або модуль для активації послуги переспорядження<br/>
		'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Квитки відродження',
		'Приведіть Медичну машину або модуль на ПОБ для переспорядження його квитками відродження'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Модулі спорядження',
		'Завантажте модулі на базі потрібними речами та транспортуйте його повітрям або землею до ПОБ щоб переспорядити його модуль спорядження'
	]
];

/*/================================= Leaderboards/*/

player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Gitmo',
		'Отримуйте бали за розміщення ворогів у в’язниці.<br/><br/>Мультиплеєри: n/a<br/><br/>В’зницю позначено на ваших мапах на базі. Дивіться детальну інформацію в щоденнику'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Tower Rangers',
		'Отримуйте бали за знищення радіовеж (не доступно для пілотів).<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Gold Diggers',
		'Отримуйте бали за збирання людських частин (золоті зуби) з вбитих ворогів (дуже сире).<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Ear Slicers',
		'Отримуйте бали за збирання людських частин (вуха) з вбитих ворогів.<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Revivalists',
		'Отримуйте бали як Медик за оживлення поранених товаришів.<br/><br/>МультиплеєриТоп 3 медика тижня (закінчується в Неділю о 23:59) додаються до білого списку слотів медика на наступний тиждень.'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Transporters',
		'Отримуйте бали за безпечне транспортування солдатів з/на базу гелікоптерами.<br/><br/>Мультиплеєри: Розширена модель пілотування<br/><br/>Топ 3 пілоти тижня (закінчується в Неділю о 23:59) додаються до білого списку слотів пілотів на наступний тиждень.<br/><br/>Транспортування на підвісі не підтримується наразі.<br/>Повантаження транспорту не підтримується наразі.'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Загальна інформація',
		format ['<t size="2">Version 1.0</t><br/><br/>Таблиця рахунку скидається кожного Понеділка о 00:01.<br/><br/>Please report bugs and weird shit on the forums or to Quiksilver on TS.<br/><br/>To maintain performance and FPS, the leaderboards are synchronized every 5-10 minutes instead of continuously, and saved to database every 10-15 minutes. For this reason, points accumulated just prior to server restart may not be saved (*sadface*). Since it is new, we are experimenting with the best and most performance-friendly methods.<br/><br/>Thanks for your patience, %1!',profileName]
	]
];

/*/-------------------------------------------------- Rules/*/

player createDiaryRecord [
	'QS_diary_hotkeys',
	[
		'Key Bindings',
		(format ['
		<br/>Client Menu - [Home]
		<br/>Earplugs - [End]
		<br/>Holster Weapon - [4]
		<br/>Magazine Repack - [L.Ctrl]+[%2]
		<br/>Jump - [%5] while running
		<br/>Group Manager - [%6]
		<br/>Tasks - [%3]
		<br/>Hints - [%4]
		<br/>Gestures - [Ctrl]+[Numpad x]
		<br/>Tactical Ping - %1
		<br/>Open and close doors - [Space]
		',(actionKeysNames 'TacticalPing'),(actionKeysNames 'ReloadMagazine'),(actionKeysNames 'Diary'),(actionKeysNames 'Help'),(actionKeysNames 'GetOver'),(actionKeysNames 'Teamswitch')])
	]
];

if ((getPlayerUID player) in (['ALL'] call (missionNamespace getVariable 'QS_fnc_whitelist'))) then {
	player createDiaryRecord [
		'QS_diary_hotkeys',
		[
			'Staff Bindings',
			'
			<br/>Staff Menu Open - [Shift]+[F2]
			<br/>Staff Menu Close - [Shift]+[F2]
			<br/>Exit Spectate - [Shift]+[F2]
			'
		]
	];
	if ((getPlayerUID player) in (['CURATOR'] call (missionNamespace getVariable 'QS_fnc_whitelist'))) then {
		player createDiaryRecord [
			'QS_diary_hotkeys',
			[
				'Curator (Zeus) Bindings',
				'
				<br/>Sync Editable Objects - [Shift]+[F3]
				<br/>(Selected Group) Garrison in Buildings - [Numpad 1]
				<br/>(Selected Group) Patrol Area - [Numpad 2]
				<br/>(Selected Group) Search Building - [Numpad 3]
				<br/>(Selected Group) Stalk Target - [Numpad 4]
				<br/>(Selected Group) Suppressive Fire - [Numpad 6]
				<br/>(Selected Unit) Revive Player - [Numpad 7]
				<br/>(All Players) View Directions - [Numpad 8]
				<br/>(Selected Unit) Set unit Unconscious - [Numpad 9]
				'
			]
		];
	};
};

/*/ Enable or change this if you like
player createDiaryRecord [
	'QS_diary_rules',
	[
		'Enforcement',
		'
		<br />The purpose of the above rules are to ensure a fun and relaxing environment for public players.
		<br />
		<br />Server rules are in place merely as a means to that end.
		<br />
		<br />Guideline for enforcement:
		<br />
		<br />-	Innocent rule violation and disruptive behavior:
		<br />
		<br />		= Verbal / Written request to cease, or warning.
		<br />
		<br />-	Minor or first-time rule violation:
		<br />
		<br />		= Kick, or 0 - 3 day ban.
		<br />
		<br />-	Serious or repetitive rule violation:
		<br />
		<br />		= 3 - 7 day ban.
		<br />
		<br />-	Administrative ban (hack/exploit/verbal abuse/serious offense):
		<br />
		<br />		= permanent or 30 day.
		<br />
		<br />
		<br />The above is subject to discretion.
		'
	]
];
/*/

player createDiaryRecord [
	'QS_diary_rules',
	[
		'General',
		(missionNamespace getVariable ['QS_missionConfig_splash_serverRules',''])
	]
];
/*/ Enable or change this if you like
player createDiaryRecord [
	'QS_diary_rules',
	[
		'Aviation',
		"
		<br /> Pilots have their own specialized roles, therefore they come with additional responsibilities. If you have any issues with any pilot, please report the player to an admin or moderator.
		<br />
		<br />1. You MUST be on our Teamspeak server--in the correct channel--and communicable. Exception if TS is down or full.
		<br />
		<br />2. You MUST be a pilot to fly an aircraft.
		<br />	If you are a non-pilot and there are less than 20 players on the server, then you may fly a hummingbird in copilot.
		<br />	If there are over 20 players, you may fly a hummingbird to a side mission ONLY.
		<br />
		<br />3. Pilots must not play infantry while in a pilot slot.
		<br />
		<br />4a. If you are an inexperienced pilot, please consider the time and enjoyment of others. The editor is there for a reason.
		<br />
		<br />4b. This is a public server. Helicopters are not private/reserved transport. A Pilots primary role is to provide timely general transport to and from objectives.
		<br />
		<br />-		* General transport in this context is defined as: Indiscriminate and timely transport for each and all players on the server.
		<br />
		<br />5. You must be able to fly AND LAND any aircraft with reasonable competence, if you do not have experience in any aircraft, you may be asked to leave the role.
		<br />
		<br />6. Landing or slinging objects/vehicles inside of infantry spawn may result in a warning or a kick for first offense.
		<br />
		<br />7. Ramming enemy or intentional crashing may result in a ban without warning, try to preserve assets.
		<br />
		<br />The above rules are subject to discretion of moderators and administrators.
		<br />
		<br />If you see a player in violation of the above, contact a moderator or admin (teamspeak).
		"
	]
];
/*/
/*/ Enable or change this if you like
player createDiaryRecord [
	'QS_diary_rules',
	[
		'Close Air Support',
		"
		<br/>0. CAS must be called in by ground elements (infantry who are near the target).
		<br/><br/>1. CAS call-ins must be typed into Side Channel with a specific position or target, no exceptions.
		<br/><br/>2. CAS may freely engage these targets without ground coordination: Fixed-wing Aircraft.
		<br/><br/>3. Do not engage any objectives and/or enemies without being called in on that specific target (See rule 1).
		<br/><br/>4. Do not ram targets and/or objectives.
		<br/><br/>5. Do not fly near (1km) marked objectives unless necessary to complete a mission.
		<br/><br/>6. Must be on Teamspeak, in Pilot channel and communicable.
		<br/><br/><br/>Failure to comply may result in administrative action without warning, up to and including permanent removal from CAS whitelist.
		"
	]
];
/*/
/*/ Enable or change this if you like
player createDiaryRecord [
	'QS_diary_rules',
	[
		'Comms',
		'
		<br />1. Spamming comms will not be tolerated
		<br />2. Arguing on comms will not be tolerated
		<br />3. Shouting/Screaming on comms will not be tolerated. (This includes telling a pilot they suck and can not fly to save their own life)
		<br />4. Speaking on Global or Side will result in a kick, and if done again a ban will be issued.
		<br />5. Speaking over side is laggy and no-one can understand you. Type on side. Talk in Group or better join us on TS
		<br />6. Excessive mic spam will result in a kick, if done again a ban will be issued
		'
	]
];
/*/

/*/-------------------------------------------------- Mods/*/

/*/ Enable or change this if you like
player createDiaryRecord [
	'QS_diary_mods',
	[
	'Mods Allowed',
	'
	<br /> Mods currently allowed (subject to change without notice):<br /><br />

	<br/>- JSRS soundmod (Steam Workshop): Audio effects mod
	<br/>- Blastcore standalone (Steam Workshop): Visual effects mod
	'
	]
];
/*/

player createDiaryRecord [
	'QS_diary_gitmo',
	[
		'Захоплення ворогів',
		'Є можливість брати ворогів у полон!<br/><br/>Щоб захопити ворожого солдата ви маєти підійти до нього на відстань до 5 метрів та виконати взаємодію з ним. У вас повинна з’явитись Команда капітуляції в скролл-меню. Щоб отримати повну винагороду - відконвоюйте полоненого до в’язниці на базі. Щоб ув’язнити полоненого у в’язниці - підійдіть з ним до телефонної будки, подивіться на телефонну будку близько 3-5 секунд та Відпустіть полоненого не відвертаючи увагу від будки.<br/><br/>Гарного полювання!'
	]
];

/*/-------------------------------------------------- Teamspeak/*/

player createDiaryRecord [
	'QS_diary_teamspeak',
	[
		'TS3 Server',
		format ['
		<br/> Address: %1
		<br/>
		<br/> Visitors and guests welcome!
		',(missionNamespace getVariable ['QS_missionConfig_commTS',''])]
	]
];

/*/-------------------------------------------------- Credits/*/
player createDiarySubject ['QS_diary_credits','Credits'];				// EULA relevant line.

////////////////////////////////// EDIT BELOW ///////////////////////////////////////

player createDiaryRecord [
	'QS_diary_credits',
	[
		'Community Editors',
		'Prioric, LordShade, varrkan_ua'
	]
];

////////////////////////////////// EDIT ABOVE ///////////////////////////////////////

////////////////////////////////// DO NOT EDIT BELOW ///////////////////////////////////////
/*/
Please do not tamper with the below lines.
Part of license for use of this framework is to maintain accessibility for players to donate to the Apex Framework developer.
Servers which have made it difficult or impossible for players to access this link are in violation of the EULA.
/*/
player createDiaryRecord [
	'QS_diary_credits',
	[
		"Developer",
		"<br/><br/><font size='20'>Quiksilver</font><br/><br/>This framework is the product of many thousands of hours of doing battle in notepad++ over a number of years (2013-2017). We sincerely hope you enjoy your experience!<br/><br/>If you would like to show your appreciation but do not know how, you can<br/><br/><executeClose expression=""createDialog 'QS_RD_client_dialog_menu_hub';"">Donate to Quiksilver (Patreon)</executeClose><br/><br/>Stay safe out there, soldier!"
	]
];
