
attribute vec3 in_Position; // (x,y,z)
attribute vec4 in_Colour; // (r,g,b,a)
attribute vec2 in_TextureCoord; // (u,v) unused

varying vec4 v_vColour;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position.xyz, 1.0);
	v_vColour = in_Colour;
}
