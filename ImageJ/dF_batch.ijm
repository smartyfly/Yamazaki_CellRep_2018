Dir = getDirectory("Choose a Directory");
list = getFileList(Dir);
for (i = 0; i < list.length; i++){
	if (endsWith(list[i],".tif")) {
		open(Dir + list[i]);
		dF("Ch2");
		close();
	}
}

function dF(Postfix_savefolder) {
	print("4D deltaF/F0");
	//initialize
	run("Select None");
	file = getTitle(); //title
	dotIndex = indexOf(file, "."); 
	if (dotIndex>0) {file = substring(file, 0, dotIndex);rename(file);};
	Dir = getDirectory("image"); //get the directory path of selected image
	nslice = nSlices(); //number of total slices
	Meta1 = getMetadata("Info");
	Stack.getDimensions(Width, Height, CH, Slices, Frames);
	TPF = Stack.getFrameInterval();
	print(TPF);

	F0frames = floor(3/TPF); //number of frames for base calculation
	ODORtrigger = 15; //odor onset sec from the recording start
	ODOR1stFrame = floor(ODORtrigger/TPF)+1; //1st frame of the odor stimulation
	Filter = true; //Median filter option
	FilterRadius = 2; //radius of median filter
	SAVE = true; //save output file if this is checked
	PostFix = "";
	
	// select channel to process
	if (CH>1){
		dCh = 2;
		run("Duplicate...","title=["+file+"_Ch"+dCh+"] duplicate channels="+dCh+"");
		file = file+"_Ch"+dCh;
		Stack.setChannel(dCh);
	}
	
	T1 = getTime();
	
	run("32-bit");
	
	setBatchMode(true);
	//duplicate for filtering
	if (Filter==true){
		PostFix = "-" + FilterRadius + "pxMedian";
		run("Duplicate...", "title="+file+PostFix+" duplicate");
		run("Median...", "radius="+FilterRadius+" stack");
		rename(file+PostFix);
	}
	
	for (i=1; i<=Slices; i++) {
		selectWindow(file+PostFix);
		run("Duplicate...",  "title =[" +file+"_z("+i+")]"+ " duplicate slices=" + i + "");
		rename(file+PostFix+"_z("+i+")");
		
		// generate base F0
		selectWindow(file+PostFix+"_z("+i+")");
		run("Duplicate...", "title=["+file+"-dup] duplicate range="+ODOR1stFrame-F0frames+"-"+ODOR1stFrame+"");
		if (nSlices>1){ 
			run("Z Project...",  "projection=[Average Intensity]");
			rename("AVG");
			selectWindow(file+"-dup");
			close();
		}else{
			rename("AVG");
		}
		
		// calculate delta F divided by F
		imageCalculator("Subtract create 32-bit stack", file+PostFix+"_z("+i+")","AVG");
		rename("deltaF");
		imageCalculator("Divide 32-bit stack", "deltaF" ,"AVG");
		rename("deltaF_F0_"+file+PostFix+"_z("+i+")");
		selectWindow("AVG");
		rename("AVG_"+file+PostFix+"_z("+i+")");
		selectWindow(file+PostFix+"_z("+i+")");
		close();
	}
	
	//reconstruct Z
	if (Slices>1) {
		for (i=1; i<Slices; i++){
			run("Concatenate...", "  title=[deltaF_F0_"+file+PostFix+"_z(1)] stack1=[deltaF_F0_"+file+PostFix+"_z(1)] stack2=[deltaF_F0_"+file+PostFix+"_z("+i+1+")] ");
		}
		run("Stack to Hyperstack...", "order=xytzc channels=1 slices="+Slices+" frames="+Frames+" display=Color");
	}
	selectWindow("deltaF_F0_"+file+PostFix+"_z(1)");
	rename("dF_F0_"+file+PostFix+".tif");
	setMetadata("Info", Meta1);
	run("ICA");
	Stack.getStatistics(voxelCount, Mean, Min, Max, stdDev);
	setMinAndMax(Mean - stdDev, Mean + 4 * stdDev);
	
	//reconstruct Z (AVG)
	if (Slices>1) {
		for (i=1; i<Slices; i++){
			run("Concatenate...", "  title=[AVG_"+file+PostFix+"_z(1)] stack1=[AVG_"+file+PostFix+"_z(1)] stack2=[AVG_"+file+PostFix+"_z("+i+1+")] ");
		}
		run("Stack to Hyperstack...", "order=xytzc channels=1 slices="+Slices+" frames=1 display=Color");
	}
	selectWindow("AVG_"+file+PostFix+"_z(1)");
	rename("AVG_fr"+ODOR1stFrame-F0frames+"_"+ODOR1stFrame-1+"_"+file+".tif");
	setMetadata("Info", Meta1);

	selectWindow(file);
	rename(file+".tif");
	
	T2 = getTime();

	//close unesseary windows
	if (CH>1) {
		selectWindow(file+".tif");
		close();
		replace(file,"_Ch"+dCh,"")
	}
	if (Filter==true){
		selectWindow(file+PostFix);
		close();
	}
	
	setBatchMode("exit & display"); 
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	print("\n\nProcessed file : "+Dir+file+".tif.zip"+"\nFrame Interval: "+TPF+" sec\nF0 frames: "+ODOR1stFrame-F0frames+"-"+ODOR1stFrame+"\nOdor start frame: "+ODOR1stFrame+" ("+ODORtrigger+" sec)\n ... done ("+year+"/"+month+"/"+dayOfMonth+"   "+hour+":"+minute+")\n");
	print("(Processing time: "+(T2 - T1)/1000+" sec)\n\n");
	
	if(SAVE == true){
		SaveDir2 = Dir+"dF_F0_"+Postfix_savefolder;
		File.makeDirectory(SaveDir2);
		selectWindow("AVG_fr"+ODOR1stFrame-F0frames+"_"+ODOR1stFrame-1+"_"+file+".tif");
		close();
		//saveAs("ZIP", SaveDir2+"/AVG_fr"+ODOR1stFrame-F0frames+"_"+ODOR1stFrame-1+"_"+file+".tif.zip");
		selectWindow("dF_F0_"+file+PostFix+".tif");
		saveAs("tiff", SaveDir2+"/dF_F0_"+file+PostFix+".tif");
	}
	selectWindow("dF_F0_"+file+PostFix+".tif");
	close();
}