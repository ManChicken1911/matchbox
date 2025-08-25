// id_Premultiply by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2025.08.25


uniform sampler2D  in_front, in_matte;
uniform     float  adsk_result_w, adsk_result_h;
uniform       int  op_mode;
uniform      vec3  bg_color;
uniform		 bool  do_clamp;

//

void main(void) {

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    vec4 px  = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).g );
	vec4 npx;

    if( op_mode == 1 )    // Premultiply
      npx = vec4( (px.rgb * px.a) + (bg_color * (1.0 - px.a)), px.a );

    else                  // Unpremultiply
      npx = vec4( ((px.rgb - (bg_color * (1.0 - px.a))) / px.a), px.a );

	gl_FragColor = do_clamp ? clamp( npx, 0.0, 1.0 ) : npx;
}
