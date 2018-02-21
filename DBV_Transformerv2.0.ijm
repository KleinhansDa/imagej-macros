///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			      MACRO INSTRUCTIONS			 		      	 				///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////  This macro reads '.nd2; .czi; .tiff' files from an input directory and outputs	   	///////////////
////////////////  	them split or as Z-Projections, into a directory of your choice.     					///////////
////////////////               To use it, load it into FIJI and press 'Run', 	       					///////////////
////////////////                           then follow instructions				       					///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			     David Kleinhans, 22.06.2016				   					///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 	Call CLEANUP
	cleanup();
//	Create Dialog
	Dialog.create("BIO transform v1.7");
	Dialog.addMessage("Please choose whether the data is time series \nand if it should be projected in Z...");
	Dialog.addCheckbox("Z Projection", false);
	Dialog.setInsets(0,40,0);
	//Dialog.addCheckbox("Time Series", false);
	Dialog.addCheckbox("Split Channels", false);
	Dialog.addCheckbox("Split Timepoints", false);
	Dialog.addCheckbox("Just convert to tiff", false);
	items = newArray(".nd2", ".tif", ".czi");
	Dialog.addRadioButtonGroup("Input File-format:", items, 3, 1, ".nd2");
	Dialog.show();
		zp = Dialog.getCheckbox();
		//ts = Dialog.getCheckbox();
		splt = Dialog.getCheckbox();
		spltT = Dialog.getCheckbox();
		jctt = Dialog.getCheckbox();
		format = Dialog.getRadioButton;
//	DIALOG Projection
	if(zp) {
		Dialog.create("Projection method");
		//Dialog.addMessage("Projection Method");
		Dialog.addChoice("Method:", newArray("Max Intensity", "Average Intensity", "Standard Deviation", "Sum Slices"));
		Dialog.show();
		method = Dialog.getChoice();
	}
//	CHOOSE DIRECTORIES
		input = getDirectory("Choose an input directory");
		output = getDirectory("Choose an output directory");
		//filename = File.nameWithoutExtension;
//	CREATE Subdirs
		par = File.getParent(output); // get org parent directory
		metadir = par + File.separator + "00 - metadata" + File.separator; // create directory to save metadata
		File.makeDirectory(metadir);

//	PRINT to LOG window
		print("PARAMETERS");
		if(splt) {print("  Split Channels: true");
			} else {print("  Split Channels: false");}
		if(zp) {print("  Projection method: "+method);
			} else {print("  Z Projection: false");}
		print("DIRECTORIES");
		print("  Home directory: "+par);
		print("  metadata directory: ~/00 - metadata");
		print("  Input directory: ~/01 - ORG");
		print("----------------- PROCESSING -----------------");
//		GET FILE LIST & SET BATCH MODE
			setBatchMode(true);
			list = getFileList(input);
				for (i = 0; i < list.length; i++) {
                    if (endsWith(list[i], format)) { //list element + dataformat from formats array
                        print("Processing file "+list[i]);
    					ZP(input, output, list[i]);
                    }
				}
			setBatchMode(false);
print(" ");
print("DONE!");

//---------------------------------------------------------------------------------------------
function cleanup(){
	run("Close All");
	run("Clear Results");
	call("java.lang.System.gc");
}

function ZP(input, output, filename){
// BIOFORMATS IMPORT

//	Get Stack dims
	run("Bio-Formats Macro Extensions");
	id = input+list[i]; // get ID of first element of org.filelist(ofl)
	Ext.setId(id);
	Ext.getSeriesName(seriesName);
	Ext.getImageCreationDate(creationDate);
  	Ext.getPixelsPhysicalSizeX(sizeX);
  	Ext.getPixelsPhysicalSizeY(sizeY);
  	Ext.getSizeZ(sizeZ);
  	Ext.getSizeT(sizeT);
  	Ext.getSizeC(sizeC);
  	if (sizeT > 1) {
  		print("  Time Series detected");
  		// calculate timing
  		Ext.getPlaneTimingDeltaT(deltaT, 1);
  		deltaT1 = deltaT;
  		//print(deltaT);
  		Ext.getPlaneTimingDeltaT(deltaT, 0);
  		deltaT0 = deltaT;
  		//print(deltaT);
  		//if (ts) {print("  Time Frames: "+sizeT);}
  		deltaTsec = (deltaT1 - deltaT0);
  			deltaTsec = toString(deltaTsec);
  		deltaTmin = (deltaT1 - deltaT0)/60;
  			deltaminTround = round(deltaTmin);
  			deltaTmin = toString(deltaTmin);
  		//print(deltaT);
  		deltaTseccon = deltaTsec + " sec.";
  		deltaTmincon = deltaTmin + " min.";
  		//print(deltaTcon);
  	}
  	print("  Resolution: "+sizeX+" x "+sizeY+" µm");
  	print("  Z slices: "+sizeZ);
  	print("  Channels: "+sizeC);
  	if (sizeT > 1) {
  		print("  delta T: "+deltaTmin+" min.");
  	}
	//if (format == ".tif") {
	//open(input+filename);
	//} else {
		if (i==0) { // @ first list element open with metadata and save it, else open without metadata
			if (zp) { // just convert to tiff
    		run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale display_metadata rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    		}
			if (spltT) { // split timepoints
			run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale display_metadata rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
			//waitForUser("wait");
			}
    		if (splt) { // split channels
    		run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale display_metadata rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
    		}
    		if (jctt) { // just convert to tiff
    		run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale display_metadata rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    		}
    	//} else {
    		//run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale display_metadata rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    		//}
		}
		if (i > 0) {//
		//} else { // after i==0
			if (zp) { // just convert to tiff
    		run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    		}
			if (spltT) { // split timepoints
			run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
			}
	    	if (splt) { // split channels
	    	run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
	    	}
	    	if (jctt) { // just convert to tiff
    		run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    		} else {
    			run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
    			}
		}
	//}
	ORG = list[i];
	filename = File.nameWithoutExtension;
	//print("filename"+list[i]);
// SAVE METADATA
	//if (format == ".tif") {
	//} else {
		if (i==0) {
			//waitForUser("wait");
			selectWindow("Original Metadata - "+list[i]);
			saveAs("Text", metadir + list[i]);
			selectWindow("Original Metadata - "+list[i]);
			run("Close");
			//waitForUser("wait");
		}
	//}

//	Save split Timepoints
	if(spltT) {
	tplist = getList("image.titles");
	//print("tplist"+tplist.length);
	for (j = 0; j < tplist.length; j++) {
		showProgress(j/nImages);
		//print("TP: "+j+"/"+nImages); //; file: "+tplist[j]);
		//waitForUser("wait");
		selectWindow(tplist[j]);
		//list[j] = replace(list[j], format, "");
		//list[j] = replace(list[j], " - T=0T", ""); 
		//print("list name: "+ list[j]);
		if (j<10) {
			saveAs("Tiff", output + filename + "T0" + j);
		}
		if (j>=10) {
			saveAs("Tiff", output + filename + "T" + j);
		}
		close();
		wait(100);
		}
		//waitForUser("wait");
	}
// Z-PROJECTIONS
	if(zp){
		selectWindow(ORG);
	if (sizeT > 1) {
	//if(ts) {
		run("Z Project...", "projection=["+method+"] all");
	}
	else {
		run("Z Project...", "projection=["+method+"]");
	}
	ZPr = getTitle();
	resetMinAndMax();
	}

// SAVE AS TIFF
  	if(splt) {
  		if (sizeC == 2) {
  		if (format == ".tif") {
  		run("Split Channels");
  		selectWindow("C1-" + filename + format);
  		saveAs("Tiff", output + filename + "C01");
  		close();
  		selectWindow("C2-" + filename + format);
  		saveAs("Tiff", output + filename + "C02");
		close();  	
  		} else {
  			selectWindow(filename + format + " - C=0");
  			saveAs("Tiff", output + filename + "C01");
  			close();
  			selectWindow(filename + format +  " - C=1");
  			saveAs("Tiff", output + filename + "C02");
  			close();
  			}
  		} else if (sizeC == 3) {
  			if (format == ".tif") {
  			run("Split Channels");
  			selectWindow("C1-" + filename + format);
  			saveAs("Tiff", output + filename + "C01");
  			close();
  			selectWindow("C2-" + filename + format);
  			saveAs("Tiff", output + filename + "C02");
			close();  	
			selectWindow("C3-" + filename + format);
  			saveAs("Tiff", output + filename + "C03");
			close();
  				} else {
  				selectWindow(filename + format + " - C=0");
  				saveAs("Tiff", output + filename + "C01");
  				close();
  				selectWindow(filename + format +  " - C=1");
  				saveAs("Tiff", output + filename + "C02");
  				close();
  				selectWindow(filename + format +  " - C=3");
  				saveAs("Tiff", output + filename + "C03");
  				close();
  				}
  			}
  	} 
  	//if (zp) {
  	//	} else {
  	//	saveAs("Tiff", output + filename);
  	//	close();
  	//	}
  	if(zp) {
  	selectWindow(ZPr);
  	saveAs("Tiff", output + filename + "_ZP");
  	close();
  	} 
  	if(jctt) {
  	//selectWindow(filename);
  	run("Properties...", "channels=["+sizeC+"] slices=["+sizeZ+"] frames=["+sizeT+"] unit=micron pixel_width=["+sizeX+"] pixel_height=["+sizeY+"] voxel_depth=1.0000000 frame=["+deltaTseccon+"]");
  	saveAs("Tiff", output + filename);
  	close();
  	}
	cleanup();
	}
//}