import iterm2
import argparse
import os

# ##################
# I found this somewhere and it doesn't appear to be needed but maybe?
# ##################
# import AppKit
# bundle = "com.googlecode.iterm2"
# if not AppKit.NSRunningApplication.runningApplicationsWithBundleIdentifier_(bundle):
#     AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm")
# ##################

_description = """
# -----------------------------------------------------------------------------
# Run command in panes
#
# Creates x panes and runs the command given in them.
# -----------------------------------------------------------------------------
"""
ITERM_VAR_COMMAND = 'ITERM_VAR_COMMAND'
ITERM_VAR_X = 'ITERM_VAR_X'


def parse_args(desc):
    parser = argparse.ArgumentParser(description=desc, formatter_class=argparse.RawTextHelpFormatter);
    
    # --- Positional ---
    parser.add_argument('command', help="The command to run")
    parser.add_argument('x', help="The number of panes to run it in")

    # # --- Optional ---
    # parser.add_argument('--run', nargs='?', dest='run', default="no",
    #     help='Run the specified build')
    # parser.add_argument('-x', dest='x', nargs='?', default=1)

    args = parser.parse_args();
    return args;


async def create_tab_with_panes(window, x):
    panes = []

    # Create main tab and first session. 
    main = await window.async_create_tab()
    await main.async_activate()
    await main.async_set_title('~ Title ~')
    sess = main.current_session
    panes.append(sess)

    # split tab x -1 times since we already have session
    for i in range(x -1):
        sub = await sess.async_split_pane(vertical=False)
        panes.insert(1, sub)
    
    return panes    


async def create_window_with_panes(connection, x):
    panes = []

    # Create main tab and first session. 
    window = await iterm2.Window.async_create(connection)
    await window.async_activate()
    sess = window.current_tab.current_session
    panes.append(sess)

    # split tab x -1 times since we already have session
    for i in range(x -1):
        sub = await sess.async_split_pane(vertical=False)
        panes.insert(1, sub)
    
    return panes    


async def run_in_panes(panes, cmd):
    i = 1
    for pane in panes:
        to_run = cmd
        if(to_run.endswith("\n") == False):
            to_run += "\n";

        to_run = to_run.replace("<x>", f"{i}")
        await pane.async_send_text(to_run)
        i += 1


async def iterm_callback_main(connection):
    app = await iterm2.async_get_app(connection)
    
    # Ensure window
    window = app.current_terminal_window
    if app.current_terminal_window is None:
        exit()

    session = window.current_tab.current_session

    # panes = await create_tab_with_panes(window, int(os.environ[ITERM_VAR_X]))
    panes = await create_window_with_panes(connection, int(os.environ[ITERM_VAR_X]))
    await run_in_panes(panes, os.environ[ITERM_VAR_COMMAND])

    
def main():
    args = parse_args(_description)
    os.environ[ITERM_VAR_COMMAND] = args.command
    os.environ[ITERM_VAR_X] = args.x

    iterm2.run_until_complete(iterm_callback_main)

main()
