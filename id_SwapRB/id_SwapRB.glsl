// Premultiply (C)2015 Bob Maple
// bobm-matchbox [at] idolum.com

uniform sampler2D in_front;
uniform     float adsk_result_w, adsk_result_h;

void main(void) {

 vec4 px = vec4( texture2D( in_front, gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h ) ) );
 gl_FragColor = vec4( px[2], px[1], px[0], px[3] );

}