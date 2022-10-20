extends Spatial

onready var animationPlayer := $AnimationPlayer
onready var spookyAnimationPlayer := $SpookyAnimationPlayer
onready var player := $player
onready var bedroom_key := $keys/bedroom_key
onready var creakTimer := $CreakTimer
onready var spookyTimer := $SpookyTimer

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("bedroom_door_open", self, "_on_bedroom_door_open")
	Events.connect("bedroom_door_close", self, "_on_bedroom_door_close")
	Events.connect("bathroom_door_open", self, "_on_bathroom_door_open")
	Events.connect("bathroom_door_close", self, "_on_bathroom_door_close")
	Events.connect("front_door_open", self, "_on_front_door_open")
	Events.connect("front_door_close", self, "_on_front_door_close")
	SoundPlayer.play_music(SoundPlayer.MUSIC)
	randomizeCreakTimer()
	randomizeSpookyTimer()

func _on_bedroom_door_open():
	animationPlayer.play("bedroom_door_open")
	SoundPlayer.play_sound(SoundPlayer.DOOR_OPEN)

func _on_bedroom_door_close():
	animationPlayer.play("bedroom_door_close")
	SoundPlayer.play_sound(SoundPlayer.DOOR_CLOSE)

func _on_bathroom_door_open():
	animationPlayer.play("bathroom_door_open")
	SoundPlayer.play_sound(SoundPlayer.DOOR_OPEN)

func _on_bathroom_door_close():
	animationPlayer.play("bathroom_door_close")
	SoundPlayer.play_sound(SoundPlayer.DOOR_CLOSE)
	
func _on_front_door_open():
	animationPlayer.play("front_door_open")
	SoundPlayer.play_sound(SoundPlayer.DOOR_OPEN)

func _on_front_door_close():
	animationPlayer.play("front_door_close")
	SoundPlayer.play_sound(SoundPlayer.DOOR_CLOSE)

func _on_CreakTimer_timeout():
	rng.randomize()
	var creak_selected = rng.randi_range(1, 3)
	if creak_selected == 1:
		SoundPlayer.play_sound(SoundPlayer.CREAK1)
	elif creak_selected == 2:
		SoundPlayer.play_sound(SoundPlayer.CREAK2)
	elif creak_selected == 3:
		SoundPlayer.play_sound(SoundPlayer.CREAK3)
	randomizeCreakTimer()
	
func randomizeCreakTimer():
	rng.randomize()
	creakTimer.wait_time = rng.randf_range(25.0, 45.0)
	creakTimer.start()

func _on_SpookyTimer_timeout():
	rng.randomize()
	if spookyAnimationPlayer.is_playing():
		yield(spookyAnimationPlayer, "animation_finished")
	var spooki_selected = rng.randi_range(1, 4)
	if spooki_selected == 1:
		spookyAnimationPlayer.play("knock_lamp")
#		SoundPlayer.play_sound(SoundPlayer.METAL_POT)
	elif spooki_selected == 2:
		spookyAnimationPlayer.play("move_books")
#		SoundPlayer.play_sound(SoundPlayer.BOOK_FLIP)
	elif spooki_selected == 3:
		spookyAnimationPlayer.play("soda_slide")
#		SoundPlayer.play_sound(SoundPlayer.METAL_POT)
	elif spooki_selected == 4:
		spookyAnimationPlayer.play("pizza_spin")
#		SoundPlayer.play_sound(SoundPlayer.DROP_LEATHER)
	randomizeSpookyTimer()
	
func randomizeSpookyTimer():
	rng.randomize()
	spookyTimer.wait_time = rng.randf_range(25.0, 45.0)
	spookyTimer.start()
		
