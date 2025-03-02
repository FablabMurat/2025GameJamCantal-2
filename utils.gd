extends Node

func lowest_unused_int(list: Array[int]):
	for i in range(1, len(list)+2):
		if !i in list:
			return i
	return len(list)+1
