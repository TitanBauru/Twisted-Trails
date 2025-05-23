
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	col.y = 1.0-col.y;
	gl_FragColor = col * v_vColour;
}
