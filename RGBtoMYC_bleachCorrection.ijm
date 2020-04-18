// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro performs bleach correction on the opened 3-channel composite movie, and converts it from red-green-blue to magenta-yellow-cyan
// Change the output filepath in line 16, change the background intensities for bleach correction (lines 8,10,12) and press Run
rename("name");
run("Split Channels");

selectWindow("C3-name");
run("Bleach Correction", "correction=[Simple Ratio] background=500");
selectWindow("C2-name");
run("Bleach Correction", "correction=[Simple Ratio] background=300");
selectWindow("C1-name");
run("Bleach Correction", "correction=[Simple Ratio] background=50");

run("Merge Channels...", "c5=DUP_C3-name c6=DUP_C1-name c7=DUP_C2-name create ignore");

saveAs("Tiff", "/Users/daniel/Desktop/fiji_output/Merged-BC.tif");
selectWindow("C1-name");
close();
selectWindow("C2-name");
close();
selectWindow("C3-name");
close();