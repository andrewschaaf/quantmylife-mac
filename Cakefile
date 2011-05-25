
{spawn, exec} = require "child_process"


task 'licenses', () ->
  packages = 'quantmylife_mac foss_credits mac_preferences idler_c json_framework'
  exec "foss-credits #{packages} > LICENSES.html"

