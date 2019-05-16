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
	['QS_diary_hotkeys','Гарячi Клавiшi'],
	['QS_diary_rules','Правила'],
	['QS_diary_radio','Канали радiо'],
	['QS_diary_roles','Ролi'],
	['QS_diary_mods','Модифiкацiї'],
	['QS_diary_teamspeak','Зв́’язатись з нами'],
	['QS_diary_leaderboards','Дошка лiдерiв'],
	['QS_diary_gitmo','В’язниця'],
	['QS_diary_fobs','FOB-и (ПОБ-и)'],
	['QS_diary_revive','Оживлення'],
	['QS_diary_inventory','iнвентар']
];

/*/========== Create Diary Records/*/

if ((missionNamespace getVariable ['QS_missionConfig_aoType','']) isEqualTo 'GRID') then {
	_description = format ['Пiсля вiйни мiж NATO та CSAT що завершилась хитким перемир’ям, опортунiстичнi повстанцi, що спонсувались навколишнiми країнами, протистояли мiсцевiй мiлiцiї та заповнили вакуум, що втворився за вiдсутностi сили.<br/><br/>Вони дестабiлiзували регiон та погружують втягнути NATO та CSAT знову у вiдкрите протистояння на %1.<br/><br/>Використовуючи стару мережу тунелiв часiв вiйни, вони досi перешкоджають кволим спробам знищити повстанськi сили за допомогою дронiв.<br/><br/>В останнiй спробi знищити ворога NATO розгорнула пiдроздiли на мiсцях на %1.',worldName];
	player createDiaryRecord [
		'Diary',
		[
			(format ['%1 Кампанiя',worldName]),
			_description
		]
	];
};

/*/================================= RADIO CHANNELS/*/

player createDiaryRecord [
	'QS_diary_radio',
	[
		'Загальний канал',
		'Пiд’єднайтесь до Загального каналу для голосового звязку.<br/><br/>Передача музики та iнших набридливих звукiв не дозволяється на цьому каналi.<br/><br/>Звичайно ж, уснi образи не припустимi також.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канал Взводiв',
		'Приєднуйтесь до канал взводу (Альфа, Браво або Чарлi) для спiлкування в групi.<br/><br/>Одночасно можна пiд’єднуватись лише до одного каналу.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канали AO',
		'Якщо ви пiдписанi на цi канали - вас будете автоматично додано до них коли ви будете в радiусi 2км вiд Основної Зони операцiї, та в радiусi 1км вiд Другорядної Зони операцiї (Другорядна цiль). Коли ви залишете цi зони - ви бiльше не зможете спiлкуватись в цiх каналах.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Канал авiацiї',
		'Пiлоти та оператор БПЛА активнi на цьому каналi.<br/><br/>Тiльки пiлоти та Оператор БПЛА можуть спiлкуватись на цьому каналi.<br/><br/>Якщо ви не є пiлотом або оператором БПЛА, ви можете прослухати цей канал, якщо ви знаходитесь в баштi керування повiтряним рухом або ЦТО (маркер на картi).'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Додатковий канал',
		'Голосовий звязок вiдключений на додатковому каналi<br/><br/>Використовуйте Загальний канал для передачi голосу всiм гравцям на серверi.'
	]
];
player createDiaryRecord [
	'QS_diary_radio',
	[
		'Огляд',
		'Бета v0.9<br/><br/>Для використання в грi доступнi цiлий ряд користувацьких радiоканалiв.<br/><br/>Щоб зайти: натиснiть [Home] >> [Комунiкацiя] >> [Налаштування каналiв]<br/><br/>Для передачi голосових повiдомлень потрiбна рацiя..<br/><br/>Передача музики чи звуку дозволена лише в прямий канал i транспортний канал.<br/><br/>Спам, набридлива поведiнка призведе до адмiнiстративних дiй щодо порушника.'
	]
];

/*/================================= INVENTORY/*/

player createDiaryRecord [
	'QS_diary_inventory',
	[
		'Редагування iнвентарю',
		'Поблизу з Вантажною Зоною та Зоною Інвентаря на базi у вас з’явиться можливiсть редагувати спорядження в транспортi та в ящиках з амунiцiєю.'
	]
];

/*/================================= REVIVE/*/

player createDiaryRecord [
	'QS_diary_revive',
	[
		'Медичнi транспортнi засоби',
		'Щоб пiдняти солдата просто завантажте його в медичний транспорт (HEMTT медичний, Медичний модуль Taru i  т.i.)<br/><br/>Транспорт повинен мати потрiбну кiлькiсть квиткiв на вiдродження. Вiдродження гравцiв використовує квитки.<br/>Квитки на вiдродження можуть бути вiдновленi на Сервiсних маркерах на базi.<br/>Кiлькiсть квиткiв на вiдродження вiдповiдає кiлькостi мiсць в транспортi.'
	]
];

/*/================================= FOBs/*/

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Загальне',
		(format ['Forward Operating Bases (Передовi Оперативнi Бази - ПОБ) розкиданi по всьому %1.<br/><br/>Даякi послуги доступнi на цих ПОБах, а також вони є об’єктами пiдвищеного iнтересу супротивника.',worldName])
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Послуги радару',
		'Коли ПОБ активна та утримується вашими силами - ворожi карти та радари будуть для вас доступними.<br/><br/>Для взаємодiї з ПОБами всерединi головного будинку розмiщено ноутбуки.<br/>Коли певнi типи транспорту/ящикiв пiдпадають пiд радiус дiї ПОБа - вони можуть активувати певнi сервiси.<br/>'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Вiдродження',
		'Вiдродження на ПОБах можливе коли дотримуються певнi умови:<br/><br/>
		- ПОБ має працювати та утримуватися вашою фракцiєю<br/>
		- Ви повиннi активувати ваше персональне вiдродження на ПОБi. Це можна зробити з терминалу ПОБ в головнiй будiвлi<br/>
		- Ви не є пiлотом<br/>
		- На ПОБi є бiльше нiж 0 квиткiв на вiдродження<br/>
		- Ви не вiдроджувались там за останнi 3 хвилини'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Транспортнi послуги',
		'Декiлька транспортних послуг доступнi на ПОБах для повiтрянного та наземного транспорту:<br/><br/>
		- Вiдродження - Приведiть HEMTT Mover або HEMTT Box на ПОБ для активацiї послуги респавну транспорту (легка техніка)<br/>
		- Ремонт - Приведiть ремонтну вантажiвку або модуль на ПОБ для активацiї послуг ремонту<br/>
		- Заправка - Приведiть заправщик або модуль для активацiї послуг заправки<br/>
		- Спорядження - Приведiть вантажiвку зi спорядженням або модуль для активацiї послуги переспорядження<br/>
		'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Квитки вiдродження',
		'Приведiть Медичну машину або модуль на ПОБ для переспорядження його квитками вiдродження'
	]
];

player createDiaryRecord [
	'QS_diary_fobs',
	[
		'Модулi спорядження',
		'Завантажте модулi на базi потрiбними речами та транспортуйте його повiтрям або землею до ПОБ щоб переспорядити його модуль спорядження'
	]
];

/*/================================= Leaderboards/*/

player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'В’язниця',
		'Отримуйте бали за розмiщення ворогiв у в’язницi.<br/><br/>Мультиплеєри: n/a<br/><br/>В’зницю позначено на ваших мапах на базi. Дивiться детальну iнформацiю в щоденнику'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Рейнжер веж',
		'Отримуйте бали за знищення радiовеж (не доступно для пiлотiв).<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Золотошукачi',
		'Отримуйте бали за збирання людських частин (золотi зуби) з вбитих ворогiв (дуже сире).<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Вухорiзи',
		'Отримуйте бали за збирання людських частин (вуха) з вбитих ворогiв.<br/><br/>Мультиплеєри: n/a'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Оживлювач',
		'Отримуйте бали як Медик за оживлення поранених товаришiв.<br/><br/>Мультиплеєри Топ 3 медика тижня (закiнчується в Недiлю о 23:59) додаються до бiлого списку слотiв медика на наступний тиждень. (Тимчасово не працює)'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Транспортер',
		'Отримуйте бали за безпечне транспортування солдатiв з/на базу гелiкоптерами.<br/><br/>Мультиплеєри: Розширена модель пiлотування<br/><br/>Топ 3 пiлоти тижня (закiнчується в Недiлю о 23:59) додаються до бiлого списку слотiв пiлотiв на наступний тиждень (Тимчасово не працює).<br/><br/>Транспортування на пiдвiсi не пiдтримується наразi.<br/>Повантаження транспорту не пiдтримується наразi.'
	]
];
player createDiaryRecord [
	'QS_diary_leaderboards',
	[
		'Загальна iнформацiя',
		format ['<t size="2">Version 1.0</t><br/><br/>Таблиця рахунку скидається кожного Понедiлка о 00:01.<br/><br/>Please report bugs and weird shit on the forums or to Quiksilver on TS.<br/><br/>To maintain performance and FPS, the leaderboards are synchronized every 5-10 minutes instead of continuously, and saved to database every 10-15 minutes. For this reason, points accumulated just prior to server restart may not be saved (*sadface*). Since it is new, we are experimenting with the best and most performance-friendly methods.<br/><br/>Thanks for your patience, %1!',profileName]
	]
];

/*/-------------------------------------------------- Rules/*/

player createDiaryRecord [
	'QS_diary_hotkeys',
	[
		'Гарячi Клавiшi',
		(format ['
		<br/>Меню гравця - [Home]
		<br/>Берушi - [End]
		<br/>Сховати зброю за спину - [4]
		<br/>Перепакувати магазини - [L.Ctrl]+[%2]
		<br/>Стрибнути - [%5] пiд час бiгу
		<br/>Менеджер груп - [%6]
		<br/>Завдання - [%3]
		<br/>Пiдказки - [%4]
		<br/>Жести - [Ctrl]+[Numpad x]
		<br/>Тактичний пiнг - %1
		<br/>Вiдкрити або закрити дверi - [Space]
		',(actionKeysNames 'TacticalPing'),(actionKeysNames 'ReloadMagazine'),(actionKeysNames 'Diary'),(actionKeysNames 'Help'),(actionKeysNames 'GetOver'),(actionKeysNames 'Teamswitch')])
	]
];

if ((getPlayerUID player) in (['ALL'] call (missionNamespace getVariable 'QS_fnc_whitelist'))) then {
	player createDiaryRecord [
		'QS_diary_hotkeys',
		[
			'Клавiшi для персоналу',
			'
			<br/>Вiдкрити меню персонала - [Shift]+[F2]
			<br/>Закрити меню персонала - [Shift]+[F2]
			<br/>Вийти з режиму спостереження - [Shift]+[F2]
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
		'Загальне',
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

/*/ Enable or change this if you like/*/
player createDiaryRecord [
	'QS_diary_rules',
	[
		'Зв’язок',
		'
		<br />1. Спам в радіоканалах не допустимий
		<br />2. Ворожнеча в радіоканалах не допустима
		<br />3. Стрільба/Крики в радіоканалах не допустимі.
		<br />4. Розмова у каналах Global або Side може призвести до кіку, при повторному порушенні - може призвести до бану (Ми ще у роздумах...).
		<br />5. Розмова у каналі Side лагуча тож ніхто вас на зможе нормально розуміти. Краще пишіть в цьому каналі. Для розмови використовуйте канал Group, а ще краще - приєднуйтесь до нас у Discord
		<br />6. Набридливий спам з використанням мікрофону призведе до кіку, за повторне порушення можна зловити бан
		'
	]
];


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
		'Захоплення ворогiв',
		'Є можливiсть брати ворогiв у полон!<br/><br/>Щоб захопити ворожого солдата ви маєти пiдiйти до нього на вiдстань до 5 метрiв та виконати взаємодiю з ним. У вас повинна з’явитись Команда Капiтуляцiї в скролл-меню. Щоб отримати повну винагороду - вiдконвоюйте полоненого до в’язницi на базi. Щоб ув’язнити полоненого у в’язницi - зайдiть з ним на огороджену територiю в’язницi та Вiдпустiть полоненого не залишаючи цю територi.<br/><br/>Гарного полювання!'
	]
];

/*/-------------------------------------------------- Teamspeak/*/

player createDiaryRecord [
	'QS_diary_teamspeak',
	[
		'TeamSpeak Сервер',
		format ['
		<br/> Адреса: %1
		<br/>
		<br/> Завжди радi новим обличчам (голосам :) )!
		',(missionNamespace getVariable ['QS_missionConfig_commTS',''])]
	]
];

player createDiaryRecord [
	'QS_diary_teamspeak',
	[
		'Discord Сервер',
		format ['
		<br/> Адреса: %1
		',(missionNamespace getVariable ['QS_missionConfig_commDiscord',''])]
	]
];

/*/-------------------------------------------------- Credits/*/
player createDiarySubject ['QS_diary_credits','Credits'];				// EULA relevant line.

////////////////////////////////// EDIT BELOW ///////////////////////////////////////

player createDiaryRecord [
	'QS_diary_credits',
	[
		'Редактори',
		'Prioric, varrkan_ua'
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
