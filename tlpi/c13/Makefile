.RECIPEPREFIX = >
current_file = 13.2.c
commons = ../lib/error_functions.c ../lib/get_num.c

sync: FLAGS=-DUSE_O_SYNC
fsync: FLAGS=-DUSE_FSYNC
fdatasync: FLAGS=-DUSE_FDATASYNC


current : $(current_file) $(commons)
> gcc -g -o current $(current_file) $(commons) $(CFLAG_ARGS)

clean: 
> rm -f current a.out *.o 13.2.dest

sync fsync fdatasync: clean
> echo "### sync_type: $@"
> make current CFLAG_ARGS=$(FLAGS)
> time -f "(real, user, sys): (%E, %U, %S)" ./current 13.2.dest $(nbytes) $(bufsize)


debug_msg:
> echo "## n_write_bytes: $(nbytes); buf_size: $(bufsize) on filesystem: `df -T ./ | tail -n 1 | tr -s ' ' | cut -d' ' -f2`"

all: debug_msg sync fsync fdatasync

