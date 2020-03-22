# BioLab

`BioLab` is a [Docker](https://www.docker.com/) container for common bioinformatics tools.

The list of the installed tools and packages can be found [here](https://github.com/ahmedmoustafa/BioLab/blob/master/Tools.md)

## Installation

### Option 1: Pulling from Docker Hub (Recommended)

[Docker Hub](https://hub.docker.com/) automatically and elegantly [builds images](https://hub.docker.com/r/cairogenes/biolab) for changes to the GitHub repository.

The built image can be downloaded as follows:

`sudo docker run -it cairogenes/biolab`

### Option 2: Building from `Dockerfile`
`git clone https://github.com/ahmedmoustafa/BioLab.git`

`cd BioLib/`

`sudo docker build -t biolab .`

`sudo docker run -it biolab`

### Note
The size of the built image is about 7 GB.

---
