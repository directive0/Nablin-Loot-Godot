extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal firehit
var hero
var object
var thisobject
var LapList
var listlength
var hit


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	hero = get_parent().get_node("Player")
	pass
	

func check_for_hit():
	
	hit = false
	
	object = hero.find_node("stand")
	thisobject = object.get_instance_id()

	
	
	LapList = $Area2D.get_overlapping_areas()
	listlength = LapList.size()

	
	for i in range(listlength):
		if LapList[i].get_instance_id() == thisobject:
			hit = true
			
	return hit


func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	if check_for_hit():
		emit_signal("firehit")
	pass
