
varying vec2 v_vTexcoord;

// >> uniforms
uniform float u_maskPower;
uniform float u_maskScale;
uniform float u_maskSmoothness;
uniform sampler2D u_maskTexture;

// >> dependencies
float MaskRadial(vec2 uv, vec2 center, float power, float scale, float smoothness) {
	float smoothh = mix(scale, 0.0, smoothness);
	float sc = scale / 2.0;
	float mask = pow(1.0-clamp((length(uv-center)-sc) / ((smoothh-0.001)-sc), 0.0, 1.0), power);
	return mask;
}

void main() {
	float mask = MaskRadial(v_vTexcoord, vec2(0.5), u_maskPower, u_maskScale, u_maskSmoothness);
	gl_FragColor = mix(texture2D(gm_BaseTexture, v_vTexcoord), texture2D(u_maskTexture, v_vTexcoord), mask);
}
