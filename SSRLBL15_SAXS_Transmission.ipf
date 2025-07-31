Function SSRLBL15_SAXS_Transmission(FileName)
    
    string FileName
    
    nvar DefSampleTransFile 
    nvar TransFile 
    nvar Trans_bstop 
    nvar Trans_seconds
    nvar Trans_norm

    //
	//HOW TO USE//////////////////////////////////////////////////////////////////////////
    //To use, place this code in a text file with .ipf file extension in
    //Documents/Wavemetrics/Igor Pro 9 User Procedures/Igor Procedures
    //(or /Igor Pro 9 Igor Procedures/)
    //ipf files placed in Igor Procedures folder are loaded always when Igor starts.
    //
    //Then in Nika : check "Use sample measurement time (ts)" checkbox and
    //on tab "Par" check "Use fnct?" for Sa Thickness in the field
    //type SSRLMSD_SAXS_MeasTime    (no " or ' , just the letters) with no parameters or ()
    //
	//DECRIPTION OF WHAT THIS IGOR PROCEDURE DOES/////////////////////////////////////////
    //This function reads from text file assuming name template:
    //image in name: imageName_XX.tif ------> the text file name:  imageName_XX.tif.txt
    //text file content line example:
    //     Seconds = 30
    //we need to return 8th element - Seconds - (Igor is 0 based, so item 7)
    //
	//
	//////////////////////////////////////////////////////////////////////////////////////
        // ----- here we go -----
        //First check if path to data exists, this is symbolic path Nika uses to name
        //location of the 2D data. Basically, images are here...
    PathInfo Convert2Dto1DDataPath
    if(V_Flag<1)                                                   //path does not exist
      Abort "Path to 2D data does not exist"   //abort
    endif
		//Then move to the parent directory.
        //This is where the .csv files are stored according to the 1-5 macro
    S_path = removeEnding(S_path, "SAXS:")
    print S_path
    NewPath/O csvPath S_path

	 //////////////////////////////////////////////////////////////////////////////////////
	 // BEGIN OBTAINING bstop VALUE FROM AIR SCAN //
	 //////////////////////////////////////////////////////////////////////////////////////
    //If(DefSampleTransFile==1)
    		//Variable TransFile 
    		//Variable Trans_bstop 
    		//Variable Trans_seconds
    		//Variable Trans_norm
    		//String TempTransFile 
    		//String Trans_aLine
    		//Open /P=csvPath /R /T=".csv" TransFile as TempTransFile
    			//FreadLine TransFile, Trans_aLine
    			//FreadLine TransFile, Trans_aLine		//progresses to line 2
    				//Trans_aLine=ReplaceString(" ", Trans_aLine, "")
					//Trans_aLine=ReplaceString(",", Trans_aLine, ";")
					//print Trans_aLine
					//Trans_bstop = str2num(StringFromList(6, Trans_aline, ";"))
					//print Trans_result
		//Else
		
			//if(Trans_bstop<=1)                                                   //path does not exist
      			//Abort "Transmission reference value is not defined. You must select an initial 'air' scan before the transmission can be calculated"   //abort
    		//endif
    //endif
    
    //Trans_seconds = str2num(StringFromList(2, Trans_aline, ";"))
    //Trans_norm = Trans_bstop/Trans_seconds
  
  
  	//////////////////////////////////////////////////////////////////////////////////////
  	//BEGIN SAMPLE MONITOR PROCEDURE//
  	//////////////////////////////////////////////////////////////////////////////////////
  
   string TextFileName                 //place for the file name
    variable NumOfSeparators2            //need a number
    NumOfSeparators2 = ItemsInList(FileName, "_")
    TextFileName = ReplaceString(".raw", FileName, "")       //remove the XX.tif part                  //remove "_"      //number of string parts separated by "_"

    string EndStuff2=StringFromList(NumOfSeparators2-1, TextFileName, "_")
    variable csvListNum=str2num(EndStuff2)
    //print csvListNum
    
    //EndStuff2 = EndStuff2[1, strlen(EndStuff2) - 2]
    TextFileName = ReplaceString(EndStuff2, TextFileName, "")
    TextFileName = removeEnding(TextFileName, "_")
    
    string FrontStuff=StringFromList(0, TextFileName, "_")
    TextFileName = ReplaceString(FrontStuff+"_", TextFileName, "")
                                                           //this is the XX.tif part
	 TextFileName = TextFileName+".csv"                         //add .txt to the name
                                    //this should be the text file name now.
    //print TextFileName            //for testing purposes
    
	//////////////////////////////////////////////////////////////////////////////////////
        //now we can open the file and read it line by line.
        //This can be done more efficiently, but if this file is not too long,
        //we can simply read through this line by line. Makes it easier to understand...
    variable i, refNum, matched
    string aLine
        //Open the file as read only.
        //We need to eventually close it so it does not stay open!
    Open /P=csvPath /R /T=".csv" refNum as TextFileName
        //iterate through first 35 lines
        //in my case example each text file had 35 lines of header
        //and then one line per file info
    //For(i=0;i<34;i+=1)                                    //35 lines of header info
      FreadLine refNum, aLine
      //print aLine                                    //for testing
    //endfor
    //    
    //    
	//////////////////////////////////////////////////////////////////////////////////////
		//now we need to read and check each line until
        //we find the one with the right parameter name in it...
    Do                                    //this loop could be done better
                        //but this should be easier to understand and modify.
      //i+=1                                            //line number, increment by +1
      FreadLine refNum, aLine         //read the line
      //print aLine
	  if(strlen(aline)<1)             //if aLine is empty we are the end of
                            //this file, Abort, did not find line which we needed...
        Abort "Date for the image name "+FileName+" was not found in the text file."
      endif
      if(GrepString(aLine, " "+num2str(csvListNum)+","))        //check if it contains sec=
        matched=1                         //if yes, we have our line
        //print aLine
        endif
    while(!matched)           //if matched, we can continue with this line
                              //else back in the loop...
    close refNum              //important, close the file.
        //now we have in string "aLine" the line from text file which
        //contains the name of the parameter we are dealing with...
    //print aLine                                                     //for testing
        //note, in my case aLine is separated by spaces = ' '
        //let's clean it up a bit,
	aLine=ReplaceString(" ", aLine, "")			//add spaces between parameter name, =, and value
	aLine=ReplaceString(",", aLine, ";")				//remove commas
    //print aLine                                                     //for testing
        //
		//////////////////////////////////////////////////////////////////////////////////
		//now we need to find the right number and return it to Nika...
    variable result
    variable sample_time
    variable Trans_corr
    variable Trans_value
        //Now it depends, which item is what.
        //Assume Seconds is eighth item (item 8, Igor is 0 based), for example...
   // print str2num(StringFromList(2, aline, ";"))
    result = str2num(StringFromList(6, aline, ";"))                   //Seconds
    sample_time = str2num(StringFromList(2, aline, ";"))
    //print "Sample time = " + num2str(sample_time)
    Trans_corr = Trans_norm*sample_time
    //print  num2str(Trans_corr)
    Trans_value = result/Trans_corr
   print num2str(Trans_norm) 
	print "Sample transmission = " + num2str(Trans_value)
    return Trans_value
end