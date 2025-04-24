
attribute vec3 in_Position; // (x,y,z)
attribute vec4 in_Colour; // (r,g,b,a)
attribute vec2 in_TextureCoord; // (u,v)

varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordRender;
varying vec4 v_vColour;

void main() {
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
	v_vTexcoordRender = (gl_Position.xy / gl_Position.w)*0.5+0.5;
	#ifdef _YY_HLSL11_
	v_vTexcoordRender.y = 1.0-v_vTexcoordRender.y;
	#endif
	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
}
