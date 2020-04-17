// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro needs an open 2-channel composite movie and a list of ROIs (spots) present in ROI manager
// It will measure the spot intensities in both channels + local background intensities (doughnut-shaped ROIs)
// Define output directory in the next line line (folder will be created). Change the band size if needed. Press Run.
outDirectory = "/Users/daniel/Desktop/4-1/";

File.makeDirectory(outDirectory); 
run("Properties...", "unit=pixel pixel_width=1 pixel_height=1 voxel_depth=1");
roiManager("Deselect");
numROIs = roiManager("count");

// Measure intensities in spots
roiManager("Save", outDirectory + "RoiSet.zip");
Stack.setChannel(1);
roiManager("measure");
saveAs("Results", outDirectory + "ch1_spots.csv");
run("Close");

Stack.setChannel(2);
roiManager("measure");
saveAs("Results", outDirectory + "ch2_spots.csv");
run("Close");

// loop through ROIs to turn each into a band (doughnut-shaped ROI)
for(i=0; i<numROIs;i++) { 
	roiManager("Select", i);
	run("Make Band...", "band=5");
	roiManager("Update");
}

roiManager("Deselect");

// Measure intensities in bands
Stack.setChannel(1);
roiManager("measure");
saveAs("Results", outDirectory + "ms2_around.csv");
run("Close");

Stack.setChannel(2);
roiManager("measure");
saveAs("Results", outDirectory + "ST_around.csv");
run("Close");