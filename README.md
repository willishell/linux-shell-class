# linux-shell-class

## Grading System

The project uses a centralized grading script (`grade.sh`) located in the root directory to grade lab assignments across all labs.

### Recent Modification: Automatic Generation of Expected Outputs

As of April 20, 2026, the `grade.sh` script has been modified to automatically generate missing expected output files (`taskN.out`) from standard teacher implementations when grading a lab. This eliminates the need for individual `grade.sh` scripts in each lab directory and ensures consistency.

#### How It Works

1. **Teacher Implementations**: Each lab should have a `submissions/teacher/` directory containing standard implementation scripts (`task1.sh` to `taskN.sh`).

2. **Input Files**: Test cases are stored in `labN/test_cases/taskN.in`.

3. **Expected Outputs**: If `taskN.out` files are missing, the script will:
   - Check for the corresponding teacher script and input file.
   - Execute the teacher script with the input to generate the expected output.
   - Save the output to `taskN.out`.

4. **Grading Process**:
   - The script compares student submissions against the expected outputs.
   - Supports both binary (pass/fail) and weighted scoring based on `config.sh`.
   - Results are saved to `labN/results/` as CSV files.

#### Usage

```bash
# Grade a specific lab
./grade.sh lab3

# Grade all labs
./grade.sh

# Use a specific ID file
./grade.sh lab3 id/5.csv
```

#### Benefits

- **Consistency**: Single grading script for all labs.
- **Automation**: No manual generation of expected outputs required.
- **Error Prevention**: Handles missing `.out` files gracefully by generating them from standards.
- **Maintainability**: Removes duplication of grading logic across labs.

This modification ensures that the grading system is robust and self-sufficient, relying on teacher-provided standard implementations to define correct outputs.