#!/bin/bash
# Generates the release assets in output/ from the original data files (not in the repository) of a
# directory:
#   ./generate.sh <directory with the original files>
# - ROOT files of the DAQ: the first events of each one (CutFile.C), with the same name (the run parameters
#   are read from it).
# - Small files (e.g. a .aqs of the Feminos cards), the restG4 simulations and the datasets: copied as they
#   are.
# The table of the files and their number of events is the catalogue of README.md.
set -euo pipefail

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <directory with the original files>" >&2
    exit 1
fi
source=$(cd "$1" && pwd)
root=$(cd "$(dirname "$0")" && pwd)
out="$root/output"
rm -rf "$out"
mkdir -p "$out"

# <file> <events> (0: the whole file, copied)
files=(
    "Run00229_Nominal_Test_Calibration_008.root 300"
    "Run03318_Calibration109Cd_TREXDM_DAQ_001.root 500"
    "R03137_Calibration37Ar_Vm_360_Vd_100_Pr_2_Gain_0x0_Shape_0xF_Clock_0x4.root 1000"
    "R01928_tagTest_Vm_250_Vd_160_Pr_6_Gain_0x0_Shape_0xF_Clock_0x4-068.aqs 0"
    # Simulations (restG4), whole files
    "Run00010_CosmicNeutrons_IAXO.root 0"
    "Run00001_CosmicMuons_IAXO.root 0"
    "Run00001_Am241_calibration_AlphaCAMM.root 0"
    # Datasets (whole files)
    "Dataset_IAXO_D1_Run00229_Calibration.root 0"
    "Dataset_IAXO_D1_Run00228_Background.root 0"
)

for entry in "${files[@]}"; do
    read -r name events <<<"$entry"
    echo "== $name"
    if [ "$events" -eq 0 ]; then
        cp "$source/$name" "$out/$name"
    else
        # The exit code of root -q is the value of the macro
        root -l -b -q "$root/CutFile.C+(\"$source/$name\", \"$out/$name\", $events)"
    fi
done

echo "Assets in $out:"
ls -l "$out"
