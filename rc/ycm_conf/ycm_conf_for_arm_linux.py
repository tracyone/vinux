# .ycm_extra_conf.py for kernel
import os

# Attention:
# File path not starting with / or = will be expanded.

flags_0 = [
    '-Wall',
    '-Wundef',
    '-Wstrict-prototypes',
    '-Wno-trigraphs',
    '-fno-strict-aliasing',
    '-fno-common',
    '-Werror-implicit-function-declaration',
    '-Wno-format-security',
    '-D__KERNEL__',
    '-DMODULE',
    '-x', 'c',
    '-std=gnu89',
    '-nostdinc',
    # Not sure if sysroot works in clang
    # Will be path mangled
    '-I', 'include',
    '-I', 'arch/arm/include',
    '-I', 'arch/arm/include/generated',
    '-I', 'arch/arm/include/uapi',
    '-I', 'arch/arm64/include',
    '-I', 'arch/arm64/include/generated',
    '-I', 'arch/arm64/include/uapi',
    '-include', 'include/linux/kconfig.h',  # IMPORTANT
]

flags_1 = [
]

flags_2 = [
]

flags = {
    'flags_0':flags_0,
    'flags_1':flags_1,
    'flags_2':flags_2,
}

def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


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

def FlagsForFile(filename):
    extension = os.path.splitext(filename)[1]
    final_flags = []
    list_name = ""
    if extension == '.cpp':
        assert False

    if os.path.exists(".csdb"): 
        with open(".csdb", 'r') as file:  
            for line_number, line in enumerate(file, start=0):
                path = line.strip()  
                list_name = 'flags_' + str(line_number)
                if list_name in flags and flags[list_name]: 
                    final_flags += MakeRelativePathsInFlagsAbsolute(flags[list_name], path) 
                else:
                    final_flags.append("-I")
                    final_flags.append(path)
                    final_flags.append("-I")
                    final_flags.append(path + "/include")
    else:
        path = os.getcwd()
        final_flags += MakeRelativePathsInFlagsAbsolute(flags_0, path) 

    return {
        'flags': final_flags,
        'do_cache': True
    }
