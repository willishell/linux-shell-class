---

# 🧪 Lab Assignment

## Linux Device Management & System Interaction (Chapter 3)

---

## 🎯 Objective

By completing this lab, you will learn how to:

* Work with Linux device files in `/dev`
* Explore system information in `/sys`
* Query device metadata using `udevadm`
* Use `dd` for low-level data operations
* Parse system-level command outputs
* Write robust, non-interactive shell scripts

---

## 📁 Lab Setup

Create your lab directory:

```bash
mkdir -p ~/labs/lab2
cd ~/labs/lab2
```

---

## ⚠️ General Requirements (VERY IMPORTANT)

You MUST follow all rules below:

1. **File names (strict):**

   ```
   task1.sh
   task2.sh
   task3.sh
   task4.sh
   task5.sh
   task6.sh
   task7.sh
   ```

2. Each task must be:

   * A **separate script**
   * **Executable** (`chmod +x taskN.sh`)

3. Scripts must run as:

   ```bash
   bash taskN.sh < input.txt
   ```

4. Scripts MUST:

   * Read input from **stdin**
   * Write output to **stdout**

5. DO NOT:

   * Use interactive input
   * Hardcode answers
   * Print extra text (no prompts, no debug logs)

---

## 📝 Assignment Tasks

---

### ✅ Task 1 — Identify Device Types

#### Input:

Each line contains a device path (e.g., `/dev/null`).

#### Task:

For each device:

* Determine if it is:

  * block device → print `b`
  * character device → print `c`
* Output format:

  ```
  <type> <device_name>
  ```

#### Example:

```
c null
```

---

### ✅ Task 2 — List Block Devices

#### Input:

A directory path (e.g., `/sys/block`)

#### Task:

* List all entries in the directory
* Output only device names

---

### ✅ Task 3 — Get Device Sizes

#### Input:

Each line contains a device name (e.g., `sda`)

#### Task:

* Read size from:

  ```
  /sys/block/<device>/size
  ```
* Output:

  ```
  <device> <size>
  ```

---

### ✅ Task 4 — Query Device Metadata

#### Input:

Each line contains a device path (e.g., `/dev/sda`)

#### Task:

* Use:

  ```bash
  udevadm info --query=property --name=<device>
  ```
* Extract:

  * `DEVNAME`
  * `DEVTYPE`

#### Output:

```
/dev/sda disk
```

---

### ✅ Task 5 — Create File Using dd

#### Input:

A filename (e.g., `output.bin`)

#### Task:

* Use `dd` to:

  * Read from `/dev/zero`
  * Write 1KB to the file

#### Output:

```
OK
```

⚠️ Do NOT write to any real device!

---

### ✅ Task 6 — Partial Copy with dd

#### Input:

```
<input_file> <output_file>
```

#### Task:

* Copy data using `dd`:

  * Skip first block
  * Copy next 2 blocks
  * Block size: 5 bytes

* Print contents of output file

---

### ✅ Task 7 — List Mounted Devices

#### Input:

A prefix (e.g., `/dev`)

#### Task:

* Use `mount`
* Extract only devices whose path starts with the prefix

#### Output:

```
/dev/sda1
/dev/sdb1
```

---

## 📤 Output Rules (STRICT)

* No extra spaces
* No extra lines
* No prompts or explanations
* Exact formatting required

---

## 🧪 Testing

You can test your script locally using:

```bash
bash taskN.sh < testN.in
```

---

## 📊 Grading

Your scripts will be automatically graded based on:

* Correctness of output
* Format compliance
* Script robustness

Each task is evaluated independently.

---

## ⚠️ Important Notes

* Your scripts will run on a **shared grading machine**
* System files like `/dev`, `/sys`, and `udevadm` are available
* Any deviation from requirements may result in **zero score**

---

## 🚀 Submission

Submit all files:

```
task1.sh
task2.sh
task3.sh
task4.sh
task5.sh
task6.sh
task7.sh
```

---

Good luck!

---

If you want, I can next generate:

* ✅ **Student hint version (less strict)**
* ✅ **TA solution guide (with explanations)**
* ✅ **Common mistakes checklist (very useful for grading)**
