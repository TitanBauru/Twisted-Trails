
attribute vec3 in_Position; // (x,y,z)
attribute vec2 in_TextureCoord; // (u,v)

uniform vec2 u_texelSize;

varying vec2 v_vTexcoord;
varying vec2 v_vTexelSize;
varying vec4 v_vFragPosition;

vec4 calcPos(vec2 uv, vec2 texelSize) {
	return vec4(uv.xy, uv.xy - (texelSize.xy * 0.75));
}

void main() {
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
	v_vTexcoord = in_TextureCoord;
	v_vTexelSize = u_texelSize;
	v_vFragPosition = calcPos(in_TextureCoord, u_texelSize);
}
