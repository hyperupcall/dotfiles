// goal: to read `user-dirs.dirs` and
// generate parts of fstab for that

package main

import (
	"fmt"
	"strings"
)

func flags() {

}

type FstabEntry struct {
	FsSpec    string
	FsFile    string
	FsVfstype string
	FsMntOps  string
	FsFreq    string
	FsPassno  string
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
		fstabEntry := FstabEntry{
			FsSpec:    "UUID=" + getUuidFromPath("/"),
			FsFile:    "/",
			FsVfstype: "ext4",
			FsMntOps:  "rw,suid,dev,exec,auto,nouser,async,relatime,errors=remount-ro",
			FsFreq:    "0",
			FsPassno:  "1",
		}

		sb.WriteString("# Root\n")
		str := writeEntry(fstabEntry, SEP)
		sb.WriteString(str + "\n")

	}

	// BOOT RELATED
	{
		fstabEntry := FstabEntry{
			FsSpec:    "UUID=" + getUuidFromPath("/efi"),
			FsFile:    "/efi",
			FsVfstype: "vfat",
			FsMntOps:  "rw,suid,dev,exec,auto,nouser,async,relatime,fmask=0033,dmask=0022,iocharset=utf8,utf8,X-mount.mkdir=0755,errors=remount-ro",
			FsFreq:    "0",
			FsPassno:  "2",
		}

		sb.WriteString("# Boot \n")
		str := writeEntry(fstabEntry, SEP)
		sb.WriteString(str)

		// mounting parts of /efi to /boot and /boot/efi
		fstabEntry1 := FstabEntry{
			FsSpec:    "/efi/EFI/arch",
			FsFile:    "/boot",
			FsVfstype: "none",
			FsMntOps:  "rw,bind,x-systemd.after=/boot,X-mount.mkdir=0755",
			FsFreq:    "0",
			FsPassno:  "0",
		}
		fstabEntry2 := FstabEntry{
			FsSpec:    "/efi",
			FsFile:    "/boot/efi",
			FsVfstype: "none",
			FsMntOps:  "rw,bind,x-systemd.after=/boot,X-mount.mkdir=0755",
			FsFreq:    "0",
			FsPassno:  "0",
		}

		str1 := writeEntry(fstabEntry1, SEP)
		sb.WriteString(str1)
		str2 := writeEntry(fstabEntry2, SEP)
		sb.WriteString(str2 + "\n")
	}

	// XDG DESKTOP ENTRIES
	{
		fstabEntry := FstabEntry{
			FsSpec:    "/dev/fox/data",
			FsFile:    MOUNTPOINT,
			FsVfstype: "xfs",
			FsMntOps:  "rw,suid,dev,exec,auto,nouser,async,relatime,X-mount.mkdir=0755,errors=remount-ro",
			FsFreq:    "0",
			FsPassno:  "2",
		}

		sb.WriteString("# XDG Desktop Entries\n")
		str := writeEntry(fstabEntry, SEP)
		sb.WriteString(str)

		xdgDirs := make(map[string]string)
		// reads common default values (not from /etc/xdg/user-dirs.defaults)
		xdgDirs = mergeAndOverwrite(xdgDirs, getDefaultDirsContent())
		// reads ~/.config/user-dirs.dirs
		xdgDirs = mergeAndOverwrite(xdgDirs, getUserDirsContent())

		// destDir is a place we want to mount our folder to (in /home/$user)
		for _, destDir := range xdgDirs {
			srcDir := MOUNTPOINT + destDir[5:]
			debug("\nsrcDir: %s\ndestDir: %s\n", srcDir, destDir)

			if !fileExists(srcDir) || !fileExists(destDir) {
				debug("SKIP\n")
				continue
			}
			debug("ADD\n")

			fstabEntry := FstabEntry{
				FsSpec:    srcDir,
				FsFile:    destDir,
				FsVfstype: "none",
				FsMntOps:  "x-systemd.after=" + MOUNTPOINT + ",bind,nofail",
				FsFreq:    "0",
				FsPassno:  "0",
			}
			str := writeEntry(fstabEntry, SEP)
			sb.WriteString(str + "\n")
		}
	}

	// STORAGE
	{
		fstabEntry := FstabEntry{
			FsSpec:    "/dev/rodinia/vault",
			FsFile:    "/data/storage",
			FsVfstype: "ext4",
			FsMntOps:  "rw,suid,dev,exec,auto,nouser,async,relatime,X-mount.mkdir=0755,errors=remount-ro",
			FsFreq:    "0",
			FsPassno:  "2",
		}
		sb.WriteString("# Storage\n")
		str := writeEntry(fstabEntry, SEP)
		sb.WriteString(str)
	}

	str := sb.String()
	fmt.Print(str)
}
