// VectorVictor (C) 2025 Bob Maple
// bobm-matchbox [at] idolum.com
//
// VER: 2025.07.23
//
// Inverts the the green (V) channel values to make motion vector passes from Lightwave 3D
// compatible with Motion Blur and StingRay Motion Blur nodes

uniform sampler2D in_front;
uniform     float adsk_result_w, adsk_result_h;

void main(void) {

 vec4 px = vec4( texture2D( in_front, gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h ) ) );
 gl_FragColor = vec4( px[0], (px[1] * -1.0) + 1.0, px[2], px[3] );

}
