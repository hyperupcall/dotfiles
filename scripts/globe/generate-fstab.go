// goal: to read `user-dirs.dirs` and
// generate parts of fstab for that

package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"strings"
)

func getXdgDirs(xdgDirs map[string]string, bytes []byte) map[string]string {
	content := string(bytes)

	for _, line := range strings.Split(strings.TrimSpace(content), "\n") {
		line := strings.TrimSpace(line)

		if strings.HasPrefix(line, "#") || line == "" {
			continue
		}

		str := strings.Split(line, "=")
		dirName := strings.TrimSpace(str[0])
		dirValue := strings.TrimSpace(str[1][1 : len(str[1])-1])
		if strings.HasPrefix(dirValue, "$HOME") {
			homeDir := os.Getenv("HOME")
			if homeDir == "" {
				log.Fatalln("home dir not set")
			}
			dirValue = homeDir + dirValue[5:]
			dirValue = strings.ReplaceAll(dirValue, "//", "/")
		}

		xdgDirs[dirName] = dirValue
	}

	return xdgDirs
}

func main() {
	defaultDirsContent := `XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
`
	xdgDirs := make(map[string]string)
	xdgDirs = getXdgDirs(xdgDirs, []byte(defaultDirsContent))

	homeDir := os.Getenv("HOME")
	userDirsFile := path.Join(homeDir, ".config", "user-dirs.dirs")
	userDirsContent, err := ioutil.ReadFile(userDirsFile)
	if os.IsNotExist(err) {
		fmt.Println("user-dirs.dirs file doesn't exist. that's okay")
	} else if err != nil {
		log.Fatalln(err)
	}
	xdgDirs = getXdgDirs(xdgDirs, userDirsContent)

	var sb strings.Builder
	sb.WriteString("# home\n")
	for _, destXdgDirValue := range xdgDirs {
		srcXdgDirValue := "/data" + destXdgDirValue[5:]

		_, err1 := os.Stat(srcXdgDirValue)
		_, err2 := os.Stat(destXdgDirValue)
		// if either directory doesn't exist, don't add it to the map
		if err1 != nil || err2 != nil {
			fmt.Printf("either directory %s or %s could not be found\n", srcXdgDirValue, destXdgDirValue)
			continue
		}

		sb.WriteString(srcXdgDirValue)
		sb.WriteString("  ")
		sb.WriteString(destXdgDirValue)
		sb.WriteString("  none  x-systemd-requires=")
		sb.WriteString("/data")
		sb.WriteString(",defaults,nofail,bind  0 0\n")
	}
	str := sb.String()
	fmt.Println(str)
}