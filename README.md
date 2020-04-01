# BioLab

`BioLab` is a [Docker](https://www.docker.com/) Ubuntu container for common bioinformatics tools.

The list of the installed tools and packages can be found [here](https://github.com/ahmedmoustafa/BioLab/blob/master/Tools.md)

## Installation

### Option 1: Pulling from Docker Hub (Recommended)

[Docker Hub](https://hub.docker.com/) automatically and elegantly [builds images](https://hub.docker.com/r/cairogenes/biolab) for changes to the GitHub repository.

The built image can be downloaded as follows:

`sudo docker run -it cairogenes/biolab`

### Option 2: Building from `Dockerfile`

`git clone https://github.com/ahmedmoustafa/BioLab.git`

`cd BioLab/`

`sudo docker build -t biolab .`

`sudo docker run -it biolab`

### Note
The size of the built image is about 7.5 GB.

## Citation

If you use BioLab in your work, please cite the following [![DOI](https://zenodo.org/badge/248756319.svg)](https://zenodo.org/badge/latestdoi/248756319)

---
