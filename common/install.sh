ui_print "+++++++++++++++++++++++++++++++"
ui_print "        ++ RM5G LED Mod ++     "
ui_print "      by fandango96 @github    "
ui_print "+++++++++++++++++++++++++++++++"

config_dir="/storage/emulated/0/Android/led_mod"

config_check() {
	if [ ! -d $config_dir ]; then
		ui_print " "
                ui_print " - Config directory not found!"
                ui_print " - Extracting led_mod config directory"
                unzip -o $ZIPFILE "led_mod/*" -d $TMPDIR >&2
		mkdir -p $config_dir
		cp -R -f $TMPDIR/led_mod/* $config_dir
	fi
}

ui_print " "
ui_print "- Reading configuration files"
config_check

handle_four_colors_internal() {
        red1=${2:0:2}
        green1=${2:2:2}
        blue1=${2:4:2}

        red2=${3:0:2}
        green2=${3:2:2}
        blue2=${3:4:2}

        red3=${4:0:2}
        green3=${4:2:2}
        blue3=${4:4:2}

        red4=${5:0:2}
        green4=${5:2:2}
        blue4=${5:4:2}

        subs=""

	for i in $(seq 16 27)
        do
                if [[ $i -le 18 ]]
                then
                        red=$red1
                        green=$green1
                        blue=$blue1
                elif [[ $i -le 21 ]]
                then
                        red=$red2
                        green=$green2
                        blue=$blue2
                elif [[ $i -le 24 ]]
                then
                        red=$red3
                        green=$green3
                        blue=$blue3
                else
                        red=$red4
                        green=$green4
                        blue=$blue4
                fi
                hex=$(printf '%x' $i)
                subs=$subs'\x'$hex
                rem=$(($i%3))
                if [[ $rem -eq 1 ]]
                then
                        subs=$subs'\x'$red
                elif [[ $rem -eq 2 ]]
                then
                        subs=$subs'\x'$green
                else
                        subs=$subs'\x'$blue
                fi
        done

        printf $subs | dd of=$MODPATH/system/vendor/firmware/aw22xxx_cfg_$1.bin bs=1 seek=$6 count=24 conv=notrunc
}

handle_one_color() {
        color=$(cat $config_dir/$1'_one_color.txt')
	ui_print " "
	ui_print "- Handling $1 one color = $color"
        handle_four_colors_internal $2'0' $color $color $color $color $3
}

handle_one_color_special() {
        color=$(cat $config_dir/$1'_one_color.txt')
	ui_print " "
	ui_print "- Handling $1 one color = $color"
        handle_four_colors_internal $2'0' $color $color $color '000000' $3
}

handle_two_colors() {
        filename=$config_dir'/'$1'_two_colors.txt'
        color1=$(head -n 1 $filename)
        color2=$(tail -n 1 $filename)
	ui_print " "
	ui_print "- Handling $1 two colors = [$color1, $color2]"
        handle_four_colors_internal $2'8' $color1 $color2 $color1 $color2 $3
}

handle_four_colors() {
        filename=$config_dir'/'$1'_four_colors.txt'
        color1=$(head -n 1 $filename)
        color2=$(head -n 2 $filename | tail -n 1)
        color3=$(head -n 3 $filename | tail -n 1)
        color4=$(tail -n 1 $filename)
	ui_print " "
	ui_print "- Handling $1 four colors = [$color1, $color2, $color3, $color4]"
        handle_four_colors_internal $2'8' $color1 $color2 $color3 $color4 $3
}

handle_one_four() {
        handle_one_color $1 $2 36
        handle_four_colors $1 $2 36
}

handle_flashing() {
        handle_one_four 'flashing' '8'
}

handle_lamp_with_sound() {
        handle_two_colors 'lamp_with_sound' '5' 18
}

handle_steady_lighting_up() {
        handle_two_colors 'steady_lighting_up' '6' 30
}

handle_breathe() {
        handle_one_four 'breathe' '7'
}

handle_flow() {
        handle_one_color_special 'flow' 'a' 42
        handle_four_colors 'flow' 'a' 42
}

handle_flashing
handle_lamp_with_sound
handle_steady_lighting_up
handle_breathe
handle_flow

ui_print " "
ui_print "Enjoy! Report bugs and share your custom configs with me: @fandango96"
