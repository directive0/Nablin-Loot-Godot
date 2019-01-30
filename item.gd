extends Path2D

# state keeper
var state = "disabled"

# holds the location of our game elements that will be effected by the item
var level
var enemy
var hero
var fire
var stealth

var itemframe
var item
var timer
var timeremaining

var defdir = 1
var flipdir = -1
var posdef = 28
var posflip = -28
var throwpos
var staticpos

# hold location of point2d
var fallpos


var particlepos 
var particlestate = "disabled"

var splash = load("res://splash.tscn")

#hold the sprite object and the sprites location
var sprite
var lastlocation

func _ready():
	
	# store the level node (so we can tell it things, like to make a new bush)
	level = get_tree().get_nodes_in_group("level")[0]
	
	# get hero object and enemy
	hero = get_tree().get_nodes_in_group("player")[0]
	enemy = get_tree().get_nodes_in_group("enemy")[0]
	sprite = $PathFollow2D/Sprite
	# record where the default position of our throw arc is.
	staticpos = get_position()
	
	fallpos = $Position2D
	
	# get the itemframe object
	itemframe = get_tree().get_nodes_in_group("itemframe")[0]
	
	# record the default value of our timer.
	timer = $Timer.get_wait_time()
	
	#get the stealth bar
	stealth = get_tree().get_nodes_in_group("stealth")[0]

func _process(delta):
	# item is spawned at correct pos
	# when inactive state is disabled
	
	lastlocation = fallpos.get_global_position()
	
	# if the item is not thrown yet.
	if state == "disabled":
		reset()
		#pass

		particlepos = sprite.get_global_position()
	# when activated it determines what item it is, sets appropriate sprite, 
	# checks what direction we are facing and adjusts things
	if state == "assign":
		
		item = itemframe.use_item()
		


		
		if typeof(item) == TYPE_ARRAY:
			
			#update the stats
			if item[0] == "Pip":
				global.lastnight["pipused"] += 1
			if item[0] == "Flask":
				global.lastnight["flaskused"] += 1
			if item[0] == "Purse":
				global.lastnight["purseused"] += 1
			
			get_tree().get_nodes_in_group("score")[0].score -= item[1]
			sprite.set_texture(item[4])
			throwpos = get_global_position()
			state = "ready"
			$Timer.start()
			#checkfacing()
		else:
			state = "disabled"
		
	# once activated item follows path based on ratio of timeleft to time total.
	# if impacts barb effect triggered.
	if state == "ready":
		set_global_position(throwpos)
		visible = true
		var left = $Timer.get_time_left()
		var change = 1.0 - (left / timer)

		$PathFollow2D.set_unit_offset(change)
		
		visible = true
		
		if check_for_hit():
			particlepos = sprite.get_global_position()
			state = "hit"
		
		# once arc completed, set state keeper to "impact"
		if change == 1:
			state = "fell"
			visible = false
	
	# once hit check for impact.
	# if item has effects based on location of drop (pip/purse)
	# this is where they will go
	if state == "fell":
		
		if item[2] == 0: 
			effect()
		state = "disabled"
		
	if state == "hit":
		effect()
		state = "disabled"
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func check_for_hit(target = enemy):
	
	var itemcollider = $PathFollow2D/Sprite/Area2D
	var hit = false
	
	var object = target.find_node("standinghit")
	var thisobject = object.get_instance_id()

	var LapList = $PathFollow2D/Sprite/Area2D.get_overlapping_areas()
	var listlength = LapList.size()

	
	for i in range(listlength):
		if LapList[i].get_instance_id() == thisobject:
			hit = true

	return hit

func reset():
		# update spawn position to default (attached to nablin)
	set_position(staticpos)
	
	# flip the spawn point and arc horizontally based on movement
	#checkfacing()
	
	# keep the item hidden
	visible = false

func checkfacing():
	
	var facing = hero.get_facing()
	
	if facing == "right":
		set_scale(Vector2(defdir,1))
		set_position(Vector2(posdef,-7))
	if facing == "left":
		set_scale(Vector2(flipdir,1))
		set_position(Vector2(posflip,-7))

func grow_bush():
	pass

func particledraw():

	if particlestate == "disabled":
		pass
		#particletimer.stop()
		#particle.set_emitting(false)
	
	if particlestate == "initialize":
		var splasher = splash.instance()
		var stage = get_tree().get_nodes_in_group("stage")[0]
		splasher.set_global_position(particlepos)
		stage.add_child(splasher)
		#particle.set_global_position(particlepos)
		particlestate = "fire"
		

		
	if particlestate == "fire":
		pass
		#particle.set_global_position(particlepos)
		#particle.set_emitting(true)
		#particle.set_visible(true)

	
	
func effect():
	
	# if pip
	if item[2] == 0: 
		level.add_bush(lastlocation)
		
	# if purse
	if item[2] == 1:
		global.lastnight["purseused"] += 1

		enemy.hitstun()
		stealth.clear()

	# if flask
	if item[2] == 2:
		global.lastnight["flaskused"] += 1
		particlestate = "initialize"
		particledraw()
		enemy.magicstun()
		stealth.clear()
	
		# if mushroom
	if item[2] == 3:
		global.lastnight["mushroomused"] += 1

		enemy.mushhit()
		stealth.clear()
	
			# if orb
	if item[2] == 4:
		global.lastnight["orbused"] += 1
		particlestate = "initialize"
		
		stealth.clear()

	state = "disabled"
	
func use():
	if state == "disabled":
		state = "assign"