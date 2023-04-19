extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Start.connect("pressed", Callable(self, "startGame"))

func startGame():
	Main.changeScene(Main.SCENE.Game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
