/screen
	parent_type = /obj
	screen_loc = "1,1"
	plane = HUD_PLANE
	appearance_flags = TILE_BOUND | PIXEL_SCALE

/screen/cutscene_object
	plane = HUD_PLANE - 1

/screen/health_bar
	icon = 'icons/hud/health.dmi'
	icon_state = "health_bg"
	screen_loc = "CENTER:-82,1:8"

/screen/plane_master
	plane = 0
	appearance_flags = PIXEL_SCALE | PLANE_MASTER

/screen/lighting_master
	plane = SHADING_PLANE
	screen_loc = "1,1"
	appearance_flags = PIXEL_SCALE | KEEP_TOGETHER | PLANE_MASTER
	blend_mode = BLEND_MULTIPLY

/client
	var/screen/health_bar/h1
	var/screen/health_bar/h1bg
	var/screen/health_bar/h1dm

	var/screen/hand_l
	var/screen/hand_r
	var/screen/gun_h



	var/old_health = 0

	New()
		..()
		Init_Hud()

	proc/Init_Hud()
		h1 = new()
		h1.icon_state = "health"
		h1bg = new()
		h1bg.icon_state = "health_bg"
		h1dm = new()
		h1dm.icon_state = "damage"

		hand_l = new()
		hand_l.icon = 'icons/hud/hud.dmi'
		hand_l.icon_state = "left"
		hand_l.screen_loc = "14,1:4"

		hand_r = new()
		hand_r.icon = 'icons/hud/hud.dmi'
		hand_r.icon_state = "right"
		hand_r.screen_loc = "15,1:4"

		gun_h = new()
		gun_h.icon = 'icons/hud/hud.dmi'
		gun_h.icon_state = "gun"
		gun_h.screen_loc = "16:8,1:4"
		gun_h.overlays += icon('icons/hud/hud.dmi',"current_gun")

		screen += h1bg
		screen += h1dm
		screen += hand_r
		screen += hand_l
		screen += gun_h
		screen += h1

	proc/Process_Hud()


		if(mob.health != old_health)
			old_health = mob.health

			var/matrix/M = matrix()
			M.Scale(max(0,mob.health / 100), 1)
			M.Translate(min(0,((mob.health / 100)*98)-98),0)
			h1.transform = M

			animate(h1dm,transform = M, time = 2)
