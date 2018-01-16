Dir = getDirectory("image");
run("Z Project...", "projection=[Average Intensity]");
Stack.setChannel(2);
//run("Make Binary", "method=Default background=Light calculate");
//run("Make Binary", "method=Percentile background=Light calculate");
run("Make Binary", "method=Huang background=Dark calculate"); //change background parameter to 'Light' if you think the selections are inverted
run("Close-", "stack");

run("Erode", "stack");

if (roiManager("count")>0) {
	roiManager("reset");
}
run("Analyze Particles...", "size=40-Infinity pixel exclude clear include add slice");
roiManager("deselect");
roiManager("save", Dir+"/AutoROI.zip");