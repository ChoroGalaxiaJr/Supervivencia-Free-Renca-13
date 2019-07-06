#define w 80
#define h 60
#define x_off 7

var/list/renderizable = list()
client
	var/list/client_raycast_screen = list()

	var
		dirX = -1
		oldDirX = -1
		dirY = 0 //initial direction vector
		planeX = 0
		oldPlaneX = 0
		planeY = 0.66 //the 2d raycaster version of camera plane

		list/sprites = list()

		screen/bg1
		screen/bg2
		screen/bg3

	New()
		..()
		for(var/x = 0, x < w, x++)
			var/screen/ray_cast_line = new()
			ray_cast_line.icon = 'icons/hud/ray.dmi'
			ray_cast_line.screen_loc = "1:[x*x_off],1"
			ray_cast_line.plane = RAY_PLANE
			client_raycast_screen += ray_cast_line
		bg1 = new()
		bg1.icon = 'icons/hud/bg.dmi'
		bg1.icon_state = "floor"
		client_raycast_screen += bg1
		bg2 = new()
		bg2.icon = 'icons/hud/bg.dmi'
		bg2.icon_state = "sky"
		bg2.screen_loc = "1,1:240"
		client_raycast_screen += bg2

		bg3 = new()
		bg3.icon = 'icons/hud/bg.dmi'
		bg3.icon_state = "sky"
		bg3.screen_loc = "1:608,1:240"
		client_raycast_screen += bg3

		var/screen/gun = new()
		gun.plane = RAY_PLANE+1
		gun.icon = 'icons/hud/guns.dmi'
		gun.icon_state = "current_gun"
		gun.transform *= 1.5

		gun.screen_loc = "1:152,1:60"
		client_raycast_screen += gun

		bg1.plane = -100
		bg2.plane = -100
		bg3.plane = -100

	proc
		render_raycast()

			//next_track = 'sounds/music/silo.ogg'
			var/rot = (keys["a"]-keys["d"])*(1+keys["shift"]*0.5)

			if(rot != 0)
				oldDirX = dirX
				dirX = dirX * cos(rot) - dirY * sin(rot)
				dirY = oldDirX * sin(rot) + dirY * cos(rot)
				oldPlaneX = planeX
				planeX = planeX * cos(rot) - planeY * sin(rot)
				planeY = oldPlaneX * sin(rot) + planeY * cos(rot)

			var/spd = (keys["w"]-keys["s"])*(2+keys["shift"]*2)
			mob.PixelMove(dirX*spd,0)
			mob.PixelMove(0,dirY*spd)

			mob.dir = FromDegrees((atan2(dirX,dirY)-90)*-1)



			var
				posX
				posY
				mapX
				mapY
				looking = (mouse_position._y-240)
			for(var/x = 0, x < w, x++)

				//calculate ray position and direction
				var
					cameraX = 2 * x / w - 1 //x-coordinate in camera space
					rayDirX = dirX + planeX * cameraX
					rayDirY = dirY + planeY * cameraX
					//length of ray from current position to next x or y-side
					sideDistX
					sideDistY
				posX = mob.x + (mob.step_x/32) + 0.5
				posY = mob.y + (mob.step_y/32) + 0.5
				mapX = mob.x
				mapY = mob.y
				 //length of ray from one x or y-side to next x or y-side
				rayDirX = noDivisionError(rayDirX)
				rayDirY = noDivisionError(rayDirY)

				var
					deltaDistX = abs(1 / rayDirX)
					deltaDistY = abs(1 / rayDirY)
					perpWallDist = 0
					//what direction to step in x or y-direction (either +1 or -1)
					stepX
					stepY
					//hits
					turf/hit = null //was there a wall hit?
					side //was a NS or a EW wall hit?
				//calculate step and initial sideDist
				if (rayDirX < 0)

					stepX = -1
					sideDistX = (posX - mapX) * deltaDistX

				else

					stepX = 1
					sideDistX = (mapX + 1.0 - posX) * deltaDistX

				if (rayDirY < 0)

					stepY = -1
					sideDistY = (posY - mapY) * deltaDistY

				else

					stepY = 1
					sideDistY = (mapY + 1.0 - posY) * deltaDistY

				//perform DDA
				while (isnull(hit))
					CHECK_TICK
					//jump to next map square, OR in x-direction, OR in y-direction
					if (sideDistX < sideDistY)

						sideDistX += deltaDistX
						mapX += stepX
						side = 0

					else
						sideDistY += deltaDistY
						mapY += stepY
						side = 1

					//Check if ray has hit a wall
					var/turf/T = locate(round(mapX),round(mapY),1)

					if(!istype(T.loc,/area/raycasted))
						hit = null
						break
					if(T && T.opacity)
						hit = T
						break
					CHECK_TICK

				//Calculate distance projected on camera direction (Euclidean distance will give fisheye effect!)
				if (side == 0)
					perpWallDist = (mapX - posX + (1 - stepX) / 2) / rayDirX
				else
					perpWallDist = (mapY - posY + (1 - stepY) / 2) / rayDirY

				perpWallDist = noDivisionError(perpWallDist)

				//Calculate height of line to draw on screen
				var lineHeight = h / perpWallDist

				//give x and y sides different brightness
				//if (side == 1) color = color / 2

				//draw the pixels of the stripe as a vertical line
				//verLine(x, drawStart, drawEnd, side ? hit.dark_color : hit.color,65536-perpWallDist)

				var/screen/P = client_raycast_screen[x+1]
				if(P)
					var/matrix/M = matrix()
					M.Scale(1,lineHeight*2)
					M.Translate(x,240 + ((lineHeight*2)*(looking/50)/-4))

					P.transform = M
					if(!isnull(hit))
						var div1 = 1+perpWallDist/4
						var div2 = 1+side
						P.color = rgb((hit.normal_r/div1)/div2,(hit.normal_g/div1)/div2,(hit.normal_b/div1)/div2)
						P.layer = 65536-perpWallDist
					else
						P.color = rgb(0,0,0)
						P.layer = 0
					P.alpha = isnull(hit) ? 0 : 255


				CHECK_TICK


			var off = ((atan2(dirX,dirY)/360)*608) - 304
			var/matrix/M = matrix()
			M.Translate(off, (looking/-50))
			bg2.transform = M
			bg3.transform = M

			M = matrix()
			M.Translate(0, (looking/-50))
			bg1.transform = M




			///Render sprites
			screen -= sprites
			sprites = list()

			//wannabe sprite rendering
			posX = mob.x + (mob.step_x/32) + 0.5
			posY = mob.y + (mob.step_y/32) + 0.5
			mapX = mob.x
			mapY = mob.y

			for(var/i in renderizable)
				if(i != mob)
					//translate sprite position to relative to camera

					var spriteX = (i:x + i:step_x/32) + 0.5 - posX;
					var spriteY = (i:y + i:step_y/32) + 0.5 - posY;

					var angle = atan2(spriteX,spriteY) - atan2(dirX,dirY)

					var dist = distance(mob,i)
					if(abs(angle) < 90 && dist < 48)

						var //matrix
							invDet = 1.0 / (planeX * dirY - dirX * planeY); //required for correct matrix multiplication
							//transforms
							transformX = noDivisionError(invDet * (dirY * spriteX - dirX * spriteY))
							transformY = noDivisionError(invDet * (-planeY * spriteX + planeX * spriteY)) //this is actually the depth inside the screen, that what Z is in 3D
							//x positions
							spriteScreenX = round(304 * (1 + transformX / transformY));
							vMoveScreen = round(i:vMove / transformY);
							//calculate height of the sprite
							spriteHeight = abs(round(480 / (transformY))) / (0.25 / i:size_y); //using "transformY" instead of the real distance prevents fisheye
							drawStartY = -spriteHeight / 2 + 240 + vMoveScreen;
							drawEndY = spriteHeight / 2 + 240 + vMoveScreen;
							//calculate width of the sprite
							spriteWidth = abs( round(480 / (transformY))) / (0.5 / i:size_x);
							drawStartX = -spriteWidth / 2 + spriteScreenX;
							drawEndX = spriteWidth / 2 + spriteScreenX;

						var matrix/t = matrix(
						  i:sprite_width/2,
						  i:sprite_height/2,
						  MATRIX_TRANSLATE)
						var matrix/m = new
						m *= t
						m.Scale(
						  (drawEndX-drawStartX) / i:sprite_width,
						  (drawEndY-drawStartY) / i:sprite_height)
						m /= t
						m.Translate(drawStartX,drawStartY*(1+(looking/-240)*0.1))

						var/screen/new_sprite = new()
						new_sprite.icon = i:icon
						new_sprite.icon_state = i:icon_state
						new_sprite.transform = m
						new_sprite.appearance_flags = PIXEL_SCALE
						new_sprite.blend_mode = i:blend_mode
						new_sprite.layer = 65536-(dist)
						new_sprite.plane = RAY_PLANE

						sprites += new_sprite

			screen += sprites


/atom/movable
	var
		sprite_width = 64
		sprite_height = 128
		size_y = 0.5
		size_x = 0.5
		vMove = 128

/renderizable_3d_object
	parent_type = /obj
	icon = 'icons/objects/3d.dmi'

	New()
		..()
		renderizable += src


	plant
		icon_state = "plant"
		pixel_x = -16