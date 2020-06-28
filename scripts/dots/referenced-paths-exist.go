package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path"
	"path/filepath"
	"runtime"
	"strings"
)

func handle(err error) {
	if err != nil {
		log.Println("there was an error")
		panic(err)
	}
}

func _dirname() string {
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		log.Println("could not read stack frames")
	}
	return path.Dir(filename)
}

func extractPathFromExport(line string) (path string, ok bool) {
	line = strings.Split(line, "=")[1]

	// after the =, there must be an '='
	// no "$''" (ANSI-C Quoting)
	if !strings.HasPrefix(line, "\"") {
		return "", false
	}

	if strings.HasPrefix(line, "\"") {
		line = line[1:]
	}

	return line, true
}

func main() {
	globPattern := path.Dir(path.Dir(_dirname())) + "/local/**"
	fmt.Printf("glob pattern: %s\n", globPattern)

	matches, err := filepath.Glob(globPattern)
	handle(err)

	// allReferencedPaths := make([]string, len([]string{}))
	allReferencedPaths := []string{}
	for _, filePath := range matches {
		// if filePath is directory, skip it
		stat, err := os.Stat(filePath)
		if err != nil {
			log.Fatalln(err)
		}
		if stat.IsDir() {
			continue
		}

		file, err := os.Open(filePath)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			line := scanner.Text()

			// fmt.Println(line)
			if strings.HasPrefix(line, "export ") {
				line, ok := extractPathFromExport(line)
				if !ok {
					continue
				}
				allReferencedPaths = append(allReferencedPaths, line)
			}
		}
		if err := scanner.Err(); err != nil {
			log.Fatal(err)
		}
	}

	for _, referencedPaths := range allReferencedPaths {
		fmt.Println(referencedPaths)
	}
}
