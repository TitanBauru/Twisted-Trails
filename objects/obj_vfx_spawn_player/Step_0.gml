x += lengthdir_x(spd,direction);
y += lengthdir_y(spd,direction);




//image_alpha = lerp(image_alpha,0,.01)
if (image_alpha <= .01) instance_destroy();

spd = lerp(spd,0,.02)

if (distancia <= .1 && explodi = false)
{
	spd = 3
	explodi = true
	if obj_player.visible != true
	{
		obj_player.visible = true
		alarm[0] = 30
		
	}
	
}

if (distancia <= 5 && explodi = false)
{
	global.aberracao_cromatica = random(20)	
	 instance_create_layer(x,y,"Player",obj_dustwalk)
	if (random(80) < 1)spark(x,y,20,direction,80,1,.8,c_white,c_white,25,0)
	obj_camera.camera.shake(1.1,1)
}

if (spd <= .2 && explodi = false)
{
	
	angulo		+= random_100;
	//image_angle = point_direction(x, y, player_x, player_y);
	
	novo_x		= lengthdir_x(distancia, angulo);
	novo_y		= lengthdir_y(distancia, angulo) * (1 - orbita);
	
	c			= cos(degtorad(offset));
	s			= sin(degtorad(offset));
	
	x			= player_x + novo_x * c + novo_y * s;
	y			= player_y + novo_y * c + novo_x * s;
	
	distancia = lerp(distancia,0,.020)
	_zoom = lerp(_zoom,4,.1)
	obj_camera.camera.zoom(_zoom,5)
	global.contraste = lerp(global.contraste,1.25,.0001)
	
}
else
{
	distancia	= point_distance(x,y,player_x,player_y) + 10
	_zoom = lerp(_zoom,.5,.8)
	obj_camera.camera.zoom(_zoom,1)
}

if (explodi = true && spd <= .5)
{
	image_xscale = lerp(image_xscale,0,.01)
	image_yscale = lerp(image_yscale,0,.01)
	obj_player.spawning = false
	if global.cancela_movimento != false
	{
		repeat(40){
			
			var dust = instance_create_layer(obj_player.x,obj_player.y,"Player",obj_dustwalk)
			dust.scale = 1
			dust.speed = random(2)
		}
		global.cancela_movimento = false
		shockwave_instance_create(obj_player.x,obj_player.y,layer_get_id("PPFX"),,3)	
	}
	obj_camera.camera.zoom(1,5)
	global.contraste = lerp(global.contraste,0,.001)
	
}

if (image_xscale <= .25 && explodi = true) 
{
	image_alpha-=.01;
}

if (image_alpha <= .1) instance_destroy();