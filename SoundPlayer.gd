extends Node

const DOOR_OPEN := preload("res://sounds/doorClose_2.ogg")
const DOOR_CLOSE := preload("res://sounds/doorClose_1.ogg")
const DOOR_LOCKED := preload("res://sounds/metalClick.ogg")
const PICKUP_KEY := preload("res://sounds/handleCoins.ogg")
const FOOTSTEP := preload("res://sounds/footstep00.ogg")
const CREAK1 := preload("res://sounds/creak1.ogg")
const CREAK2 := preload("res://sounds/creak2.ogg")
const CREAK3 := preload("res://sounds/creak3.ogg")
const MUSIC := preload("res://sounds/Juhani Junkala - Post Apocalyptic Wastelands [Loop Ready].ogg")
const LAMP_DROP := preload("res://sounds/metalPot3.ogg")
const BOOK_MOVE := preload("res://sounds/drawKnife2.ogg")
const GHOST := preload("res://sounds/ghost.wav")

onready var audioPlayers := $AudioPlayers
onready var musicPlayers := $MusicPlayers

func play_sound(sound):	
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_music(sound):	
	for audioStreamPlayer in musicPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func stop_music():
	for audioStreamPlayer in musicPlayers.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stop()
