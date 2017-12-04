#!/usr/bin/env osascript
on run argv
tell application "System Events"
    keystroke "\\" using control down
    keystroke "n" using control down
    if (item 1 of argv exists) then
        keystroke ":tabe " & item 1 of argv
        keystroke "j" using control down
    end if
    if (item 2 of argv exists) then
        keystroke ":tabe " & item 2 of argv
        keystroke "j" using control down
    end if
    if (item 3 of argv exists) then
        keystroke ":tabe " & item 3 of argv
        keystroke "j" using control down
    end if
    if (item 4 of argv exists) then
        keystroke ":tabe " & item 4 of argv
        keystroke "j" using control down
    end if
end tell
end run



