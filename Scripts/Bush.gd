extends StaticBody2D

var IsTouched = false
var LapList = []
signal IsHiding
var latch = 0
var univ = 0
var decay = 5
var decay1 = 0
var decay2 = 0
var decay3 = 0


func _ready():
	var fullbush = load("res://bush.png")
	var halfbush = load("res://bush_half.png")
	var nobush = load("res://bush_bare.png")
	var stealth = get_parent().get_parent().get_node("stealth")
	var flipdecide = randi() % 2

	
	if flipdecide == 1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	decay1 = randi() % 1 + 0
	decay2 = randi() % 3 + 2
	decay3 = randi() % 5 + 4
	connect("IsHiding",stealth,"_on_Bush_IsHiding")
	
	mushrooms()
	

func mushrooms():
	var randomizer = 0
		
	if global.situation["night"] == 0:
		randomizer = 100
	if global.situation["night"] == 1:
		randomizer = 50
	if global.situation["night"] == 2:
		randomizer = 25
	
	var plantit = [0,0,0]
	
	for i in range(3):
		randomize()
		plantit[i] = randi() % randomizer
		#print("plantit = ", plantit[i])
	
	if plantit[0] == 1:
		pass
	else:
		$mushroom.queue_free()
	
	if plantit[1] == 1:
		pass
	else:
		$mushroom2.queue_free()
	
	if plantit[2] == 1:
		pass
	else:
		$mushroom3.queue_free()
			
func _process(delta):
	var object
	var hero = get_parent().get_node("Player")
	var thisobject
	var listlength 
	
	
	object = hero.find_node("stand")
	thisobject = object.get_instance_id()
	
	LapList = $Area2D.get_overlapping_areas()

	listlength = LapList.size()
	var nablinover = false
	for i in range(listlength):
		
		if LapList[i].get_instance_id() == thisobject:

			
			if decay > 0:
				emit_signal("IsHiding")
				nablinover = true
	
	if nablinover == true:
		latch = 1
		
	if latch == 1 and nablinover == false:

		latch = 0
		decay -= 1
		
		if decay > 0:
			$Particles2D.set_emitting(true)

	var fullbush = load("res://bush.png")
	var halfbush = load("res://bush_half.png")
	var nobush = load("res://bush_bare.png")

	if decay == decay1:
		$Sprite.set_texture(nobush)
	elif decay == decay2:
		$Sprite.set_texture(halfbush)
	elif decay == decay3:
		$Sprite.set_texture(fullbush)

