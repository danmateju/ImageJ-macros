// Daniel Mateju, 2020 - https://doi.org/10.1101/2020.03.31.018093
// This macro makes Max Intensity projections from movies in one folder and saves them in a new folder
// Change the input directory (line 4), output directory (line 17), file extension (line 11), and press Run
directory = "/Users/daniel/Desktop/raw/";
fileList = getFileList(directory);
run("Bio-Formats Macro Extensions");
setBatchMode(true);

// Loop for files in the folder
for (i=0; i<fileList.length; i++) {	
	if (endsWith(fileList[i], "nd")) {
   file = directory + fileList[i];
    Ext.openImagePlus(file);
	rename("newname");
	run("Z Project...", "projection=[Max Intensity] all");

	saveAs("Tiff", "/Users/daniel/Desktop/MaxZ/" + fileList[i]);
	close("*");    
}
  }

showStatus("Finished.");
setBatchMode(false);