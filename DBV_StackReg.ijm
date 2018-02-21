///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			      MACRO INSTRUCTIONS			 		       ////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////  This macro reads any bio-format from an input directory, performs    ////////////////
////////////////	an stack registration algorithm and saves the registered images	   ////////////////
////////////////  						in a directory of choice.					   ////////////////
////////////////               To use it, load it into FIJI and press 'Run', 	       ////////////////
////////////////                           then follow instructions				       ////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////           			     David Kleinhans, 22.06.2016				   ////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

//	Create Dialog
	Dialog.create("Registration method");
	Dialog.addChoice("Method:", newArray("Translation", "Rigid Body", "Scaled Rotation", "Affine"));
	Dialog.addChoice("Frame:", newArray("First", "Last"));
	Dialog.show();
	method = Dialog.getChoice();
	frame = Dialog.getChoice();
// 	Call CLEANUP
	cleanup();
//	CHOOSE DIRECTORIES
	input = getDirectory("Choose an input directory");
	output = getDirectory("Choose an output directory");
	filename = File.nameWithoutExtension;
//	GET FILE LIST & SET BATCH MODE
	setBatchMode(true);
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
    	print("Processing file "+list[i]);
    	ZP(input, output, list[i]);
	}
	setBatchMode(false)
	//close();
	if(getBoolean("DONE! :).\nOpen output directory?"))
    call("bar.Utils.revealFile", output);
    
//---------------------------------------------------------------------------------------------
function cleanup(){
	run("Close All");
	run("Clear Results");
	call("java.lang.System.gc");
	roiManager("reset");
}

function ZP(input, output, filename){
	//GCA: wrong syntax	run("Bio-Formats Importer", "open[i] color_mode=Grayscale view=Hyperstack stack_order=XYCZT");
    run("Bio-Formats Importer", "open=["+input+filename+"] color_mode=Grayscale view=Hyperstack stack_order=XYCZT");
    filename = File.nameWithoutExtension;
	//open(input + filename);
	getDimensions(width, height, channels, slices, frames);
	if (frame=="Last") {
		setSlice(slices);
	}
	if (frame=="First") {
		setSlice(1);
	}
	run("StackReg", "transformation=["+method+"]");
	//run("StackReg", "transformation=Translation");
	//GCA: variables inside a string are treated as characters	saveAs("Tiff", "output + filename");
  	saveAs("Tiff", output + filename);
	close();
	cleanup();
}
