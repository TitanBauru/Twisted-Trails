/// @description Insert description here
// You can write your code in this editor
repeat(6)
{
	with(instance_create_depth(x,y,depth-1,obj_impacto_vfx))
	{
		debri = false
		image_angle = random(360)
		fric = .8
		
		motion_add(obj_weapon.image_angle+random_range(-70,70),random_range(-4,-9))
	}
}

repeat(5)
	{
		
		with(instance_create_depth(x,y,depth-1,obj_impacto_vfx))
		{
			debri = true
			image_index = random(image_number-1)
			image_speed = 0;
			image_angle = direction;
			sprite_index = spr_debri
			fric = .8
			
			motion_add(obj_weapon.image_angle+random_range(-40,40),random_range(-1,-6))
		}
	}
	
instance_destroy();	