var/list/clients = list() //list of all clients

/client
	New()
		..()
		clients += src
	Del()
		clients -= src
		..()