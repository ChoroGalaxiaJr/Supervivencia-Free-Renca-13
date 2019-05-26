/*
Inputs are handled in skin.dmf, see macro.
*/

client
	North()
	South()
	East()
	West()
	Southeast()
	Southwest()
	Northeast()
	Northwest()

/client
	var/list/keys = list()

/mob/verb/KeyDown(k as text)
	set instant = 1
	set waitfor = 0
	k = lowertext(k)
	client.keys[k] = 1

/mob/verb/KeyUp(k as text)
	set instant = 1
	set waitfor = 0
	k = lowertext(k)
	client.keys[k] = 0