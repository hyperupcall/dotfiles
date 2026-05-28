#include "d.h"

#pragma clang diagnostic warning "-Wunused-variable"
#pragma clang diagnostic push

// Macros.
#define Username "edwin"
#define Hme "/home/" Username "/"
#define Src Hme ".dotfiles/config-system/root/"
#define Dst "/root/"

// Root.
#define CategoryRoot ""
static Item bash[] = HomeEntry(".bashrc", CategoryRoot);
static Item dircolors[] = HomeEntry(".dir_colors", CategoryRoot);
static Item nano[] = HomeEntry(".nanorc", CategoryRoot);

static Item *configuration[] = {
	bash,
	dircolors,
	nano,
	NULL
};

Item **getConfiguration() {
	return configuration;
}

#pragma clang diagnostic pop
