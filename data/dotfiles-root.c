#include <stdbool.h>
#include <stddef.h>

#pragma clang diagnostic error "-Wunused-variable"
#pragma clang diagnostic push

struct Entry {
	char const *category;
	char const *source;
	char const *destination;
};

#define H "/home/" Username "/" // lint-ignore

// clang-format off
#define File(path) \
	{ \
		.category = "root", \
		.source = H ".dotfiles/config-system/" path, \
		.destination = "/" path \
	}
// clang-format on

#define DefineEntry(name, obj) static struct Entry name[] = {obj, Done}

#define Done \
	{ .category = NULL, .source = NULL, .destination = NULL }

// Macros
#define Username "edwin"

// Applications
DefineEntry(bash, File("root/.bashrc"));
DefineEntry(dircolors, File("root/.dir_colors"));
DefineEntry(nano, File("root/.nanorc"));

static struct Entry *configuration[] = {
	bash,
	dircolors,
	nano,
	NULL
};

struct Entry **getConfiguration() {
	return configuration;
}

#pragma clang diagnostic pop
