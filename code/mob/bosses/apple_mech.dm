/mob/boss/apple_mech
	icon = 'icons/mob/apple_mech.dmi'

	var/x_spd = 0
	var/y_spd = 0
	var/z_spd = 0
	var/z_pos = 0
	var/scale = 1
	var/can = 0
	var/time_until_change = 200
	layer = 3
	bound_width = 64
	bound_height = 64
	health = 30
	New()
		..()
		pixel_z = 1000
		spawn(10)
			animate(src,pixel_z = 0, time = 20)
			sleep(20)
			PlaySound(loc,'sounds/fx/explosion_g.ogg',20)
			world << 'sounds/fx/iphone.ogg'

			next_track = 'sounds/music/4.ogg'
			sleep(10)
			world << 'sounds/fx/alarm.ogg'
			world << "<b><font color='red'><font size=6>ALERT!!! APPLE MECH HAS ARRIVED AND WILL KILL U ALL"
			sleep(20)
			can = 1

	Del()
		processing_objects -= src
		..()

	proc
		//jump

		phase_1()
			health -= 1
			z_spd = 10
			time_until_change = 200
			z_pos += 1
			while(z_pos != 0)
				sleep(world.tick_lag)
			PlaySound(loc,'sounds/fx/exp.ogg',9999)
			for(var/i in 1 to 12)
				var/projectile/plasma/p = new(loc)
				p.owner = src
				p.step_x = step_x
				p.step_y = step_y
				p.x_spd = cos(i*30)*1
				p.y_spd = sin(i*30)*1
			PlaySound(loc,'sounds/fx/projectile.ogg',30)

		//fire cannons
		phase_2()
			health -= 1
			spawn()
				for(var/i = 0, i < 5, i++)

					icon_state = "shoot"
					sleep(4)
					for(var/e = 0, e < 5, e++)
						sleep(0.5)
						var/obj/bomb/new_b = new(loc)
						new_b.step_x = step_x + 16
						new_b.step_y = step_y + 16
						var/ang = rand(0,360)
						var/dist = rand(20,200)
						new_b.x_spd = cos(ang)*(dist/20)
						new_b.y_spd = sin(ang)*(dist/20)
					sleep(3)
					icon_state = ""

			time_until_change = 400
		//slide
		phase_3()
			health -= 1
			var/mob/b = null
			for(var/mob/i in ohearers(src,15))
				b = i
				break

			if(b)
				PlaySound(loc,'sounds/fx/slide.ogg',30)


				var/ang = atan2(b.Get_Position_X()-Get_Position_X(),b.Get_Position_Y()-Get_Position_Y())
				x_spd = cos(ang)*10
				y_spd = sin(ang)*10
				spawn(10)
					x_spd = 0
					y_spd = 0
			time_until_change = 80
		//plasma
		phase_4()
			health -= 1
			PlaySound(loc,'sounds/fx/projectile.ogg',30)
			for(var/i in 1 to 24)
				var/projectile/plasma/p = new(loc)
				p.owner = src
				p.step_x = step_x
				p.step_y = step_y
				p.x_spd = cos(i*15)*1
				p.y_spd = sin(i*15)*1
			time_until_change = 100

	Process()
		..()
		update_shadow(127)
		if(!can)
			return
		if(health <= 0)
			next_track = "silence"
			if(health > -50)
				if(!(global_frame_counter % 20))
					spawn()
						var/p_off = rand(-40,40)+32
						var/p_off_2 = rand(-40,40)+32
						for(var/i in 0 to 3)
							new /fx/explosion(loc, i*90, 16+(i % 2)*8, p_off, p_off_2)
						PlaySound(loc,'sounds/fx/exp.ogg',20)
					health -= 3
					if(health < -49)
						PlaySound(loc,'sounds/fx/exp.ogg',9999)
						PlaySound(loc,'sounds/fx/boss_death.ogg',9999)

			else
				pixel_y += 20
				if(pixel_y > 1000)
					del src
			return





		if(time_until_change > 0)
			time_until_change -= 1
		else
			spawn()
				call(src,"phase_[rand(1,4)]")()

		if(health <= 0)
			master.do_processing = 0
			world << sound(null)
			world << 'sounds/music/clear.ogg'
			world << "<font size =6><font color='green'>APPLE MECH HAS BEEN OWNED!!!!!!"
			sleep(90)
			master.do_processing = 1
			return

		z_pos += z_spd
		if(z_pos < 0 && z_spd != 0)
			z_pos = 0
			z_spd = 0
		else
			z_spd -= 96/256
		pixel_y = z_pos

		PixelMove(x_spd,y_spd)




		if((x_spd != 0) || (y_spd != 0))

			if(x_spd > 0)
				scale = -1
			else
				scale = 1

			if(!(global_frame_counter % 5))
				var/fx/disappear_apple_mech/f = new(loc)
				f.pixel_y = pixel_y
				f.icon = icon
				f.step_x = step_x
				f.step_y = step_y
				f.transform = transform
			if(!(global_frame_counter % 7))
				var/obj/bomb/static_b/new_b = new(loc)
				new_b.step_x = step_x
				new_b.step_y = step_y



		var/matrix/M = matrix()
		M.Scale(scale,1)
		transform = M
		shadow.transform = M



/fx/disappear_apple_mech
	New()
		..()
		processing_objects += src
		spawn(6)
			del src
	Del()
		processing_objects -= src
		..()
	Process()
		alpha = (global_frame_counter % 2)*255
