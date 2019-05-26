proc/PlaySound(atom/location,sound,range_div)
	var/sound/p_snd = sound(sound)
	for(var/client/c in clients)
		p_snd.x = (location.y-c.mob.x)/range_div
		p_snd.y = (location.x-c.mob.y)/range_div
		p_snd.volume = 100/max(1,distance(location,c.mob)/(range_div))
		c << p_snd