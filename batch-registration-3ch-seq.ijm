// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro needs a folder with 3-channel movies (1=green 2=red 3=far red) with channel 1 acquired on a separate camera
// It will correct the misalignment in channel 1 in all movies, using images of beads
// Can be adapted to different channel combinations. Always check if it worked on the images of beads
// First, run Descriptor-based registration using single-frame images of beads: 1st channel = reference, 2nd channel = second image. Use affine model.
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

	// Swapping frames/slices (delete line 21 if needed), Re-applying registration for C1 and C2
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	rename("substacked");
	run("Split Channels");
	selectWindow("C1-substacked");
	run("Duplicate...", "title=C1-substacked-duplicated duplicate");
	run("Descriptor-based registration (2d/3d)", "first_image=C1-substacked second_image=C2-substacked reapply");
	rename("registered");
	run("Split Channels"); 

	// Re-applying Registration for C3 (This is necessary to end up with the same image size. Note that C2-C3 alignment remains unchanged)
	run("Descriptor-based registration (2d/3d)", "first_image=C1-substacked-duplicated second_image=C3-substacked reapply");
	rename("registered2");
	run("Split Channels"); 

	// Saving corrected composite movies
	run("Merge Channels...", "c1=C2-registered c2=C1-registered c3=C2-registered2 create ignore");
	newimage = outputDirectory + replace( fileList[i] , "-", "_" ); 
	outFile = replace(newimage, ".nd" , "-composite.tiff" );
	saveFile(outFile);
	close("*");
}
  }

showStatus("Finished.");
setBatchMode(false);

function saveFile(outFile) {
   run("Bio-Formats Exporter", "save=[" + outFile + "] compression=Uncompressed");
}
