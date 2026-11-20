# rest-common-data

Small data files of real detectors, the inputs of the pipeline tests of
[rest-for-physics-toolkit](https://github.com/rest-for-physics-toolkit/rest-framework) (and of its examples).

The data files are the assets of each release (a tag `v*`), so a test or an example reads a fixed version of
them by URL:

```
https://github.com/rest-for-physics-toolkit/rest-common-data/releases/download/<tag>/<asset>
```

rest-for-physics-toolkit downloads a URL once and keeps it in `$REST_HOME/.rest/download` (it works offline
afterwards).

Part of the shared resources of rest-for-physics-toolkit (topic `rest-common`):
[rest-common-materials](https://github.com/rest-for-physics-toolkit/rest-common-materials) (Geant4 materials),
[rest-common-transport](https://github.com/rest-for-physics-toolkit/rest-common-transport) (electron transport
tables), [rest-common-readouts](https://github.com/rest-for-physics-toolkit/rest-common-readouts) (readouts)
and data (this repository).

## Catalogue

The first events of a run (the file keeps the name of the run: the run parameters are read from it):

| Asset | Events | Detector | Format | Used by (rest-framework) |
|---|---|---|---|---|
| `Run00229_Nominal_Test_Calibration_008.root` | 300 | IAXO-D1 Micromegas (`IAXO.root` of rest-common-readouts) | FEMDAQ ROOT file | `examples/FemDAQToTracks.yaml` |
| `Run03318_Calibration109Cd_TREXDM_DAQ_001.root` | 500 | TREX-DM, both planes (`TREXDM.root`), 109Cd calibration | FEMDAQ ROOT file | `examples/TREXDMToTracks.yaml` |
| `R03137_Calibration37Ar_Vm_360_Vd_100_Pr_2_Gain_0x0_Shape_0xF_Clock_0x4.root` | 1000 | 37Ar calibration | ROOT file of feminos-daq | `libraries/raw/examples/FeminosRootToRaw.yaml` |
| `R01928_tagTest_Vm_250_Vd_160_Pr_6_Gain_0x0_Shape_0xF_Clock_0x4-068.aqs` | whole file | TREX-DM (Feminos cards, TCM mode) | `.aqs` | `libraries/raw/examples/MultiFEMINOSToRaw.yaml` |

## Generation

The original files are not in the repository. With ROOT in the environment, `./generate.sh <directory>`
writes in `output/` the first events of each ROOT file of the catalogue found in `<directory>`
(`CutFile.C`: the first entries of every tree, the other objects as they are) and copies the small files.
A new file: a line in the list of `generate.sh` and a row of the catalogue.

## Release

The assets are uploaded by hand (the original files are not available to the CI):

```
./generate.sh <directory with the original files>
gh release create v1.0 output/* --title v1.0 --notes "Pipeline test data"
```

A new version (new or different files) is a new tag; the tests of rest-framework read a fixed tag.
