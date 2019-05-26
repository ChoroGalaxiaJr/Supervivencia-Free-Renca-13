/turf/rock
	icon = 'icons/turf/cave.dmi'
	icon_state = "0,0"
	density = 1
	opacity = 1
	normal_r = 210
	normal_g = 105
	normal_b = 30
	New()
		..()
		icon_state = "[x % 8],[y % 8]"