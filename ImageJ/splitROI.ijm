// genrates 'AND' ROI from two overlapping ROIs

Rcount = roiManager("count");
for (i=2;i>0;i--) {
	for (ii=0;ii<Rcount-2;ii++) {
		R = newArray(ii,Rcount-i);
		roiManager("select",R);
		roiManager("AND");
		getSelectionBounds(x, y, width, height);
		if (x*y!=0) {
			roiManager("Add");
		}
	}
}

for (ii=0;ii<Rcount;ii++) {
	roiManager("select",0);
	roiManager("Delete");
}

Dir = getDirectory("image");
roiManager("save", Dir+"/AutoROI_man.zip");

roiManager("reset");
close();