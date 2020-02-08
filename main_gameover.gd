extends Node

var opcion_actual = 1

func _ready():
	if(game_handler.gano == false):
		get_node("AudioStreamPlayer").play()
	else:#si supero el nivel
		get_node("AudioStreamPlayer2").play()
	chequear_highscore()
	if(game_handler.jugadores == 2):
		get_node("GUI/Menu/txt_pp2").visible = true
		get_node("GUI/Menu/txt_player2").visible = true
		get_node("GUI/Menu/txt_pp2").text = String(game_handler.puntaje_j2)
	get_node("GUI/Menu/txt_pp1").text = String(game_handler.puntaje_j1)
	get_node("GUI/Menu/txt_ph").text = String(game_handler.highscore)
	 
	
func chequear_highscore():
	var puntaje_alto 
	if(game_handler.jugadores == 2):
		if(game_handler.puntaje_j1 > game_handler.puntaje_j2):
			puntaje_alto = game_handler.puntaje_j1
		else:
			puntaje_alto = game_handler.puntaje_j2 
	else:
		puntaje_alto = game_handler.puntaje_j1		
		
	if(puntaje_alto > game_handler.highscore):
		game_handler.highscore = puntaje_alto
			

func _physics_process(delta):
	if(Input.is_action_just_pressed("tecla_select")):
		cambiar_opcion()
	elif(Input.is_action_just_pressed("tecla_start")):
		if(opcion_actual == 1):
			get_tree().change_scene("res://Scene/main.tscn")
		else:
			game_handler.jugadores = 1
			get_tree().change_scene("res://Scene/main_menu.tscn")
		reset()
		
func cambiar_opcion():
	if(opcion_actual == 1):
		opcion_actual = 2
		get_node("GUI/Menu/cursor").global_position =  get_node("GUI/Menu/end").global_position
	else:
		opcion_actual = 1
		get_node("GUI/Menu/cursor").global_position =  get_node("GUI/Menu/continuar").global_position
		
func reset():
	game_handler.puntaje_j1 = 0
	game_handler.puntaje_j2 = 0
	game_handler.gano = false
	