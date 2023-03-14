extends Node2D

@onready var camera2d: Camera2D = $Camera2D
@onready var bird: RigidBody2D = $Bird

# @onready var background: Node2D = $Backgrounds
@onready var pipes: Node2D = $Pipes

signal end_game(point: int)

var pipeInterval: int = 150
var pipeCount: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(30):
		createPipe()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera2d.position.x = bird.position.x - 90
	var count = int(bird.position.x) / 1152
	# background.position.x = count * 1152
	if (bird.hp < 0):
		emit_signal("end_game", bird.point)

func createPipe():
	var createPositionX = pipeCount * pipeInterval
	var createPositionY = randf_range(120, 320)
	
	var pipeResource = preload("res://scene/Pipe.tscn")
	var newPipe = pipeResource.instantiate()
	newPipe.position.x = createPositionX
	newPipe.position.y = createPositionY
	newPipe.name = String.num_int64(pipeCount)
	pipes.add_child(newPipe)
	
	newPipe.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(onPipeScreenExited.bind(newPipe))
	newPipe.get_node("Coin").connect("body_entered", Callable(self, "onBirdEntered"))
	
	pipeCount = pipeCount + 1
	

func onPipeScreenExited(exitedPipe: Node2D):
	exitedPipe.queue_free()
	createPipe()

func onBirdEntered(otherBody):
	if (otherBody == bird):
		$Bird/point.play()
		bird.point = bird.point + 1
