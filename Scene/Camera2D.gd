extends Camera2D

var final = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		if player.global_position.x > get_node("pos_x").global_position.x:
			var puede_avanzar = true
			for jugadores in players:
				if(jugadores.global_position.x < get_node("pos_x2").global_position.x):
					puede_avanzar = false
			if(puede_avanzar):
				global_position.x = player.global_position.x + 2
			elif(!final):
				player.global_position.x = get_node("pos_x").global_position.x - 1
		
	for player in players:
		if(player.global_position.x < get_node("pos_x2").global_position.x - 3):
			player.global_position.x = get_node("pos_x2").global_position.x + 1


func _on_VisibilityNotifier2D_screen_entered():
	final = true
