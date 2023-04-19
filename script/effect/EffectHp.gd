extends Node2D

signal addHpSignal(node: Node2D, other)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect('body_entered', Callable(self, 'onHpEntered'))
	$Area2D/AnimatedSprite2D.play()

func onHpEntered(other_body):
	emit_signal('addHpSignal', self, other_body)
