import pandas as pd
import numpy as np
import glob
from multiprocessing import Pool
import os
from tqdm import tqdm
import subprocess

PATH = "/home/jmurga/Downloads/popgenStats_PoolSNP_100k"
bdTobw="/home/jmurga/.conda/bin/bedGraphToBigWig"

os.makedirs(PATH + "/theta_watterson/", exist_ok=True)
os.makedirs(PATH + "/tajima/", exist_ok=True)
os.makedirs(PATH + "/pi/", exist_ok=True)

files = np.sort(glob.glob(PATH + "/*stats"))
caller = "PoolSNP"
chrSize = pd.read_csv(PATH+"/chrom.sizes")

def openFiles(f,chrom):

	nchr = f.split('/')[-1].split("PoolSNP")[1].split("_")[1]
	df = pd.read_csv(f,sep='\t')
	df[['chr']] = nchr
	df[['Start']] = df.Start - 1
	if(df.window.values[0] != 1):
		
		w = df.window.values[0] - 1 
		tmp = pd.DataFrame({'Start':np.arange(0,(10**5*w),10**5),'End':np.arange(10**5,(10**5*w)+10**5,10**5),'length':np.repeat(np.nan,w),'Watterson':np.repeat(np.nan,w),'Pi':np.repeat(np.nan,w),'Tajima_D':np.repeat(np.nan,w),'chr':np.repeat(nchr,w)})
		df = pd.concat([tmp,df])

	df.End.values[-1] = chrom[chrom.chr==nchr].end.values[0]
	df.sort_values(['chr', 'Start'])
	return(df)

def splitPop(x,c=caller):
	name = x.split("/")[-1].split(c)
	pop = name[0]
	return(pop)

vfunc   = np.vectorize(splitPop)

samples = np.unique(vfunc(files))
nchr    = np.array(["2L","2R","3L","3R","X"])
stats   = np.array(["Watterson","Pi","Tajima_D"])
chrSize = pd.read_csv(PATH+"/chrom.sizes",sep='\t',header=None,names=["chr","end"])

for s in tqdm(samples):

	popFiles = files[np.where(np.char.find(files, s + caller) >=0)[0]]

	pool = Pool(processes=nthreads)
	tmp = pool.starmap(openFiles,list(zip(popFiles,[chrSize]*len(popFiles))))
	pool.terminate()

	df = pd.concat(tmp)

	watterson = df[['chr','Start','End','Watterson']]
	tajima = df[['chr','Start','End','Tajima_D']]
	pi = df[['chr','Start','End','Pi']]

	
	watterson.to_csv(PATH + "/theta_watterson/" + s + "theta_watterson.bedgraph",index=False,header=False,sep='\t',na_rep='nan')
	tajima.to_csv(PATH + "/tajima/" + s + "tajima.bedgraph",index=False,header=False,sep='\t',na_rep='nan')
	pi.to_csv(PATH + "/pi/" + s + "pi.bedgraph",index=False,header=False,sep='\t',na_rep='nan')

	subprocess.run([bdTobw,PATH + "/theta_watterson/" + s + "theta_watterson.bedgraph",PATH+"/chrom.sizes",PATH + "/theta_watterson/" + s + "theta_watterson.bw"]) 
	subprocess.run([bdTobw,PATH + "/tajima/" + s + "tajima.bedgraph",PATH+"/chrom.sizes",PATH + "/tajima/" + s + "tajima.bw"]) 
	subprocess.run([bdTobw,PATH + "/pi/" + s + "pi.bedgraph",PATH+"/chrom.sizes",PATH + "/pi/" + s + "pi.bw"]) 
	subprocess.run(["rm",PATH + "/theta_watterson/" + s + "theta_watterson.bedgraph"]) 
	subprocess.run(["rm",PATH + "/tajima/" + s + "tajima.bedgraph"]) 
	subprocess.run(["rm",PATH + "/pi/" + s + "pi.bedgraph",]) 

