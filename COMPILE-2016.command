#!/usr/bin/env python

# COMPILE-2016.command by Bob Maple
# Compiles and installs Matchbox and Lightbox shaders from http://logik-matchbook.org/ into IFFFS 2016 versions
# Place in the same directory of the download as INSTALL.command and run instead.

import os, glob, shlex, subprocess, sys, shutil, re

# Config
debug_compiler      = False
mx_install_dir_name = "shaders/LOGIK-MX"
lx_install_dir_name = "LOGIK-LX"

print("LOGIK Matchbook shader collection compiler/installer running py-%s\n" % (sys.version))

# Only proceed if sudo or root
# Attempt to re-run self via sudo
if os.getuid() != 0:

    print("You need to be root or have sudo to run the installer.")
    print("I will now ask you for your account password.")
    print("If this doesn't work, then you probably have a Linux IFFS system")
    print("and you'll have to run this installer as root.")

    cmd = 'sudo "%s"' % __file__
    subprocess.call(shlex.split(cmd))
    exit(0)

# Find shader_builder binary or die
find_builder = glob.glob("/usr/discreet/*/bin/shader_builder" )

if( find_builder ):
    shader_builder = find_builder.pop()
    print( "Using shader compiler at %s\n" % shader_builder )
else:
    sys.stderr.write("Couldn't find shader_builder\n")
    sys.stderr.write("Compiling glsl shaders with this script is only supported in release 2016.\n")
    sys.stderr.write("If you are running release 2015, please use the COMPILE-2015.command script instead.\n")
    exit(1)

pkgdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'shaders')
files = glob.glob(pkgdir + "/*.glsl")
files.sort()

# Find all Matchbox install directories
matchbox_directories = glob.glob("/usr/discreet/presets/2016*/matchbox")
lightbox_directories = glob.glob("/usr/discreet/presets/2016*/action/lightbox")

for destination in matchbox_directories:
    if not os.access(destination, os.W_OK):
        sys.stderr.write("We cannot write to your IFFS directories.\n")
        sys.stderr.write("You need to run this installer as root or via sudo\n")
        sys.stderr.write("Aborting...\n")
        exit(1)
    else:
        print("Found matchbox install directory %s" % destination)

for destination in lightbox_directories:
    if not os.access(destination, os.W_OK):
        sys.stderr.write("We cannot write to your IFFS directories.\n")
        sys.stderr.write("You need to run this installer as root or via sudo\n")
        sys.stderr.write("Aborting...\n")
        exit(1)
    else:
        print("Found lightbox install directory %s" % destination)

# Create install directories, cleanup old shaders
for destination in matchbox_directories:
    logik_dir = os.path.join(destination, mx_install_dir_name)
    # Delete old LOGIK directory
    if os.path.exists(logik_dir):
        print( "Removing old %s" % logik_dir )
        shutil.rmtree(logik_dir,True)
    # Create a new LOGIK subdir in the shader directory
    if not os.path.isdir(logik_dir):
        os.makedirs(logik_dir)

for destination in lightbox_directories:
    logik_dir = os.path.join(destination, lx_install_dir_name)
    # Delete old LOGIK directory
    if os.path.exists(logik_dir):
        print( "Removing old %s" % logik_dir )
        shutil.rmtree(logik_dir,True)
    # Create a new LOGIK subdir in the shader directory
    if not os.path.isdir(logik_dir):
        os.makedirs(logik_dir)

print

#
# ---- Begin Compiler/Installer ---- #
#

# Read a list of shaders to skip

if os.access( "skip-shaders.cfg", os.F_OK ):
    print( "Reading skip-shaders.cfg\n" )
    tmp_fp = open( "skip-shaders.cfg", 'r' )
    skip_shaders = tmp_fp.readlines()
    tmp_fp.close()

else:
    skip_shaders = False


for shader_file in files:

    do_install = False
    do_compile = False
    do_skip    = False

    # Get the name of the shader without extension
    regex = re.search('(.*)\.glsl', shader_file)
    shader_name = os.path.basename( regex.group(1) )

    # See if this is a multipass shader
    regex = re.search('(.*)\.([0-9]+)\.glsl', shader_file)

    if regex:
        if int(regex.group(2)) == 1:

            shader_name = os.path.basename( regex.group(1) )

            # This is the first pass shader. find all the others
            allshaders = [regex.group(0)]
            srchregex  = re.escape( regex.group(1) ) + "\.([0-9]+)\.glsl"

            for srchshader in files:
                findshader = re.search( srchregex, srchshader )

                if findshader:
                    if int(findshader.group(1)) != 1:
                        allshaders.append( findshader.group(0) )

            allshaders.sort()
            do_compile = True

    else:
        allshaders = [shader_file]
        do_compile = True

    if do_compile:

        # Check whether we should actually skip this shader

        if( skip_shaders != False ):
            for tmp_skip in skip_shaders:
                if( tmp_skip.strip().lower() == shader_name.lower() ):
                    do_skip = True
                    break

            if( do_skip == True ):
                print( "\033[94mSkipping shader          : %s\033[0m" % shader_name )
                continue

        # Now figure out if it's a Matchbox or a Lightbox shader

        shader_type = "-m"
        shader_type_name = "matchbox"

        tmp_xmlfp = open( os.path.join( pkgdir, shader_name + ".xml" ), 'r' )
        tmp_xml   = tmp_xmlfp.read()
        tmp_xmlfp.close()

        tmpregex = re.findall( "ShaderType=.*Lightbox", tmp_xml, re.IGNORECASE )
        if tmpregex:
            shader_type = "-l"
            shader_type_name = "\033[93mlightbox\033[0m"

        print( "Compiling %s shader: %s" % (shader_type_name, shader_name) ),
        compileargs = [shader_builder, '-p', shader_type]
        compileargs.extend(allshaders)

        if debug_compiler:
            rc = subprocess.call(compileargs)
        else:
            rc = subprocess.call(compileargs,stdout=open(os.devnull, 'wb'))

        if( rc != 0 ):
            print( "  \033[91m[FAILED]\033[0m" )
        else:
            print
            do_install = True


        if do_install:
            # print( "Installing shader: %s" % shader_name )

            if shader_type == "-m":
                for destination in matchbox_directories:
                    src_path  = os.path.join(pkgdir, shader_name + ".mx")
                    logik_dir = os.path.join(destination, mx_install_dir_name)
                    dest_path = os.path.join(logik_dir, shader_name + ".mx")
                    #print( "src is %s" % src_path )
                    #print( "dest is %s\n" % dest_path )
                    shutil.copyfile(src_path, dest_path)
            else:
                for destination in lightbox_directories:
                    src_path  = os.path.join(pkgdir, shader_name + ".lx")
                    logik_dir = os.path.join(destination, lx_install_dir_name)
                    dest_path = os.path.join(logik_dir, shader_name + ".lx")
                    #print( "src is %s" % src_path )
                    #print( "dest is %s\n" % dest_path )
                    shutil.copyfile(src_path, dest_path)


print( "\nInstall done.")
