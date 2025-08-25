// id_SwapRB by Bob Maple
// https://github.com/ManChicken1911/matchbox
// Version 2025.08.25

// Swaps the red and blue channels to fix broken material from some old versions
// of Resolve and possibly others


uniform sampler2D in_front;
uniform     float adsk_result_w, adsk_result_h;

//

void main(void) {

 vec4 px = vec4( texture2D( in_front, gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h ) ) );
 gl_FragColor = vec4( px[2], px[1], px[0], px[3] );

}
