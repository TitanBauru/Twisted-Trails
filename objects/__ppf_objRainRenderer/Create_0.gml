
// EXPERIMENTAL !!!

surfaceWidth = 0;
surfaceHeight = 0;
rainSurfaceA = -1;
rainSurfaceB = -1;
rainSurfaceSwap = false;

fadeClearAmount = 0.01;

rainTimer = 5;
rainTimerRange1 = 10;
rainTimerRange2 = 60;

raindropList = []; // array with structs

enableSmallDrops = false;


//surf_final = -1;
// 266 | 256 / 14641 (bm_src_color, bm_src_color, bm_src_color, bm_zero);
// 750 | 740 / 14641 (bm_src_color, bm_src_color, bm_dest_alpha, bm_zero);
//TESTT = 750;
//TESTT1 = 0;
//TESTT2 = 0;
//var _angle = (current_time*0.5) % 360;
//draw_sprite(__ppf_sprRainNormal, 0, mouse_x+lengthdir_x(20, _angle), mouse_y+lengthdir_y(20, _angle));
//gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
