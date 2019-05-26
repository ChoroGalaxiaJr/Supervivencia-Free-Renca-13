/fx/explosion
	icon = 'icons/fx/explosion.dmi'
	var/ang_offset = 0
	var/ang_range = 0

	New(loc, var/ang_new, var/rang_new, var/px, var/py)
		..()
		ang_offset = ang_new
		ang_range = rang_new

		if(ang_range == 0)
			PlaySound(loc,"sounds/fx/explosion_g.ogg",20)
			for(var/mob/i in loc)
				i.TakeDamage(1)
			for(var/i in 0 to 3)
				new /fx/explosion(loc, i*90, 16+(i % 2)*8, 0, 0)
			del src
		else
			pixel_z = py
			pixel_w = px
			processing_objects += src
			icon_state = "boom"
			spawn(6)
				processing_objects -= src
				del src
	Process()
		if(src)
			pixel_x = cos(ang_offset + global_frame_counter*22)*ang_range
			pixel_y = sin(ang_offset + global_frame_counter*22)*ang_range