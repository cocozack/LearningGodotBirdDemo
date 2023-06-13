extends Node

@onready var transitionAnimation: AnimationPlayer = $Transition/AnimationPlayer

enum SCENE { Home, Game, Over }
var sceneMap = {
	SCENE.Home: preload("res://scene/Home.tscn"),
	SCENE.Game: preload("res://scene/Game.tscn"),
	SCENE.Over: preload("res://scene/Over.tscn"),
}

var score: int = 0
var highestScore: int = 0

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	changeScene(SCENE.Home)
	
func changeScene(scene: SCENE):
	var scenePath = sceneMap[scene]
	if scene == SCENE.Over:
		$die.play()
	else:
		$swoosh.play()
	if scene != SCENE.Home:
		transitionAnimation.play_backwards("fade-in")
		await transitionAnimation.animation_finished
	get_tree().change_scene_to_packed(scenePath)
	transitionAnimation.play('fade-in')
	await transitionAnimation.animation_finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
