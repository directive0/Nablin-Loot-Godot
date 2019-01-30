extends AnimatedSprite
var fadedone = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	visible = false
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	fadedone = get_parent().fade_done
	if fadedone == true:
		visible = true
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
