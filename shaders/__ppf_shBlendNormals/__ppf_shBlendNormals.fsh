
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	vec4 mainTex = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(mix(vec3(0.5, 0.5, 1.0), mainTex.rgb, v_vColour.a*mainTex.a), mainTex.a);
}
