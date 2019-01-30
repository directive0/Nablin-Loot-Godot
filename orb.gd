extends Node
var player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("itemframe")[0]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):

	player.pickup("orb")
	queue_free()
	

func _on_Area2D_area_entered(area):

	player.pickup("orb")
	queue_free()
	pass # Replace with function body.
