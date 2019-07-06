/*

	05/06/2019 Cleaned up -ChoroGalaxia2019
	most code from https://github.com/ChoroGalaxiaJr/FreeRencaMarioWorld

	Feel free to use this code for your server. it is licensed under AGPL V3.0
	I mean, you probably won't be able to use it but if you know how to set stuff like this up, feel free to do so.

*/

#define P_METER_REQUIRED 112
#define RUN_KEY_MARIO "shift"
#define RIGHT_KEY_MARIO "d"
#define LEFT_KEY_MARIO "a"
#define DOWN_KEY_MARIO "s"
#define JUMP_KEY_MARIO "space"

proc/Calculate_Speed(x)
	return x/256

world
	mob = /mob/player


client
	perspective = EYE_PERSPECTIVE

/mob/player

	var
		X_SPEED = 0
		Y_SPEED = 0
		STATE = 0
		WALKING_DIR = 0
		P_METER = 0

		to_scale = 1
		INVINCIBILITY_FRAMES = 0
		SLIGHT_HI = 0
		CAN_SPRI = 0
		ON_FL = 0
		DEAD = 0
		JUMP = 0
		LAST_X_SPEED_ON_FL = 0

		CAN_PHYSICS = 1
		TIME_RUNNING_OUT = 0

		SKIDDING = 0
		FALLING = 0

		WALK_TIMER = 0

		color_top = rgb(0,0,0)
		color_bottom = rgb(0,0,0)
		CROUCH = 0

		EXTRA_VARIABLE_1 = 0
		EXTRA_VARIABLE_2 = 0
		EXTRA_VARIABLE_3 = 0

		MARIO_MODE = 0
	/*

	MAIN

	*/
	proc/Initialize_mario()
		update_colors()

	proc/Die(var/ju = 1)
		if(DEAD)
			return

		INVINCIBILITY_FRAMES = 0
		if(ju)
			EXTRA_VARIABLE_1 = Calculate_Speed(1292)
		else
			EXTRA_VARIABLE_1 = Y_SPEED

		EXTRA_VARIABLE_2 = 0
		DEAD = 1

		world << "<font color=#FF0000><b>[name]</b> died (SHITTY MARIO PLAYER CONFIRMED???)!</font>"
		src << 'sounds/mario/died.wav'
		spawn(20)
			if(client)
				Respawn()
			else
				del src

	/*

	COMMAND VERBS

	*/

	verb
		Change_Bottom_Color(ass as color)
			color_bottom = ass
			update_colors()
		Change_Top_Color(ass as color)
			color_top = ass
			update_colors()

	proc
		//Updates player icon/colors
		update_colors()
			var/icon/I = new('icons/mario.dmi')
			//vars
			var
				rt = hex2num(copytext(color_top,2,4), TRUE)
				gt = hex2num(copytext(color_top,5,7), TRUE)
				bt = hex2num(copytext(color_top,-2), TRUE)

				rb = hex2num(copytext(color_bottom,2,4), TRUE)
				gb = hex2num(copytext(color_bottom,5,7), TRUE)
				bb = hex2num(copytext(color_bottom,-2), TRUE)

			I.SwapColor(rgb(248,64,112),rgb(rt,gt,bt))
			I.SwapColor(rgb(176,40,96),rgb(rt/1.5,gt/1.5,bt/1.5))
			I.SwapColor(rgb(80,0,0),rgb(rt/2,gt/2,bt/2))

			I.SwapColor(rgb(248,0,0),rgb(rt,gt,bt))
			I.SwapColor(rgb(176,0,0),rgb(rt/1.5,gt/1.5,bt/1.5))

			I.SwapColor(rgb(128,216,200),rgb(rb,gb,bb))
			I.SwapColor(rgb(64,128,152),rgb(rb/1.5,gb/1.5,bb/1.5))
			I.SwapColor(rgb(32,48,136),rgb(rb/2,gb/2,bb/2))

			I.SwapColor(rgb(64,64,216),rgb(rb,gb,bb))

			icon = I
		//Input react
		Jump()
			if(ON_FL)

				PlaySound(src,'sounds/mario/jump.ogg',16)

				ON_FL = 0
				JUMP = 3
				FALLING = 0
				Y_SPEED = Calculate_Speed(1282+(148*SLIGHT_HI)+(20*CAN_SPRI))

		//Jump after hitting enemy
		Enemy_Jump()
			if(client.keys[JUMP_KEY_MARIO])
				Y_SPEED = Calculate_Speed(1408) //jump
			else
				Y_SPEED = Calculate_Speed(768)

		//Get matrix, icon, etc.
		Get_Matrix()
			bound_width = 14
			bound_x = 1

			var/matrix/M = matrix()
			if(DEAD == 0)
				pixel_w = 0
				//icon = 'mario.dmi'
				if(STATE > 0)
					bound_height = 28
					if(CROUCH)
						bound_height = 14
				else
					bound_height = 14



				var/EXTRA = ""
				pixel_y = 0
				if(abs(X_SPEED) > 0)
					WALK_TIMER += abs(X_SPEED)
					if(SKIDDING == 0)
						icon_state = "WALK"
						if(abs(X_SPEED) > Calculate_Speed(750) )
							icon_state = "RUN"
						else
							if(Y_SPEED == 0)
								EXTRA = "_[round(WALK_TIMER/(10+((STATE > 0)*5) ) ) % (2+(STATE > 0))]"
					else
						EXTRA = ""
						icon_state = "SKID"
				else
					icon_state = "STAND"

				if(abs(LAST_X_SPEED_ON_FL) > Calculate_Speed(750))
					if(Y_SPEED != 0)
						EXTRA = ""
						icon_state = "JUMP_B"
				else
					if(Y_SPEED > 0 && FALLING == 0)
						EXTRA = ""
						icon_state = "JUMP"
					if(Y_SPEED < 0 || FALLING == 1)
						FALLING = 1
						EXTRA = ""
						icon_state = "FALL"
				if(CROUCH)
					EXTRA = ""
					icon_state = "CROUCH"
				icon_state = icon_state + "_[STATE][EXTRA]"

				if(SKIDDING)
					to_scale = SKIDDING*-1

				M.Scale(to_scale,1)
			else

				pixel_w = 0
				icon_state = "DEAD"
				M.Scale(to_scale,1)

			if(to_scale == -1)
				pixel_w = -8

			transform = M


		//Main physics loop.
		Mario_Process()
			if(JUMP > 0)
				JUMP -= 1
			if(INVINCIBILITY_FRAMES > 0)
				INVINCIBILITY_FRAMES = INVINCIBILITY_FRAMES - 1

			SKIDDING = 0

			if(DEAD == 1)
				FALLING = 0
				density = 0

				Get_Matrix()

				if(EXTRA_VARIABLE_3 == 0)
					EXTRA_VARIABLE_3 = 7
					to_scale = to_scale * -1
				else
					EXTRA_VARIABLE_3 = EXTRA_VARIABLE_3 - 1
				EXTRA_VARIABLE_1 = EXTRA_VARIABLE_1 - Calculate_Speed(48)
				EXTRA_VARIABLE_2 = EXTRA_VARIABLE_2 + EXTRA_VARIABLE_1

				if(Get_Position_Y() + EXTRA_VARIABLE_2 < 17)
					alpha = 0

				pixel_z = EXTRA_VARIABLE_2
			else

				if(Get_Position_Y() < 17)
					Die(0)

				density = 1
				var
					RUN = 0 //set to 1
					GRAV = -96 //-48 if Z is held
					MOV = 0
					SLIGHT_HIGH_SPEED = 0
					CAN_SPRINT = 0

				ON_FL = 0
				pixel_z = 0
				alpha = 255 - (INVINCIBILITY_FRAMES % 2)*255


				if(PixelMove(0,-1) == 0)
					//world << "damu tu cosita"
					ON_FL = 1
					FALLING = 0
					Y_SPEED = 0
				else
					PixelMove(0,1)

				/*
					Physics (cleaned upas of 05/06/2019), ported from Byond Mario World 2
				*/
				if(abs(X_SPEED) >= Calculate_Speed(576) && client.keys[RUN_KEY_MARIO])
					SLIGHT_HIGH_SPEED = 1
					P_METER = min(P_METER_REQUIRED, P_METER + (ON_FL && !CROUCH)*2)
				else
					P_METER = max(0, P_METER - ON_FL)

				if(P_METER >= P_METER_REQUIRED && client.keys[RUN_KEY_MARIO])
					CAN_SPRINT = 1

				//Walking and crouching.
				WALKING_DIR = client.keys[RIGHT_KEY_MARIO] - client.keys[LEFT_KEY_MARIO]
				MOV = WALKING_DIR != 0

				if(client.keys[DOWN_KEY_MARIO])
					if(ON_FL)
						WALKING_DIR = 0
						MOV = 0
						CROUCH = 1
				else
					if(ON_FL)
						CROUCH = 0

				//running if da key pressed
				RUN = client.keys[RUN_KEY_MARIO]
				//make gravity affect less if holding jump
				GRAV /= (1+client.keys[JUMP_KEY_MARIO])

				if(client.keys[JUMP_KEY_MARIO])
					Jump()


				//to_scale change
				if(!SKIDDING && MOV)
					to_scale = client.keys[LEFT_KEY_MARIO] ? 1 : -1


				//X Speed calcultaions (cleaned up)
				var
					SPEED_X_TO_SET = Calculate_Speed(320+(RUN*256)+(CAN_SPRINT*192))*WALKING_DIR
					SPEED_ACCEL_X = Calculate_Speed(24)
					STOPPING_DECEL = Calculate_Speed(16)
					SKID_ACCEL = Calculate_Speed(16+(24*RUN)+(CAN_SPRINT*40))

				if(MOV != 0)
					if(ON_FL)
						//Skidding (to-do : clean up)
						if(X_SPEED > 0 && SPEED_X_TO_SET < 0 && WALKING_DIR == -1)
							SKIDDING = -1
							X_SPEED -= SKID_ACCEL
						if(X_SPEED < 0 && SPEED_X_TO_SET > 0 && WALKING_DIR == 1)
							SKIDDING = 1
							X_SPEED += SKID_ACCEL
					else
						SKIDDING = 0
					if(SKIDDING == 0)
						//Acceleration.
						if(X_SPEED > SPEED_X_TO_SET)
							X_SPEED = max(SPEED_X_TO_SET, X_SPEED - SPEED_ACCEL_X)

						if(X_SPEED < SPEED_X_TO_SET)
							X_SPEED = min(SPEED_X_TO_SET, X_SPEED + SPEED_ACCEL_X)

						if(X_SPEED > 0 && SPEED_X_TO_SET < 0 && WALKING_DIR == -1)
							X_SPEED -= SKID_ACCEL
						if(X_SPEED < 0 && SPEED_X_TO_SET > 0 && WALKING_DIR == 1)
							X_SPEED += SKID_ACCEL

				else
					//Stopping (also cleaned up.)
					if(ON_FL == 1)
						if(X_SPEED > 0)
							X_SPEED = max(0, X_SPEED - STOPPING_DECEL)
						if(X_SPEED < 0)
							X_SPEED = min(0, X_SPEED + STOPPING_DECEL)

				if(!ON_FL)
					Y_SPEED += Calculate_Speed(GRAV)
				else
					LAST_X_SPEED_ON_FL = X_SPEED

				if(Y_SPEED < Calculate_Speed(-1312))
					Y_SPEED = Calculate_Speed(-1312)



				if(PixelMove(X_SPEED,0) == 0)
					X_SPEED = 0

				if(PixelMove(0,Y_SPEED) == 0)
					Y_SPEED = 0


				SLIGHT_HI = SLIGHT_HIGH_SPEED
				CAN_SPRI = CAN_SPRINT


				Get_Matrix()

				density = 0
