#include <stdbool.h>
#include <stddef.h>
#include "d.h"

#pragma clang diagnostic warning "-Wunused-variable"
#pragma clang diagnostic push

// Macros.
#define Hme CONFIG_HOME "/"
#define Src Dst ".dotfiles/"
#define Dst Hme

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

// Applications.
static Entry albert[] = {
	Config("albert/albert.conf", CategoryApplication),
	Data("albert/python/plugins/", CategoryApplication),
	Done,
};
static Entry broot[] = ConfigEntry("broot/", CategoryApplication);
static Entry calcurse[] = ConfigEntry("calcurse/", CategoryApplication);
static Entry cmus[] = ConfigEntry("cmus/rc", CategoryApplication);
static Entry espanso[] = ConfigEntry("espanso/", CategoryApplication);
static Entry htop[] = ConfigEntry("htop/", CategoryApplication);
static Entry irssi[] = HomeEntry(".irssi/", CategoryApplication);
static Entry lazydocker[] = ConfigEntry("lazydocker/", CategoryApplication);
static Entry mnemosyne[] = ConfigEntry("mnemosyne/config.py", CategoryApplication);
static Entry mpv[] = ConfigEntry("mpv/", CategoryApplication);
static Entry nb[] = ConfigEntry("nb/", CategoryApplication);
static Entry ncmpcpp[] = ConfigEntry("ncmpcpp/", CategoryApplication);
static Entry octave[] = ConfigEntry("octave/", CategoryApplication);
static Entry ranger[] = ConfigEntry("ranger/", CategoryApplication);
static Entry taskwarrior[] = ConfigEntry("taskwarrior/", CategoryApplication);
static Entry viewnior[] = ConfigEntry("viewnior/", CategoryApplication);
static Entry vimiv[] = ConfigEntry("vimiv/", CategoryApplication);
static Entry wtf[] = ConfigEntry("wtf/", CategoryApplication);
static Entry xplr[] = ConfigEntry("xplr/", CategoryApplication);
static Entry zathura[] = ConfigEntry("zathura/", CategoryApplication);
static Entry llpp[] = ConfigEntry("llpp.conf", CategoryApplication);
static Entry blender[] = DataEntry("applications/FoxBlender.desktop", CategoryApplication);
static Entry gnuplot[] = HomeEntry(".gnuplot", CategoryApplication);
static Entry librewolf[] = {
	Home(".librewolf/librewolf.overrides.cfg", CategoryApplication),
	Home(".librewolf/kpfswkqk.default-default/chrome/userChrome.css", CategoryApplication),
	Home(".librewolf/kpfswkqk.default-default/chrome/userChrome.js", CategoryApplication),
	Done,
};

// Command Line Interfaces.
static Entry aria2[] = ConfigEntry("aria2/", CategoryCli);
static Entry bat[] = ConfigEntry("bat/", CategoryCli);
static Entry ccache[] = ConfigEntry("ccache/", CategoryCli);
static Entry sccache[] = ConfigEntry("sccache/", CategoryCli);
static Entry cookiecutter[] = ConfigEntry("cookiecutter/", CategoryCli);
static Entry neofetch[] = ConfigEntry("neofetch/", CategoryCli);
static Entry pgcli[] = ConfigEntry("pgcli/", CategoryCli);
static Entry ripgrep[] = ConfigEntry("ripgrep/", CategoryCli);
static Entry rtorrent[] = ConfigEntry("rtorrent/", CategoryCli);
static Entry wget[] = HomeEntry(".wgetrc", CategoryCli);
static Entry youtubeDl[] = ConfigEntry("youtube-dl/", CategoryCli);
static Entry agignore[] = HomeEntry(".agignore", CategoryCli);
static Entry psqlrc[] = HomeEntry(".psqlrc", CategoryCli);

// Dotfile Managers.
static Entry chezmoi[] = ConfigEntry("chezmoi/", CategoryDotfileManager);
static Entry dotdrop[] = ConfigEntry("dotdrop/", CategoryDotfileManager);
static Entry dotgen[] = ConfigEntry("dotgen/", CategoryDotfileManager);
static Entry rcrc[] = HomeEntry(".rcrc", CategoryDotfileManager);

// Editors.
static Entry vscode[] = {
	Config("Code/User/keybindings.json", CategoryEditor),
	Config("Code/User/settings.json", CategoryEditor),
	Config("Code/User/snippets/", CategoryEditor),
	Done,
};
static Entry ossCode[] = {
	// clang-format off
	{
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/keybindings.json",
		.destination = Hme ".config/Code - OSS/User/keybindings.json"
	},
	{
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/settings.json",
		.destination = Hme ".config/Code - OSS/User/settings.json"
	},
	{
		.category = CategoryEditor,
		.source = Hme ".config/Code/User/snippets/",
		.destination = Hme ".config/Code - OSS/User/snippets/"
	},
	Done
	// clang-format on
};
static Entry helix[] = ConfigEntry("helix/", CategoryEditor);
static Entry kak[] = ConfigEntry("kak/", CategoryEditor);
static Entry micro[] = {
	Config("micro/bindings.json", CategoryEditor),
	Config("micro/settings.json", CategoryEditor),
	Done,
};
static Entry nano[] = ConfigEntry("nano/", CategoryEditor);
static Entry nvim[] = ConfigEntry("nvim/", CategoryEditor);
static Entry ox[] = ConfigEntry("ox/", CategoryEditor);
static Entry sublimeText3[] = {
	Config("sublime-text-3/Packages/User/Preferences.sublime-settings", CategoryEditor),
	Config("sublime-text-3/Packages/User/Package Control.sublime-settings", CategoryEditor),
	Done,
};
static Entry vim[] = ConfigEntry("vim/", CategoryEditor);
static Entry zed[] = ConfigEntry("zed/", CategoryEditor);
static Entry exrc[] = HomeEntry(".exrc", CategoryEditor);

// Email.
static Entry aerc[] = {
	Config("aerc/aerc.conf", CategoryEmail),
	Config("aerc/binds.conf", CategoryEmail),
	Done,
};
static Entry neomutt[] = ConfigEntry("neomutt/", CategoryEmail);
static Entry notmuch[] = ConfigEntry("notmuch/", CategoryEmail);

// Language.
static Entry bpython[] = ConfigEntry("bpython/", CategoryLanguage);
static Entry cargo[] = ConfigEntry("cargo/", CategoryLanguage);
static Entry conda[] = ConfigEntry("conda/", CategoryLanguage);
static Entry gdb[] = ConfigEntry("gdb/", CategoryLanguage);
static Entry irb[] = ConfigEntry("irb/", CategoryLanguage);
static Entry nimble[] = ConfigEntry("nimble/", CategoryLanguage);
static Entry npm[] = HomeEntry(".npmrc", CategoryLanguage);
static Entry please[] = ConfigEntry("please/", CategoryLanguage);
static Entry pudb[] = ConfigEntry("pudb/", CategoryLanguage);
static Entry pylint[] = ConfigEntry("pylint/", CategoryLanguage);
static Entry pypoetry[] = ConfigEntry("pypoetry/", CategoryLanguage);
static Entry python[] = ConfigEntry("python/", CategoryLanguage);
static Entry yapf[] = ConfigEntry("yapf/", CategoryLanguage);
static Entry cpan[] = HomeEntry(".cpan/CPAN/MyConfig.pm", CategoryLanguage);
static Entry sdkman[] = DataEntry("sdkman/etc/config", CategoryLanguage);

// Linux Core.
static Entry curl[] = ConfigEntry("curl/", CategoryLinuxCore);
static Entry dircolors[] = ConfigEntry("dircolors/", CategoryLinuxCore);
static Entry environmentD[] = ConfigEntry("environment.d/", CategoryLinuxCore);
static Entry fontconfig[] = ConfigEntry("fontconfig/", CategoryLinuxCore);
static Entry info[] = ConfigEntry("info/", CategoryLinuxCore);
static Entry less[] = ConfigEntry("less/", CategoryLinuxCore);
static Entry most[] = ConfigEntry("most/", CategoryLinuxCore);
static Entry readline[] = HomeEntry(".inputrc", CategoryLinuxCore);
static Entry userDirsConf[] = ConfigEntry("user-dirs.conf", CategoryLinuxCore);
static Entry gnupgDirmngr[] = HomeEntry(".gnupg/dirmngr.conf", CategoryLinuxCore);
static Entry gnupgGpg[] = HomeEntry(".gnupg/gpg.conf", CategoryLinuxCore);
static Entry gnupgGpgAgent[] = HomeEntry(".gnupg/gpg-agent.conf", CategoryLinuxCore);
static Entry pamEnvironment[] = {
	{
		.category = CategoryLinuxCore,
		.source = (true ? Src CategoryLinuxCore ".pam_environment/xdg-default.conf"
							 : Dst ".pam_environment/xdg-custom.conf"),
		.destination = Dst ".pam_environment",
	 },
	Done,
};
static Entry digrc[] = HomeEntry(".digrc", CategoryLinuxCore);
static Entry hushlogin[] = HomeEntry(".hushlogin", CategoryLinuxCore);

// Linux Extra.
static Entry ltrace[] = ConfigEntry("ltrace/", CategoryLinuxExtra);
static Entry pacman[] = ConfigEntry("pacman/", CategoryLinuxExtra);
static Entry paru[] = ConfigEntry("paru/", CategoryLinuxExtra);
static Entry toast[] = ConfigEntry("toast/", CategoryLinuxExtra);
static Entry udiskie[] = ConfigEntry("udiskie/", CategoryLinuxExtra);
static Entry yay[] = ConfigEntry("yay/", CategoryLinuxExtra);
static Entry aspell[] = HomeEntry(".aspell.conf", CategoryLinuxExtra);

// Linux Rice.
static Entry awesome[] = ConfigEntry("awesome/", CategoryLinuxRice);
static Entry bspwm[] = ConfigEntry("bspwm/", CategoryLinuxRice);
static Entry cava[] = ConfigEntry("cava/", CategoryLinuxRice);
static Entry cdm[] = ConfigEntry("cdm/", CategoryLinuxRice);
static Entry conky[] = ConfigEntry("conky/", CategoryLinuxRice);
static Entry dunst[] = ConfigEntry("dunst/", CategoryLinuxRice);
static Entry dxhd[] = ConfigEntry("dxhd/", CategoryLinuxRice);
static Entry eww[] = ConfigEntry("eww/", CategoryLinuxRice);
static Entry i3[] = ConfigEntry("i3/", CategoryLinuxRice);
static Entry i3blocks[] = ConfigEntry("i3blocks/", CategoryLinuxRice);
static Entry i3status[] = ConfigEntry("i3status/", CategoryLinuxRice);
static Entry i3statusRust[] = ConfigEntry("i3status-rust/", CategoryLinuxRice);
static Entry ly[] = ConfigEntry("ly/", CategoryLinuxRice);
static Entry mako[] = ConfigEntry("mako/config", CategoryLinuxRice);
static Entry mpd[] = ConfigEntry("mpd/", CategoryLinuxRice);
static Entry nitrogen[] = ConfigEntry("nitrogen/", CategoryLinuxRice);
static Entry openbox[] = ConfigEntry("openbox/", CategoryLinuxRice);
static Entry pacmixer[] = ConfigEntry("pacmixer/", CategoryLinuxRice);
static Entry picom[] = ConfigEntry("picom/", CategoryLinuxRice);
static Entry polybar[] = ConfigEntry("polybar/", CategoryLinuxRice);
static Entry rofi[] = ConfigEntry("rofi/", CategoryLinuxRice);
static Entry swaylock[] = ConfigEntry("swaylock/", CategoryLinuxRice);
static Entry sx[] = ConfigEntry("sx/", CategoryLinuxRice);
static Entry sxhkdrc[] = ConfigEntry("sxhkdrc/", CategoryLinuxRice);
static Entry taffybar[] = ConfigEntry("taffybar/", CategoryLinuxRice);
static Entry twmn[] = ConfigEntry("twmn/", CategoryLinuxRice);
static Entry wofi[] = ConfigEntry("wofi/", CategoryLinuxRice);
static Entry X11[] = ConfigEntry("X11/", CategoryLinuxRice);
static Entry xbindkeys[] = ConfigEntry("xbindkeys/", CategoryLinuxRice);
static Entry xkb[] = ConfigEntry("xkb/", CategoryLinuxRice);
static Entry xmobar[] = ConfigEntry("xmobar/", CategoryLinuxRice);
static Entry xob[] = ConfigEntry("xob/", CategoryLinuxRice);
static Entry emptty[] = ConfigEntry("emptty", CategoryLinuxRice);
static Entry ncpamixerConf[] = ConfigEntry("ncpamixer.conf", CategoryLinuxRice);
static Entry pamixConf[] = ConfigEntry("pamix.conf", CategoryLinuxRice);
static Entry pavucontrolIni[] = ConfigEntry("pavucontrol.ini", CategoryLinuxRice);
static Entry pulsemixerCfg[] = ConfigEntry("pulsemixer.cfg", CategoryLinuxRice);

// Shell.
static Entry fish[] = ConfigEntry("fish/", CategoryShell);
static Entry ion[] = ConfigEntry("ion/", CategoryShell);
static Entry liquidprompt[] = ConfigEntry("liquidprompt/", CategoryShell);
static Entry nu[] = ConfigEntry("nu/", CategoryShell);
static Entry powerline[] = ConfigEntry("powerline/", CategoryShell);
static Entry sh[] = ConfigEntry("sh/", CategoryShell);
static Entry starship[] = ConfigEntry("starship/", CategoryShell);
static Entry zsh[] = ConfigEntry("zsh/", CategoryShell);
static Entry bash[] = {
	// clang-format off
	Home(".bashrc", CategoryShell),
	Home(".bash_profile", CategoryShell),
	Home(".bash_logout", CategoryShell),
	Config("bash/", CategoryShell),
	Done
	// clang-format on
};
static Entry sbp[] = ConfigEntry("sbp/", CategoryShell);
static Entry cshrc[] = HomeEntry(".cshrc", CategoryShell);
static Entry kshrc[] = HomeEntry(".kshrc", CategoryShell);
static Entry login[] = HomeEntry(".login", CategoryShell);
static Entry mkshrc[] = HomeEntry(".mkshrc", CategoryShell);
static Entry profile[] = HomeEntry(".profile", CategoryShell);
static Entry tcshrc[] = HomeEntry(".tcshrc", CategoryShell);
static Entry zshenv[] = HomeEntry(".zshenv", CategoryShell);

// Terminal.
static Entry alacritty[] = ConfigEntry("alacritty/", CategoryTerminal);
static Entry kermit[] = ConfigEntry("kermit/", CategoryTerminal);
static Entry kitty[] = ConfigEntry("kitty/", CategoryTerminal);
static Entry screen[] = ConfigEntry("screen/", CategoryTerminal);
static Entry terminator[] = ConfigEntry("terminator/", CategoryTerminal);
static Entry termite[] = ConfigEntry("termite/", CategoryTerminal);
static Entry tmux[] = ConfigEntry("tmux/", CategoryTerminal);
static Entry urxvt[] = ConfigEntry("urxvt/", CategoryTerminal);
static Entry gtktermrc[] = ConfigEntry(".gtktermrc", CategoryTerminal);
static Entry hyperJs[] = HomeEntry(".hyper.js", CategoryTerminal);

// Tools.
static Entry cspell[] = ConfigEntry("cspell/", CategoryTools);
static Entry libfsguest[] = ConfigEntry("libfsguest/", CategoryTools);
static Entry nvchecker[] = ConfigEntry("nvchecker/", CategoryTools);
static Entry osc[] = ConfigEntry("osc/", CategoryTools);
static Entry redshift[] = ConfigEntry("redshift/", CategoryTools);
static Entry sheldon[] = ConfigEntry("sheldon/", CategoryTools);
static Entry urlwatch[] = ConfigEntry("urlwatch/", CategoryTools);
static Entry garden[] = ConfigEntry("garden/", CategoryTools);


// Version Control.
static Entry gh[] = ConfigEntry("gh/config.yml", CategoryVersionControl);
static Entry git[] = ConfigEntry("git/", CategoryVersionControl);
static Entry hg[] = ConfigEntry("hg/", CategoryVersionControl);
static Entry jj[] = ConfigEntry("jj/", CategoryVersionControl);
static Entry pijul[] = ConfigEntry("pijul/", CategoryVersionControl);
static Entry tig[] = ConfigEntry("tig/", CategoryVersionControl);

// Groups.
static Group defaultGroup = {
	.name = "Default",
	.entries = (Entry *[]){
		wget,
		youtubeDl,
		vscode,
		nano,
		nvim,
		vim,
		zed,
		npm,
		python,
		dircolors,
		environmentD,
		info,
		less,
		readline,
		userDirsConf,
		gnupgDirmngr,
		gnupgGpg,
		gnupgGpgAgent,
		sh,
		zsh,
		bash,
		sbp,
		profile,
		zshenv,
		alacritty,
		kitty,
		gh,
		garden,
		git,
		jj,
		NULL
	}
};

static Group otherGroup = {
	.name = "Rice",
	.entries = (Entry *[]){
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
		cookiecutter,
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
		bpython,
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
		cpan,
		sdkman,
		curl,
		fontconfig,
		most,
		pamEnvironment,
		digrc,
		hushlogin,
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

static Group* groups[] = {
	&defaultGroup,
	&otherGroup,
	NULL
};

Group **getGroups() {
	return groups;
}

Group *getDefaultGroup() {
	return &defaultGroup;
}

#pragma clang diagnostic pop
