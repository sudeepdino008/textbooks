#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include "../lib/error_functions.h"

void pUsageErr(char *progName, char *msg, char opt) {
    fprintf(stderr, msg, opt);
    fprintf(stderr, "\nUsage: %s [-a] <filename>\n", progName);
    exit(EXIT_FAILURE);
}

void tee_up(int append, char *filename) {
    #define MAX_BYTES 1000
    char buffer[MAX_BYTES];
    ssize_t nbytes;
    int fflags = O_WRONLY | O_CREAT | ((append == 1) ? O_APPEND : 0);
    int fd = open(filename, fflags, 0666);
    while ((nbytes = read(STDIN_FILENO, buffer, MAX_BYTES)) != -1) {
        ssize_t wbytes = write(fd, buffer, nbytes);
        if (wbytes == -1) {
            errExit("can't write bytes to file");
        }

        buffer[nbytes] = '\0';
        wbytes = write(STDOUT_FILENO, buffer, nbytes);
        if (wbytes == -1) {
            errExit("can't write bytes to stdout");
        }

        fflush(stdout);
    }


    close(fd);
}

int main(int argc, char *argv[]) {

    int append = 0;
    char flag;
    char *programName = argv[0];
    while((flag = getopt(argc, argv, "a")) != -1) {
        switch (flag) {
            case 'a': append = 1; break;
            case '?': pUsageErr(programName, "unknown argument", optopt);
            default: fatal("unexpected case in switch");
        }
        if (flag == 'a') {
            append = 1;
        }
    }

    argc -= optind;
    argv += optind;

    char *filename = argv[0];
    if (filename == NULL) {
        pUsageErr(programName, "filename not provided", 0);
    }

    printf("append: %d, filename: %s\n", append, filename);

    tee_up(append, filename);
}