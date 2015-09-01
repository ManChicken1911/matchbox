// Premultiply (C)2015 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D  in_front, in_matte;
uniform     float  adsk_result_w, adsk_result_h;
uniform       int  op_mode;
uniform      vec3  bg_color;

//

void main(void) {

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv  = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );
    vec4 px  = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).g );

    if( op_mode == 1 )
      gl_FragColor = vec4( (px.rgb * px.a) + (bg_color * (1.0 - px.a)), px.a );    // Premultiply
    else
      gl_FragColor = vec4( ((px.rgb - (bg_color * (1.0 - px.a))) / px.a), px.a );  // Unpremultiply

}
