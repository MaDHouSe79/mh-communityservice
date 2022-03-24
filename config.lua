Config = {}

-- # By how many services a player's community service gets extended if he tries to escape
Config.ServiceExtensionOnEscape = 8
-- # Don't change this unless you know what you are doing.
Config.ServiceLocation = {x =  170.43, y = -990.7, z = 30.09}
-- # Don't change this unless you know what you are doing.
Config.ReleaseLocation = {x = 427.33, y = -979.51, z = 30.2}

Config.Command = {
	start      = "comserv",
	ending     = "endcomserv",
}
-- # Don't change this unless you know what you are doing.
Config.ServiceLocations = {
	{ type = "cleaning", coords = vector3(170.0, -1006.0, 29.34) },
	{ type = "cleaning", coords = vector3(177.0, -1007.94, 29.33) },
	{ type = "cleaning", coords = vector3(181.58, -1009.46, 29.34) },
	{ type = "cleaning", coords = vector3(189.33, -1009.48, 29.34) },
	{ type = "cleaning", coords = vector3(195.31, -1016.0, 29.34) },
	{ type = "cleaning", coords = vector3(169.97, -1001.29, 29.34) },
	{ type = "cleaning", coords = vector3(164.74, -1008.0, 29.43) },
	{ type = "cleaning", coords = vector3(163.28, -1000.55, 29.35) },

	{ type = "gardening", coords = vector3(193.64, -1007.39, 29.52) },
	{ type = "gardening", coords = vector3(173.4, -1000.48, 29.52) },
	{ type = "gardening", coords = vector3(159.93, -983.46, 30.6) },
	{ type = "gardening", coords = vector3(169.81, -981.63, 30.6) },
	{ type = "gardening", coords = vector3(179.03, -996.96, 30.69) },
	{ type = "gardening", coords = vector3(182.76, -1000.0, 30.69) },
	{ type = "gardening", coords = vector3(208.51, -1010.5, 29.52) },
	{ type = "gardening", coords = vector3(197.62, -1009.44, 29.52) },
}



Config.Uniforms = {
	['male'] = {
		outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 345, texture = 0},
			['arms']    = {item = 119, texture = 0},
			['pants']   = {item = 8, texture = 4},
			['shoes']   = {item = 12, texture = 2},
		}
	},
	['female'] = {
	 	outfitData = {
			['t-shirt'] = {item = 15, texture = 0},
			['torso2']  = {item = 345, texture = 0},
			['arms']    = {item = 119, texture = 0},
			['pants']   = {item = 8, texture = 4},
			['shoes']   = {item = 12, texture = 2},
	 	}
	},
}
