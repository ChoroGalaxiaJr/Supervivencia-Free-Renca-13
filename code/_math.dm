//they did the math

proc
	shuffle(list/givenList)
		. = givenList
		var/nextElement

		for(var/i = 1; i <= givenList.len; i++)

			nextElement = rand(1, givenList.len - i)
			nextElement = givenList[nextElement]
			. -= nextElement
			. += nextElement
		return .

proc/atan2(x, y)
	if(!x && !y) return 0
	return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

proc/distance(atom/A, atom/B)
	return sqrt((B.x-A.x)**2 + (B.y-A.y)**2)


proc/FromDegrees(Degrees)
	var global/from_degrees[] = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
	return from_degrees[1 + round(8 + Degrees * 8 / 360, 1) % 8]

atom/movable/proc/Get_Position_X()
	return step_x + x * 32

atom/movable/proc/Get_Position_Y()
	return step_y + y * 32


proc/distance_pos(var/x_1,var/y_1,var/x_2,var/y_2)
	return sqrt((x_2-x_1)**2 + (y_2-y_1)**2)


proc/noDivisionError(num)
	return num == 0 ? 0.0000000001 : num

/proc/hex2num(hex, safe=FALSE)
	. = 0
	var/place = 1
	for(var/i in length(hex) to 1 step -1)
		var/num = text2ascii(hex, i)
		switch(num)
			if(48 to 57)
				num -= 48	//0-9
			if(97 to 102)
				num -= 87	//a-f
			if(65 to 70)
				num -= 55	//A-F
			if(45)
				return . * -1 // -
			else
				if(safe)
					return null
				else
					CRASH("Malformed hex number")

		. += num * place
		place *= 16