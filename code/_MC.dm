
/*

Master System

*/

#define SLOW_WAIT 5
#define NORMAL_WAIT 1

var/master_controller/master

var/list/processing_objects = list()
var/global_frame_counter = 0

datum
	proc
		Process()

client
	proc
		Process()
	New()
		..()
		clients += src
	Del()
		clients -= src
		..()

mob
	New()
		..()
		mobs += src
	Del()
		mobs -= src
		..()

master_controller
	var
		fast_process_temp = 0
		slow_process_temp = 0
		normal_process_temp = 0
		do_processing = 1
	proc/Initialize()
		while(clients.len == 0)
			sleep(1)
		Start_Processing()
	proc/Start_Processing()
		spawn()
			Process_Fast()
		spawn()
			Process_Slow()
		spawn()
			Process_Normal()
		spawn(2)
			game_handler.entire_game_loop()
	proc/Process_Fast()
		while(1)
			if(do_processing)
				fast_process_temp = 0

				while(fast_process_temp < clients.len)
					fast_process_temp += 1
					clients[fast_process_temp]:Process()

				fast_process_temp = 0

				while(fast_process_temp < mobs.len)
					fast_process_temp += 1
					mobs[fast_process_temp]:Process()

				fast_process_temp = 0

				while(fast_process_temp < processing_objects.len)
					fast_process_temp += 1
					processing_objects[fast_process_temp]:Process()

				global_frame_counter += 1
				if(shake_timer > 0)
					shake_timer -= 1
			sleep(world.tick_lag)
	proc/Process_Slow()
		while(1)
			sleep(SLOW_WAIT)
			//new /obj/bomb(locate(rand(1,14),rand(1,14),1), 0, 0)
	proc/Process_Normal()
		while(1)
			sleep(NORMAL_WAIT)