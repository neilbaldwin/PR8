	.MACRO defp _string
	.BYTE (.STRAT (_string,0))-49, (.STRAT (_string,1))-49, (.strat (_string,2))-49
	.ENDMACRO

	.MACRO defp2 _string
	.BYTE (.STRAT (_string,0))-1, (.STRAT (_string,1))-1, (.strat (_string,2))-1
	.ENDMACRO
	
parameterNames:
	defp "AOC"
	defp "AOF"
	defp "AOD"
	defp "ALD"
	defp "ALS"
	defp "ALW"
	defp "AAV"
	defp "AAE"
	defp "AAH"
	defp "AP1"
	defp "AP2"
	
	defp "BOC"
	defp "BOF"
	defp "BOD"
	defp "BLD"
	defp "BLS"
	defp "BLW"
	defp "BAV"
	defp "BAE"
	defp "BAH"
	defp "BP1"
	defp "BP2"
	
	defp "COC"
	defp "COF"
	defp "CLD"
	defp "CLS"
	defp "CLW"
	defp "CAP"
	defp "CAG"
	
	defp "DOC"
	defp "DLD"
	defp "DLS"
	defp "DLW"
	defp "DAV"
	defp "DAE"
	defp "DAH"
	
	defp "ESM"
	defp "EST"
	defp "EEN"
	defp "EPT"
	defp "ELP"
	
	defp "MLD"
	defp "MLS"
	defp "MLW"

	defp "MAV"
	defp "MAE"
	defp "MAH"

	
parameterNamesEnd:
	.BYTE $2C,$2C,$2C
	