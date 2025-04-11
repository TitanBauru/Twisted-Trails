
 // Stackin
 
image_angle  += random(10) 
//var scale = sin(get_timer()/500000) 
//image_xscale = scale
//image_yscale = scale
direction = image_angle
		//_trail.valor = valor;
	
if (tempo_max_player)
{
	direction = point_direction(x,y, obj_player.x,obj_player.y);	
}
	
if tempo_max = true
{
	randomize();
	//x = obj_player.x
	//y = obj_player.y
	var dir = point_direction(x,y, obj_player.x,obj_player.y - 8);
	var acel = 1;
	motion_add(dir,acel);
}


if (distance_to_object(obj_player) < 10 && tempo_max_player)
{
	
	instance_destroy(trail_dash);
	instance_destroy();
	
	obj_player.pode_dash_player += 1
}
