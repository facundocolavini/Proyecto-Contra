extends KinematicBody2D

var velocidad = Vector2()
var velocidad_minibalas = Vector2()
export var potencia = 0
var id = 1 

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
	
	var puentes = get_tree().get_nodes_in_group("puente")
	for puente in puentes:
		add_collision_exception_with(puente)
		
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
	get_node("2").rotation_degrees = 22
	get_node("3").rotation_degrees = 44
	get_node("4").rotation_degrees = -22
	get_node("5").rotation_degrees = -44
	for i in 5: #omito la colision entre las balas
		get_node("1").add_collision_exception_with(get_node(String(i+1)))
		get_node("2").add_collision_exception_with(get_node(String(i+1)))
		get_node("3").add_collision_exception_with(get_node(String(i+1)))
		get_node("4").add_collision_exception_with(get_node(String(i+1)))
		get_node("5").add_collision_exception_with(get_node(String(i+1)))
		for suelo in todos_los_suelos:
			get_node(String(i+1)).add_collision_exception_with(suelo)		
		for suelo in s_invisible:
			get_node(String(i+1)).add_collision_exception_with(suelo)
		for player in players:
			get_node(String(i+1)).add_collision_exception_with(player)
				
func _physics_process(delta):
	var angulo = velocidad.angle()
	var movimiento = velocidad * delta
	move_and_collide(movimiento)
	var obj_colisionado = []
	for i in 5:
		if(get_node(String(i+1)) != null):
			velocidad_minibalas.x = potencia * cos(get_node(String(i+1)).rotation + angulo)
			velocidad_minibalas.y = potencia * sin(get_node(String(i+1)).rotation + angulo)
			movimiento = velocidad_minibalas * delta
			obj_colisionado.append(get_node(String(i+1)).move_and_collide(movimiento))

	
	for i in 5:
		if(get_node(String(i+1)) != null):
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
	queue_free()
