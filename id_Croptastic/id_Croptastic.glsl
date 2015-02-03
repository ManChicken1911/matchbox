// Croptastic (C)2015 Bob Maple
// bobm-matchbox@idolum.com

uniform sampler2D  in_front, in_matte;
uniform	    float  crop_l, crop_r, crop_t, crop_b;
uniform      vec2  crop_tl, crop_br, offset_xy;
uniform     float  adsk_result_w, adsk_result_h;
uniform      bool  border;
uniform      vec3  border_color;
uniform     float  border_size, border_trans;

//

void main(void) {

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv = (gl_FragCoord.xy - offset_xy) / vec2( adsk_result_w, adsk_result_h );
    vec4 px = vec4( texture2D( in_front, uv ).rgb, texture2D( in_matte, uv ).g );

    if( gl_FragCoord.x < crop_l )
        px = vec4(0.0, 0.0, 0.0, 0.0);
    if( gl_FragCoord.x > adsk_result_w - crop_r )
        px = vec4(0.0, 0.0, 0.0, 0.0);

    if( gl_FragCoord.y > adsk_result_h - crop_t )
        px = vec4(0.0, 0.0, 0.0, 0.0);
    if( gl_FragCoord.y < crop_b )
        px = vec4(0.0, 0.0, 0.0, 0.0);

    if( border ) {

        if( (gl_FragCoord.x >= crop_l && gl_FragCoord.x <= crop_l + border_size) || (gl_FragCoord.x <= (adsk_result_w - crop_r) && gl_FragCoord.x >= (adsk_result_w - crop_r) - border_size) )
            if( gl_FragCoord.y >= crop_b && gl_FragCoord.y <= adsk_result_h - crop_t )
                px = vec4( mix( px, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );

        if( (gl_FragCoord.y >= crop_b && gl_FragCoord.y <= crop_b + border_size) || (gl_FragCoord.y <= (adsk_result_h - crop_t) && gl_FragCoord.y >= (adsk_result_h - crop_t) - border_size) )
            if( gl_FragCoord.x >= crop_l + border_size && gl_FragCoord.x <= (adsk_result_w - crop_r) - border_size )
                px = vec4( mix( px, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );
    }

    gl_FragColor = px;
}
