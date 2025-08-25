// id_Variables by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2025.08.25


uniform sampler2D passthru;
uniform float adsk_result_w, adsk_result_h;

//

void main(void) {

	// Pass the back input to the output, no alpha

	vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
	gl_FragColor = vec4( texture2D( passthru, uv ).rgb, 0.0 );
}
