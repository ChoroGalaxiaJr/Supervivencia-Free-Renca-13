#define HUD_PLANE 100
#define RAY_PLANE 97
#define SHADING_PLANE 50
#define LIGHT_LAYER 99

#define WALL_PLANE 1
#define OBJECTS_PLANE 2

#define CHECK_TICK if(world.tick_usage > 95) sleep(world.tick_lag)

var shake_timer = 0

var list/cutscene_items = list()

atom
	appearance_flags = PIXEL_SCALE

world/New()
	..()
	master = new()
	master.Initialize()

mob
	PixelMove(move_x,move_y)
		move_delay = 0
		return ..()

atom/movable
	var
		sub_step_x = 0
		sub_step_y = 0

	proc
		PixelMove(move_x, move_y)
			var
				whole_x = 0
				whole_y = 0

			if(move_x)
				sub_step_x += move_x
				whole_x = round(sub_step_x, 1)
				sub_step_x -= whole_x

			if(move_y)
				sub_step_y += move_y
				whole_y = round(sub_step_y, 1)
				sub_step_y -= whole_y

			if(whole_x || whole_y)
				//step_size = max(abs(whole_x), abs(whole_y))
				return Move(loc, dir, step_x + whole_x, step_y + whole_y)
			return 1
