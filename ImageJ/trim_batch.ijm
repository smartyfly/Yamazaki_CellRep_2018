if (roiManager("count")>0) {
	roiManager("reset");
}
Dir = getDirectory("Choose a Directory");
open(Dir+"AutoROI_man.zip");
Dir = Dir+"dF_F0_Ch2/";

list = getFileList(Dir);
for (i = 0; i < list.length; i++){
	if (endsWith(list[i],".tif")) {
		open(Dir + list[i]);
		trimimage(Dir, list[i]);
	}
}

function trimimage(savepath, img) {
	File.makeDirectory(savepath+"/trim2/");	
	if (roiManager("count")>0) {
		for (n=0;n<roiManager("count");n++) {
			selectWindow(img);
			File.makeDirectory(Dir+"/trim2/roi"+n+1);
			roiManager("Select", n);
			run("Duplicate...", "duplicate");
			setBackgroundColor(0);
			run("Clear Outside", "stack");
			saveAs("Tiff",savepath+"trim2/roi"+n+1+"/"+img+"-roi"+n+1+".tif");
			close();
		}
	} else {
		exit("no item in the ROI manager.");
	}
	selectWindow(img);
	close();
}