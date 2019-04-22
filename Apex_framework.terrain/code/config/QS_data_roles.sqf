/*/
File: QS_data_roles.sqf
Author:

	Quiksilver
	
Last modified:

	13/10/2018 A3 1.84 by Quiksilver
	
Description:

	Role Assignment Data
	
Roles:


	[
		<role>,
		<minimum unlocked>
		<max number in role>,
		<per X number of players another slot will open, up to the max>
	]
		
	
__________________________________________________________________________/*/

private _return = [];
if (worldName isEqualTo 'Altis') exitWith {
	[
		[
			'soldier',				// Role
			'Стрілок',				// Role Title
			-1,						// Minimum slots unlocked
			-1,						// Max number in role
			-1,
			0						// per X number of players another slot will open, up to the max
		],
		[
			'medic',
			'Медик',
			4,
			10,
			6
		],
		[
			'autorifleman',
			'Кулеметник',
			4,
			10,
			6,
			0
		],
		[
			'machine_gunner',
			'Важкий кулеметник',
			4,
			10,
			6,
			0
		],
		[
			'engineer',
			'Інженер',
			4,
			10,
			6,
			0
		],
		[
			'sniper',
			'Снайпер',
			1,
			2,
			12,
			0
		],
		[
			'pilot_heli',
			'Пілот вертольоту',
			3,
			5,
			12
		],
		[
			'pilot_plane',
			'Пілот літака',
			1,
			1,
			-1,
			0
		],
		[
			'uav',
			'Оператор БПЛА',
			1,
			1,
			-1,
			0
		],
		[
			'mortar',
			'Mortar Gunner',
			1,
			1,
			-1,
			0
		],
		[
			'jtac',
			'JTAC',
			1,
			1,
			-1,
			0
		],
		[
			'squad_leader',
			'Squad Leader',
			2,
			6,
			10,
			0
		],
		[
			'commander',
			'Commander',
			1,
			1,
		-1,
		0
		]
	]
};