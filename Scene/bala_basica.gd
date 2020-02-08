extends KinematicBody2D
var id = 1 
var velocidad = Vector2()
export var potencia = 0

func _ready():
	velocidad.x = 0
	velocidad.y = 0 
	#Toma todos los suelos por excepcion de colision
	var todos_los_suelos = get_tree().get_nodes_in_group("suelo")
	#Excepciones con un ciclo recorriendo todos los suelos
	for suelo in todos_los_suelos:
		add_collision_exception_with(suelo)
	
	var s_invisible = get_tree().get_nodes_in_group("sinvisible")
	for suelo in s_invisible:
		add_collision_exception_with(suelo)
	
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		add_collision_exception_with(player)
		
	var balas = get_tree().get_nodes_in_group("bala")
	for player in balas:
		add_collision_exception_with(player)
		
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
		
	var puentes = get_tree().get_nodes_in_group("puente")
	for player in players:
		add_collision_exception_with(player)
		
func _physics_process(delta):
	var movimiento = velocidad * delta
	var obj_colisionado = move_and_collide(movimiento)
	
	if(obj_colisionado != null):
		obj_colisionado = obj_colisionado.collider
		if(obj_colisionado.is_in_group("enemigo")):
			if(obj_colisionado.is_in_group("boss")):
				obj_colisionado = obj_colisionado.get_parent()
			obj_colisionado.recibir_golpe(id)
			queue_free()
		elif(obj_colisionado.is_in_group("powerup")):
			obj_colisionado.explotar()
			queue_free()
			

		
func _on_VisibilityNotifier2D_screen_exited():
	print('salio de pantalla')
	queue_free() # elimina la bala que sale de la pantalla para liberar memoria y que no quede basura


