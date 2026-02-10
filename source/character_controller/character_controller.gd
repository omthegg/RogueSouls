extends Node3D

@onready var head:Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D

const HEAD_HEIGHT:float = 0.8
const CAM_TILT_ANGLE:float = 0.3
const CAM_TILT_SPEED:float = 2.0

var character:CharacterBody3D
var speed:float = 5.0
var jump_velocity:float = 4.5
var input_dir:Vector2 = Vector2.ZERO

func _ready() -> void:
	character = get_parent()
	head.position.y = HEAD_HEIGHT


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var ratio:float = float(get_window().size.y) / float(get_window().size.x)
		character.rotate_y(-event.relative.x * Settings.mouse_sens)
		head.rotate_x(-event.relative.y * Settings.mouse_sens * ratio)
		
		head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90.0, 90.0)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !character.is_on_floor():
		character.velocity += character.get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = jump_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction:Vector3 = (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		character.velocity.x = move_toward(character.velocity.x, direction.x * speed, speed * 10 * delta)
		character.velocity.z = move_toward(character.velocity.z, direction.z * speed, speed * 10 * delta)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed * 10 * delta)
		character.velocity.z = move_toward(character.velocity.z, 0, speed * 10 * delta)
	
	character.move_and_slide()


func _process(delta: float) -> void:
	tilt_camera(delta)
	head_bob(delta)


func tilt_camera(delta:float) -> void:
	camera.rotation_degrees.z = move_toward(camera.rotation_degrees.z, 
	CAM_TILT_ANGLE * -sign(input_dir.x), 
	CAM_TILT_SPEED * delta)


func head_bob(delta:float) -> void:
	var target_pos:Vector2 = Vector2.ZERO
	if input_dir.length() > 0.0:
		var t:float = Time.get_ticks_msec()/1000.0
		target_pos.y = -abs(sin(t*2.0*PI)) / 10.0
		target_pos.x = (cos(t*2.0*PI)) / 10.0
	
	if abs(character.velocity.y) > 0.1:
		target_pos = Vector2.ZERO
	
	camera.position.x = move_toward(camera.position.x, target_pos.x, 1.0 * delta)
	camera.position.y = move_toward(camera.position.y, target_pos.y, 1.0 * delta)
	
	#$Sprite2D.position = target_pos * 30.0
