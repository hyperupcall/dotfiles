package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/mattn/go-isatty"
	"github.com/shirou/gopsutil/disk"
)

func writeEntry(entry FstabEntry, SEP string) string {
	var sb strings.Builder

	sb.WriteString(entry.FsSpec + SEP)
	sb.WriteString(entry.FsFile + SEP)
	sb.WriteString(entry.FsVfstype + SEP)
	sb.WriteString(entry.FsMntOps + SEP)
	sb.WriteString(entry.FsFreq + SEP)
	sb.WriteString(entry.FsPassno + "\n")

	return sb.String()
}

// name can be '/dev/dm-0', '/dev/sda7', etc.
func getUuid(location string) string {
	file, err := ioutil.ReadDir("/dev/disk/by-uuid")
	if err != nil {
		log.Fatalln(err)
	}

	// base := path.Base(location)
	for _, file := range file {
		uuidPath := path.Join("/dev/disk/by-uuid", file.Name())
		diskPath, err := filepath.EvalSymlinks(uuidPath)
		if err != nil {
			log.Fatalln(err)
		}
		if location == diskPath {
			return uuidPath
		}
	}

	return ""
}

// mostly a function for debugging, since
// getUuidFromPath calls disk.Partitions by itself
func getDisks() {
	partitionStats, err := disk.Partitions(false)
	if err != nil {
		log.Fatalln(err)
	}

	for _, partitionStat := range partitionStats {
		uuid := getUuid(partitionStat.Device)

		debug("device: %s\n", partitionStat.Device)
		debug("mountpoint: %s\n", partitionStat.Mountpoint)
		debug("fstype: %s\n", partitionStat.Fstype)
		debug("opts: %s\n", partitionStat.Opts)
		debug("uuid: %s\n", uuid)
		debug("\n")
	}
}

func getUuidFromPath(mountpoint string) string {
	partitionStats, err := disk.Partitions(false)
	if err != nil {
		log.Fatalln(err)
	}

	for _, partitionStat := range partitionStats {
		uuid := getUuid(partitionStat.Device)

		if partitionStat.Mountpoint == mountpoint {
			debug("device: %s\n", partitionStat.Device)
			debug("mountpoint: %s\n", partitionStat.Mountpoint)
			debug("fstype: %s\n", partitionStat.Fstype)
			debug("opts: %s\n", partitionStat.Opts)
			debug("uuid: %s\n", uuid)
			debug("\n")

			return path.Base(uuid)
		}

	}
	return ""
}

func getDefaultDirsContent() []byte {
	return []byte(`XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
`)
}

func getUserDirsContent() []byte {
	homeDir := os.Getenv("HOME")
	userDirsFile := path.Join(homeDir, ".config", "user-dirs.dirs")
	userDirsContent, err := ioutil.ReadFile(userDirsFile)
	if os.IsNotExist(err) {
		fmt.Println("user-dirs.dirs file doesn't exist. that's okay")
	} else if err != nil {
		log.Fatalln(err)
	}

	return []byte(userDirsContent)
}

func mergeAndOverwrite(xdgDirs map[string]string, userDirsDotDirsContent []byte) map[string]string {
	content := string(userDirsDotDirsContent)

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

func isColorEnabled() bool {
	_, isNoColorEnabled := os.LookupEnv("NO_COLOR")
	if (os.Getenv("TERM") != "dumb") && !isNoColorEnabled &&
		isatty.IsTerminal(os.Stdout.Fd()) || isatty.IsCygwinTerminal(os.Stdout.Fd()) {
		return true
	}
	return false
}

func print(text string, args ...interface{}) {
	if isColorEnabled() {
		fmt.Print("\033[34m")
		fmt.Printf(text, args...)
		fmt.Print("\033[m")
		return
	}

	fmt.Printf(text, args...)
}

func debug(text string, args ...interface{}) {
	isDebug := func() bool {
		_, ok := os.LookupEnv("DEBUG")
		if !ok {
			return false
		}
		return true
	}

	if isDebug() {
		if isColorEnabled() {
			fmt.Print("\033[32m")
			fmt.Printf(text, args...)
			fmt.Print("\033[m")
			return
		}

		fmt.Printf(text, args...)
	}
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	if err == nil {
		return true
	}
	if os.IsNotExist(err) {
		return false
	}
	return false
}
