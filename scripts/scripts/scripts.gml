global.area = 0;
randomize()
#macro CRIA_PAREDE instance_create_layer(x, y, "Instances", obj_colisor)

function Item_Creator(_chest)
{		
	if(instance_exists(obj_player))
	{
		var _playerDist = point_distance(x, y, obj_player.x, obj_player.y);
		var _colisao = collision_circle(x, y, 24, obj_colisor, false, false);
		var _dist = 96;

		
		if(_playerDist > _dist && !_colisao)
		{
			instance_create_layer(x, y, "Instances", _chest);	
		}		
	}		
}
function Cria_Dois(_obj1, _obj2)
{		
	if(instance_exists(obj_player))
	{
		var _playerDist = point_distance(x, y, obj_player.x, obj_player.y);
		var _colisao = collision_circle(x, y, 24, obj_colisor, false, false);
		var _dist = 96;

		
		if(_playerDist > _dist && !_colisao)
		{
			instance_create_layer(x-16, y, "Instances", _obj1);	
			instance_create_layer(x+16, y, "Instances", _obj2);	
		}		
	}		
}

function Drunken_Walk_Improved(steps, walker_count, dir_repeats)
{
    randomize();
    var _size = 32;
    var _x = room_width div _size;
    var _y = room_height div _size;
    for(var i = 0; i < _x; i += 1)
    {
        for(var j = 0; j < _y; j += 1)
        {
            instance_create_layer(_size*i, _size*j, "vacuo", obj_vacuo);
        }
    }
    for(var w = 0; w < walker_count; w += 1)
    {
        var _wx = irandom_range(3*_size, (_x-6)*_size);
        var _wy = irandom_range(3*_size, (_y-6)*_size);
        var walker = instance_create_layer(_wx, _wy, "vacuo", obj_walker);
    }
    repeat(steps)
    {
        with(obj_walker)
        {
            if(irandom_range(1, dir_repeats) == 1)
            {
                direction = irandom(3)*90;
            }
            x += lengthdir_x(32, direction);
            y += lengthdir_y(32, direction);
            var col = instance_place(x, y, obj_vacuo);
            if(col) { instance_destroy(col); }
            x = clamp(x, 3*32, (_x - 6)*32);
            y = clamp(y, 3*32, (_y - 6)*32);
            
        }
    }
}

function get_attack_direction(){
	var _dir = point_direction(obj_player.x, obj_player.y, mouse_x, mouse_y); // Calcula a direção com base no mouse
   
	return _dir;
}

