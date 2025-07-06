Function/S ReturnSampleName(My2DImage, OriginalDataFileName)
	wave My2DImage
	string OriginalDataFileName
	string tempName=OriginalDataFileName
	tempName=ReplaceString("b_strange_", tempName, "")
	tempName=ReplaceString("_scan1", tempName, "")
	tempName=ReplaceString("_00", tempName, "_")
	tempName=ReplaceString("loop", tempName, "")
	tempName=ReplaceString("run", tempName, "")
	tempName=ReplaceString("per", tempName, "")
	tempName=ReplaceString("inner_", tempName, "in")
	tempName=ReplaceString("INEOS_MDPE", tempName, "INEOS_MD")
	tempName=ReplaceString("unfill", tempName, "unf")
	tempName=ReplaceString("MARLEX", tempName, "MRLX")
	tempName=ReplaceString("HDPE_DOW2480", tempName, "HDP_DOW")
	tempName=ReplaceString("liqH2O", tempName, "lH2O")
	tempName=ReplaceString("sealed_", tempName, "seal")
	tempName=ReplaceString("ange_", tempName, "")
	tempName=ReplaceString("PE2708", tempName, "")
	tempName=ReplaceString("gasmix", tempName, "mix")
	tempName=ReplaceString("bar", tempName, "b")
	tempName=ReplaceString("trial", tempName, "t")
	tempName=ReplaceString("postevac", tempName, "PE")
	return tempName
end