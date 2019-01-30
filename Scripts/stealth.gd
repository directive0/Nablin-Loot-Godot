extends TextureProgress

# class member variables go here, for example:
# var a = 2
var hero
var enemy
var herovect
var enemyvect

var noisestandard = 10.0
var noisescaled

signal Awake

func _ready():
	hero = get_parent().get_node("YSort/Player")
	enemy = get_parent().get_node("YSort/Barbarian")

	# Called every time the node is added to the scene.
	# Initialization here

	
	

func _process(delta):
	
	var distance = get_distance()
	
	var distanceadjust = (distance / 800)
	
	value -= 1
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_distance():
	enemyvect = enemy.get_global_position()
	herovect = hero.get_global_position()
	var distance = herovect.distance_to(enemyvect)

	return distance

func _on_Player_moving():
	
	var distance = get_distance()

	var distanceadjust = (distance / 800)
	#print(distanceadjust)
	var noise2 = (10.0 * distanceadjust)
	#print(noise2)
	
	noisescaled = noisestandard - noise2 

	#print(noisescaled)
	value += noisescaled
	
	if value >= 1000:
		emit_signal("Awake")

func clear():
	value = 0
	
func get_value():
	return value

func _on_Bush_IsHiding():
	value -= 10
	pass # replace with function body
