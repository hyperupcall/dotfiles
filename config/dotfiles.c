#include <stdbool.h>
#include <stddef.h>
#include "d.h"

#pragma clang diagnostic warning "-Wunused-variable"
#pragma clang diagnostic push

// Macros.
#define Hme CONFIG_HOME "/"
#define Src Dst ".dotfiles/"
#define Dst Hme

// Applications.
#define CategoryApplication "config-application/"
static Item albert[] = {
	Config("albert/albert.conf", CategoryApplication),
	Data("albert/python/plugins/", CategoryApplication),
	Done,
};
static Item broot[] = ConfigEntry("broot/", CategoryApplication);
static Item calcurse[] = ConfigEntry("calcurse/", CategoryApplication);
static Item cmus[] = ConfigEntry("cmus/rc", CategoryApplication);
static Item espanso[] = ConfigEntry("espanso/", CategoryApplication);
static Item htop[] = ConfigEntry("htop/", CategoryApplication);
static Item irssi[] = HomeEntry(".irssi/", CategoryApplication);
static Item lazydocker[] = ConfigEntry("lazydocker/", CategoryApplication);
static Item mnemosyne[] = ConfigEntry("mnemosyne/config.py", CategoryApplication);
static Item mpv[] = ConfigEntry("mpv/", CategoryApplication);
static Item nb[] = ConfigEntry("nb/", CategoryApplication);
static Item ncmpcpp[] = ConfigEntry("ncmpcpp/", CategoryApplication);
static Item octave[] = ConfigEntry("octave/", CategoryApplication);
static Item ranger[] = ConfigEntry("ranger/", CategoryApplication);
static Item taskwarrior[] = ConfigEntry("taskwarrior/", CategoryApplication);
static Item viewnior[] = ConfigEntry("viewnior/", CategoryApplication);
static Item vimiv[] = ConfigEntry("vimiv/", CategoryApplication);
static Item wtf[] = ConfigEntry("wtf/", CategoryApplication);
static Item xplr[] = ConfigEntry("xplr/", CategoryApplication);
static Item zathura[] = ConfigEntry("zathura/", CategoryApplication);
static Item llpp[] = ConfigEntry("llpp.conf", CategoryApplication);
static Item blender[] = DataEntry("applications/FoxBlender.desktop", CategoryApplication);
static Item gnuplot[] = HomeEntry(".gnuplot", CategoryApplication);
static Item librewolf[] = ConfigEntry("librewolf/librewolf/librewolf.overrides.cfg", CategoryApplication);
static Item firefox[] = ConfigEntry("mozilla/firefox/user.js", CategoryApplication);

// Command Line Interfaces.
#define CategoryCli "config-cli/"
static Item aria2[] = ConfigEntry("aria2/", CategoryCli);
static Item bat[] = ConfigEntry("bat/", CategoryCli);
static Item ccache[] = ConfigEntry("ccache/", CategoryCli);
static Item sccache[] = ConfigEntry("sccache/", CategoryCli);
static Item neofetch[] = ConfigEntry("neofetch/", CategoryCli);
static Item pgcli[] = ConfigEntry("pgcli/", CategoryCli);
static Item ripgrep[] = ConfigEntry("ripgrep/", CategoryCli);
static Item rtorrent[] = ConfigEntry("rtorrent/", CategoryCli);
static Item youtubeDl[] = ConfigEntry("youtube-dl/", CategoryCli);
static Item agignore[] = HomeEntry(".agignore", CategoryCli);
static Item psqlrc[] = HomeEntry(".psqlrc", CategoryCli);
static Item ltrace[] = ConfigEntry("ltrace/", CategoryCli);
static Item pacman[] = ConfigEntry("pacman/", CategoryCli);
static Item paru[] = ConfigEntry("paru/", CategoryCli);
static Item toast[] = ConfigEntry("toast/", CategoryCli);
static Item udiskie[] = ConfigEntry("udiskie/", CategoryCli);
static Item yay[] = ConfigEntry("yay/", CategoryCli);
static Item aspell[] = HomeEntry(".aspell.conf", CategoryCli);
static Item cspell[] = ConfigEntry("cspell/", CategoryCli);
static Item libfsguest[] = ConfigEntry("libfsguest/", CategoryCli);
static Item nvchecker[] = ConfigEntry("nvchecker/", CategoryCli);
static Item osc[] = ConfigEntry("osc/", CategoryCli);
static Item redshift[] = ConfigEntry("redshift/", CategoryCli);
static Item urlwatch[] = ConfigEntry("urlwatch/", CategoryCli);
static Item garden[] = ConfigEntry("garden/", CategoryCli);

// Dotfile Managers.
#define CategoryDotfileManager "config-dotfile-manager/"
static Item chezmoi[] = ConfigEntry("chezmoi/", CategoryDotfileManager);
static Item dotdrop[] = ConfigEntry("dotdrop/", CategoryDotfileManager);
static Item dotgen[] = ConfigEntry("dotgen/", CategoryDotfileManager);
static Item rcrc[] = HomeEntry(".rcrc", CategoryDotfileManager);

// Editors.
#define CategoryEditor "config-editor/"
static Item vscode[] = {
	Config("Code/User/keybindings.json", CategoryEditor),
	Config("Code/User/settings.json", CategoryEditor),
	Config("Code/User/snippets/", CategoryEditor),
	Done,
};
static Item ossCode[] = {
	// clang-format off
	{
		.type = TYPE_ENTRY,
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/keybindings.json",
		.destination = Dst ".config/Code - OSS/User/keybindings.json"
	},
	{
		.type = TYPE_ENTRY,
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/settings.json",
		.destination = Dst ".config/Code - OSS/User/settings.json"
	},
	{
		.type = TYPE_ENTRY,
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/snippets/",
		.destination = Dst ".config/Code - OSS/User/snippets/"
	},
	Done
	// clang-format on
};
static Item sublimeText3[] = {
	Config("sublime-text-3/Packages/User/Preferences.sublime-settings", CategoryEditor),
	Config("sublime-text-3/Packages/User/Package Control.sublime-settings", CategoryEditor),
	Done,
};
static Item zed[] = ConfigEntry("zed/", CategoryEditor);
static Item kate[] = ConfigEntry("kate/formatting/settings.json", CategoryEditor);
static Item vim[] = ConfigEntry("vim/", CategoryEditor);
static Item nvim[] = ConfigEntry("nvim/", CategoryEditor);
static Item helix[] = ConfigEntry("helix/", CategoryEditor);
static Item kak[] = ConfigEntry("kak/", CategoryEditor);
static Item micro[] = {
	Config("micro/bindings.json", CategoryEditor),
	Config("micro/settings.json", CategoryEditor),
	Done,
};
static Item nano[] = ConfigEntry("nano/", CategoryEditor);
static Item ox[] = ConfigEntry("ox/", CategoryEditor);
static Item exrc[] = HomeEntry(".exrc", CategoryEditor);
static Item defaultEditorGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		vscode,
		ossCode,
		sublimeText3,
		zed,
		kate,
		vim,
		nvim,
		nano,
		NULL
	}
};
static Item serverEditorGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		vscode,
		ossCode,
		sublimeText3,
		zed,
		kate,
		vim,
		nvim,
		NULL
	}
};

// Email.
#define CategoryEmail "config-email/"
static Item aerc[] = {
	Config("aerc/aerc.conf", CategoryEmail),
	Config("aerc/binds.conf", CategoryEmail),
	Done,
};
static Item neomutt[] = ConfigEntry("neomutt/", CategoryEmail);
static Item notmuch[] = ConfigEntry("notmuch/", CategoryEmail);

// Language.
#define CategoryLanguage "config-language/"
static Item python[] = {
	Config("python/", CategoryLanguage),
	Config("bpython/", CategoryLanguage),
	Done,
};
static Item cargo[] = ConfigEntry("cargo/", CategoryLanguage);
static Item clangFormat[] = HomeEntry(".clang-format", CategoryLanguage);
static Item conda[] = HomeEntry(".condarc", CategoryLanguage);
static Item gdb[] = ConfigEntry("gdb/", CategoryLanguage);
static Item irb[] = ConfigEntry("irb/", CategoryLanguage);
static Item nimble[] = ConfigEntry("nimble/", CategoryLanguage);
static Item npm[] = HomeEntry(".npmrc", CategoryLanguage);
static Item please[] = ConfigEntry("please/", CategoryLanguage);
static Item pudb[] = ConfigEntry("pudb/", CategoryLanguage);
static Item pylint[] = ConfigEntry("pylintrc", CategoryLanguage);
static Item pypoetry[] = ConfigEntry("pypoetry/", CategoryLanguage);
static Item tombi[] = ConfigEntry("tombi/", CategoryLanguage);
static Item yapf[] = ConfigEntry("yapf/", CategoryLanguage);
static Item sdkman[] = DataEntry("sdkman/etc/config", CategoryLanguage);
static Item yamlfmt[] = ConfigEntry("yamlfmt/", CategoryLanguage);
static Item yamllint[] = ConfigEntry("yamllint/", CategoryLanguage);
static Item defaultLanguageGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		python,
		cargo,
		clangFormat,
		conda,
		gdb,
		irb,
		npm,
		please,
		pylint,
		pypoetry,
		tombi,
		yapf,
		sdkman,
		yamlfmt,
		yamllint,
		NULL,
	}
};

// Linux Core.
#define CategoryLinuxCore "config-linux-core/"
static Item curl[] = ConfigEntry("curlrc", CategoryLinuxCore);
static Item wget[] = HomeEntry(".wgetrc", CategoryLinuxCore);
static Item dircolors[] = ConfigEntry("dircolors/", CategoryLinuxCore);
static Item environmentD[] = ConfigEntry("environment.d/", CategoryLinuxCore);
static Item fontconfig[] = ConfigEntry("fontconfig/", CategoryLinuxCore);
static Item info[] = ConfigEntry("info/", CategoryLinuxCore);
static Item less[] = ConfigEntry("less/", CategoryLinuxCore);
static Item most[] = HomeEntry(".mostrc", CategoryLinuxCore);
static Item readline[] = HomeEntry(".inputrc", CategoryLinuxCore);
static Item userDirsConf[] = ConfigEntry("user-dirs.conf", CategoryLinuxCore);
static Item gnupgDirmngr[] = HomeEntry(".gnupg/dirmngr.conf", CategoryLinuxCore);
static Item gnupgGpg[] = HomeEntry(".gnupg/gpg.conf", CategoryLinuxCore);
static Item gnupgGpgAgent[] = HomeEntry(".gnupg/gpg-agent.conf", CategoryLinuxCore);
static Item pamEnvironment[] = {
	{
		.type = TYPE_ENTRY,
		.category = CategoryLinuxCore,
		.source = (true ? Src CategoryLinuxCore ".pam_environment/xdg-default.conf"
							 : Dst ".pam_environment/xdg-custom.conf"),
		.destination = Dst ".pam_environment",
	 },
	Done,
};
static Item digrc[] = HomeEntry(".digrc", CategoryLinuxCore);
static Item hushlogin[] = HomeEntry(".hushlogin", CategoryLinuxCore);
static Item defaultLinuxCoreGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		curl,
		wget,
		dircolors,
		environmentD,
		fontconfig,
		info,
		less,
		most,
		readline,
		userDirsConf,
		gnupgDirmngr,
		gnupgGpg,
		gnupgGpgAgent,
		pamEnvironment,
		digrc,
		NULL
	}
};
static Item serverLinuxCoreGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		dircolors,
		info,
		less,
		most,
		readline,
		digrc,
		NULL,
	}
};

// Linux Rice.
#define CategoryLinuxRice "config-linux-rice/"
static Item awesome[] = ConfigEntry("awesome/", CategoryLinuxRice);
static Item bspwm[] = ConfigEntry("bspwm/", CategoryLinuxRice);
static Item cava[] = ConfigEntry("cava/", CategoryLinuxRice);
static Item cdm[] = ConfigEntry("cdm/", CategoryLinuxRice);
static Item conky[] = ConfigEntry("conky/", CategoryLinuxRice);
static Item dunst[] = ConfigEntry("dunst/", CategoryLinuxRice);
static Item dxhd[] = ConfigEntry("dxhd/", CategoryLinuxRice);
static Item eww[] = ConfigEntry("eww/", CategoryLinuxRice);
static Item i3[] = ConfigEntry("i3/", CategoryLinuxRice);
static Item i3blocks[] = ConfigEntry("i3blocks/", CategoryLinuxRice);
static Item i3status[] = ConfigEntry("i3status/", CategoryLinuxRice);
static Item i3statusRust[] = ConfigEntry("i3status-rust/", CategoryLinuxRice);
static Item ly[] = ConfigEntry("ly/", CategoryLinuxRice);
static Item mako[] = ConfigEntry("mako/config", CategoryLinuxRice);
static Item mpd[] = ConfigEntry("mpd/", CategoryLinuxRice);
static Item nitrogen[] = ConfigEntry("nitrogen/", CategoryLinuxRice);
static Item openbox[] = ConfigEntry("openbox/", CategoryLinuxRice);
static Item pacmixer[] = ConfigEntry("pacmixer/", CategoryLinuxRice);
static Item picom[] = ConfigEntry("picom/", CategoryLinuxRice);
static Item polybar[] = ConfigEntry("polybar/", CategoryLinuxRice);
static Item rofi[] = ConfigEntry("rofi/", CategoryLinuxRice);
static Item swaylock[] = ConfigEntry("swaylock/", CategoryLinuxRice);
static Item sx[] = ConfigEntry("sx/", CategoryLinuxRice);
static Item sxhkdrc[] = ConfigEntry("sxhkdrc/", CategoryLinuxRice);
static Item taffybar[] = ConfigEntry("taffybar/", CategoryLinuxRice);
static Item twmn[] = ConfigEntry("twmn/", CategoryLinuxRice);
static Item wofi[] = ConfigEntry("wofi/", CategoryLinuxRice);
static Item X11[] = ConfigEntry("X11/", CategoryLinuxRice);
static Item xbindkeys[] = ConfigEntry("xbindkeys/", CategoryLinuxRice);
static Item xkb[] = ConfigEntry("xkb/", CategoryLinuxRice);
static Item xmobar[] = ConfigEntry("xmobar/", CategoryLinuxRice);
static Item xob[] = ConfigEntry("xob/", CategoryLinuxRice);
static Item emptty[] = ConfigEntry("emptty", CategoryLinuxRice);
static Item ncpamixerConf[] = ConfigEntry("ncpamixer.conf", CategoryLinuxRice);
static Item pamixConf[] = ConfigEntry("pamix.conf", CategoryLinuxRice);
static Item pavucontrolIni[] = ConfigEntry("pavucontrol.ini", CategoryLinuxRice);
static Item pulsemixerCfg[] = ConfigEntry("pulsemixer.cfg", CategoryLinuxRice);

// Shell.
#define CategoryShell "config-shell/"
static Item sh[] = {
	// clang-format off
	Config("sh/", CategoryShell),
	Home(".profile", CategoryShell),
	Done
	// clang-format on
};
static Item bash[] = {
	// clang-format off
	Home(".bashrc", CategoryShell),
	Home(".bash_profile", CategoryShell),
	Home(".bash_logout", CategoryShell),
	Config("bash/", CategoryShell),
	Config("blesh/", CategoryShell),
	Done
	// clang-format on
};
static Item zsh[] = {
	// clang-format off
	Config("zsh/", CategoryShell),
	Home(".zshenv", CategoryShell),
	Done
	// clang-format on
};
static Item sheldon[] = ConfigEntry("sheldon/", CategoryShell);
static Item fish[] = ConfigEntry("fish/", CategoryShell);
static Item ion[] = ConfigEntry("ion/", CategoryShell);
static Item liquidprompt[] = ConfigEntry("liquidprompt/", CategoryShell);
static Item nu[] = ConfigEntry("nu/", CategoryShell);
static Item powerline[] = ConfigEntry("powerline/", CategoryShell);
static Item starship[] = ConfigEntry("starship.toml", CategoryShell);
static Item sbp[] = ConfigEntry("sbp/", CategoryShell);
static Item cshrc[] = HomeEntry(".cshrc", CategoryShell);
static Item kshrc[] = HomeEntry(".kshrc", CategoryShell);
static Item login[] = HomeEntry(".login", CategoryShell);
static Item mkshrc[] = HomeEntry(".mkshrc", CategoryShell);
static Item tcshrc[] = HomeEntry(".tcshrc", CategoryShell);
static Item basicShellGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		sh,
		bash,
		readline,
		zsh,
		NULL
	}
};
static Item defaultShellGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		sh,
		bash,
		readline,
		zsh,
		fish,
		ion,
		liquidprompt,
		nu,
		powerline,
		starship,
		sbp,
		NULL
	}
};
static Item serverShellGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		sh,
		bash,
		readline,
		NULL
	}
};

// Terminal.
#define CategoryTerminal "config-terminal/"
static Item alacritty[] = ConfigEntry("alacritty/", CategoryTerminal);
static Item kitty[] = ConfigEntry("kitty/", CategoryTerminal);
static Item ghostty[] = ConfigEntry("ghostty/", CategoryTerminal);
static Item kermit[] = ConfigEntry("kermit/", CategoryTerminal);
static Item terminator[] = ConfigEntry("terminator/", CategoryTerminal);
static Item tmux[] = ConfigEntry("tmux/", CategoryTerminal);
static Item screen[] = ConfigEntry("sWcreen/", CategoryTerminal);
static Item gtktermrc[] = ConfigEntry(".gtktermrc", CategoryTerminal);
static Item urxvt[] = ConfigEntry("urxvt/", CategoryTerminal);
static Item hyperJs[] = HomeEntry(".hyper.js", CategoryTerminal);
static Item termite[] = ConfigEntry("termite/", CategoryTerminal);
static Item defaultTerminalGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		alacritty,
		kitty,
		ghostty,
		tmux,
		NULL
	}
};
static Item serverTerminalGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		tmux,
		NULL
	}
};

// Version Control.
#define CategoryVersionControl "config-version-control/"
static Item git[] = ConfigEntry("git/", CategoryVersionControl);
static Item gh[] = ConfigEntry("gh/config.yml", CategoryVersionControl);
static Item hg[] = ConfigEntry("hg/", CategoryVersionControl);
static Item jj[] = ConfigEntry("jj/", CategoryVersionControl);
static Item pijul[] = ConfigEntry("pijul/", CategoryVersionControl);
static Item tig[] = ConfigEntry("tig/", CategoryVersionControl);
static Item basicVersionControlGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		git,
		NULL
	}
};
static Item defaultVersionControlGroup = {
	.type = TYPE_GROUP,
	.entries = (Item *[]){
		git,
		gh,
		hg,
		jj,
		NULL
	}
};

// Deployments.
static Deployment defaultDeployment = {
	.name = "Default",
	.items = (Item *[]){
		&defaultLinuxCoreGroup,
		&defaultShellGroup,
		&defaultTerminalGroup,
		&defaultVersionControlGroup,
		&defaultEditorGroup,
		&defaultLanguageGroup,
		youtubeDl,
		garden,
		aria2,
		firefox,
		librewolf,
		NULL
	}
};

static Deployment serverDeployment = {
	.name = "Server",
	.items = (Item *[]){
		&serverLinuxCoreGroup,
		&serverShellGroup,
		&serverTerminalGroup,
		&basicVersionControlGroup,
		&serverEditorGroup,
	}
};

static Deployment riceDeployment = {
	.name = "Rice",
	.items = (Item *[]){
		albert,
		broot,
		calcurse,
		cmus,
		espanso,
		htop,
		irssi,
		lazydocker,
		mnemosyne,
		mpv,
		nb,
		ncmpcpp,
		octave,
		taskwarrior,
		viewnior,
		vimiv,
		wtf,
		xplr,
		zathura,
		llpp,
		blender,
		gnuplot,
		aria2,
		bat,
		ccache,
		sccache,
		neofetch,
		pgcli,
		ripgrep,
		rtorrent,
		agignore,
		psqlrc,
		chezmoi,
		dotdrop,
		dotgen,
		rcrc,
		ossCode,
		helix,
		kak,
		micro,
		ox,
		sublimeText3,
		exrc,
		aerc,
		neomutt,
		notmuch,
		cargo,
		conda,
		gdb,
		irb,
		nimble,
		please,
		pudb,
		pylint,
		pypoetry,
		yapf,
		sdkman,
		curl,
		fontconfig,
		most,
		pamEnvironment,
		digrc,
		ltrace,
		pacman,
		paru,
		toast,
		udiskie,
		yay,
		aspell,
		awesome,
		bspwm,
		cava,
		cdm,
		conky,
		dunst,
		dxhd,
		eww,
		i3,
		i3blocks,
		i3status,
		i3statusRust,
		ly,
		mako,
		mpd,
		nitrogen,
		openbox,
		pacmixer,
		picom,
		polybar,
		rofi,
		swaylock,
		sx,
		sxhkdrc,
		taffybar,
		twmn,
		wofi,
		X11,
		xbindkeys,
		xkb,
		xmobar,
		xob,
		emptty,
		ncpamixerConf,
		pamixConf,
		pavucontrolIni,
		pulsemixerCfg,
		fish,
		ion,
		liquidprompt,
		nu,
		powerline,
		starship,
		cshrc,
		kshrc,
		login,
		mkshrc,
		tcshrc,
		kermit,
		screen,
		terminator,
		termite,
		tmux,
		urxvt,
		gtktermrc,
		hyperJs,
		cspell,
		libfsguest,
		nvchecker,
		osc,
		redshift,
		sheldon,
		urlwatch,
		garden,
		hg,
		jj,
		pijul,
		tig,
		NULL
	}
};

static Deployment* deployments[] = {
	&defaultDeployment,
	&serverDeployment,
	&riceDeployment,
	NULL
};

Deployment **getDeployments() {
	return deployments;
}

Deployment *getDefaultDeployment() {
	return &defaultDeployment;
}

#pragma clang diagnostic pop
