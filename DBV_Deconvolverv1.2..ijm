///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			      MACRO INSTRUCTIONS			 		      	 				///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////  This macro reads '.nd2; .czi; .tiff' files from an input directory and outputs	   	///////////////
////////////////  	them as deconvolved				       					///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			     David Kleinhans, 22.06.2016				   					///////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	psfdir = "//141.2.47.191/grp_ak-lecaudey$/lab common/Analyse and process Images/PSFs (for deconvolution)/"
// 	Call CLEANUP
	cleanup();
//	Create Dialog
	Dialog.create("Deconvolver v1.0");
	Algoarr = newArray("RL", "else");
	Dialog.addMessage("Z / .tif stacks only!");
	Dialog.addChoice("Algorithm:", Algoarr);
	Dialog.addNumber("Iterations", 20)
	Dialog.show();
		algo = Dialog.getChoice();
		iter = Dialog.getNumber();
//	CHOOSE PSF
	files = newArray(0); 
	list = getFileList(psfdir); 
	for (i = 0; i < list.length; i++){ 
	if(endsWith(list[i],".tif")){ 
        files=Array.concat(files,list[i]); 
        } 
	}
	Dialog.create("Choose PSF");
	//psflist = getFileList(psfdir);
	Dialog.addChoice("PSF", files);
	Dialog.show();
		PSF = Dialog.getChoice();
	PSFp = psfdir + PSF;
//	CHOOSE DIRECTORIES
		input = getDirectory("Choose an input directory");
		channel = File.getName(input);
//	CREATE Subdirs
		par = File.getParent(input); // get org parent directory
		decondir = par + File.separator + channel + "_" + algo + iter +  File.separator; // create directory to save metadata
		File.makeDirectory(decondir);
//	PRINT to LOG window
		print("PARAMETERS");
		print("  Algorithm: "+algo);
		print("  Iterations: "+iter);
		print("POINT SPREAD FUNCTION");
		print("  PSF: "+PSF);
		print("DIRECTORIES");
		print("  INPUT directory: "+input);
		print("  OUTPUT directory: "+decondir);
		print("----------------- PROCESSING -----------------");
//		GET FILE LIST & SET BATCH MODE
			setBatchMode(true);
			list = getFileList(input);
				for (i = 0; i < list.length; i++) {
                    if (endsWith(list[i], ".tif")) { //list element + dataformat from formats array
                        print("Processing file "+list[i]);
    					decon(input, decondir, list[i]);
                    }
				}
			setBatchMode(false);
print(" ");
print("DONE!");

//--------------------------------FUNCTIONS-------------------------------------
function cleanup(){
	run("Close All");
	run("Clear Results");
	call("java.lang.System.gc");
}

function decon(input, decondir, filename){
	filepath = input + list[i];
	filepath = replace(filepath,"\\","/");
	PSFstr = " -psf file "+ PSFp;
	image = " -image file " + filepath;
	algorithm = " -algorithm "+ algo + " " + iter;
	parameters = "";
	run("DeconvolutionLab2 Run", image + PSFstr + algorithm + parameters);
	run("16-bit");
	deconimg = replace(list[i], ".tif", ""); 
	saveAs("Tiff", decondir + deconimg + "DC" + algo + iter);
	close();
	cleanup();
}
