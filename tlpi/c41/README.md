size of program built with shared gcc lib - 17Kbs
size of program built with static gcc lib - 852Kbs

```bash
gcc -o dyn_out program.c
gcc -static -o static_out program.c

sudeep@shifu-apps:~/repos/textbooks/tlpi/c41$ ls -lh
total 884K
-rwxrwxr-x 1 sudeep sudeep  17K Jun 23 17:35 dyn_out
-rw-rw-r-- 1 sudeep sudeep   72 Jun 23 17:35 program.c
-rw-rw-r-- 1 sudeep sudeep  463 Jun 23 17:42 README.md
-rwxrwxr-x 1 sudeep sudeep 852K Jun 23 17:39 static_out
drwxrwxr-x 2 sudeep sudeep 4.0K Jun 23 17:34 testing
```