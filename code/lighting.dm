/spotlight
	icon = 'icons/lighting.dmi'
	icon_state = "spotlight"

	parent_type = /obj

	plane = SHADING_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = RESET_COLOR | LONG_GLIDE
	mouse_opacity = 0
	layer = LIGHT_LAYER + 1

	New()
		..()

/atom/movable
	var/spotlight/light_object = null
	proc/change_light(var/l_range,var/n_color)
		if(!light_object)
			light_object = new(loc)
		light_object.transform = matrix()*l_range
		light_object.color = n_color

/area/New()
	..()
	plane = SHADING_PLANE
	layer = LIGHT_LAYER
	icon = 'icons/lighting.dmi'
	icon_state = name == "black_total" ? "black_total" : "black"
