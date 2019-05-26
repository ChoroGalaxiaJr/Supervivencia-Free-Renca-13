/shadow
	parent_type = /obj

/atom/movable
	var/shadow/shadow = null
	proc/update_shadow(var/alpha_new = 0)

		if(!shadow)
			shadow = new(loc)

		shadow.loc = loc
		shadow.step_x = step_x
		shadow.step_y = step_y

		shadow.overlays = overlays
		shadow.underlays = underlays
		shadow.icon = icon
		shadow.icon_state = icon_state

		shadow.color = rgb(0,0,0)
		shadow.alpha = max(0,round(alpha_new))


	Del()
		if(shadow)
			del shadow
		..()
