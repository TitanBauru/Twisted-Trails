/// @description Insert description here
// You can write your code in this editor



// Create Event
drawMethod = function() {
    draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, angle, cor, alpha);

}

// Step or Draw event
crystal_pass_submit(CRYSTAL_PASS.COMBINE, drawMethod);



