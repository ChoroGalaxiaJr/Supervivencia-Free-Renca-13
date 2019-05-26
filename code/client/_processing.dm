/area/raycasted
	icon = 'icons/area.dmi'
	icon_state = "red"
	plane = 100

/area/dark_total
	icon = 'icons/area.dmi'
	icon_state = "yellow"
	name = "black_total"
	plane = 100


/client
	var/camera_x = 32
	var/camera_y = 32

	var/mode = 0

	var/screen/plane_master/p_master_wall
	var/screen/plane_master/p_master
	var/screen/plane_master/p_master_objects
	var/screen/lighting_master/l_m

	var/screen/text

	New()
		..()
		p_master_wall = new()
		p_master_wall.plane = WALL_PLANE
		p_master_wall.appearance_flags = PIXEL_SCALE | PLANE_MASTER | KEEP_TOGETHER
		p_master_wall.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=2, color=rgb(0,0,0))

		p_master = new()
		p_master.plane = 0

		p_master_objects = new()
		p_master_objects.plane = OBJECTS_PLANE

		text = new()
		text.maptext_width = 32*8
		text.maptext_height = 32
		text.maptext = "bruh moment"

		l_m = new()

		screen += p_master
		screen += p_master_wall
		screen += p_master_objects
		screen += text
		screen += l_m

		screen += mouse_position.MouseCatcher

	Process()
		camera_x += (mob.Get_Position_X() - camera_x)/50
		camera_y += (mob.Get_Position_Y() - camera_y)/50

		var
			camera_x_t = camera_x
			camera_y_t = camera_y + (shake_timer != 0 ? ((global_frame_counter % 3)-1)*round(shake_timer/3) : 0)
		eye = locate(camera_x_t/32, camera_y_t/32, mob.z)
		pixel_x = round(camera_x_t) % 32
		pixel_y = round(camera_y_t) % 32


		Music_Loop()

		Process_Hud()

		screen -= cutscene_items
		screen += cutscene_items

		mode = istype(mob.loc.loc, /area/raycasted) ? 1 : 0
		if(mode == 0)
			//world << "bofa"
			screen -= client_raycast_screen
			screen -= sprites


			dirX = -1
			oldDirX = -1
			dirY = 0 //initial direction vector
			planeX = 0
			oldPlaneX = 0
			planeY = 0.66 //the 2d raycaster version of camera plane

			mob.move_delay = 2-keys["shift"]
			var/dir = (keys["west"]*WEST) + (keys["east"]*EAST) + (keys["north"]*NORTH) + (keys["south"]*SOUTH)
			if(dir != 0)
				mob.Move(get_step(mob,dir),dir)

		else

			screen -= client_raycast_screen
			render_raycast()
			screen += client_raycast_screen

		p_master.alpha = 255-mode*255
		p_master_wall.alpha = p_master.alpha
		p_master_objects.alpha = p_master.alpha
		l_m.alpha = mode ? 0 : (sin(world.time/6)*127)+127

		text.maptext = "%[world.cpu], [mouse_position._x], [mouse_position._y]"