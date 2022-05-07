
## Running the programs
- edit the Makefile to have the program you want to run.
- `make clean current`, then you can do `./current` etc.


## gdb debugging
- compile the c program with `-g` option to have the debugging symbols in the executable.


```bash

$ gdb current      # START gdb on the executable
(gdb) help         # help api
(gdb) search while  # search for lines which have "while" in the them
(gdb) b 29       # from above "search", use the location and can set breakpoint
(gdb) r <args>   # run the program with arguments


```

- to view program near the current frame, use `list`
- view addresses in decimal: `p/d ptr`