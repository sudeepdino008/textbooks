#include <stdio.h>
#include <unistd.h>
#include "lib/error_functions.h"

int main() {
	char *s = "hello\n";
	char *s1 = "bye\n";
	fwrite(s, 1, 6, stdout);
	fwrite(s1, 1, 4, stderr);

	return 0;
}
