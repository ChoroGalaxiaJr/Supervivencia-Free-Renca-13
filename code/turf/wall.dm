/turf/wall
	icon = 'icons/turf/concrete.dmi'
	icon_state = "0,0"
	density = 1
	opacity = 1

	plane = WALL_PLANE

	New()
		..()
		icon_state = "[x % 16],[y % 16]"

/turf/autosmoothed_wall
	icon = 'icons/turf/wall.dmi'
	icon_state = "0"
	density = 1
	opacity = 1
	New()
		..()
		spawn(1)
			var/d = 0
			for(var/turf/i in range(1, src))
				if(get_dir(src,i) in list(NORTH,SOUTH,EAST,WEST))
					if(istype(i, type))
						d += get_dir(src,i)
			icon_state = "[d]"