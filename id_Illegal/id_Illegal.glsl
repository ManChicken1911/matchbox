// Illegal (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_front, in_matte;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  showRed, showGreen, showBlue, showMatte;
uniform      vec3  colorOver, colorUnder;

vec3 adsk_rgb2yuv( vec3 );
vec3 adsk_yuv2rgb( vec3 );

//


void main(void) {

	// Convert pixel coords to UV position for texture2D
	// and fetch the input pixel into px

	vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
	vec4 px  = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).r );

	vec3 npx = px.rgb;
	float nmpx;

	if( showMatte )
		nmpx = 0.0;
	else
		nmpx = px.a;

	// Do something important

	vec3 rgbPx = adsk_yuv2rgb( adsk_rgb2yuv( px.rgb ) );

	if( showRed && rgbPx.r > 1.0 ) {
		npx = colorOver;
		if( showMatte ) nmpx = 1.0;
	}
	if( showGreen && rgbPx.g > 1.0 ) {
		npx = colorOver;
		if( showMatte ) nmpx = 1.0;
	}
	if( showBlue && rgbPx.b > 1.0 ) {
		npx = colorOver;
		if( showMatte ) nmpx = 1.0;
	}


	if( showRed && rgbPx.r < 0.0 ) {
		npx = colorUnder;
		if( showMatte ) nmpx = 1.0;
	}
	if( showRed && rgbPx.r < 0.0 ) {
		npx = colorUnder;
		if( showMatte ) nmpx = 1.0;
	}
	if( showRed && rgbPx.r < 0.0 ) {
		npx = colorUnder;
		if( showMatte ) nmpx = 1.0;
	}

	gl_FragColor = vec4( npx, nmpx );
}
