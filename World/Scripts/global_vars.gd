extends Node

@export_range(8, 16) var player_throw_force: int = 16
@export_range(16, 32) var player_strength: int = 32

enum Quality_Levels{
	Debug = 0,
	Vile = 1,
	Trash = 10,
	Meh = 25,
	Mid = 50,
	Nice = 75,
	Esquicite = 90,
	Pure = 99
}

var quality_tiers: Array[String] = [
	"Debug",
	"Vile",
	"Trash",
	"Meh",
	"Mid",
	"Nice",
	"Esquicite",
	"Pure"
]
