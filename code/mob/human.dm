/world
	mob = /mob/player

/mob/player
	var/icon/stand_icon = null
	var/species_icon = 'icons/mob/human.dmi'
	var/hair = "messy"
	var/hair_color = rgb(0,0,0)

	step_size = 32
	sprite_width = 32
	sprite_height = 32
	size_y = 0.25
	vMove = -20

	sight = SEE_THRU


	New()
		..()
		update_body()
		//initialize mario, also general
		color_top = rgb(rand(0,255),rand(0,255),rand(0,255))
		color_bottom = rgb(rand(0,255),rand(0,255),rand(0,255))
		renderizable += src

		loc = locate(103,145,1)


	proc/MovePlayer(var/dir)
		if(world.time > last_move_delay)
			last_move_delay = world.time + move_delay
			var/old_x = Get_Position_X()
			var/old_y = Get_Position_Y()
			Move(get_step(src,dir),dir,0,0)
			var/new_x = Get_Position_X()
			var/new_y = Get_Position_Y()

			pixel_w = old_x - new_x
			pixel_z = old_y - new_y
			animate(src, pixel_w = 0, pixel_z = 0, time = move_delay)

	Process()
		..()
		if(MARIO_MODE)
			Mario_Process()
		else
			bound_width = 32
			bound_height = 32
			bound_x = 0
			bound_y = 0
			density = 1
			transform = matrix()

		if(client)
			if(client.keys["b"] && !MARIO_MODE)
				update_colors()
				MARIO_MODE = 1

		if(client)
			if(client.keys["c"] && MARIO_MODE)
				update_body()
				MARIO_MODE = 0

	proc

		//Rest in peace. logic. :sob:
		Respawn()
			update_body()
			MARIO_MODE = 0
			loc = locate(2,2,1)
		/*

		creates a icon of the body.

		*/


		update_body()
			if(src.stand_icon)
				del(src.stand_icon)

			var/g = gender != MALE ? "m" : "f"
			src.stand_icon = new /icon(species_icon, "blank")

			/*
				Parts by gender
			*/
			for (var/part in list("head","torso","groin"))
				var/icon/ge =  new /icon(species_icon, "[part]_[g]")
				src.stand_icon.Blend(ge, ICON_OVERLAY)

			/*
				Parts normal
			*/
			for (var/part in list("arm","hand","leg","foot"))
				for(var/d in list("l","r"))
					var/icon/ge =  new /icon(species_icon, "[d]_[part]")
					src.stand_icon.Blend(ge, ICON_OVERLAY)


			var/icon/eyes_s = new/icon(species_icon, "icon_state" = "eyes")
			var/icon/hair_s = new/icon('icons/mob/human_face.dmi', "icon_state" = hair)
			hair_s.Blend(hair_color, ICON_ADD)

			stand_icon.Blend(eyes_s, ICON_OVERLAY)
			stand_icon.Blend(hair_s, ICON_OVERLAY)

			del(hair_s)
			del(eyes_s)

			src.icon = src.stand_icon