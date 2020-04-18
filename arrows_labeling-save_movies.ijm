// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro needs one or more arrows (or other objects) in ROI Manager and a folder with movies to be labelled with the arrows
// Change the input directory (line 4) and output directory (line 19), change file extension if needed (line 12), and press Run
directory = "/Users/daniel/Desktop/fiji_input/";

fileList = getFileList(directory);
roiManager("Deselect");
setBatchMode(true);

// Loop for all files in the folder, labeling with all arrows in ROI manager
for (i=0; i<fileList.length; i++) {	
	if (endsWith(fileList[i], "tif")) {
  file = directory + fileList[i];
    open(file);
    
	roiManager("Show All");
	run("Flatten", "stack");
	rename(fileList[i]);
	saveAs("Tiff", "/Users/daniel/Desktop/fiji_output/arrows/" + fileList[i]);
	close("*");    
}
  }

showStatus("Finished.");
setBatchMode(false);


