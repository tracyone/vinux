#!/usr/bin/env osascript
on run argv
tell application "System Events"
    if (item 1 of argv is equal to "q") then
        keystroke "w" using control down
        keystroke "q"
    else
        repeat with i from 1 to (count argv)
            keystroke item i of argv
        end repeat
        keystroke "j" using control down
    end if
end tell
end run



