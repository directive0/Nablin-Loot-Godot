extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var hero

func _ready():
	hero = get_tree().get_nodes_in_group("player")[0]
	visible = false
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if hero.isdead():
		visible = true
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_timer_timesup():
	set_text("Times Up")
	visible = true
	pass # replace with function body


func _on_Area2D_input_event(viewport, event, shape_idx):
	print("hit!")
	pass # Replace with function body.
