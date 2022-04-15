### Installation & Usage Instructions
- Flash module in Magisk Manager.
- Reboot each time after flashing this module.
- You can flash this module multiple times.
- The module uses configuration files located at `/storage/emulated/0/Android/led_mod` (the default home page in most file managers is `/sdcard` so you just need to click on `Android` and then `led_mod`). If these don't exist (i.e. you are installing the module for the first time), then they will be created during installation.
- The configuration files follow the format: `<effect>_<num_colors>_colors.txt` (e.g. `flashing_one_color.txt`, `breathe_four_colors.txt`, `lamp_with_sound_two_colors.txt`, etc.)
- Each line in the configuration file is the RGB color in hex (see https://duckduckgo.com/?q=color+picker&ia=answer). Change them to your liking (you can repeat colors if you want).
- Flash the module again and reboot to apply your changes.
- The Magisk Manager logs during installation will show your changes being picked up.
- The new colors will replace the red & yellow option (last one in the list when you go `Settings -> Light Strip Setting -> <any row in Light Strip> -> Select LED color`) in case of two and four colors and the red option (first one in the aforementioned list) in case of one color.
- You will need to reflash the module every time you change the colors in the configuration files for the changes to be applied.

### Uninstallation
- Uninstall with Magisk and reboot.
