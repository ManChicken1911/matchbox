#!/usr/bin/php
<?php

// makeproxy by Bob Maple
// Version: 2026.0427
//
// Takes a PNG image and turns it into an Autodesk .p proxy
// Currently preferring images at 266x194

if( !extension_loaded("gd") )
	die( "This script requires the PHP gd extension with PNG support.\n" );

if( $argc < 2 )
	die( "\nUsage: makeproxy.php <png file>\n Hint: Recommend a 266x194 input image.\n\n" );

if( preg_match( "/(.*)\\.png/i", $argv[1], $matches ) )
	$outname = $matches[1];
else
	die( "Input isn't a .png file?\n" );

if( !file_exists( $argv[1] ) )
	die( "File not found " . $argv[1] . "\n" );

$proxy_img = @imagecreatefrompng( $argv[1] );

if( $proxy_img === false )
	die( "Error reading input file (is it really a PNG?)\n" );

$pwidth  = imagesx( $proxy_img );
$pheight = imagesy( $proxy_img );

if( $pwidth % 4 )
	die( "error: Image width must be divisible by 4 (is $pwidth)\n" );

$oufp = fopen( $outname . ".p", "wb" );

if( $oufp )
    print( "Converting " . $argv[1] . " to " . $outname . ".p\n" );
else
    die( "Unable to write " . $outname . ".p\n" );

// Write header - all is little endian

$header  = pack( "nS", 0xFAF0, 0x00 );		                // Magic number + 2 byte pad
$header .= flipfloat( 1.1 );				                // Version - manually byteswapped
$header .= pack( "nnnNNNNNNn", $pwidth, $pheight, 130,		// Width, Height, Depth (? static 130)
                 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 );		// 6 floats + 2 byte Pad

fwrite( $oufp, $header, 40 );

// Image is written out upside-down

imageflip( $proxy_img, IMG_FLIP_VERTICAL );

for( $y = 0; $y < $pheight; $y++ ) {

    for( $x = 0; $x < $pwidth; $x++ ) {

        $px         = imagecolorat( $proxy_img, $x, $y );
        $pix_pack   = pack( "CCC", ($px >> 16) & 0xFF, ($px >> 8) & 0xFF, $px & 0xFF );
        fwrite( $oufp, $pix_pack, 3 );
    }
}

fclose( $oufp );

print( "Done.\n" );

//

function flipfloat( $val ) {

  $nval = pack( "f", $val );
  return( $nval[3] . $nval[2] . $nval[1] . $nval[0] );
}
