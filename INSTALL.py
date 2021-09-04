#!/usr/bin/python

# INSTALL.py by Bob Maple v0.3
# Packages into .mx/.lx and installs Matchbox and Lightbox shaders from http://logik-matchbook.org/
# Place this in the same directory of the extracted Matchbook tar and run it instead:
#
# python ./INSTALL.py

import os, glob, shlex, subprocess, signal, sys, shutil, re

# Config
debug_compiler      = False
mx_install_dir_name = "LOGIK-MX"
lx_install_dir_name = "LOGIK-LX"


# Functions
def get_install_subdir( shader_name ):
	global install_hints

	for tmp_hint in install_hints:
		aregex = re.search('(\\S+)\\s*=\\s*(\\S+)', tmp_hint)
		if aregex:
			bregex = re.search( aregex.group(1), shader_name )
			if bregex:
				return( aregex.group(2) )

	return( "" )


def handle_signal( rec_signal, tmp ):
	print( "\nAborting.\n" )
	exit(0)


# Main
print("LOGIK Matchbook shader collection installer running py-%s\n" % (sys.version))

signal.signal( signal.SIGINT, handle_signal )

# Only proceed if sudo or root
# Attempt to re-run self via sudo
if os.getuid() != 0:

	print( ">> You need to be root or use sudo to run this installer." )
	print( ">> I'll try sudo; If you have administrator access, enter your password if asked.\n" )

	cmd = 'sudo "%s"' % __file__
	subprocess.call(shlex.split(cmd))
	exit(0)

# Find versions of Flame-family products and ask the user
# which version to install using/into
find_flames  = glob.glob("/opt/Autodesk/presets/*")

# Find versions of Flame products so we can ask the user
# which version to install into
#find_flames  = glob.glob("/opt/Autodesk/flame_*")
#find_flames += glob.glob("/opt/Autodesk/flare_*")
#find_flames += glob.glob("/opt/Autodesk/flameassist_*")

if( find_flames ):
	print( "Found " + str( len( find_flames ) ) + " Flame Family versions:\n" )
	i = 0;
	for tmp in find_flames:
		tmpregex = re.search( '.*/(.*)$', tmp )
		i += 1
		print( "[" + str(i) + "] " + tmpregex.group(1) )

	if( sys.version_info[0] > 2 ):
		tmp_in = input( "\nInstall to (" + str(len(find_flames)) + "): " )
	else:
		tmp_in = raw_input( "\nInstall to (" + str(len(find_flames)) + "): " )

	if( not tmp_in.isdigit() ):

		# Default to the last
		if( tmp_in == '' ):
			choice = i;
		else:
			choice = 0;
	else:
		choice = int(tmp_in);

	if( choice < 1 or choice > i ):
		sys.stderr.write("\nInvalid selection, exiting.\n")
		exit(1)

	tmpregex  = re.search( '.*/(.*)$', find_flames[choice-1] )
	flame_ver = tmpregex.group(1)

	# Find a shader_builder with a matching version to use
	find_builders = glob.glob("/opt/Autodesk/fl*" + flame_ver + "/bin/shader_builder" )

	if( find_builders ):
		shader_builder = find_builders[0]
		print( "\nUsing shader_builder at %s\n" % shader_builder )
	else:
		sys.stderr.write( "\nUnable to find a shader_builder for " + flame_ver )
		exit(1)

else:
	sys.stderr.write("Couldn't find any installed Flame Family versions.\n")
	exit(1)

pkgdir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'shaders')
os.chdir( pkgdir )
# print("CWD is " + os.getcwd())
files = glob.glob("*.glsl")
files.sort()

# Verify all matchbox install directories
matchbox_directory = "/opt/Autodesk/presets/" + flame_ver + "/matchbox/shaders"
lightbox_directory = "/opt/Autodesk/presets/" + flame_ver + "/action/lightbox"

if not os.access(matchbox_directory, os.W_OK):
	sys.stderr.write("Cannot write to your matchbox directory %s\n" % matchbox_directory)
	sys.stderr.write("You need to run this installer as root or via sudo\n")
	sys.stderr.write("Aborting...\n")
	exit(1)
else:
	print("Found matchbox install directory %s" % matchbox_directory)

if not os.access(lightbox_directory, os.W_OK):
	sys.stderr.write("Cannot write to your action lightbox directory %s\n" % lightbox_directory)
	sys.stderr.write("You need to run this installer as root or via sudo\n")
	sys.stderr.write("Aborting...\n")
	exit(1)
else:
	print("Found lightbox install directory %s" % lightbox_directory)

# Create install directory and remove all old shaders
logik_dir = os.path.join(matchbox_directory, mx_install_dir_name)
# Delete old LOGIK directory
if os.path.exists(logik_dir):
	print( "Removing old %s" % logik_dir )
	shutil.rmtree(logik_dir,True)
# Create a new LOGIK subdir in the shader directory
if not os.path.isdir(logik_dir):
	os.makedirs(logik_dir)

logik_dir = os.path.join(lightbox_directory, lx_install_dir_name)
# Delete old LOGIK directory
if os.path.exists(logik_dir):
	print( "Removing old %s" % logik_dir )
	shutil.rmtree(logik_dir,True)
# Create a new LOGIK subdir in the shader directory
if not os.path.isdir(logik_dir):
	os.makedirs(logik_dir)

#
# ---- Begin Compiler/Installer ---- #
#

# Read a list of shaders to skip

if os.access( "../skip-shaders.cfg", os.F_OK ):
	print( "Reading skip-shaders.cfg" )
	tmp_fp = open( "../skip-shaders.cfg", 'r' )
	skip_shaders = tmp_fp.readlines()
	tmp_fp.close()

else:
	skip_shaders = False


# Read a list of shader prefixes and their install directory names

if os.access( "../install-hints.cfg", os.F_OK ):
	print( "Reading install-hints.cfg" )
	tmp_fp = open( "../install-hints.cfg", 'r' )
	install_hints = tmp_fp.readlines()
	tmp_fp.close()

	# Make subdirs in matchbox shaders folder
	for tmp_hint in install_hints:
		aregex = re.search('(\\S+)\\s*=\\s*(\\S+)', tmp_hint)
		if aregex:
			tmpnewdir = os.path.join(matchbox_directory, mx_install_dir_name, aregex.group(2))
			os.makedirs(tmpnewdir)

else:
	install_hints = False

print()

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
				print( "\033[94mSkipping shader           : %s\033[0m" % shader_name )
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

		print( "Installing %s shader: %s" % (shader_type_name, shader_name) ),
		compileargs = [shader_builder, '-p', '-d', shader_type]
		compileargs.extend(allshaders)

		# rc = 0
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

			if shader_type == "-m":
				src_path  = os.path.join(pkgdir, shader_name + ".mx")
				logik_dir = os.path.join(matchbox_directory, mx_install_dir_name)
				if install_hints:
					logik_dir = os.path.join(logik_dir, get_install_subdir(shader_name))
				dest_path = os.path.join(logik_dir, shader_name + ".mx")
				shutil.copyfile(src_path, dest_path)
			else:
				src_path  = os.path.join(pkgdir, shader_name + ".lx")
				logik_dir = os.path.join(lightbox_directory, lx_install_dir_name)
				dest_path = os.path.join(logik_dir, shader_name + ".lx")
				shutil.copyfile(src_path, dest_path)


print( "\nInstall done.")
