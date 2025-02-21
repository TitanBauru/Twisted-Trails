/// @description Insert description here
// You can write your code in this editor
if (cooldown_hit > 0) cooldown_hit--;
resetar_escala();


var current_t = current_time;
var window = 1000;
var damage_sum = 0;
var count = ds_list_size(damage_events);
for (var i = count - 1; i >= 0; i--) {
    var event = damage_events[| i];
    if (current_t - event[1] > window) {
        ds_list_delete(damage_events, i);
    } else {
        damage_sum += event[0];
    }
}
var dps_instant = damage_sum / (window / 1000);

    dummy_dps = dps_instant

switch(estado)
{
	case "Idle":
	{
		velh = lerp(velh,0,.1)
		velv = lerp(velv,0,.1)
		sprite_index = spr_dummy_idle
		break;
	}
	
	case "Hurt":
	{
		
		if (sprite_index != spr_dummy_hit)
        {
			ajustar_direcao_para_target(obj_player.x);
			repeat(8) instance_create_layer(x+random_amp(8),y+random_amp(8),"Sangue",obj_blood)
			repeat(8) instance_create_layer(x+random_range(-12,12), y+random_range(-12,12), "Bloom", obj_pop, { width: irandom_range(2, 12), lerpval : .9 });
			repeat(irandom(16)) spark(x, y, random(10), random(360), 120, 8, .9, c_white, c_white,2, 0);
			repeat(random_range(10,20)) 
			{
				var poeira = instance_create_layer(x,y-8,"Instances",obj_dustwalk)
				 poeira.speed = random(1);
				 poeira.direction = random(360);
			}
			repeat(irandom(3)) instance_create_layer(x+random_range(-12,12), y+random_range(-12,12),"Bloom",obj_vfx_1);
            instance_create_layer(x, y,"Bloom",obj_vfx_2);
			sprite_index = spr_dummy_hit;
            image_index = 0;
            aplicar_squish_and_stretch();
			
        }
		
		if (image_index >= image_number - 1)
		{
			estado = "Idle";	
		}
		break;
	}
}

depth = -bbox_bottom