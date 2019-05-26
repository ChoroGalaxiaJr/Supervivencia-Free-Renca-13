var/list/mobs = list()

/mob
	var/health = 100


	var/last_move_delay = 0
	var/move_delay = 1

	plane = OBJECTS_PLANE


	proc
		TakeDamage(dmg)
			health -= dmg