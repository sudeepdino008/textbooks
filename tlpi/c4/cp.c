#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "../lib/error_functions.h"

#define BATCH_SIZE 1000

// ./current data/file_with_holes fwh_c
// load the source bytes into memory, and then write a non-null segment chunk or null segment chunk.
// alteratively (and much better) would be to use SEEK_HOLE to directly jump to the next non-null or null
// character containing offset. This way you don't load stuff into memory + don't traverse on all the 
// characters. 
int main(int argc, char *argv[]) {
    if (argc != 3) {
        usageErr("\n%s <source_file_path> <destination_file_path>\n", argv[0]);
    }

    char *source_file = argv[1];
    char *dest_file = argv[2];

    int sfd = open(source_file, O_RDONLY);
    if (sfd == -1) {
        errExit("error opening source file");
    }

    int dfd = open(dest_file, O_WRONLY | O_CREAT, 0666);
    if (dfd == -1) {
        errExit("error opening destination file");
    }

    int rbytes;
    char buffer[BATCH_SIZE];
    while((rbytes = read(sfd, buffer, BATCH_SIZE)) > 0) {
        int index = 0;
        while (index < rbytes) {
            int offset = index;

            // write non-null bytes
            while(index < rbytes && buffer[index] != '\0') index++;
            ssize_t wbytes = write(dfd, &buffer[offset], index-offset);
            if (wbytes == -1) {
                errMsg("error writing the bytes");
            }

            // write null bytes
            offset = index;

            while(index < rbytes && buffer[index] == '\0') index++;
            ssize_t seek_pos = lseek(dfd, index - offset, SEEK_CUR);
            if (seek_pos == -1) {
                errMsg("error in seeking file");
            }
        }
    }

    close(sfd);
    close(dfd);
}