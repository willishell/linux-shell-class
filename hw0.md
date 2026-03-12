Log in to the Raspberry Pi system with your own account and change your password. The username is your student ID, and the initial password is 123. You can use any SSH client such as MobaXterm, XShell, or PuTTY, or use the command line:

`ssh student_id@150.158.24.225 -p 6001`

Under your home directory (`~`), create a `labs` directory, and then create `lab0` inside `labs` as your first lab directory:

`mkdir -p ~/labs/lab0`

All files to be checked for this lab must be placed in `~/labs/lab0`, and file names should start with `lab0_`, such as `lab0_1.sh`. Example path: `~/labs/lab0/lab0_1.sh`.

The following tasks are designed based on Chapter 2 (Linux basic commands and file system operations):

1. Write `lab0_1.sh` to print `Hello World` in the terminal.
2. Create `lab0_2.sh` to output the following information:
	- Current working directory (`pwd`)
	- Files and directories in the current directory (`ls -la`)
3. Complete file and directory operation practice (record with screenshots or screen capture):
	- Create a directory named `practice` under `~/labs/lab0`.
	- Create two empty files under `practice`: `a.txt` and `b.txt`.
	- Copy `a.txt` to `a_copy.txt`.
	- Rename `b.txt` to `b_renamed.txt`.
4. Write `lab0_3.sh` to demonstrate redirection and append:
	- Write the string `Linux Lab0` into `log.txt` (overwrite mode).
	- Append the current date (`date`) as a new line to `log.txt`.
5. Write `lab0_4.sh` to demonstrate text viewing commands:
	- Display the first 2 lines of `log.txt` (`head -n 2`).
	- Display the last line of `log.txt` (`tail -n 1`).
6. Write `lab0_5.sh` to demonstrate permission changes:
	- Create `run_me.sh` and add one line: `echo Run OK`.
	- Use `chmod` to make it executable.
	- Execute the script and show the output.

Submission requirements:

1. Submission directory: `~/labs/lab0`.
2. All scripts must include readable comments and be directly executable.
3. Submit all script files and a short report named `lab0_report.txt`, including key commands and execution results for each task.
