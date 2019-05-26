/game_handler

	proc/entire_game_loop()
		next_track = "silence"

		/*var/screen/cutscene_object/apple_building = new()
		apple_building.icon = 'icons/hud/fullscreen.dmi'
		apple_building.icon_state = "apple"
		cutscene_items += apple_building

		sleep(20)
		var/matrix/M = matrix()
		M.Scale(10)
		animate(apple_building, transform = M, color = "#000000", time = 50)

		sleep(50)

		var/screen/cutscene_object/t = new()
		t.maptext_width = 608
		t.maptext_height = 480
		t.maptext = "<text align=center valign=middle>The start of a incident that will leave millions dead.."
		t.color = "#000000"
		cutscene_items += t
		animate(t, color = "#FFFFFF", time = 20)
		sleep(20)


		//next_track = 'sounds/music/emergency.ogg'



		world << 'sounds/voice/argument.ogg'
		world << "<b><font color='red'>XBOX 1 Player : I don't have UNO, so fuck off.</font></b>"
		sleep(20)
		world << "<b><font color='red'>UNO Player : Everyone has UNO dipshit, it came free, with your fucking XBOX.</font></b>"
		sleep(50)
		t.maptext = "<text align=center valign=middle>A game programmed by the Bread Getters Studio"

		world << "<b><font color='red'>XBOX 1 Player : I didn't get it, I have the oldest XBOX known to man.</font></b>"
		sleep(30)
		world << "<b><font color='red'>UNO Player : No you don't, I got mine on day one, you fucking tard.</font></b>"
		sleep(40)
		t.maptext = "<text align=center valign=middle>with no ones help (we were smart enough to code it on our own)"

		world << "<b><font color='red'>XBOX Player : Well, mine didn't have it-</font></b>"
		sleep(20)
		world << "<b><font color='red'>UNO Player : YOU HAVE UNO!!!! YOU FUCKING DICK</font></b>"
		sleep(30)
		t.maptext = "<text align=center valign=middle>a epic game"
		//0:19 mark
		world << "<b><font color='red'>XBOX Player : I don't have it you-</font></b>"
		sleep(20)
		world << "<b><font color='red'>UNO Player : YOU HAVE UNO!!!!</font></b>"
		sleep(30)
		world << "<b><font color='red'>XBOX Player : I don't fucking have UNO mother-fucker!</font></b>"
		sleep(30)
		world << "<b><font color='red'>*arguing*</font></b>"
		animate(apple_building, alpha = 0, time = 50)
		t.maptext = "<text align=center valign=middle>"
		sleep(100)
		cutscene_items -= t
		cutscene_items -= apple_building
		del t
		del apple_building
		world << "<b><font size=6>Supervivencia Free Renca 13</font></b>"
		world << {"based off the funniest hit "anal the movie (2019)", the adventure begins now I guess. the heroes (aka the players) have to save the world, because everything is about to go to shit."}
		sleep(50)
		*/

		//mission start

		var/list/mission_order = list(
			"/datum/mission/save_jah")
		var/current_mission = 1

		while(current_mission <= mission_order.len)
			var/p = text2path(mission_order[current_mission])
			var/datum/mission/n_mission = new p()
			n_mission.Start()
			while(n_mission.finished == FALSE)
				n_mission.Process()
				sleep(world.tick_lag)
			del n_mission
			current_mission += 1



var/game_handler/game_handler = new()