extends Node2D

@onready var camera2d: Camera2D = $Camera2D
@onready var bird: RigidBody2D = $Bird

@onready var backgroundLand: Node2D = $Background/Land
@onready var pipes: Node2D = $Pipes

signal end_game(point: int)

var pipeInterval: int = 150
var pipeCount: int = 3

var isOver: bool = false

# 设置hp道具生成的概率
var hpItemGeneratedRate = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D/Control/HP.text = 'HP: ' + String.num_int64($Bird.hp)
	bird.hpChanged.connect(birdHpChangedEvent)
	
	for i in range(30):
		createPipe()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera2d.position.x = bird.position.x - 90
	var count = int(bird.position.x) / 1152
	backgroundLand.position.x = count * 1152
	if (!isOver && bird.hp <= 0):
		endGame(bird.point)

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
	
	# 在水管之间生成hp道具
	if (randf() <= 0.1):
		createItem(pipeCount * pipeInterval + pipeInterval / 2)
	
	pipeCount = pipeCount + 1


func onPipeScreenExited(exitedPipe: Node2D):
	exitedPipe.queue_free()
	createPipe()

func onBirdEntered(otherBody):
	if (otherBody == bird):
		$Bird/point.play()
		bird.point = bird.point + 1
		$Camera2D/Control/Point.text = 'Point: ' + String.num_int64(bird.point)

func endGame(point: int):
	isOver = true
	Main.score = point
	Main.highestScore = max(Main.highestScore, point)
	Main.changeScene(Main.SCENE.Over)

func birdHpChangedEvent(oldHp, newHp):
	$Camera2D/Control/HP.text = 'HP: ' + String.num_int64(newHp)
	
func onHpItemEntered(node: Node2D, otherBody):
	if (otherBody == bird):
		$Bird/hp.play()
		var oldHp = bird.hp
		bird.hp = oldHp + 1
		birdHpChangedEvent(oldHp, bird.hp)
		node.queue_free()

func createItem(posX):
	var createPositionY = randf_range(0, 512)
	
	var itemResource = preload("res://scene/effect/EffectHp.tscn")
	var newItem = itemResource.instantiate()
	newItem.position.x = posX
	newItem.position.y = createPositionY
	add_child(newItem)
	
	newItem.addHpSignal.connect(onHpItemEntered)
	
	newItem.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(onItemSrceenExited.bind(newItem))
	
func onItemSrceenExited(node: Node2D):
	node.queue_free()
	
