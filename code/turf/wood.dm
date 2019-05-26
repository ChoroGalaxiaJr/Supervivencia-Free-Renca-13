/turf/wood
	icon = 'icons/turf/wood.dmi'
	icon_state = "0,0"
	New()
		..()
		icon_state = "[x % 16],[y % 16]"