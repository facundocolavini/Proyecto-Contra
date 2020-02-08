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
		
	var balas = get_tree().get_nodes_in_group("bala")
	for player in balas:
		add_collision_exception_with(player)
		
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	
	var puentes = get_tree().get_nodes_in_group("puente")
	for puente in puentes:
		add_collision_exception_with(puente)
	
	for i in 3: #omito la colision entre las balas
		get_node("1").add_collision_exception_with(get_node(String(i+1)))
		get_node("2").add_collision_exception_with(get_node(String(i+1)))
		get_node("3").add_collision_exception_with(get_node(String(i+1)))
		var players = get_tree().get_nodes_in_group("player")
		for player in players:
			get_node(String(i+1)).add_collision_exception_with(player)
		
func _physics_process(delta):
	rotation = velocidad.angle()
	var movimiento = velocidad * delta
	var obj_colisionado = []
	move_and_collide(movimiento)
	
	for i in 3: 
		if(get_node(String(i+1)) != null):
			obj_colisionado.append(get_node(String(i+1)).move_and_collide(movimiento))
			if(obj_colisionado[i] != null):
				obj_colisionado[i] = obj_colisionado[i].collider
				if(obj_colisionado[i].is_in_group("enemigo")):
					if(obj_colisionado[i].is_in_group("boss")):
						obj_colisionado[i] = obj_colisionado[i].get_parent()
					obj_colisionado[i].recibir_golpe(id)
					queue_free()
				elif(obj_colisionado[i].is_in_group("powerup")):
					obj_colisionado[i].explotar()
					queue_free()
			

		
func _on_VisibilityNotifier2D_screen_exited():
	print('salio de pantalla')
	queue_free() # elimina la bala que sale de la pantalla para liberar memoria y que no quede basura


