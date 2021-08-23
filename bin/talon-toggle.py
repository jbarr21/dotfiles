from talon import actions

speech_enabled = actions.speech.enabled()
if speech_enabled:
  actions.speech.disable()
else:
  actions.speech.enable()

speech_enabled = not speech_enabled
print(int(speech_enabled))
quit()
