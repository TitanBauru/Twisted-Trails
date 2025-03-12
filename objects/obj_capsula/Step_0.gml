if (z > 0) {
    z += zspeed;
    zspeed += zgravity;
	if (rodando)image_angle+=random(40);
}
if (z < 0) {
    z = -z;
    zspeed = abs(zspeed) * 0.6 - 0.7
	
    if (zspeed < 1) {
        z = 0;
        zspeed = 0
		instance_destroy()
    }
}
