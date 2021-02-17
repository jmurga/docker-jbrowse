import numpy as np
import pandas as pd
import subprocess
import glob
from tqdm import tqdm

def loadTestByWindowsSize(path,test,ws,samples,subcat,description,trackList="/jbrowse/data/dm6/trackList.json",addBw="/jbrowse/bin/add-bw-track.pl"):
	
	colorDict = {'pi':'#065EE8','theta_watterson':'#13B2FF','tajima':'green'}
	files = np.array(glob.glob(path + "/" + test + "/" + ws + "/*"))
	
	df = pd.read_csv(samples) 
	desc = pd.read_csv(description) 

	# for f in files:
		# print(f)
	for f in tqdm(files):
		track = f.split('/')[-1]
		pop = track.split(test)[0]

		tmp = df[(df.sampleId.str.contains(pop)) | (df.sampleId.str.contains(pop[0:-1]))]
		sampleId = tmp.sampleId.values[0]
		season = tmp.season.values[0]
		country = tmp.country.values[0]
		city = tmp.city.values[0]
		continent = tmp.continent.values[0]
		descText = desc[desc.test == test].description.values[0]

		color = colorDict[test]
		
		if(season is str and season not in sampleId):
			label = sampleId + "_" + season + "_" + test
		else:
			label = sampleId + "_" + test

		if(test == 'tajima'):
			testLabel = test.capitalize()+ "_D"
		else:
			testLabel = test.capitalize()
		
		category = subcat + "/" + testLabel + "/" + ws

		subprocess.run([addBw,
						'--category',category,
						'--label',label,
						'--key',label,
						'--plot',
						'--pos_color', color,
						'--neg_color', 'red',
						'--bw_url', '../../files/' + test + "/" + ws + "/" + track ,
						'--config','{"metadata":{ "population":"' + sampleId + '","metapopulation":"' + continent + '","' + subcat + '":"' + testLabel + '","windows_size":"' + ws + '","description":"' + descText + '"}}',
						"--in",trackList,
						"--out",trackList])

loadTestByWindowsSize(path="/jbrowse/files",test="theta_watterson",ws="100kb",samples="/data/dmel/samples.csv",description="/data/dmel/descriptionTable.txt",subcat="Variation")

loadTestByWindowsSize(path="/jbrowse/files",test="tajima",ws="100kb",samples="/data/dmel/samples.csv",description="/data/dmel/descriptionTable.txt",subcat="Variation")

loadTestByWindowsSize(path="/jbrowse/files",test="pi",ws="100kb",samples="/data/dmel/samples.csv",description="/data/dmel/descriptionTable.txt",subcat="Variation")