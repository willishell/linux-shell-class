---

# 🧪 Lab Assignment

## Linux Disk & Filesystem Management (Chapter 4)

---

## 🎯 Objective

By completing this lab, you will learn how to:

* Inspect disk partitions and block devices
* Work with filesystem metadata and mount points
* Analyze mounted filesystems
* Understand swap usage and configuration
* Explore `/proc` and `/sys` filesystem data
* Interact with Logical Volume Manager (LVM)
* Write robust shell scripts for system-level parsing

---

## 📁 Lab Setup

```bash
mkdir -p ~/labs/lab3
cd ~/labs/lab3
```

---

## ⚠️ General Requirements (VERY IMPORTANT)

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
* **Executable**

3. Execution format:

```bash
bash taskN.sh < input.txt
```

4. Scripts MUST:

* Read from **stdin**
* Write to **stdout**

5. DO NOT:

* Use interactive input
* Hardcode results
* Print extra text

---

## 📝 Assignment Tasks

---

### ✅ Task 1 — List Disk Partitions

#### Input:

A disk device:

```
/dev/sda
```

#### Task:

* Use `lsblk` or `parted -l`
* Extract all partitions of the disk

#### Output:

```
sda1
sda2
```

#### Requirement:

* Sorted
* Only partition names (no `/dev/`)

---

### ✅ Task 2 — Identify Filesystem Types

#### Input:

Device paths:

```
/dev/sda1
/dev/sda2
```

#### Task:

* Use `lsblk -f -n -o NAME,FSTYPE`
* Extract filesystem type

#### Output:

```
sda1 ext4
sda2 swap
```

---

### ✅ Task 3 — List Mounted Filesystems

#### Input:

A prefix:

```
/dev
```

#### Task:

* Use `mount`
* Extract mounted devices starting with prefix

#### Output:

```
/dev/sda1 /
/dev/sda2 [SWAP]
```

#### Requirement:

* Format:

```
<device> <mountpoint>
```

* Sorted & unique

---

### ✅ Task 4 — Analyze /proc Filesystem

#### Input:

```
/proc/cpuinfo
```

#### Task:

* Count number of CPU cores

#### Output:

```
8
```

#### Hint:

Count occurrences of:

```
processor
```

---

### ✅ Task 5 — Swap Usage Analysis

#### Input:

(no input)

#### Task:

* Use:

```bash
free -b
```

* Extract from line starting with:

Swap:

#### Output:

```
<total> <used>
```

---

### ✅ Task 6 — Parse /etc/fstab

#### Input:

```
/etc/fstab
```

#### Task:

* Extract all **mount points** (ignore comments)

#### Output:

```
/
/home
```

#### Requirement:

* Skip lines starting with `#`
* Extract **second column**

---

### ✅ Task 7 — LVM Information Extraction

#### Input:

```
(no input)
```

---

### Task:

* Use:

```bash
df -h --output=source,size
```

* Extract:

  * device name
  * size

* Only include devices starting with `/dev`

---

### Output:

```
/dev/sda1 50G
/dev/sda2 100G
```

---

### Requirements:

* Skip header line
* Sorted
* Unique

---


## 🧪 Testing

```bash
bash taskN.sh < testN.in
```

---

## 📊 Grading

Each task is graded independently:

| Task   | Weight |
| ------ | ------ |
| Task 1 | 10%    |
| Task 2 | 15%    |
| Task 3 | 15%    |
| Task 4 | 10%    |
| Task 5 | 15%    |
| Task 6 | 15%    |
| Task 7 | 20%    |

---

## ⚠️ Important Notes

* System tools available:

  * `lsblk`, `blkid`, `mount`, `free`, `df`
* System files:

  * `/proc`, `/sys`, `/etc/fstab`
* Scripts must work on **real system data**

---

## 🚀 Submission

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
