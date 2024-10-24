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

## Development Workflow

### Research & Development

- Reference code: `<base>/ml-engineering/reference/nonstandardcode`
- Working notebooks: `<base>/ml-engineering/notebooks/working`

### Script Development

Scripts are derived from working notebooks in `<base>/ml-engineering/notebooks/working`.

### Setting PYTHONPATH

Ensure the directory containing `housing_value` is in PYTHONPATH:
```bash
conda env config vars set PYTHONPATH=$(pwd)/src
conda deactivate
conda activate mle
echo $PYTHONPATH
```

### Integrated Features in Scripts

- Argument Parsing: Uses `argparse` for command-line arguments.
- Configuration Management: Implements `configparser` with `setup.cfg`.
- Logging: Incorporates `logging` for execution tracking and debugging.

### Code Quality Tools

Install required tools:
```bash
sudo apt install black isort flake8
```

| Tool   | Description     | Usage             |
|--------|-----------------|-------------------|
| Black  | Code formatter  | `black <script.py>` |
| isort  | Import sorter   | `isort <script.py>` |
| flake8 | Linter          | `flake8 <script.py>` |

**Note:** Configurations are specified in `setup.cfg` and `.vscode/settings.json` (for VS Code users).

### Maintaining Code Quality

```bash
chmod +x shell/src_quality.sh
./shell/src_quality.sh
```

### Script Execution

View available options for each script using the `--help` flag:
```bash
python src/housing_value/ingest_data.py --help
python src/housing_value/train.py --help
python src/housing_value/score.py --help
```

## Testing 

Install pytest:
```bash
sudo apt install python3-pytest
```

**Note:** Configurations are specified in `setup.cfg`.

Maintain test code quality:
```bash
chmod +x shell/tests_quality.sh
./shell/tests_quality.sh
```

Run tests:
```bash
pytest
pytest <test_directory>/<test.py>
```

## Documentation

Using Sphinx for documentation generation.

### Prerequisites

1. Install the package:
   - Option 1: Editable mode (dependent on pyproject.toml): produces egg-info folder.
     ```bash
     pip install -e .
     ```
   - Option 2: Build and install: produces egg-info folder as well as dist folder containing tar.gz and whl file.
     ```bash
     python3 -m pip install --upgrade build
     python3 -m build
     pip install dist/housing_value-0.0.0-py3-none-any.whl
     ```

2. Install Sphinx:
   ```bash
   sudo apt install python3-sphinx
   ```

### Generating Documentation

1. Navigate to the docs directory:
   ```bash
   cd docs
   ```

2. Check configuration files:
   - Make sure to create Makefile.

3. Generate Sphinx project:
   ```bash
   sphinx-quickstart
   ```

4. Update configuration files:
   - Modify `source/conf.py` and `source/index.rst` as needed.
   - Reference files are available in the `reference` directory.

5. Generate API documentation:
   ```bash
   sphinx-apidoc -o ./source ../src/housing_value
   ```

6. Update configuration files:
   - Modify `source/housing_value.rst` as needed.
   - Reference files are available in the `reference` directory.

7. Build HTML documentation:
   ```bash
   make clean
   make html
   ```

8. Return to the project root:
   ```bash
   cd ..
   ```

**Note:** The documentation file hierarchy in the `source` directory is: `index.rst > modules.rst > housing_value.rst`.

## Application Packaging with MLflow

1. **Maintaining Code Quality**
   ```bash
   chmod +x shell/app_quality.sh
   ./shell/app_quality.sh
   ```
   
**Note:** The file hierarchy for MLflow is structured as follows: `MLproject > app.py`.

2. **Tracking UI**: Launch the MLflow tracking server using the command.
   ```bash
   mlflow server --backend-store-uri mlruns/ --default-artifact-root mlruns/ --host 127.0.0.1 --port 5000
   ```

3. **Run Experiment**: Execute an experiment to generate a model artifact with the following command.
   ```bash
   mlflow run . -P <parameters>
   ```
   
The optional parameter `split_size` defaults to `0.2`.

4. **Python Version Management**: Install `pyenv` for managing Python versions and ensuring reproducibility, which facilitates selecting a specific Python version for the project.
   ```bash
   chmod +x shell/pyenv.sh
   ./shell/pyenv.sh
   ```

5. **Activate Conda Environment**: Activate the conda environment created during the experiment execution.

6. **Dependency Installation**: Install the required dependency in activated environment.
   ```bash
   pip install virtualenv
   ```

7. **API Endpoint Generation**: Create an API endpoint to serve the model using -
   ```bash
   mlflow models serve -m mlruns/<experiment_id>/<run_id>/artifacts/model/ -h 127.0.0.1 -p 1234
   ```

8. **Testing API Endpoint**: Test the API endpoint from another terminal with the following formats.

- **Datasplit Format**:
  ```bash
  curl -X POST -H "Content-Type: application/json" --data '{"dataframe_split": {"columns": ["longitude", "latitude", "housing_median_age", "total_rooms", "total_bedrooms", "population", "households", "median_income", "ocean_proximity"], "data": [[-118.39, 34.12, 29.0, 6447.0, 1012.0, 2184.0, 960.0, 8.2816, "<1H OCEAN"]]}}' http://127.0.0.1:1234/invocations 
  ```

- **Inputs/Instances Format**:
  ```bash 
  curl -X POST -H "Content-Type: application/json" --data '{"inputs": [{"longitude": -118.39, "latitude": 34.12, "housing_median_age": 29.0, "total_rooms": 6447.0, "total_bedrooms": 1012.0, "population": 2184.0, "households": 960.0, "median_income": 8.2816, "ocean_proximity": "<1H OCEAN"}]}' http://127.0.0.1:1234/invocations 
  ```

## Dockerization

### Deployment Readiness

To facilitate deployment, Docker images are created by aggregating necessary artifacts and configurations.

1. **Artifact Aggregation:** 

- Copy model artifacts (`MLmodel` and `model.pkl`) from `mlruns/<experiment_id>/<run_id>/artifacts/model` to `<base>/ml-engineering/deploy/docker/mlruns`. Ensure unnecessary metadata is cleaned from the `MLmodel`.

- Transfer the `requirements.txt` file from `mlruns/<experiment_id>/<run_id>/artifacts/model` to `<base>/ml-engineering/deploy/docker`.

- Move the wheel file (`housing_value-0.0.0-py3-none-any.whl`) from the dist directory to `<base>/ml-engineering/deploy/docker`.

- Copy the `setup.cfg` from the project root to `<base>/ml-engineering/deploy/docker`, ensuring it contains only data required for inference.

2. **Script and Configuration Creation:**

- Develop script `run.sh` to execute MLflow models serve command.

- Create `.dockerignore` file to ignore copying files in WORKDIR of image/container.

- Construct Dockerfile to package all components into a Docker image, ensuring efficient deployment and scalability.