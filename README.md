## Machine Learning Engineering

This repository contains the code and documentation for developing and deploying machine learning models while adhering to engineering best practices.

## Environment Setup

### Virtual Environment

- Navigate to the project directory:
  ```bash
  cd <base>/ml-engineering
  ```

- Create and activate the conda environment:
  ```bash
  conda env create --file deploy/conda/linux_py312.yml
  conda activate mle
  ```

- Manage dependencies:
  - Install additional dependencies using conda or pip as needed.
  - Update environment file: `conda env export --name mle > deploy/conda/linux_py312.yml`
  - Deactivate environment: `conda deactivate`
  - Remove environment (if necessary): `conda remove --name mle --all`