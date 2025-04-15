///@desc
randomize();

alarm[0] = 6;
pode_rodar = true
alarm[1] = 60
image_speed = 0;
image_index = random(12)

create_prop = true

//TODO mano pq caralhos tem OITO INSTÂNCIAS DISSO SENDO CRIADAS NO MESMO LUGAR
if (place_meeting(x, y, object_index)) {
	instance_destroy()
}


inimigo_qtd_max = 30;

spawna = true;
_a = 0;
global.dungeon = 1


inimigo[0] = choose(obj_dummy);
//inimigo[1] = choose(obj_inimigo_1, obj_inimigo_2);
//inimigo[2] = choose(obj_inimigo_1, obj_inimigo_2, obj_inimigo_3);
//inimigo[3] = obj_boss;




