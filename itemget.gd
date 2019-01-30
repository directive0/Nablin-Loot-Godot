extends Sprite

var timer
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	timer = get_node("boxtimer")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass

func get_item(sprite):
	$Sprite.set_texture(sprite)
	set_visible(true)
	#$Sprite.set_visible(true)
	timer.start()
	
func _on_Timer_timeout():
	set_visible(false)
	#$Sprite.set_visible(false)
	timer.stop()

