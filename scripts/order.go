package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

// this ensures that ~/.profile is alphabetically ordered;
// valid comment lines start with '# '. we avoid '~' since
// that's the first comment, which includes the filename
func isValidCommentLine(line string) bool {
	runes := []rune(line)
	firstChars := string(runes[0:2])
	thirdChar := string(runes[2:3])

	if len(line) != 0 && firstChars == "# " && thirdChar != "~" {
		return true
	}
	return false
}

// start of a section is denoted by two pound signs
func isStartOfSection(line string) bool {
	runes := []rune(line)
	firstChars := string(runes[0:2])
	if firstChars == "##" {
		return true
	}
	return false
}

func main() {
	file, err := os.Open("../.profile")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	previousLine := ""
	for scanner.Scan() {
		line := scanner.Text()

		// reset lexigraphical ordering after
		// end of section
		if isStartOfSection(line) {
			previousLine = ""
			continue
		}

		if isValidCommentLine(line) {
			if previousLine == "" || previousLine < line {
				previousLine = line
			} else {
				fmt.Printf("error: %#v is not less than %#v\n", previousLine, line)
				return
			}
		}

	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("all things ordered!")
}
