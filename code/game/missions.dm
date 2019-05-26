/datum/mission
	var/name = "unnamed mission"
	var/finished = FALSE
	proc
		Start()
			world << sound(null)
			world << "<font size=5>Mission <b>[name]</b> is starting!</font>"
			//master.do_processing = FALSE
			world << 'sounds/music/start.wav'
			sleep(70)
			//master.do_processing = TRUE
			..()

/datum/mission/save_jah
	/*
		infiltrate fortnite dabbing school

		fight apple mech
	*/
	var/timer = 600
	var/screen/cutscene_object/timer_t = new()
	name = "Save jah"
	Start()
		..()
		next_track = 'sounds/music/emergency.ogg'
		world << "<font size=3><b>Shit! Jah's about to be raped! We have to save him! Go to the school (located north) and get jah out of the principal's room.</b></font>"
		cutscene_items += timer_t
		timer_t.screen_loc = "18,1"
		timer_t.maptext_width = 64
	Process()
		timer_t.maptext = "<text align=center>[round(timer/60)]:[(round(timer) % 60) > 10 ? (round(timer) % 60) : "0[round(timer) % 60]"]"
		if(!(global_frame_counter % 60))
			timer -= 1


