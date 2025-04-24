
/*---------------------------------------------------------------------------------
This object is nothing more than a sprite with normal map. Post-Processing FX will
distort the image according to the sprite. Be creative to do whatever you want with
this object (like apply a wave shader or movement?). :)
---------------------------------------------------------------------------------*/

// defined when created:
//animCurve = __ppf_acShockwave;
//scale = 1;
//spd = 1;
//image_index = 0;
image_speed = 0;
image_xscale = 0;
image_yscale = 0;

curveChannelScale = animcurve_get_channel(animCurve, 0);
curveChannelAlpha = animcurve_get_channel(animCurve, 1);
progress = 0;
