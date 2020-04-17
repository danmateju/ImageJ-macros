// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro needs a folder with 2-channel movies
// It will correct the misalignment between the two channels, using images of beads
// Always check if the macro worked on the images of beads
// First, run Descriptor-based registration using single-frame images of beads (split channels before). Use affine model.
// Define input and output directory in the next two lines (make sure folders exist), change file extension in line 16 if needed, and press Run
directory = "/Volumes/gchao_scratch/matedani/folder/";
outputDirectory = "/Users/daniel/Desktop/registered/";

fileList = getFileList(directory);
run("Bio-Formats Macro Extensions");
setBatchMode(true);

// Loop for files with a given extension
for (i=0; i<fileList.length; i++) {	
	if (endsWith(fileList[i], "nd")) {
  file = directory + fileList[i];
    Ext.openImagePlus(file);

	// Swapping frames/slices (delete line 21 if needed), Re-applying Registration	
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	rename("substacked");
	run("Split Channels");
	run("Descriptor-based registration (2d/3d)", "first_image=C1-substacked second_image=C2-substacked reapply");	
 	newimage = outputDirectory + replace( fileList[i] , "-", "_" ); 
	saveFile(newimage);	
    close("*");
}
  }

showStatus("Finished.");
setBatchMode(false);

function saveFile(outFile) {
   run("Bio-Formats Exporter", "save=[" + outFile + "] compression=Uncompressed");
}
