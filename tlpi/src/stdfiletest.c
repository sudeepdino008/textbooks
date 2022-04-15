#include <stdio.h>

int main() {
    write("/dev/fd/1", O_WRONLY);
    int errfd = open("/dev/fd/2", O_WRONLY); 
    return 0;
}
