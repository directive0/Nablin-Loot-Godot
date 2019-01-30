extends Label

var score = 0
var pretext = "Score: "
var fulltext

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
#	pass

func _process(delta):
	fulltext = pretext + str(global.situation["score"])
	set_text(fulltext)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
