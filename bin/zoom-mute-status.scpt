property btnTitle : "Mute audio"

if application "zoom.us" is running then
  tell application "System Events"
  	tell application process "zoom.us"
  		if exists (menu item btnTitle of menu 1 of menu bar item "Meeting" of menu bar 1) then
  			set returnValue to "unmuted"
  		else
  			set returnValue to "muted"
  		end if
  	end tell
  end tell
else
  set returnValue to "closed"
end if

return returnValue