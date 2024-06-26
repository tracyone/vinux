# This file is NOT licensed under the GPLv3, which is the license for the rest
# of YouCompleteMe.
#
# Here's the license text for this file:
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

from distutils.sysconfig import get_python_inc
import platform
import os
import ycm_core

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
      '-Wall',
     '-Wextra',
     '-Werror',
     '-Wno-long-long',
     '-Wno-variadic-macros',
     '-Wno-unused-parameter',
     '-fexceptions',
     '-DNDEBUG',
     '-DANDROID',
     '-DHWC2_USE_CPP11',
     '-DHWC2_INCLUDE_STRINGIFICATION',
     '-DSUNXI_SIDEBAND_STREAM',
     '-DGL_GLEXT_PROTOTYPES',
     '-DEGL_EGLEXT_PROTOTYPES',
     # THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
     # use when compiling headers. So it will guess. Badly. So C++ headers will be
     # compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
     # For a C project, you would set this to 'c' instead of 'c++'.
     '-std=c++11',
     '-x',
     'c++',
     '-I', 'include',
]


includedirs_android = [
 'system/core/include',
 'hardware/libhardware/include',
 'hardware/libhardware_legacy/include',
 'hardware/aw/display/hwc-hal/svp/include',
 'hardware/aw/display/hwc-hal/svp',
 'hardware/aw/display',
 'hardware/aw/display/include',
 'hardware/aw/display/interfaces/config/1.0/src',
 'hardware/ril/include',
 'libnativehelper/include',
 'bionic/libc/arch-arm/include',
 'bionic/libc/include',
 'bionic/libc/kernel/common',
 'bionic/libc/kernel/arch-arm',
 'bionic/libstdc++/include',
 'bionic/libstdc++/include',
 'bionic/libm/include',
 'bionic/libm/include/arm',
 'bionic/libthread_db/include',
 'frameworks/native/include',
 'frameworks/native/opengl/include',
 'frameworks/av/include',
 'frameworks/base/include',
 'kernel/include/uapi'
 #Add more header locations that you're interested in
]

flags_1 = [
]

flags_2 = [
]

flags_x = {
    'flags_1':flags_1,
    'flags_2':flags_2,
}

def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return flags
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=', '-include']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/') and not flag.startswith('='):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break
            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)

    return new_flags

def GetRoot(filename, marker_dir):
    path = os.path.dirname(os.path.abspath(filename))
    while True:
        if os.path.ismount(path):
            return None
        if os.path.isdir(os.path.join(path, marker_dir)):
            return path
        path = os.path.dirname(path)

def AppendIncludes(filename):
    root = GetRoot(filename, ".repo")
    if root == None:
        cpp_compiler_version = os.popen("g++ -dumpversion").read().strip('\n')
        cpp_compiler_machine = os.popen("g++ -dumpmachine").read().strip('\n')
        cpp_path = os.path.dirname(os.popen("which g++").read()).strip('\n')
        include_path = cpp_path[:-3] + "include/c++/" + cpp_compiler_version
        include_path2 = include_path + "/bits"
        lib_path = cpp_path[:-3] + "lib/gcc/" + cpp_compiler_machine + "/" + cpp_compiler_version + "/include/"
        flags.append('-isystem')
        flags.append(include_path)
        flags.append('-isystem')
        flags.append(lib_path)
        flags.append('-isystem')
        flags.append(include_path2)
        return None
    else:
        for includedir in includedirs_android:
            flags.append('-isystem')
            flags.append(os.path.join(root, includedir))


# Clang automatically sets the '-std=' flag to 'c++14' for MSVC 2015 or later,
# which is required for compiling the standard library, and to 'c++11' for older
# versions.
if platform.system() != 'Windows':
  flags.append( '-std=c++11' )


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
compilation_database_folder = ''

if os.path.exists( compilation_database_folder ):
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]


def FindCorrespondingSourceFile( filename ):
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        return replacement_file
  return filename


def FlagsForFile( filename, **kwargs ):
    # If the file is a header, try to find the corresponding source file and
    # retrieve its flags from the compilation database if using one. This is
    # necessary since compilation databases don't have entries for header files.
    # In addition, use this source file as the translation unit. This makes it
    # possible to jump from a declaration in the header file to its definition in
    # the corresponding source file.
    final_flags = []
    list_name = ""
    AppendIncludes(filename)
    filename = FindCorrespondingSourceFile( filename )

    if os.path.exists(".csdb"): 
        with open(".csdb", 'r') as file:  
            for line_number, line in enumerate(file, start=0):
                path = line.strip()  
                list_name = 'flags_' + str(line_number)
                if list_name in flags_x and flags_x[list_name]: 
                    final_flags += MakeRelativePathsInFlagsAbsolute(flags_x[list_name], path) 
                else:
                    final_flags.append("-I")
                    final_flags.append(path)

    path = os.getcwd()
    final_flags += flags

    if not database:
        return {
            'flags': final_flags,
            'include_paths_relative_to_dir': DirectoryOfThisScript(),
            'override_filename': filename
        }

    compilation_info = database.GetCompilationInfoForFile( filename )
    if not compilation_info.compiler_flags_:
        return None

# Bear in mind that compilation_info.compiler_flags_ does NOT return a
# python list, but a "list-like" StringVec object.
    final_flags = list( compilation_info.compiler_flags_ )

# NOTE: This is just for YouCompleteMe; it's highly likely that your project
# does NOT need to remove the stdlib flag. DO NOT USE THIS IN YOUR
# ycm_extra_conf IF YOU'RE NOT 100% SURE YOU NEED IT.
    try:
        final_flags.remove( '-stdlib=libc++' )
    except ValueError:
        pass

    return {
        'flags': final_flags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
        'override_filename': filename
    }
