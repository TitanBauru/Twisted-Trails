repeat(2)instance_create_layer(x + random_range(-12,12), y + random_range(-12,12), "Bloom", obj_pop, { width: irandom_range(2, 16), lerpval : .5 });
spark(x, y, 10, direction - 180, 40, 4, .9, c_white, c_white, 4, 0);
//audio_play_sound(snd_hit_solid, 0, false, , , random_range(.6, .8));