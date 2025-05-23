
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
	gl_FragColor = vec4(0.0, 0.0, 0.0, (col.r+col.g+col.b)/3.0);
}
