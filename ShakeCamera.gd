extends Camera

export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
#export (NodePath) var target  # Assign the node this camera will follow.

var shake_strength = 0.0  # Current shake strength.
var shake_power = 2  # shake exponent. Use [2, 3].

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func add_shake(amount):
	shake_strength = min(shake_strength + amount, 1.0)

func _process(delta):
#	if target:
#		global_position = get_node(target).global_position
	if shake_strength:
		shake_strength = max(shake_strength - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(shake_strength, shake_power)
	noise_y += 1
	var pitch = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	var yaw = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	var roll = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	set_rotation(Vector3(deg2rad(pitch),deg2rad(yaw),deg2rad(roll)))
