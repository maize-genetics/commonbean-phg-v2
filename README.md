# Common bean PHGv2 build
Scripts and notes for building a common bean PHG using [v2 architecture](https://github.com/maize-genetics/phg_v2).

## Prerequisites
* Conda package management system
* CBSU working environment
  + Uses `module load java/21.0.1` for PHGv2 steps

## Repo structure
* [`data/`](data)
  + `fa_keyfile.csv` - files to pull from `CBSUBLFS1`
* [`src/`](src)
  + `utitl_config.sh` - defining global parameters.
  + `util_functions.sh` - helper functions.
* `./00_setup_and_download.sh` - creates working directories and retrieves assemblies.
