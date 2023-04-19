extends AnimatableBody2D

var speed: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(onScreenExited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x = position.x - speed * delta

func onScreenExited():
	queue_free()
