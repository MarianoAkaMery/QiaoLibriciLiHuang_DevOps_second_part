# DevOps Project — Task 2 & 3  
**Grayscale Image Conversion on Galileo100 with CI/CD & SLURM**

## 📋 Overview

This project implements and automates the grayscale image conversion tool using a DevOps pipeline. It builds, tests, containerizes (Singularity), and deploys the application to the **Galileo100 HPC cluster**, submitting jobs to SLURM.

It covers:
- CI/CD with GitHub Actions
- Singularity containerization
- SSH-based job deployment to HPC
- Automated test and job output collection

---

## 👨‍👩‍👧‍👦 Team Members

| Name                    | Person Code |
|-------------------------|-------------|
| Salvatore Mariano Librici | 11078653    |
| Rong Huang              | 10948935    |
| Yibo Li                 | 11022291    |
| Zhaochen Qiao           | 11021721    |

---

## 🛠️ Project Structure

```

.
├── build.sh                # Build script
├── job.sh                  # SLURM job submission script
├── grayscale.sif           # Singularity container (built in pipeline)
├── Singularity.def         # Singularity definition file
├── src/                    # Application source code
├── test/                   # Unit tests
├── .github/workflows/      # GitHub Actions CI/CD pipeline
└── README.md

````

---

## 🚀 Pipeline Overview

The GitHub Actions workflow:

1. **Build & Test**
   - Installs dependencies and compiles the code.
   - Executes unit tests to ensure correctness.

2. **Containerization**
   - Builds the `grayscale.sif` Singularity image.

3. **SSH to HPC**
   - Transfers the image and `job.sh` to **Galileo100** via certificate-based SSH.
   - Submits the job to SLURM with `sbatch`.

4. **Result Handling**
   - Waits for job completion.
   - Downloads the job’s output logs and displays them.
   - Publishes them as artifacts.

---

## 🧪 Test Cases

The tool was tested using internal unit tests compiled in the container, executed via:

```bash
singularity exec ./grayscale.sif /opt/app/build/test_grayscale
````

Additional integration testing was done through job execution on the Galileo cluster, comparing output grayscale image files with known expected values.

---

## ⚙️ SLURM Job

The job is submitted via the `job.sh` script, which:

* Loads required modules
* Sets up environment variables
* Runs the conversion and the tests inside the container

```bash
singularity exec ./grayscale.sif /opt/app/build/convert_grayscale input output Average
singularity exec ./grayscale.sif /opt/app/build/test_grayscale > grayscale_output.log 2>&1
```

---

## ⚠️ Difficulties Encountered

| Problem                                         | Solution                                                               |
| ----------------------------------------------- | ---------------------------------------------------------------------- |
| SSH certificate setup failing in GitHub Actions | Converted key to PEM-compatible format and disabled OTP on HPC account |
| Host verification errors                        | Disabled `StrictHostKeyChecking` and used temporary known\_hosts file  |
| Job timing issues                               | Added wait/delay and ensured `.log` file is flushed properly           |
| Output missing in pipeline                      | Downloaded output explicitly and uploaded as artifact for inspection   |

---

## 📜 License

This repository is licensed under the **MIT License** — see the [LICENSE](./LICENSE) file for details.

---

## 📎 Submission

Final project submission includes:

* [x] Step 1 code and pipeline
* [x] Task 2/3 implementation with pipeline
* [x] `README.md` with team members, explanation and documentation
* [x] `LICENSE` file
* [x] Submission form completed at [this link](https://forms.office.com/e/RnaZicBjWQ)