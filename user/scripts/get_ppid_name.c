#include <stdio.h>
#include <unistd.h>

static void get_process_name(const pid_t pid, char *name) {
    char procfile[BUFSIZ];
    sprintf(procfile, "/proc/%d/cmdline", pid);
    FILE *f = fopen(procfile, "r");
    if (f) {
        size_t size;
        size = fread(name, sizeof(char), sizeof(procfile), f);
        if (size > 0) {
            if ('\n' == name[size - 1])
                name[size - 1] = '\0';
        }
        fclose(f);
    }
}

int main(int argc, char *argv[]) {
    pid_t pid = getppid();
    if (pid == 0)
        return 1;

    char name[BUFSIZ];
    get_process_name(pid, name);
    printf("%s\n", name);

    return 0;
}
