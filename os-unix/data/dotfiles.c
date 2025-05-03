#include <stddef.h>
#include <stdbool.h>

#pragma clang diagnostic error "-Wunused-variable"
#pragma clang diagnostic push

struct Entry {
	char const *category;
	char const *source;
	char const *destination;
};

#define H "/home/" Username "/"

#define Home(_category, path) { \
	.category = _category, \
	.source = H ".dotfiles/os-unix/" _category path, \
	.destination = H path \
}
#define Config(_category, path) { \
	.category = _category, \
	.source = H ".dotfiles/os-unix/" _category ".config/" path, \
	.destination = H ".config/" path \
}
#define Data(_category, path) { \
	.category = _category, \
	.source = H ".dotfiles/os-unix/" _category ".local/share/" path, \
	.destination = H ".local/share/" path \
}
#define DefineEntry(name, obj) \
	static struct Entry name[] = { obj, Done };

#define Done { \
	.category = NULL, \
	.source = NULL, \
	.destination = NULL \
}

// Macros
#define Username "edwin"
#define CategoryApplication "config-application/"
#define CategoryCli "config-cli/"
#define CategoryDotfileManager "config-dotfile-manager/"
#define CategoryEditor "config-editor/"
#define CategoryEmail "config-email/"
#define CategoryLanguage "config-language/"
#define CategoryLinuxCore "config-linux-core/"
#define CategoryLinuxExtra "config-linux-extra/"
#define CategoryLinuxRice "config-linux-rice/"
#define CategoryShell "config-shell/"
#define CategoryTerminal "config-terminal/"
#define CategoryTools "config-tool/"
#define CategoryVersionControl "config-version-control/"

// Applications
static struct Entry albert[] = {
	Config(CategoryApplication, "albert/albert.conf"),
	Data(CategoryApplication, "albert/python/plugins/"),
	Done,
};
DefineEntry(broot, Config(CategoryApplication, "broot/"))
DefineEntry(calcurse, Config(CategoryApplication, "calcurse/"))
DefineEntry(cmus, Config(CategoryApplication, "cmus/rc"))
DefineEntry(espanso, Config(CategoryApplication, "espanso/"))
DefineEntry(htop, Config(CategoryApplication, "htop/"))
DefineEntry(irssi, Config(CategoryApplication, "irssi/"))
DefineEntry(lazydocker, Config(CategoryApplication, "lazydocker/"))
DefineEntry(mnemosyne, Config(CategoryApplication, "mnemosyne/config.py"))
DefineEntry(mpv, Config(CategoryApplication, "mpv/"))
DefineEntry(nb, Config(CategoryApplication, "nb/"))
DefineEntry(ncmpcpp, Config(CategoryApplication, "ncmpcpp/"))
DefineEntry(octave, Config(CategoryApplication, "octave/"))
DefineEntry(OpenSCAD, Config(CategoryApplication, "OpenSCAD/"))
DefineEntry(ranger, Config(CategoryApplication, "ranger/"))
DefineEntry(slackTerm, Config(CategoryApplication, "slack-term/"))
DefineEntry(taskwarrior, Config(CategoryApplication, "taskwarrior/"))
DefineEntry(viewnior, Config(CategoryApplication, "viewnior/"))
DefineEntry(vimiv, Config(CategoryApplication, "vimiv/"))
DefineEntry(wtf, Config(CategoryApplication, "wtf/"))
DefineEntry(xplr, Config(CategoryApplication, "xplr/"))
DefineEntry(zathura, Config(CategoryApplication, "zathura/"))
DefineEntry(appimagelauncher, Config(CategoryApplication, "appimagelauncher.cfg"))
DefineEntry(llpp, Config(CategoryApplication, "llpp.conf"))
DefineEntry(blender, Data(CategoryApplication, "applications/FoxBlender.desktop"))
DefineEntry(gnuplot, Home(CategoryApplication, ".gnuplot"))

// CLIs
DefineEntry(aria2, Config(CategoryCli, "aria2/"))
DefineEntry(bat, Config(CategoryCli, "bat/"))
DefineEntry(ccache, Config(CategoryCli, "ccache/"))
DefineEntry(sccache, Config(CategoryCli, "sccache/"))
DefineEntry(cookiecutter, Config(CategoryCli, "cookiecutter/"))
DefineEntry(foxDefault, Config(CategoryCli, "fox-default/"))
DefineEntry(neofetch, Config(CategoryCli, "neofetch/"))
DefineEntry(pgcli, Config(CategoryCli, "pgcli/"))
DefineEntry(ripgrep, Config(CategoryCli, "ripgrep/"))
DefineEntry(rtorrent, Config(CategoryCli, "rtorrent/"))
DefineEntry(wget, Config(CategoryCli, "wget/"))
DefineEntry(youtubeDl, Config(CategoryCli, "youtube-dl/"))
DefineEntry(agignore, Home(CategoryCli, ".agignore"))
DefineEntry(psqlrc, Home(CategoryCli, ".psqlrc"))

// Dotfile Managers
DefineEntry(chezmoi, Config(CategoryDotfileManager, "chezmoi/"))
DefineEntry(dotdrop, Config(CategoryDotfileManager, "dotdrop/"))
DefineEntry(dotgen, Config(CategoryDotfileManager, "dotgen/"))
DefineEntry(rcrc, Home(CategoryDotfileManager, ".rcrc"))

// Editors
static struct Entry vscode[] = {
	Config(CategoryEditor, "Code/User/keybindings.json"),
	Config(CategoryEditor, "Code/User/settings.json"),
	Done,
};
static struct Entry ossCode[] = {
	{
		.category = CategoryEditor,
		.source = H ".config/Code/User/settings.json",
		.destination = H ".config/Code - OSS/User/settings.json"
	},
	Done
};
DefineEntry(helix, Config(CategoryEditor, "helix/"))
DefineEntry(kak, Config(CategoryEditor, "kak/"))
static struct Entry micro[] = {
	Config(CategoryEditor, "micro/bindings.json"),
	Config(CategoryEditor, "micro/settings.json"),
	Done,
};
DefineEntry(nano, Config(CategoryEditor, "nano/"))
DefineEntry(nvim, Config(CategoryEditor, "nvim/"))
DefineEntry(ox, Config(CategoryEditor, "ox/"))
static struct Entry sublimeText3[] = {
	Config(CategoryEditor, "sublime-text-3/Packages/User/Preferences.sublime-settings"),
	Config(CategoryEditor, "sublime-text-3/Packages/User/Package Control.sublime-settings"),
	Done,
};
DefineEntry(vim, Config(CategoryEditor, "vim/"))
DefineEntry(zed, Config(CategoryEditor, "zed/"))
DefineEntry(exrc, Home(CategoryEditor, ".exrc"))

// Email
static struct Entry aerc[] = {
	Config(CategoryEmail, "aerc/aerc.conf"),
	Config(CategoryEmail, "aerc/binds.conf"),
	Done,
};
DefineEntry(neomutt, Config(CategoryEmail, "neomutt/"))
DefineEntry(notmuch, Config(CategoryEmail, "notmuch/"))

// Language
DefineEntry(bpython, Config(CategoryLanguage, "bpython/"))
DefineEntry(cabal, Config(CategoryLanguage, "cabal/config"))
DefineEntry(cargo, Config(CategoryLanguage, "cargo/"))
DefineEntry(conda, Config(CategoryLanguage, "conda/"))
DefineEntry(gdb, Config(CategoryLanguage, "gdb/"))
DefineEntry(irb, Config(CategoryLanguage, "irb/"))
DefineEntry(maven, Config(CategoryLanguage, "maven/"))
DefineEntry(nimble, Config(CategoryLanguage, "nimble/"))
DefineEntry(npm, Config(CategoryLanguage, "npm/"))
DefineEntry(please, Config(CategoryLanguage, "please/"))
DefineEntry(pudb, Config(CategoryLanguage, "pudb/"))
DefineEntry(pylint, Config(CategoryLanguage, "pylint/"))
DefineEntry(pypoetry, Config(CategoryLanguage, "pypoetry/"))
DefineEntry(python, Config(CategoryLanguage, "python/"))
DefineEntry(yapf, Config(CategoryLanguage, "yapf/"))
DefineEntry(cpan, Home(CategoryLanguage, ".cpan/CPAN/MyConfig.pm"))
DefineEntry(sdkman, Data(CategoryLanguage, "sdkman/etc/config"))

// Linux Core
DefineEntry(curl, Config(CategoryLinuxCore, "curl/"))
DefineEntry(dircolors, Config(CategoryLinuxCore, "dircolors/"))
DefineEntry(environmentD, Config(CategoryLinuxCore, "environment.d/"))
DefineEntry(fontconfig, Config(CategoryLinuxCore, "fontconfig/"))
DefineEntry(info, Config(CategoryLinuxCore, "info/"))
DefineEntry(less, Config(CategoryLinuxCore, "less/"))
DefineEntry(most, Config(CategoryLinuxCore, "most/"))
DefineEntry(readline, Config(CategoryLinuxCore, "readline/"))
// DefineEntry(userDirsDirs, Config(CategoryLinuxCore, "user-dirs.dirs")) // Handled by "~/scripts/idempotent.sh".
DefineEntry(userDirsConf, Config(CategoryLinuxCore, "user-dirs.conf"))
DefineEntry(gnupgDirmngr, Home(CategoryLinuxCore, ".gnupg/dirmngr.conf"))
DefineEntry(gnupgGpg, Home(CategoryLinuxCore, ".gnupg/gpg.conf"))
DefineEntry(gnupgGpgAgent, Home(CategoryLinuxCore, ".gnupg/gpg-agent.conf"))
static struct Entry pamEnvironment[] = {
	{
		.category = CategoryLinuxCore,
		.source = (true ? H ".dotfiles/os-unix/" CategoryLinuxCore ".pam_environment/xdg-default.conf" : H ".pam_environment/xdg-custom.conf"),
		.destination = H ".pam_environment",
	},
	Done,
};
DefineEntry(digrc, Home(CategoryLinuxCore, ".digrc"))
DefineEntry(hushlogin, Home(CategoryLinuxCore, ".hushlogin"))

// Linux Extra
DefineEntry(ltrace, Config(CategoryLinuxExtra, "ltrace/"))
DefineEntry(pacman, Config(CategoryLinuxExtra, "pacman/"))
DefineEntry(paru, Config(CategoryLinuxExtra, "paru/"))
DefineEntry(toast, Config(CategoryLinuxExtra, "toast/"))
DefineEntry(udiskie, Config(CategoryLinuxExtra, "udiskie/"))
DefineEntry(yay, Config(CategoryLinuxExtra, "yay/"))
DefineEntry(aspell, Home(CategoryLinuxExtra, ".aspell.conf"))

// Linux Rice
DefineEntry(awesome, Config(CategoryLinuxRice, "awesome/"))
DefineEntry(bspwm, Config(CategoryLinuxRice, "bspwm/"))
DefineEntry(cava, Config(CategoryLinuxRice, "cava/"))
DefineEntry(cdm, Config(CategoryLinuxRice, "cdm/"))
DefineEntry(conky, Config(CategoryLinuxRice, "conky/"))
DefineEntry(dunst, Config(CategoryLinuxRice, "dunst/"))
DefineEntry(dxhd, Config(CategoryLinuxRice, "dxhd/"))
DefineEntry(eww, Config(CategoryLinuxRice, "eww/"))
DefineEntry(i3, Config(CategoryLinuxRice, "i3/"))
DefineEntry(i3blocks, Config(CategoryLinuxRice, "i3blocks/"))
DefineEntry(i3status, Config(CategoryLinuxRice, "i3status/"))
DefineEntry(i3statusRust, Config(CategoryLinuxRice, "i3status-rust/"))
DefineEntry(ly, Config(CategoryLinuxRice, "ly/"))
DefineEntry(mako, Config(CategoryLinuxRice, "mako/config"))
DefineEntry(mpd, Config(CategoryLinuxRice, "mpd/"))
DefineEntry(nitrogen, Config(CategoryLinuxRice, "nitrogen/"))
DefineEntry(openbox, Config(CategoryLinuxRice, "openbox/"))
DefineEntry(pacmixer, Config(CategoryLinuxRice, "pacmixer/"))
DefineEntry(picom, Config(CategoryLinuxRice, "picom/"))
DefineEntry(polybar, Config(CategoryLinuxRice, "polybar/"))
DefineEntry(rofi, Config(CategoryLinuxRice, "rofi/"))
DefineEntry(swaylock, Config(CategoryLinuxRice, "swaylock/"))
DefineEntry(sx, Config(CategoryLinuxRice, "sx/"))
DefineEntry(sxhkdrc, Config(CategoryLinuxRice, "sxhkdrc/"))
DefineEntry(taffybar, Config(CategoryLinuxRice, "taffybar/"))
DefineEntry(twmn, Config(CategoryLinuxRice, "twmn/"))
DefineEntry(wofi, Config(CategoryLinuxRice, "wofi/"))
DefineEntry(X11, Config(CategoryLinuxRice, "X11/"))
DefineEntry(xbindkeys, Config(CategoryLinuxRice, "xbindkeys/"))
DefineEntry(xkb, Config(CategoryLinuxRice, "xkb/"))
DefineEntry(xmobar, Config(CategoryLinuxRice, "xmobar/"))
DefineEntry(xob, Config(CategoryLinuxRice, "xob/"))
DefineEntry(emptty, Config(CategoryLinuxRice, "emptty"))
DefineEntry(ncpamixerConf, Config(CategoryLinuxRice, "ncpamixer.conf"))
DefineEntry(pamixConf, Config(CategoryLinuxRice, "pamix.conf"))
DefineEntry(pavucontrolIni, Config(CategoryLinuxRice, "pavucontrol.ini"))
DefineEntry(pulsemixerCfg, Config(CategoryLinuxRice, "pulsemixer.cfg"))

// Shell
DefineEntry(fish, Config(CategoryShell, "fish/"))
DefineEntry(ion, Config(CategoryShell, "ion/"))
DefineEntry(liquidprompt, Config(CategoryShell, "liquidprompt/"))
DefineEntry(nu, Config(CategoryShell, "nu/"))
DefineEntry(powerline, Config(CategoryShell, "powerline/"))
DefineEntry(sh, Config(CategoryShell, "sh/"))
DefineEntry(starship, Config(CategoryShell, "starship/"))
DefineEntry(zsh, Config(CategoryShell, "zsh/"))
static struct Entry bash[] = {
	Home(CategoryShell, ".bashrc"),
	Home(CategoryShell, ".bash_profile"),
	Home(CategoryShell, ".bash_logout"),
	Config(CategoryShell, "bash/"),
	Done
};
DefineEntry(cshrc, Home(CategoryShell, ".cshrc"))
DefineEntry(kshrc, Home(CategoryShell, ".kshrc"))
DefineEntry(login, Home(CategoryShell, ".login"))
DefineEntry(mkshrc, Home(CategoryShell, ".mkshrc"))
DefineEntry(profile, Home(CategoryShell, ".profile"))
DefineEntry(tcshrc, Home(CategoryShell, ".tcshrc"))
DefineEntry(zshenv, Home(CategoryShell, ".zshenv"))

// Terminal
DefineEntry(alacritty, Config(CategoryTerminal, "alacritty/"))
DefineEntry(kermit, Config(CategoryTerminal, "kermit/"))
DefineEntry(kitty, Config(CategoryTerminal, "kitty/"))
DefineEntry(screen, Config(CategoryTerminal, "screen/"))
DefineEntry(terminator, Config(CategoryTerminal, "terminator/"))
DefineEntry(termite, Config(CategoryTerminal, "termite/"))
DefineEntry(tmux, Config(CategoryTerminal, "tmux/"))
DefineEntry(urxvt, Config(CategoryTerminal, "urxvt/"))
DefineEntry(gtktermrc, Config(CategoryTerminal, ".gtktermrc"))
DefineEntry(hyperJs, Home(CategoryTerminal, ".hyper.js"))

// Tools
DefineEntry(cspell, Config(CategoryTools, "cspell/"))
DefineEntry(libfsguest, Config(CategoryTools, "libfsguest/"))
DefineEntry(nvchecker, Config(CategoryTools, "nvchecker/"))
DefineEntry(osc, Config(CategoryTools, "osc/"))
DefineEntry(redshift, Config(CategoryTools, "redshift/"))
DefineEntry(sheldon, Config(CategoryTools, "sheldon/"))
DefineEntry(urlwatch, Config(CategoryTools, "urlwatch/"))

// Version Control
DefineEntry(gh, Config(CategoryVersionControl, "gh/config.yml"))
DefineEntry(git, Config(CategoryVersionControl, "git/"))
DefineEntry(hg, Config(CategoryVersionControl, "hg/"))
DefineEntry(pijul, Config(CategoryVersionControl, "pijul/"))
DefineEntry(tig, Config(CategoryVersionControl, "tig/"))

struct Entry *configuration[] = {
	// albert,
	// broot,
	// calcurse,
	// cmus,
	// espanso,
	// htop,
	// irssi,
	// lazydocker,
	// mnemosyne,
	// mpv,
	// nb,
	// ncmpcpp,
	// octave,
	// OpenSCAD,
	// ranger,
	// slackTerm,
	// taskwarrior,
	// viewnior,
	// vimiv,
	// wtf,
	// xplr,
	// zathura,
	appimagelauncher,
	// llpp,
	// blender,
	// gnuplot,
	// aria2,
	// bat,
	// ccache,
	// sccache,
	// cookiecutter,
	foxDefault, // TODO
	// neofetch,
	// pgcli,
	// ripgrep,
	// rtorrent,
	wget,
	youtubeDl,
	// agignore,
	// psqlrc,
	// chezmoi,
	// dotdrop,
	// dotgen,
	// rcrc,
	vscode,
	// ossCode,
	// helix,
	// kak,
	// micro,
	nano,
	nvim,
	// ox,
	// sublimeText3,
	vim,
	zed,
	// exrc,
	// aerc,
	// neomutt,
	// notmuch,
	// bpython,
	// cabal,
	// cargo,
	// conda,
	// gdb,
	// irb,
	// maven,
	// nimble,
	npm,
	// please,
	// pudb,
	// pylint,
	// pypoetry,
	// python,
	// yapf,
	// cpan,
	// sdkman,
	// curl,
	dircolors,
	environmentD,
	// fontconfig,
	info,
	less,
	// most,
	readline,
	// userDirsDirs,
	userDirsConf,
	gnupgDirmngr,
	gnupgGpg,
	gnupgGpgAgent,
	// pamEnvironment,
	// digrc,
	// hushlogin,
	// ltrace,
	// pacman,
	// paru,
	// toast,
	// udiskie,
	// yay,
	// aspell,
	// awesome,
	// bspwm,
	// cava,
	// cdm,
	// conky,
	// dunst,
	// dxhd,
	// eww,
	// i3,
	// i3blocks,
	// i3status,
	// i3statusRust,
	// ly,
	// mako,
	// mpd,
	// nitrogen,
	// openbox,
	// pacmixer,
	// picom,
	// polybar,
	// rofi,
	// swaylock,
	// sx,
	// sxhkdrc,
	// taffybar,
	// twmn,
	// wofi,
	// X11,
	// xbindkeys,
	// xkb,
	// xmobar,
	// xob,
	// emptty,
	// ncpamixerConf,
	// pamixConf,
	// pavucontrolIni,
	// pulsemixerCfg,
	// fish,
	// ion,
	// liquidprompt,
	// nu,
	// powerline,
	sh,
	// starship,
	zsh,
	bash,
	// cshrc,
	// kshrc,
	// login,
	// mkshrc,
	profile,
	// tcshrc,
	// zshenv,
	// alacritty,
	// kermit,
	// kitty,
	// screen,
	// terminator,
	// termite,
	// tmux,
	// urxvt,
	// gtktermrc,
	// hyperJs,
	// cspell,
	// libfsguest,
	// nvchecker,
	// osc,
	// redshift,
	// sheldon,
	// urlwatch,
	gh,
	git,
	// hg,
	// pijul,
	// tig,
	NULL,
};

#pragma clang diagnostic pop
