// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro creates montages of selected frames from multi-channel movies and adds arrows (or other objects) in all channels
// You need a folder with movies (one file = one channel) in the input directory, and one or more arrows in ROI Manager
// Change the input directory on line 6 and output directory on line 7 (the folder will be created)
// Change the slices to be selected on line 8, change rectangle dimensions for cropping on line 32, file extension on line 21
directory = "/Users/daniel/Desktop/fiji_input/";
outputDirectory = "/Users/daniel/Desktop/montage/";
slices = "1,11,21,31,41";

File.makeDirectory(outputDirectory); 
File.makeDirectory(outputDirectory + "full/"); 
File.makeDirectory(outputDirectory + "crop/"); 
roiManager("Deselect");
roiManager("Save", outputDirectory + "RoiSet.zip");
roiManager("Associate", "true");
fileList = getFileList(directory);
setBatchMode(true);

// Loop for all files in the folder, adding ROIs and saving the montage
for (i=0; i<fileList.length; i++) {	
	if (endsWith(fileList[i], "tif")) {
  file = directory + fileList[i];
    open(file);
	roiManager("Show All");
	run("Flatten", "stack");
	run("Make Substack...", "  slices=" + slices);
	rename(fileList[i]);
	slicenumber = nSlices;
	run("Make Montage...", "columns=" +slicenumber+ " rows=1 border=2");
	saveAs("Tiff", outputDirectory + "full/" + fileList[i]);
	close();
		
	makeRectangle(23, 30, 70, 70);
	run("Crop");
	run("Make Montage...", "columns=" +slicenumber+ " rows=1 border=2");
	saveAs("Tiff", outputDirectory + "crop/" + fileList[i]);
	close("*");    
}
  }

showStatus("Finished.");
setBatchMode(false);


