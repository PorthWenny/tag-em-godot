extends Sprite2D

var tilt_sensitivity: float = 2.0

func _ready():
	Input.set_use_accumulated_input(false)

func _process(delta):
	var accel = Input.get_accelerometer()

	var tilt_x = accel.y * tilt_sensitivity
	var tilt_y = -accel.x * tilt_sensitivity

	rotation = tilt_x

	# for skew, remove if needed to replace.
	# var transform_matrix = Transform2D(1, tilt_y, tilt_x, 1, position.x, position.y)
	# set_transform(transform_matrix)
