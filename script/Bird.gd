extends RigidBody2D

@export var speed: int = 100
@export var hp: int = 3
@export var gravityScale: float = 1.5

var point: int = 0

var screen_size

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	set_linear_velocity(Vector2(speed, 0))
	set_linear_damp(0)
	set_gravity_scale(gravityScale)
	
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
	connect("body_entered", Callable(self, "on_body_entered_event"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rotation < deg_to_rad(-30):
		rotation = deg_to_rad(-30)
		set_angular_velocity(0)
	if get_linear_velocity().y > 0:
		set_angular_velocity(3)
		
	if Input.is_action_just_pressed("ui_up"):
		set_linear_velocity(Vector2(speed, -200))
		set_angular_velocity(-3)
		set_gravity_scale(0)
		animated.play()
		$wing.play()
	
	if animated.frame == 2:
		animated.stop()
		animated.frame = 0
		set_gravity_scale(gravityScale)
		set_linear_velocity(Vector2(speed, get_linear_velocity().y))
	
	position.y = clamp(position.y, 0, screen_size.y)

func on_body_entered_event(enter_body):
	$hit.play()
	hp = hp - 1
