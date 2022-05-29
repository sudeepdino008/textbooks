execute via: 
`make -s all nbytes=10000000 bufsize=1000`

# results:

## n_write_bytes: 10000000; buf_size: 1000 on filesystem: ext4
### sync_type: sync
(real, user, sys): (0:02.97, 0.00, 0.25)
### sync_type: fsync
(real, user, sys): (0:01.32, 0.00, 0.25)
### sync_type: fdatasync
(real, user, sys): (0:01.27, 0.00, 0.23)

## n_write_bytes: 10000000; buf_size: 10000 on filesystem: ext4
### sync_type: sync
(real, user, sys): (0:00.33, 0.00, 0.04)
### sync_type: fsync
(real, user, sys): (0:00.14, 0.00, 0.03)
### sync_type: fdatasync
(real, user, sys): (0:00.14, 0.00, 0.02)

## n_write_bytes: 10000000; buf_size: 100 on filesystem: ext4
### sync_type: sync
(real, user, sys): (0:27.35, 0.08, 2.41)
### sync_type: fsync
(real, user, sys): (0:12.85, 0.07, 2.49)
### sync_type: fdatasync
(real, user, sys): (0:13.68, 0.11, 2.57)