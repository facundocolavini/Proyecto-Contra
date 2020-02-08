extends KinematicBody2D
var id = 1 
var velocidad = Vector2()
export var potencia = 0
export var vel_rotacion = 1

func _ready():
	velocidad.x = 0
	velocidad.y = 0 
	#Toma todos los suelos por excepcion de colision
	var todos_los_suelos = get_node("1").get_tree().get_nodes_in_group("suelo")
	#Excepciones con un ciclo recorriendo todos los suelos
	for suelo in todos_los_suelos:
		get_node("1").add_collision_exception_with(suelo)
	
	var s_invisible = get_node("1").get_tree().get_nodes_in_group("sinvisible")
	for suelo in s_invisible:
		get_node("1").add_collision_exception_with(suelo)
	
	var players = get_node("1").get_tree().get_nodes_in_group("player")
	for player in players:
		get_node("1").add_collision_exception_with(player)
		
	var balas = get_node("1").get_tree().get_nodes_in_group("bala")
	for player in balas:
		get_node("1").add_collision_exception_with(player)
		
	var powerupabiertos = get_node("1").get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		get_node("1").add_collision_exception_with(powerupabierto)
	
	var puentes = get_tree().get_nodes_in_group("puente")
	for puente in puentes:
		add_collision_exception_with(puente)
		
func _physics_process(delta):
	rotate(vel_rotacion / delta)
	var movimiento = velocidad * delta
	move_and_collide(movimiento)
	var obj_colisionado
	
	if(get_node("1") != null):
		obj_colisionado = get_node("1").move_and_collide(movimiento)
	
	if(get_node("1") != null):
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


