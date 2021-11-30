#!/usr/bin/env python3


# Directions to run the program
# parameters:

# 1: Jaguar data sirectory of the project: ../jaguar-data/<projectname>/<version>
# 2: Subsumption data directory of the project: ../subsumption-data/<projectid>

import os
import sys
import xml.etree.ElementTree as ET
import json

def createSpectraDic(folder):
	spectradir = {}
	listspectra =  os.listdir(spectra_folder)
	for f in listspectra:
		if ".spectra" in f:
			dirf=spectra_folder + os.sep + f
			if ".gz" in f:
				f = f.replace('.spectra.gz','')
			else:
				f = f.replace('.spectra','')
			spectradir[f] = dirf
	return spectradir

def createDuasDic(duas_folder):
	duadir = {}
	listduas =  os.listdir(duas_folder)
	for f in listduas:
		if ".duas.json" in f:
			dirf=dua_folder + os.sep + f
			if ".gz" in f:
				f = f.replace('.duas.json.gz','')
			else:
				f = f.replace('.duas.json','')
			duadir[f] = dirf
	return duadir

def createSpectraList(f):
	spectra = []

	if os.path.exists(f):
		filespectra = open(f, 'r')
		lines = filespectra.readlines()
       		# Strips the newline character & adds to spectra list
		for line in lines:
			spectra.append(line.strip())
	else:
		print ("File does not exist")
	return spectra

def createDuaList(f):
	listofduas = []
	if os.path.exists(f):
        	with open(f) as read_file:
                	data = json.load(read_file)
                	clazz = data['Class']
                	methods = data['Methods']
                	for m in methods:
                        	name = m['Name']
                        	noDuas = m['Duas']
                        	it = range(noDuas)
                        	#print("Method: %s, noDuas: %s, range: %s " %(name, noDuas, it))
                        	for d in it:
                                	dua = m[str(d)]
                                	fulldua = clazz + '#' + name + ':' + dua
                                	listofduas.append(fulldua);
	else:
		print ("File does not exist")
	return listofduas

def compareDuas(slist, dlist):
	a = len(slist) == len(dlist)
	if a == False:
		return False
	for n in range(len(slist)):
		s = slist[n]
		d = dlist[n]
		if s != d:
			#print(str(n)+':'+s+':'+d+':'+str(s == d))
			a = False
	return a

def compareDuas2(slist, dlist):
	a = len(slist) == len(dlist)
	if a == False:
		return False
	for n in range(len(slist)):
		s = slist[n]
		d = dlist[n]
		if s != d:
			print(str(n)+':'+s+':'+d+':'+str(s == d))
			a = False
	return a

if __name__ == '__main__':
	jaguar_dir = sys.argv[1]
	subsumption_dir = sys.argv[2]
	#print("Directory of jaguar data: %s" % jaguar_dir)
	#print("Directory of subsumption data: %s" % subsumption_dir)

	spectra_folder = os.path.join(jaguar_dir, "jaguar", ".jaguar", "spectra")

	#print(spectra_folder)

	spectramap = createSpectraDic(spectra_folder)
	#print(spectramap)

	#dua_folder = os.path.join(subsumption_dir, "reduce")
	dua_folder = subsumption_dir
	print(dua_folder)

	duamap = createDuasDic(dua_folder)
	#print(duamap)

	keysSpectra = spectramap.keys()
	keysDuas = duamap.keys()

	for v in keysSpectra:
		if v in keysDuas:
			spectrafile = spectramap[v]
			spectralist = createSpectraList(spectrafile)

			#print(v)

			duafile = duamap[v]
			dualist = createDuaList(duafile)
			if len(spectralist) == len(dualist):
				if compareDuas(spectralist,dualist):
					print(v)
				else:
					print(v+': NOK')
			else:
				print(v+': tamanho: '+ str(len(spectralist)) + '!=' + str(len(dualist)) + ': NOK')
		else:
			print(v+': not in spectra keys')
