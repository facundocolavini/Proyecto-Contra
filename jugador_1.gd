 extends Position2D

var velocidad = Vector2()
export (float) var gravedad = 500
export (float) var vel_movimiento = 25
export (float) var vel_salto = 25
var puede_saltar = false
var esta_en_el_agua = false 
func _ready():
	pass
	
	#Movimiento del personaje
	
func _physics_process(delta): #Actualiza el sprite la posicion del jugador		
	
	velocidad.y += gravedad * delta
	#Correr para los costados
	if(Input.is_action_pressed("tecla_a") ):
		velocidad.x =  -vel_movimiento
		get_node("cuerpo_j1/spr_j1").flip_h = false
		if(Input.is_action_just_pressed("tecla_w") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").play("j1_diagar")
		elif(Input.is_action_just_pressed("tecla_s") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").play("j1_diagab")
		elif(Input.is_action_just_released("tecla_w") && (puede_saltar) && !esta_en_el_agua || Input.is_action_just_released("tecla_s") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").stop()
		elif(!get_node("animacion_j1").is_playing() && (puede_saltar)):
			if (!esta_en_el_agua):#si no estoy en el agua
				get_node("animacion_j1").play("j1_corriendo")
			else: 
				get_node("animacion_j1").play("j1_watermove")
				
	#Si presiono la tecla D
	elif(Input.is_action_pressed("tecla_d")):
		velocidad.x = vel_movimiento
		get_node("cuerpo_j1/spr_j1").flip_h = true	
		if(Input.is_action_just_pressed("tecla_w") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").play("j1_diagar")
		elif(Input.is_action_just_pressed("tecla_s") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").play("j1_diagab")	
		elif(Input.is_action_just_released("tecla_w") && (puede_saltar) && !esta_en_el_agua || Input.is_action_just_released("tecla_s") && (puede_saltar) && !esta_en_el_agua):
			get_node("animacion_j1").stop()	
		elif(!get_node("animacion_j1").is_playing() && (puede_saltar)):
			if (!esta_en_el_agua):
				get_node("animacion_j1").play("j1_corriendo")
			else: 
				get_node("animacion_j1").play("j1_watermove")
			
	elif(Input.is_action_pressed("tecla_s") && (puede_saltar)):	
			if(puede_saltar):
				if(!esta_en_el_agua):#cuerpo a tierra		
					get_node("animacion_j1").play("j1_agachado")
				else: #bajo el agua
					get_node("animacion_j1").play("j1_underwater")	
			velocidad.x = 0	
	elif(Input.is_action_pressed("tecla_w") && (puede_saltar)):	
			if(puede_saltar && !esta_en_el_agua):			
				get_node("animacion_j1").play("j1_haciaarriba")
			velocidad.x = 0
				
	else:
		velocidad.x = 0
		if(puede_saltar):
			if(!esta_en_el_agua):
				get_node("animacion_j1").play("j1_idle")
			else:
				get_node("animacion_j1").play("J1_water")
		
	#Salto
	if(Input.is_action_pressed("tecla_space") && (puede_saltar)):
		#evito el salto doble
		velocidad.y= - vel_salto	
		get_node("animacion_j1").play("j1_salto")
		puede_saltar = false
			
	
	var desplazamiento = velocidad * delta
	get_node("cuerpo_j1").move_and_slide(desplazamiento)
	
	#Los collider colisionadores Agrego colision a un cuerpo
	#si el objeto colisiona y existe esa colision
	if(get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1) != null):#si  mi cuerpo esta colisionando detecta si es un suelo
		var obj_colisionado = get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1).collider	
		#Seleciono la etiqueta para el obj saber a que pertenece ese objeto colisionador
		if(obj_colisionado.is_in_group("suelo")):
			if(puede_saltar == false): #SI ESTA TOCANDO EL SUELO
				puede_saltar = true
				get_node("animacion_j1").stop()
				if(obj_colisionado.is_in_group("agua")): #Y SI ADEMAS ESTA TOCANDO EL AGUA
					esta_en_el_agua = true
				else:#sino esta colisionando 
					esta_en_el_agua = false
	elif(puede_saltar):#esta en el aire  se desactiva 
		puede_saltar = false
					
					
	
	
	
	