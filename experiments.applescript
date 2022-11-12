

tell application "System Events"
    repeat with p in every process
        if background only of p is false then
            log(name of p as string)
            log(file of p as string)
            -- display dialog "Would you like to quit " & name of p & "?" as string
        end if
    end repeat
end tell