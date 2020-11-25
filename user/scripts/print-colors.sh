#!/usr/bin/env bash

set -euo pipefail

# console_codes(4)

# 256 colors
for fgbg in 38 48; do
	for color in {0..255}; do
		printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color

		# 6 entries per row
		[ $((($color + 1) % 6)) == 4 ] && echo
	done
	echo
done;

for i in {0..255} ; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( $i == 15 )) || (( $i > 15 )) && (( ($i-15) % 12 == 0 )); then
        echo;
    fi
done

echo


# for clbg in {40..47} {100..107} 49; do
# 	#Foreground
# 	for clfg in {30..37} {90..97} 39; do
# 		#Formatting
# 		for attr in 0 1 2 4 5 7; do
# 			#Print the result
# 			echo        -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
# 		done
# 		echo #Newline
# 	done
# done

for i in {0..255} ; do
    printf "\x1b[38;5;${i}m%3d " "${i}"
    if (( $i == 15 )) || (( $i > 15 )) && (( ($i-15) % 12 == 0 )); then
        echo;
    fi
done
echo

awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
	s="/\\";
	for (colnum = 0; colnum<term_cols; colnum++) {
		r = 255-(colnum*255/term_cols);
		g = (colnum*510/term_cols);
		b = (colnum*255/term_cols);
		if (g>255) g = 510-g;
		printf "\033[48;2;%d;%d;%dm", r,g,b;
		printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
		printf "%s\033[0m", substr(s,colnum%2+1,1);
	}
	printf "\n";
}'
