/mob/boss/nigga_helicopter
	icon = 'icons/mob/nigga_helicopter.dmi'
	var/x_spd = 0
	var/y_spd = 0
	var/z_spd = 0
	var/z_pos = 0

	New()
		..()
		spawn(20)

			next_track = 'sounds/music/orange.ogg'
			sleep(10)
			world << 'sounds/fx/alarm.ogg'
			world << "<b><font color='red'><font size=6>le helicopter alert"
			processing_objects += src


	Del()
		processing_objects -= src
		..()
	Process()
		..()
		density = 0

		PixelMove(x_spd,0)
		PixelMove(0,y_spd)

		update_shadow(127)


		z_spd = (200+(sin(global_frame_counter)*20)-z_pos)/50


		if((global_frame_counter % 30) == 0)
			var/obj/bomb/new_b = new(loc)
			new_b.step_x = step_x + 16
			new_b.step_y = step_y + 16
			var/ang = rand(0,360)
			new_b.x_spd = cos(ang)*2
			new_b.y_spd = sin(ang)*2
			new_b.z_pos = z_pos
		/*

			player searching momentum
		*/
		var/mob/player/locked = null
		for(var/mob/player/d in ohearers(40,src))
			locked = d
			break
		if(locked)
			//x_spd
			if(Get_Position_X() < locked.Get_Position_X())
				x_spd += 0.01
			else
				x_spd -= 0.01

			if(Get_Position_Y() < locked.Get_Position_Y())
				y_spd += 0.01
			else
				y_spd -= 0.01

		//world << z_pos

		z_pos += z_spd
		pixel_z = z_pos

		var/matrix/M = matrix()
		M.Turn(x_spd*10)
		transform = M
		shadow.transform = M


