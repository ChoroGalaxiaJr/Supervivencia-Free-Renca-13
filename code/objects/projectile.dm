/projectile
	parent_type = /obj
	var/x_spd = 0
	var/y_spd = 0
	var/damage = 5
	var/owner

	density = 0
	New()
		..()
		processing_objects += src
	Del()
		processing_objects -= src
		..()

	Process()
		if(!PixelMove(x_spd,y_spd))
			del src

		for(var/atom/i in obounds(src))
			Bump(i)

	Bump(atom/Obstacle)
		if(istype(Obstacle,/mob) && Obstacle != owner)
			Obstacle:TakeDamage(damage)
			del src
		else
			if(istype(Obstacle, /turf) && Obstacle.density)
				del src


	plasma
		icon = 'icons/projectiles/projectile.dmi'
		icon_state = "plasma"
		bound_width = 16
		bound_height = 16