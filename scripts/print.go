package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("../.profile")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		if len(line) == 0 {
			continue
		}

		runes := []rune(line)
		firstChar := string(runes[0:1])
		secondChar := string(runes[1:2])

		if firstChar == "#" && secondChar == " " {
			fmt.Println(line)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
