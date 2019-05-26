/obj/bomb
	icon = 'icons/objects/misc.dmi'
	icon_state = "bomb"

	var/x_spd = 0
	var/y_spd = 0
	var/z_spd = 0
	var/z_pos = 0
	New()
		..()
		processing_objects += src
		z_spd = 10

	Process()
		..()
		z_spd -= 96/256

		layer = 3 + (z_pos > 0)*2

		PixelMove(x_spd, y_spd)

		z_pos += z_spd
		pixel_z = z_pos

		update_shadow(170-z_pos/2)

		if(z_pos < 0)
			processing_objects -= src
			shake_timer = 30
			new /fx/explosion(loc, 0, 0)
			del src

	static_b

		Process()
			return
		New()
			..()
			spawn(10)
				shake_timer = 30
				processing_objects -= src
				new /fx/explosion(loc, 0, 0)
				del src