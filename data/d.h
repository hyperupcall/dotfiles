#include <stdbool.h>
#include <stddef.h>

typedef enum {
	TYPE_ENTRY = 0,
	TYPE_GROUP = 1,
} ItemType;

typedef struct Item {
	int type;
	// TYPE_ENTRY fields
	char const *category;
	char const *source;
	char const *destination;
	// TYPE_GROUP fields
	struct Item **entries;
} Item;

typedef struct Deployment {
	char const *name;
	Item **items;
} Deployment;

// clang-format off
#define Home(path, category) { \
	.type = TYPE_ENTRY, \
	.source = Src category path, \
	.destination = Dst path \
}
#define Config(path, category) { \
	.type = TYPE_ENTRY, \
	.source = Src category ".config/" path, \
	.destination = Dst ".config/" path \
}
#define Data(path, category) { \
	.type = TYPE_ENTRY, \
	.source = Src category ".local/share/" path, \
	.destination = Dst ".local/share/" path \
}
#define Done { \
	.source = NULL, \
	.destination = NULL \
}
// clang-format on

#define HomeEntry(path, category) {Home(path, category), Done}
#define ConfigEntry(path, category) {Config(path, category), Done}
#define DataEntry(path, category) {Data(path, category), Done}
