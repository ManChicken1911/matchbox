// id_ShowAlpha (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_front, in_matte;
uniform     float  adsk_result_w, adsk_result_h;

void main(void) {

    // Convert pixel coords to UV position for texture2D
    // and fetch the input pixel into px

	vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
	vec4 px  = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).g );

    // Output the alpha channel as RGB

    gl_FragColor = vec4( px.a, px.a, px.a, 1.0 );
}
