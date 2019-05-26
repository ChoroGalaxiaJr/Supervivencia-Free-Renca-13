/*
	How to change music :
		change next_track
*/
var next_track = "silence"
/client

	var
		current_track = "silence"
		mus_frm = 0
		sound/music = null
		vol = 100

	proc
		Music_Loop()

			if(music == null)
				music = sound('sounds/music/track_peace.ogg',channel=768)
				music.volume = vol
				music.repeat = 1
				src << music
				music.status = SOUND_UPDATE
			else

				src << music
				if(current_track != next_track)
					if(music.volume > 0)
						music.volume = max(0,music.volume -2)
					else
						src << sound(null,channel=768)
						if(next_track != "silence")
							music = sound(next_track,channel=768)
							music.repeat = 1
							music.volume = vol

							src << music
							music.status = SOUND_UPDATE
						current_track = next_track
				else
					music.volume = vol
	verb
		Change_Music_Volume(new_vol as num)
			vol = new_vol