
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;

uniform vec4 u_TexOverlayTextureUVs;
uniform sampler2D u_TexOverlayTexture;
uniform float u_TexOverlayIntensity;
uniform float u_TexOverlayScale;
uniform int u_TexOverlayBlendMode;
uniform float u_TexOverlayCanDistort;
uniform float u_TexOverlayTiled;

// >> dependencies
uniform float u_lensDistortionEnable;
uniform float u_lensDistortionAmount;
vec2 ApplyLensDistortionUV(vec2 uv, float intensity) {
	vec2 uvCenter = vec2(0.5);
	vec2 dir = (uv - uvCenter);
	float polar = atan(dir.y, dir.x);
	float radius = length(dir);
	radius *= (1.0 + pow(radius, 2.0) * u_lensDistortionAmount * intensity);
	uv = uvCenter + radius * vec2(cos(polar), sin(polar));
	return uv;
}

#region Common

vec4 Blend(vec4 source, vec4 dest) {
	return dest * dest.a + source * (1.0-dest.a);
}

// blendmodes (c) 2015 Jamie Owen
vec3 BlendmodeAdd(vec3 src, vec3 dst) {
    return src + dst;
}

vec3 BlendmodeSubtract(vec3 src, vec3 dst) {
    return src - dst;
}

vec3 BlendmodeMultiply(vec3 src, vec3 dst) {
    return src * dst;
}

vec3 BlendmodeDivide(vec3 src, vec3 dst) {
    return src / dst;
}

vec3 BlendmodeColorBurn(vec3 src, vec3 dst) {
    return 1.0 - ((1.0 - dst) / max(src, 0.001));
}
#endregion

void main() {
	vec2 uv = v_vTexcoord;
	vec4 mainTex = texture2D(gm_BaseTexture, uv);
	
	// [d] lens distortion
	vec2 uvl = uv;
	if (u_lensDistortionEnable > 0.5) uvl = ApplyLensDistortionUV(uv, 1.0);
	
	// get texture
	vec2 uv2 = mix(uv, uvl, step(0.5, u_TexOverlayCanDistort));
	uv2 = (uv2 - 0.5) * (1.0-u_TexOverlayScale+1.0) + 0.5; // zoom
	uv2 = (u_TexOverlayTiled > 0.5) ? fract(uv2) : clamp(uv2, 0.0, 1.0);
	
	// blend
	vec4 sourceCol = mainTex;
	vec4 destCol = texture2D(u_TexOverlayTexture, mix(u_TexOverlayTextureUVs.xy, u_TexOverlayTextureUVs.zw, uv2));
	vec4 blendedCol = vec4(sourceCol.rgb, destCol.a);
	if (u_TexOverlayBlendMode == 0) {
		blendedCol = destCol;
	} else
	if (u_TexOverlayBlendMode == 1) {
		blendedCol.rgb = BlendmodeAdd(blendedCol.rgb, destCol.rgb);
	} else
	if (u_TexOverlayBlendMode == 2) {
		blendedCol.rgb = BlendmodeSubtract(blendedCol.rgb, destCol.rgb);
	}
	if (u_TexOverlayBlendMode == 3) {
		blendedCol.rgb = BlendmodeMultiply(blendedCol.rgb, destCol.rgb);
	} else
	if (u_TexOverlayBlendMode == 4) {
		blendedCol.rgb = BlendmodeDivide(blendedCol.rgb, destCol.rgb);
	} else
	if (u_TexOverlayBlendMode == 5) {
		blendedCol.rgb = BlendmodeColorBurn(blendedCol.rgb, destCol.rgb);
	}
	// add chroma key later...
	// texture overlay
	gl_FragColor = mix(sourceCol, Blend(sourceCol, blendedCol), u_TexOverlayIntensity);
}
