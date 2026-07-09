# Managing packages and environments

![Linux Package Manager Explanation](https://itsfoss.com/content/images/wordpress/2020/10/linux-package-manager-explanation.png)

## Introduction

**Package managers** install and update software packages and their dependencies. They often also allow to create **environments**, which are isolated collections of software packages. One such example are the built-in package managers of Linux, such as `apt` (in Ubuntu and Debian), `dnf` (in Red Hat and Fedora), and `apk` (in Alpine Linux), which are used to install system-level software. `pip` is another package manager, widely used for installing Python libraries and managing their dependencies. It can be used on a system-level or user-level.

[Conda](https://docs.conda.io/) is an open-source **package manager** and **environment manager** widely used in bioinformatics. It allows to install software together with all of its dependencies, while keeping different projects isolated from one another.

A **Conda environment** is a self-contained collection of software packages and libraries. By using separate environments for different projects, you can avoid software conflicts and ensure that analyses remain reproducible.

For bioinformatics, most software is distributed through the **Bioconda** channel, a community-maintained repository containing thousands of life science packages.

Conda also works nicely with pip, and less nicely with Bioconductor, a package manager for R.

Useful documentation:

- Conda documentation: https://docs.conda.io/
- Conda User Guide: https://docs.conda.io/projects/conda/en/latest/user-guide/
- Bioconda: https://bioconda.github.io/
- conda-forge: https://conda-forge.org/

---

## Loading Conda on Puli

On the Puli supercomputer, Conda is available through the module system.

Load the Miniconda module:

```bash
ml miniconda3
```

See information about your Conda installation:

```bash
conda info
```

This command displays information about your Conda installation, including the active environment and the directories where environments are stored.

---

## Manage Packages

#### Search for available packages using:

```bash
conda search keggcharter
```

This also prints nicely available versions, such as:
```
Loading channels: done
# Name                       Version           Build  Channel             
keggcharter                    0.0.3               0  bioconda            
keggcharter                    0.0.4               0  bioconda            
keggcharter                    0.1.0               0  bioconda            
keggcharter                    0.1.1               0  bioconda    
...
keggcharter                    1.1.0      hdfd78af_0  bioconda            
keggcharter                    1.1.1      hdfd78af_0  bioconda            
keggcharter                    1.1.2      hdfd78af_0  bioconda 
```

---

#### Install a package into the active environment:

```bash
conda install upimapi
```

Or explicitly specify the Bioconda channel:

```bash
conda install -c bioconda upimapi
```

Conda automatically installs any required dependencies.

*How to not be prompted by the "Proceed ([y]/n)?" message?*

---

#### Updating packages

```bash
conda update upimapi
```

Update every package in the active environment:

```bash
conda update --all
```

Updating environments used for published analyses is generally discouraged, as software versions may change.

---

## Managing environments

It is good practice to create one environment per project or workflow. By default, users work on `base` environment, which in Puli is managed by the system administrator. Users cannot install software into the `base` environment, but should instead create a new environment for each project.

Create an environment with a specific Python version:

```bash
conda create -n pathway_mapping python=3.12
```

Create an environment and install packages at the same time:

```bash
conda create -n pathway_mapping python=3.12 keggcharter
```

Activate the environment:

```bash
conda activate pathway_mapping
```

Deactivate the current environment (sends back to `base`):

```bash
conda deactivate
```

List all environments:

```bash
conda env list
```

or

```bash
conda info --envs
```

---

#### Exporting an environment

To make an analysis reproducible, or to share your working environment, export the environment to a YAML file:

```bash
conda env export > environment.yml
```

This file records the installed packages and their versions.

---

#### Creating an environment from a YAML file

Recreate an environment from an exported YAML file:

```bash
conda env create -f environment.yml
```

This is the recommended way to share software environments with collaborators.

---

## Removing packages

Remove a package from the active environment:

```bash
conda remove keggcharter
```

---

## Removing environments

Delete an environment completely:

```bash
conda env remove -n pathway_mapping
```

---

## Resolving dependency conflicts

Conda automatically resolves software dependencies. Occasionally, it may report that requested packages have incompatible dependency requirements.

Some common ways to avoid dependency conflicts are:

- Create a fresh environment instead of installing into an existing one.
- Install all required packages in a single command.
- Use compatible software versions.
- Keep unrelated projects in separate environments.
- Sometimes pip can fix it.
- Othertimes, installing separately one by one the problematic packages will make it easier for the package manager to solve the dependencies.

In practice, creating a new environment is often faster than troubleshooting a heavily modified one.

---

## Good practices

- Create one environment per project (or per similar fields of study).
- Order of preference for channels: `conda-forge` > `bioconda` > `defaults`/`anaconda`.
- Use Bioconda whenever possible for bioinformatics software.
- Export environments (`environment.yml`) to ensure reproducibility.
- Avoid installing unnecessary software into the same environment.
- Avoid updating environments used for published analyses.

---

## The .condarc file

The `.condarc` file is a configuration file for Conda. It allows you to customize Conda's behavior, such as specifying channels, setting environment and package directories, and enabling or disabling certain features. Users can create a `.condarc` file in their home directory (`~/.condarc`) to apply settings globally, or in a specific environment to apply settings only to that environment.

An example with the most common settings is provided [here](https://github.com/HCEMM/acceleration-toolbox/blob/main/07_Package_Managers/.condarc).

# pip

## Introduction

[`pip`](https://pip.pypa.io/) is Python's official package manager. Unlike Conda, it only installs **Python packages** and does not manage system-level dependencies.

When using Conda, install packages with **Conda first**, and use `pip` only for packages that are unavailable through Conda.

Official documentation:

- https://pip.pypa.io/

---

## Installing packages

```bash
pip install package_name
```

---

## Updating packages

```bash
pip install --upgrade package_name
```

---

## Removing packages

```bash
pip uninstall package_name
```

---

## Listing installed packages

```bash
pip list
```

---

## Exporting installed packages

Export installed Python packages:

```bash
pip freeze > requirements.txt
```

---

## Installing from a requirements file

Recreate the Python environment:

```bash
pip install -r requirements.txt
```

---

# Conda vs pip

| Conda | pip |
|--------|-----|
| Manages software and environments | Manages Python packages only |
| Installs packages from many programming languages | Installs Python packages only |
| Resolves system and software dependencies | Resolves Python dependencies |
| Recommended for bioinformatics software | Recommended for Python libraries unavailable in Conda |

**Recommendation:** install software with Conda whenever possible, and only use `pip` for packages that are not available through Conda.

# NextFlow with Conda

The pipeline has already been configured to use Conda environments. Run as `nextflow run main.nf -profile slurm,conda`.

## Exercises

# Exercises — Conda Environments and Package Management

These exercises will help you practice creating, managing, exporting, and integrating Conda environments in bioinformatics workflows.

---

## Exercise 1 — Create your first environment

Create an environment called `seqkit_env` containing:

- Python 3.12
- SeqKit

### Questions

1. How do you activate the environment?
2. Which version of SeqKit was installed?
3. Which channel did it come from?

---

## Exercise 2 — Install more software

Add the following packages to the same environment:

- FastQC
- MultiQC

### Questions

1. Which package manager resolved the dependencies?
2. Approximately how many packages were installed?

---

## Exercise 3 — Search before installing

Without installing anything:

1. Find the latest available version of Salmon.
2. Find every available version of Trimmomatic.
3. Check whether STAR is available on Bioconda.

### Questions

- Which commands allow you to search packages before installation?
- Why is searching before installing useful?

---

## Exercise 4 — Build an environment in one command

Create a new environment called `rnaseq` containing:

- FastQC
- Trimmomatic
- Salmon
- MultiQC

### Questions

1. How many packages were installed?
2. Which package took the longest to solve?

---

## Exercise 5 — Export and recreate an environment

Export your environment:

```bash
conda env export > rnaseq.yml
```

## Exercise 6 — Create an environment from scratch

Create a file called `rnaseq.yml`:

```yaml
channels:
  - conda-forge
  - bioconda
  - defaults

dependencies:
  - fastqc=0.12.1
  - multiqc
  - salmon
```

Create the environment:

conda env create -n rnaseq -f rnaseq.yml

### Questions
1. Which command recreates the environment from the YAML file?
2. How would you share this environment with a collaborator?
3. Why is an environment file preferable to manually listing installation commands?

## Exercise 7 — R and Bioconductor packages

Create an environment containing:
```
R
limma
edgeR
tximport
```

Questions
1. Which package names are used in Conda?
2. Do you need to run BiocManager::install() inside R?
3. How would you verify that the packages are correctly installed?

This exercise reinforces that Conda can manage many Bioconductor packages directly, making computational environments easier to reproduce.

## Exercise 8 — Use pip inside Conda

Create an environment containing:

Python
pandas (installed through Conda)

Then install:
```
pip install rich-click
```
### Questions

1. Which package came from Conda?
2. Which package came from pip?
3. How can you check where each package was installed from?
4. Why is installing with Conda first generally recommended?

## Exercise 9 — Customize .condarc

Create a .condarc file containing:
```
channels:
  - conda-forge
  - bioconda
  - defaults

channel_priority: strict
```
### Questions
1. What is the effect of channel_priority: strict?
2. Why is conda-forge listed before bioconda?
3. How can you check your current Conda configuration?

## Exercise 10 — Nextflow integration

Given the following Nextflow process:
```
process FASTQC {

    conda = "$projectDir/envs/fastqc.yml"

    ...
}
```
Tasks
1. Create the fastqc.yml environment file.
2. Modify it to install FastQC version 0.12.1.
3. Add MultiQC to the environment.
4. Explain why using a YAML file is preferable to writing:
   conda = "bioconda::fastqc"
