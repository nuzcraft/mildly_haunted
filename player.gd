extends KinematicBody

export(float) var speed = 7
export(int) var ACCEL_DEFAULT = 7
export(int) var ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
export(float) var gravity = 9.8
export(int) var jump = 5

export(int) var cam_accel = 40
export(float) var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head := $Head
onready var camera := $Head/Camera
onready var ray := $Head/Camera/RayCast
onready var message := $Message
onready var messageTimer := $MessageTimer
onready var animationPlayer := $AnimationPlayer
onready var crosshair := $Crosshair

var has_bedroom_key = false
var has_bathroom_key = false
var has_front_key = false

var bedroom_door_open = false
var bathroom_door_open = false
var front_door_open = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crosshair.hide()
	print(crosshair.visible)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
	if Input.is_action_just_pressed("select"):
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider.is_in_group("bedroom_door"):
				if not bedroom_door_open:
					if has_bedroom_key:
						Events.emit_signal("bedroom_door_open")
						bedroom_door_open = true
					else:
						set_message("bedroom door locked")
			if collider.is_in_group("bathroom_door"):
				if not bathroom_door_open:
					if has_bathroom_key:
						Events.emit_signal("bathroom_door_open")
						bathroom_door_open = true
					else:
						set_message("bathroom door locked")
			if collider.is_in_group("front_door"):
				if not front_door_open:
					if has_front_key:
						Events.emit_signal("front_door_open")
						front_door_open = true
					else:
						set_message("front door locked")
			if collider.name == "bedroom_key" or collider.is_in_group("bedroom_key"):
				has_bedroom_key = true
				collider.queue_free()
				set_message("found the bedroom key")
			if collider.name == "bathroom_key" or collider.is_in_group("bathroom_key"):
				has_bathroom_key = true
				collider.queue_free()
				set_message("found the bathroom key")
			if collider.name == "front_key" or collider.is_in_group("front_key"):
				has_front_key = true
				collider.queue_free()
				set_message("found the front door key")
				camera.add_shake(.25)

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
	show_interact_crosshair()
		
func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		snap = Vector3.ZERO
#		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	
func set_message(text):
	if messageTimer.time_left > 0:
		yield(messageTimer, "timeout")
#	if animationPlayer.is_playing():
#		yield(animationPlayer, "animation_finished")
	message.text = text
	messageTimer.wait_time = 3
	messageTimer.start()
	animationPlayer.play("Message_FadeIn")
	
func _on_MessageTimer_timeout():
	animationPlayer.play("Message_FadeOut")
	
func show_interact_crosshair():
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider:
			if collider.is_in_group("interactable"):
				if not crosshair.visible:
					animationPlayer.play("Crosshair_FadeIn")
				return
	if crosshair.visible:
		animationPlayer.play("Crosshair_FadeOut")
