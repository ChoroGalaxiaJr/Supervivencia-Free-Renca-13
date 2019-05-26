/obj/light_post
	icon = 'icons/objects/street_light.dmi'
	pixel_x = -68+16+32
	density = 1
	bound_width = 32
	bound_height = 32
	layer = 8
	New()
		..()
		change_light(20,rgb(232, 255, 255))
		light_object.pixel_y = 110

/obj/siren_light
	icon = 'icons/objects/lighting.dmi'
	icon_state = "siren"
	density = 1
	New()
		..()
		change_light(20,rgb(255,0,0))
		light_object.icon_state = "triangle"
		processing_objects += src
		transform *= 0.25
	Del()
		processing_objects -= src
		..()

	Process()
		var/matrix/M = matrix()
		M.Scale(10)
		var time = global_frame_counter*3
		M.Turn((time*-1)-90)
		light_object.transform = M
		light_object.pixel_x = cos(time)*144
		light_object.pixel_y = sin(time)*144

/obj/floor_light
	icon = 'icons/objects/lighting.dmi'
	icon_state = "light"
	New()
		..()
		change_light(20,rgb(232, 255, 255))