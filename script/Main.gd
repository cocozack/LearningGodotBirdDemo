extends Node2D

@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

var sceneMap = {
}

# Called when the node enters the scene tree for the first time.
func _ready():
	home()
	$swoosh.play()
	transitionAnimation.play('fade-in')
	await transitionAnimation.animation_finished
	
func changeScene(scene: SCENE):
	var scenePath = sceneMap[scene]
	if scene == SCENE.Over:
		$die.play()
	else:
		$swoosh.play()
	transitionAnimation.play_backwards("fade-in")

func home():
	var homeResource = preload("res://scene/Home.tscn")
	var home = homeResource.instantiate()
	add_child(home)
	$Home/Control/Start.connect("pressed", Callable(self, "startGame"))
	$swoosh.play()
	if get_node_or_null("Over") != null:
		$Over.queue_free()

func startGame():
	var gameResource = preload("res://scene/Game.tscn")
	var game = gameResource.instantiate()
	add_child(game)
	
	game.end_game.connect(endGame)
	
	$Home.queue_free()
	
	$swoosh.play()
	
func endGame(point: int):
	var overResource = preload("res://scene/Over.tscn")
	var over = overResource.instantiate()
	add_child(over)
	$Over/Control/Score.text = String.num_int64(point)
	$Over/Control/Menu.connect("pressed", Callable(self, "home"))
	$Game.queue_free()
	
	$die.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
