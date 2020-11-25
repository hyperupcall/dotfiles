if [ "$(curl -LsSo- https://edwin.dev)" = "Hello World" ]; then
	:
else
	echo "https://edwin.dev OPEN"
fi
