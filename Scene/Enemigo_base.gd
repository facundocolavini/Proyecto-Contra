extends KinematicBody2D

var velocidad = Vector2()
export (float) var gravedad = 100
export (float) var vel_movimiento = 25
export (float) var vel_salto = 25
enum estados {corriendo , saltando, cayendo}
var estado_actual = estados.cayendo
var habilitado  = true
var puede_saltar = true
var ultimo_punto = Vector2()
export var vidas = 0
export var puntos = 0

func _ready():
	get_node("AnimationPlayer").play("enem_run")
	var powerupabiertos = get_tree().get_nodes_in_group("powerup_abierto")
	for powerupabierto in powerupabiertos:
		add_collision_exception_with(powerupabierto)
		
	
	#Posicion del personaje 
func _physics_process(delta):
	if (habilitado):
		velocidad.y += gravedad * delta
		
		
			
		#Movimiento laterales del enemigo
		if (!get_node("Sprite").flip_h):
			velocidad.x = -vel_movimiento
		else:
			velocidad.x = vel_movimiento	
			

		
		if(!test_move(transform ,Vector2(0,1)) && estado_actual != estados.saltando && estado_actual != estados.cayendo) && puede_saltar:#Detecta el proximo movimiento del enemigo aver si ahy precipisios
			if(rand_range(0,10) < 4):
				estado_actual = estados.saltando
				get_node("AnimationPlayer").play("enem_salto")
				if(velocidad.y > 0):
					velocidad.y = -vel_salto
				puede_saltar = false
			else:	
				estado_actual = estados.cayendo
				get_node("Sprite").flip_h = !get_node("Sprite").flip_h
				velocidad.x = 0
				global_position = ultimo_punto
				if(get_node("Sprite").flip_h):
					global_position.x += 1
				else:
					global_position.x -= 1
				puede_saltar = false
			yield(get_tree().create_timer(0.5), "timeout")
			puede_saltar = true
		else:
			#Desplaza el sprite del enemigo 
			velocidad.y += gravedad * delta
			var movimiento = velocidad * delta
			move_and_slide(movimiento)
			
		if(get_slide_collision(get_slide_count()-1) != null):#si estoy colisionando con un suelo y no es nulo
			var objeto_colisionado= get_slide_collision(get_slide_count()-1).collider
			if(objeto_colisionado != null):
				if (objeto_colisionado.is_in_group("suelo")):
					if(estado_actual != estados.corriendo):
						estado_actual = estados.corriendo
						if(velocidad.y > 0):
							get_node("AnimationPlayer").play("enem_run")
						if(objeto_colisionado.is_in_group("agua")):
							muerte_enemigo()
					else:
						ultimo_punto = global_position
				elif(objeto_colisionado.is_in_group("bala")):
					var padre =  objeto_colisionado.get_parent()
					if(padre.is_in_group("main") || padre.is_in_group("nivel")):
						recibir_golpe(objeto_colisionado.id)
					else:
						recibir_golpe(padre.id)
					objeto_colisionado.queue_free()
				elif (objeto_colisionado.is_in_group("player")):#Si ell enemigo toca am i personaje muere
					objeto_colisionado.get_parent().muerte_player()
				elif (objeto_colisionado.is_in_group("enemigo")):
					get_node("Sprite").flip_h = !get_node("Sprite").flip_h

func recibir_golpe(var id):
	vidas -= 1
	if(vidas < 1):
		muerte_enemigo()
		if(id == 1):
			game_handler.puntaje_j1 += puntos
		elif(id == 2):
			game_handler.puntaje_j2 += puntos

func muerte_enemigo():
	get_node("muerte").play()
	habilitado = false
	get_node("CollisionShape2D").queue_free()
	get_node("AnimationPlayer").play("enem_explos")
	yield(get_node("AnimationPlayer"),"animation_finished")	#recibe 2 parametros va a esperar hasta que la animacion termine
	queue_free()
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.
