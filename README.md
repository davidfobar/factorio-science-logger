# factorio-science-logger

A simple mod that adds two files {"script-output/available_science_packs.txt", "script-output/science_log.txt"}

At the loading of a map, all of the possible sciences are printed to the available science packs file. 
Each second a second the log file is updated to reflect the science packs currently being utilized in the labs.

The intent behind these two actions is to create the ability to bring the Disco Science mod to real life. A simple python script will monitor the science log, and it will send a list of appropriate colors to an arduino. The arduino will flash a series of RGB leds, much like what is seen in the mod Disco Science. The arduino and LEDs will be housed in a 3d printed Factorio lab.

The user will have to update the python script in order to control which colors are sent to the arduino, which is why printing all science packs at the beginning is useful.
