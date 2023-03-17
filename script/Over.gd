extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Menu.connect("pressed", Callable(self, "home"))
	$Control/Score.text = String.num_int64(Main.score)
	$Control/Best.text = String.num_int64(Main.highestScore)

func home():
	Main.changeScene(Main.SCENE.Home)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
