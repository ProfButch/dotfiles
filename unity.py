import sys
import os 
import argparse
import subprocess

_description = """
# -----------------------------------------------------------------------------
# IT4080 Module 3 Assignment.
#
#
# -----------------------------------------------------------------------------
"""

# dir_path = os.path.dirname(os.path.realpath(__file__))
# new_path = dir_path + '/../'
# if new_path not in sys.path:
#     sys.path.append(new_path)
# import utils;


def parse_args(desc):
    parser = argparse.ArgumentParser(description=desc, formatter_class=argparse.RawTextHelpFormatter);

    # --- Optional ---
    parser.add_argument('--run', nargs='?', dest='run', default="no",
        help='Run the specified build')
    parser.add_argument('-x', dest='x', nargs='?', default=1)

    args = parser.parse_args();
    return args;

def run_osascript(text):
    cmd = f"osascript &>/dev/null <<EOF\n{text}\nEOF"
    subprocess.run(cmd, shell=True)


def new_iterm_window():
    # https://gist.github.com/reyjrar/1769355
    s = """
    tell application "iTerm"
        create window with default profile
    end tell
    """

    run_osascript(s)

def run_build_in_new_tab(path, logfile, new_tab=True):
    subcmd = f"unity_run_build {path} {logfile}";
    new_tab_cmd = ''
    if(new_tab):
        new_tab_cmd = 'tell current window to set tb to create tab with default profile'
    s = f"""
    tell application "iTerm" 
        activate
            {new_tab_cmd}
            tell current session of current window to write text "{subcmd}"  
    end tell
    """
    run_osascript(s)

def run_builds(path, times):
    new_iterm_window()
    for i in range(times):
        run_build_in_new_tab(path, f"~/Builds/log_{i}.txt", i != 0)

def main():
    args = parse_args('asdf');    
    if(args.run != 'no'):
        run_builds(args.run, int(args.x))

main();