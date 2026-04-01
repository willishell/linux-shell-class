Log in to the Raspberry Pi system with your own account and change your password. The username is your student ID, and the initial password is 123. You can use any SSH client such as MobaXterm, XShell, or PuTTY, or use the command line:

`ssh student_id@150.158.24.225 -p 6001`

Under your home directory (`~`), create a `labs` directory if it doesn't exist, and then create `lab1` inside `labs` as your lab directory for this assignment:

`mkdir -p ~/labs/lab1`

All files to be checked for this lab must be placed in `~/labs/lab1`, and file names should start with `lab1_`, such as `lab1_1.sh`. Example path: `~/labs/lab1/lab1_1.sh`.

The following tasks are designed based on the latter part of Chapter 2 (advanced Linux commands, processes, permissions, and system information):

1. Write `lab1_1.sh` to demonstrate process management:
   - List all processes (`ps aux`)
   - Show top processes (`top -n 1 -b`)
   - Kill a background process (e.g., start `sleep 100 &`, then kill it with `kill`)

2. Create `lab1_2.sh` to work with environment variables:
   - Display current environment variables (`env`)
   - Set a new variable and echo it (`export MY_VAR="Hello"; echo $MY_VAR`)
   - Show PATH variable (`echo $PATH`)

3. Write `lab1_3.sh` to demonstrate user and group information:
   - Show current user (`whoami`)
   - Show user ID and groups (`id`)
   - List all users (`cat /etc/passwd | head -10`)

4. Create `lab1_4.sh` for advanced permissions:
   - Create a file and set permissions (`touch perm_file.txt; chmod 755 perm_file.txt`)
   - Change ownership (if possible, `sudo chown root perm_file.txt`)
   - Check permissions (`ls -l perm_file.txt`)

5. Write `lab1_5.sh` to demonstrate file searching:
   - Find files by name (`find /usr -name "*.txt" 2>/dev/null | head -5`)
   - Grep for text in files (`grep -r "Linux" /etc/passwd`)

6. Create `lab1_6.sh` for archiving and compression:
   - Create a tar archive (`tar -cvf archive.tar ~/labs/lab1`)
   - Compress it (`gzip archive.tar`)
   - List contents (`tar -tzf archive.tar.gz`)

Submission requirements:

1. Submission directory: `~/labs/lab1`.
2. All scripts must include readable comments and be directly executable.
3. Submit all script files and a short report named `lab1_report.txt`, including key commands and execution results for each task.

