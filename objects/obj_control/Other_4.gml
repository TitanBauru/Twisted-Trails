
global.quantidade_de_inimigos = instance_number(obj_dummy);	

omnicam_follow(obj_player, true)
omnicam_move_damped()
omnicam_limit(0, 0, room_width, room_height)