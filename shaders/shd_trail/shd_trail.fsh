
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_color;

void main() {
	vec4 fragcol = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(u_color) * fragcol;
}
