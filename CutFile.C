// Copies a ROOT file keeping only the first entries of its trees:
//   root -b -q 'CutFile.C("input.root", "output.root", 500)'
// Every other object (e.g. the run configuration of the DAQ as TObjString) is copied as it is; of the
// cycles of a key only the last one is copied. Returns 0 on success (the exit code of root -q).

#include <TFile.h>
#include <TKey.h>
#include <TTree.h>

#include <iostream>
#include <memory>
#include <set>
#include <string>

int CutFile(const char* inputName, const char* outputName, Long64_t entries) {
    std::unique_ptr<TFile> input(TFile::Open(inputName, "READ"));
    if (!input || input->IsZombie()) {
        std::cerr << "CutFile: cannot open " << inputName << std::endl;
        return 1;
    }
    std::unique_ptr<TFile> output(TFile::Open(outputName, "RECREATE"));
    if (!output || output->IsZombie()) {
        std::cerr << "CutFile: cannot create " << outputName << std::endl;
        return 1;
    }
    std::set<std::string> copied;
    // The keys are listed with the highest cycle first
    for (auto* object : *input->GetListOfKeys()) {
        auto* key = static_cast<TKey*>(object);
        if (!copied.insert(key->GetName()).second) continue;
        TObject* read = key->ReadObj();
        output->cd();
        if (auto* tree = dynamic_cast<TTree*>(read)) {
            TTree* cut = tree->CopyTree("", "", entries);
            cut->Write(key->GetName(), TObject::kOverwrite);
            std::cout << key->GetName() << ": " << cut->GetEntries() << " of " << tree->GetEntries()
                      << " entries" << std::endl;
        } else {
            read->Write(key->GetName(), TObject::kOverwrite);
        }
    }
    output->Close();
    return 0;
}
