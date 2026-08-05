extends Node
class_name Item_Dictionary

###################################

enum ITEM_ID {
	empty = 0,
	apple = 1,
	banana = 2,
	burger = 3,
	l_bottle = 4,
	s_bottle = 5
}

###################################


var ITEM_DATA: Array[Dictionary] = [
	{
	"item_name" = "empty",
	"item_path" = null
	},
	{
	"item_name" = "apple",
	"item_path" = preload("uid://be0q082q2raxi")
	},
	{
	"item_name" = "banana",
	"item_path" = preload("uid://ck5i6ran7uqye")
	},
	{
	"item_name" = "burger",
	"item_path" = preload("uid://capor1xdafw18")
	},
	{
	"item_name" = "l_bottle",
	"item_path" = preload("uid://d2y7g0nse2h6o")
	},
	{
	"item_name" = "s_bottle",
	"item_path" = preload("uid://8fk5q252us21")
	}
]	
