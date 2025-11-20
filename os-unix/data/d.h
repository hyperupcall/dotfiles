#include <stdbool.h>
#include <stddef.h>

typedef struct Group {
	char const *name;
	struct Entry **entries;
} Group;

typedef struct Entry {
	char const *category;
	char const *source;
	char const *destination;
} Entry;

// clang-format off
#define Home(path, category) { \
	.source = Src category path, \
	.destination = Dst path \
}
#define Config(path, category) { \
	.source = Src category ".config/" path, \
	.destination = Dst ".config/" path \
}
#define Data(path, category) { \
	.source = Src category ".local/share/" path, \
	.destination = Dst ".local/share/" path \
}
#define Done { \
	.source = NULL, \
	.destination = NULL \
}
// clang-format on

#define HomeEntry(path, category) { Home(path, category), Done }
#define ConfigEntry(path, category) { Config(path, category), Done }
#define DataEntry(path, category) { Data(path, category), Done }
