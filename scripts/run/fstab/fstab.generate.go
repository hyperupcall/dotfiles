// goal: to read `user-dirs.dirs` and
// generate parts of fstab for that

package main

import (
	"fmt"
	"strings"
)

func flags() {

}

func main() {
	flags()

	// SEP separates characters in
	SEP := "  "
	// MOUNTPOINT is where the `pics`, `dls`, etc. files are actually kept
	MOUNTPOINT := "/data"

	var sb strings.Builder
	// ROOT
	{
		// TODO: automatically set mount options, mount fs
		// and have that be returned from getUuidFromPath()
		uuid := getUuidFromPath("/")
		sb.WriteString("# Root\n")
		sb.WriteString("UUID=" + uuid + SEP + "/" + SEP + "ext4" + SEP)
		sb.WriteString("rw,relatime" + SEP + "0 1\n")
		sb.WriteString("\n")
	}

	// BOOT RELATED
	{
		uuid := getUuidFromPath("/efi")
		sb.WriteString("# Boot\n")
		sb.WriteString("UUID=" + uuid + SEP + "/efi" + SEP + "vfat" + SEP)
		sb.WriteString("rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,")
		sb.WriteString("shortname=mixed,utf8,errors=remount-ro" + SEP + "0 2\n")

		// mounting parts of /efi to /boot and /boot/efi
		sb.WriteString("/efi/EFI/arch" + SEP + "/boot" + SEP + "none" + SEP)
		sb.WriteString("rw,bind" + SEP + "0 0\n")
		sb.WriteString("/efi" + SEP + "/boot/efi" + SEP + "none" + SEP)
		sb.WriteString("rw,bind,x-systemd.requires=/boot" + SEP + "0 0\n")
		sb.WriteString("\n")
	}

	// DATA DIRECTORY
	{
		sb.WriteString("# Data\n")
		sb.WriteString("/dev/main/data" + SEP + MOUNTPOINT + SEP + "xfs" + SEP)
		sb.WriteString("rw,relatime,defaults" + SEP + "0 2\n")
		sb.WriteString("\n")
	}

	// XDG DESKTOP ENTRIES
	{
		xdgDirs := make(map[string]string)
		// reads common default values (not from /etc/xdg/user-dirs.defaults)
		xdgDirs = mergeAndOverwrite(xdgDirs, getDefaultDirsContent())
		// reads ~/.config/user-dirs.dirs
		xdgDirs = mergeAndOverwrite(xdgDirs, getUserDirsContent())

		sb.WriteString("# XDG Desktop Entries\n")

		// destDir is a place we want to mount our folder to (in /home/$user)
		for _, destDir := range xdgDirs {
			srcDir := MOUNTPOINT + destDir[5:]
			debug("\nsrcDir: %s\ndestDir: %s\n", srcDir, destDir)

			if !fileExists(srcDir) || !fileExists(destDir) {
				debug("SKIP\n")
				continue
			}
			debug("ADD\n")

			sb.WriteString(srcDir + SEP + destDir)
			sb.WriteString(SEP + "none" + SEP + "x-systemd-requires=" + MOUNTPOINT)
			sb.WriteString(",defaults,nofail,bind" + SEP + "0 0\n")
		}
	}

	str := sb.String()
	fmt.Print(str)
}
