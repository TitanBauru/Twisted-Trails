
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2022 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vPosition;
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordRender;
varying vec4 v_vColour;

uniform sampler2D u_renderTexture;

void main() {
	gl_FragColor = vec4(texture2D(u_renderTexture, v_vTexcoordRender).rgb, texture2D(gm_BaseTexture, v_vTexcoord).a) * v_vColour;
}
