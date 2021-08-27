#!/usr/bin/env bash

declare -i monitors= margin=
monitors="$(xrandr --query | awk '{ if ($2 == "connected" ) { print $1 } }' | wc -l)"
margin=5

declare dateStr=
while :; do
	userStr="$USER"
	dateStr="$(date +"%b (%m) %d, %A %I:%M:%S")"
	kexecStr="systemctl kexec"
	poweroffStr="systemctl poweroff"

	str=
	for ((i=0; i<monitors; ++i)); do
		str="$str%{S$i}%{l}%{O$margin}$userStr%{c}$dateStr%{r}%{A:$kexecStr:} Restart %{A}%{A:$poweroffStr:} Shutdown %{A}%{O$margin}"
	done

	printf "%s\n" "$str"
	sleep 1
done | lemonbar -g x25 -f 'Noto' -B '#212529' -F '#f8f9fa' -U '#ffe066' | sh
