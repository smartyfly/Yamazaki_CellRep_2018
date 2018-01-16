path = File.openDialog("Select a File");
dir = File.getParent(path);
Im = File.getName(path);
print(Im);
print(dir);

setBatchMode(true);
open(dir+"/"+Im);
run("Z Project...", "projection=[Average Intensity]");
rename("AveIm");
run("Duplicate...", "title=roi duplicate channels=1");
close("AveIm");
run("Enhance Contrast", "saturated=0.35");
if (roiManager("count")>0){
	roiManager("reset");
}
open(dir+"/AutoROI_man.zip");
roiManager("select",seqArray(roiManager("count")));
run("Flatten");
rename("Flatten");
save(dir+"/AutoROI_man.png");
close("roi");
close("Flatten");
close(Im);
setBatchMode(false);

function seqArray(i) {
	a = newArray(i);
 	for (i=0; i<a.length; i++) {
 		a[i] = i;
 	}
 	return a;
}