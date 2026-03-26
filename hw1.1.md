Under your home directory (`~`), create a `labs` directory if it doesn't exist, and then create `lab1` inside `labs` as your lab directory for this assignment:

`mkdir -p ~/labs/lab1`

PART 1 — LAB ASSIGNMENT (Template for Students)
🧪 Lab Title

Linux Shell Programming & System Management (Chapter 2 – Advanced)

🎯 Objective

By completing this lab, students will:

- Use pipes and redirection
- Process text with grep, sort, head, tail
- Work with globbing and variables
- Handle errors and streams
- Write robust shell scripts

📝 Assignment Tasks

✅ Task 1 — Extract and Sort Usernames

From /etc/passwd:

- Extract usernames (before `:`)
- Sort alphabetically

✅ Task 2 — Filter Users

- Print only users containing `root`
- Case-insensitive

✅ Task 3 — Count Users

- Count total number of users

✅ Task 4 — Error Handling

- Try accessing a non-existing file
- Redirect errors to `error.txt`
- Do NOT print errors to stdout

✅ Task 5 — Pipeline Task

Combine:

- `cat`, `grep`, `sort`
- Output only unique usernames

📦 Input Format

Your script should read from stdin:

- `/etc/passwd`

📤 Output Format (STRICT)

Example:

daemon
root
sys

Rules:

- No extra spaces
- No prompts
- No debug text

⚠️ REQUIREMENTS (CRITICAL)

Students MUST follow:

1. File name: `script.sh`
2. Must run as:
   `bash script.sh < input.txt`
3. Must:
   - read from stdin
   - write to stdout
4. NO interactive input
5. NO hardcoded answers
