#!/usr/bin/env python3

# To run this script you should first set up the environment for numpy
# Use the following commands:
# python3 -m venv work
# source work/bin/activate


# Directions to run the program
# parameters:

# 1: Jaguar data sirectory of the project: ../jaguar-data/<projectname>/<version>
# 2: Subsumption data directory of the project: ../subsumption-experiment/subsumption-data/<projectid>
# 3: Class name: name of the class whose data will be checked.

# Observations:
# Note that <projectid> != <projectname>. Use <projectid> and <projectname> as defined in the defects4j repository
# The json files should be in the  directory ../subsumption-data/<projectid>/reduce
# The matrix files should be in the directory ../jaguar-data/<projectname>/<version>/jaguar/.jaguar/matrix/

import numpy as np
import json
import os
import re
import sys
import xml.etree.ElementTree as ET
import csv
import copy


def get_list_proj_classes(jaguar_spectra_folder_path):
	list_proj_classes = []
	suffix = "."+cft.replace('s','') +".matrix"
	for file in os.listdir(jaguar_spectra_folder_path):
		if file.endswith(suffix):
			clazz = file.replace(suffix,'')
			list_proj_classes.append(clazz)
	return list_proj_classes



def read_class_cft_file(cft,cft_file,dic_class,dic_class_info,methods_name,methods_noCfts):
	if os.path.exists(cft_file):
		with open(cft_file) as read_file:
			#print(read_file)
			data = json.load(read_file)
			cl = data['Class']
			methods = data['Methods']
			counter = 0
			#print(methods)
			for m in methods:
				name = m['Name']
				#noCfts = m['Duas']
				if cft == "nodes":
					noCfts = m['Nodes']
				else:
					noCfts = m['Edges']

				#print(noCfts)
				itCfts = range(int(noCfts))

				dic_cft = {}
				dic_cft_info = {}
				
				for key in itCfts:
					#print(key)
					if str(key) in m:
						cft_list = m[str(key)]

						list_cft = []
						list_cft.append(key)

						dic_cft[key] = list_cft
						dic_cft_info[key] = cft_list

				methods_name [counter] = name
				methods_noCfts[counter] = int(noCfts)
				dic_class[counter] = dic_cft
				dic_class_info[counter] = dic_cft_info
				counter = counter+1

	else:
		print('Could not open file '+cft_file)
		#sys.exit(1)
	return


def read_class_cft_sub_file(cft,cft_sub_file,dic_class_sub_info):
	if os.path.exists(cft_sub_file):
		with open(cft_sub_file) as read_file:
			#print(read_file)
			data = json.load(read_file)
			methods = data['Methods']
			counter = 0
			#print(methods)
			for m in methods:
				
				#noCfts = m['Duas']
				if cft == "nodes":
					noCfts = m['Nodes']
					noCoveredDuas = m['CoveredDUAsByNodes']
				else:
					noCfts = m['Edges']
					noCoveredDuas = m['CoveredDUAsByEdges']

				#print(noCfts)
				itCfts = range(int(noCfts))

				dic_cft_sub_duas = {}
		
				for key in itCfts:
					#print(key)
					if noCoveredDuas == -1: # Not well-formed method
						dic_cft_sub_duas[key] = 'notclear'	
					else:
						if str(key) in m:
							cft_list = m[str(key)]
							dic_cft_sub_duas[key] = cft_list

				dic_class_sub_info[counter] = dic_cft_sub_duas
				counter = counter+1

	else:
		print('Could not open file '+cft_sub_file)
		#sys.exit(1)
	return

def findmaxfpd(cvsversionfile,proj,ver,dicfdp):
    data = []
    fdp = 0
    fdpfirst = True
    uncfdpmax = 0
    nouncfdpmax = 0
    subfdpmax = 0
    nosubfdpmax = 0
    uncstatus = 'notclear'
    fdplast = 0
    
    if os.path.exists(cvsversionfile):
        with open(cvsversionfile, mode ='r') as file:
			
            # reading the CSV file
            csvvf = csv.DictReader(file, delimiter=';'); 
            uncdualist = []; 
            subdualist = []
            for line in csvvf:
                fdp = float(line['FAULT DETECTION '])
				
                if fdpfirst:
                    fdplast = fdp
                    fdpfirst = False

                if fdp != fdplast:
                    break
                dua = line['DUAs']
                if line['Uncon'] == 'True':
                    uncfdpmax = fdp
                    nouncfdpmax = nouncfdpmax + 1; 
                    uncdualist.append(dua)
                    if line['Status'] == 'clear':
                        uncstatus = line['Status']
                else:
                    subfdpmax = fdp
                    nosubfdpmax = nosubfdpmax + 1; 
                    subdualist.append(dua)                     
    
        data.append(proj)
        data.append(ver)
        data.append(uncfdpmax)
        data.append(nouncfdpmax); 
        data.append(uncdualist)
        data.append(uncstatus)
        data.append(subfdpmax)
        data.append(nosubfdpmax); 
        data.append(subdualist)

        label = proj+"-"+ver
        dicfdp[label] = data
    else:
        print("File " +cvsversionfile+ " does not exist!"); 
        sys.exit(1)

    return dicfdp


def findmaxfpd_cft(jsonversionfile,proj,ver,dicfdp):
    data = []
    fdp = 0
    fdpfirst = True
    fdplast = 0

    if os.path.exists(jsonversionfile):
        with open(jsonversionfile, mode ='r') as file:		
            # reading the json file
            listedges = json.load(file)
            for e in listedges: # cft
                fdp = e[1][0] # e's fdp
				
                if fdpfirst:
                    fdplast = fdp
                    fdpfirst = False

                if fdp != fdplast:
                    break
                data.append(e[1])
        label = proj+"-"+ver
        dicfdp[label] = data
    else:
        print("File " +jsonversionfile+ " does not exist!"); 
        sys.exit(1)

    return dicfdp

def get_dic_dua_info(d_duas_info,clist,l_top_duas):
	for dua in l_top_duas:
		#print(dua)
		dua_info = []

		string = dua
		# find Dua class
		class_obj = re.search(r"(\w+.\w*)+%",string)
		class_str = class_obj.group()
		string = string.replace(class_str,'')
		class_str = class_str.replace('%','')
		if not class_str in clist:
			clist.append(class_str)
		# print('class: ' +class_str)
		# print('String: '+ string)
		# print('Dua: ' + dua)

		# find method name

		method_obj = re.search(r"(\w+.\w*)+\#",string)
		method_str = method_obj.group()
		string = string.replace(method_str,'')
		method_name = method_str.replace('#','')
		# print(method_name)
		# print(string)

		# find method id
		methodid_obj = re.search(r"(\d)+@",string)
		methodid_str = methodid_obj.group()
		string = string.replace(methodid_str,'')
		methodid_id = methodid_str.replace('@','')
		# print(methodid_id)
		# print(string)

		# find dua id

		duaid_obj = re.search(r"(\d)+\$",string)
		duaid_str = duaid_obj.group()
		string = string.replace(duaid_str,'')
		duaid = duaid_str.replace('$','')
		# print(duaid)
		# print(string)

		dua_info.append(class_str)
		dua_info.append(method_name)
		dua_info.append(methodid_id)
		dua_info.append(duaid)
		dua_info.append(False)
		dua_info.append([])
		d_duas_info[dua] = dua_info

	return

def find_subsumption(cft,dic_all_classes_cft_sub,dic_top_duas):
	isSubsumed_list = []
	ret = 'notclear'
	for d in dic_top_duas:
		isDuaSubsumed = 'False'
		classname = dic_top_duas[d][0] # Get the class name

		if classname in dic_all_classes_cft_sub: 
			if cft == "nodes":
				dic_cftdua = dic_all_classes_cft_sub[classname]['duanodesub']
			else:
				dic_cftdua = dic_all_classes_cft_sub[classname]['duaedgesub']

			duam = int(dic_top_duas[d][2]) # Get dua's method number

			if duam in dic_cftdua:
				dic_method_dua_cft_sub = dic_cftdua[duam] 
				duaid = int(dic_top_duas[d][3]) # Get dua's id number
				for c in dic_method_dua_cft_sub:
					# print(dic_method_dua_cft_sub[c])
					if dic_method_dua_cft_sub[c] == 'notclear':
						isDuaSubsumed = 'notclear' # there is no subsumption relationship for the method
						break
					else:
						# print("Class: %s; Method id:  %s; Dua id: %s" %(classname, str(duam), str(duaid)))
						# print("%s: %s: subsumed duas: %s" %(cft,c,dic_method_dua_cft_sub[c]))
						
						# print(dic_method_dua_cft_sub[c])
						if duaid in dic_method_dua_cft_sub[c]: # check if dua is in the list of subsumed duas
							# print("%s:%s:is subsumed by edge: %s" %(duam,duaid, c))
							isDuaSubsumed = 'True'
							dic_top_duas[d][5].append(c)
			dic_top_duas[d][4] = isDuaSubsumed
			isSubsumed_list.append(isDuaSubsumed)

	# Check for the result of the subsumption analysis of all top duas
	
	if isSubsumed_list:
		# print("isSubsumed_list: %s" % isSubsumed_list)
		if 'True' in isSubsumed_list:
			ret = 'True'
		else:
			if not 'notclear' in isSubsumed_list:
				ret = 'False'
	
	return ret

# Deprecated 
def compare_dua_cft(projectid, version, fdpmax, cftmax, dic_duas, dic_cfts):
	list_comparison = []
	
	listcfts = dic_cfts[projectid+"-"+version]

	# print("cftmax: %s; fdpmax: %s" %(cftmax,fdpmax))
	if cftmax < fdpmax:
		# print("cftmax < fdpmax for " + projectid+"-"+version)
		list_comparison.append(">")
	else:
		if cftmax == fdpmax:
			# print("cfmax == fdpmax for " + projectid+"-"+version)
			list_comparison.append("==")
		else:
			# print("cfmax > fdpmax for " + projectid+"-"+version)
			list_comparison.append("<")

	top_duas_subsumed = False
	c_subsumers = []
	for c in listcfts:
		# print(c)
		c_clazz = c[1]
		c_method_id = c[2]
		
		c_sublist = c[5]
		c_subsumes = False
		for d in dic_duas:
			# print(d)
			dua = dic_duas[d]
			clazz = dua[0]
			method = dua[1]
			method_id = dua[2]
			duaid = int(dua[3])
			# print("c_clazz: %s; clazz: %s; c_method_id: %s; method_id: %s" %(c_clazz, clazz, c_method_id, method_id))
			# print(c_clazz)
			# print(clazz)
			# if c_clazz == clazz:
			# 	print("Iguais")
			if c_clazz == clazz and int(c_method_id) == int(method_id):
				# print(duaid)
				# print(c_sublist)
				if duaid in c_sublist: # same class and method
					top_duas_subsumed = True
					c_subsumes = True
				# else:
					# 	print("Not the same class and method.")
			if c_subsumes:
				c_subsumers.append(c)
			list_comparison.append(top_duas_subsumed)
			list_comparison.append(c_subsumers)
		
	return list_comparison

def create_dic_all_classes_cft_sub(subsumption_dir, version,clazzlist,dic_all_classes_dua_node_sub,dic_all_classes_dua_edge_sub):
	for clazz in clazzlist:
	 
		# print("Analyzing class %s" % clazz, end = "\n")

		dic_class_dua_node_sub = {}
		dic_class_dua_edge_sub = {}

		subsumption_folder = os.path.join(subsumption_dir, version)
		node_file = subsumption_folder + '/' + clazz + ".nodes.json"
		edge_file = subsumption_folder + '/' + clazz + ".edges.json"
		node_sub_file = subsumption_folder + '/' + clazz + ".nodesub.json"
		edge_sub_file = subsumption_folder + '/' + clazz + ".edgesub.json"

		#print(cft_file)

		dic_class_nodes = {}
		dic_class_nodes_arrays = {}
		methods_name_nodes = {}
		methods_noNodes = {}
		dic_class_node_sub = {}

		dic_class_edges = {}
		dic_class_edges_arrays = {}
		methods_name_edges = {}
		methods_noEdges = {}
		dic_class_edge_sub = {}

		read_class_cft_file("nodes",node_file,dic_class_nodes,dic_class_nodes_arrays,methods_name_nodes,methods_noNodes)

		read_class_cft_file("edges",edge_file,dic_class_edges,dic_class_edges_arrays,methods_name_edges,methods_noEdges)
		
		read_class_cft_sub_file("nodes",node_sub_file,dic_class_node_sub)

		read_class_cft_sub_file("edges",edge_sub_file,dic_class_edge_sub)
		#print(dic_class_edge_sub)

		no_class_nodes = 0
		for m in methods_noNodes:
			no_class_nodes = no_class_nodes + methods_noNodes[m]

		
		no_class_edges = 0
		for m in methods_noEdges:
			no_class_edges = no_class_edges + methods_noEdges[m]

		if no_class_nodes == 0:
			print("Class %s has no nodes." % clazz)
			continue
		else:
			if no_class_nodes == 0:
				print("Class %s has no edges." % clazz)
				continue
		
		dic_class_dua_node_sub['nodes'] = dic_class_nodes
		dic_class_dua_node_sub['duanodesub'] = dic_class_node_sub
		dic_class_dua_node_sub['noclassnodes'] = no_class_nodes
		dic_class_dua_edge_sub['edges'] = dic_class_edges
		dic_class_dua_edge_sub['duaedgesub'] = dic_class_edge_sub
		dic_class_dua_edge_sub['noclassedges'] = no_class_edges
		dic_all_classes_dua_node_sub[clazz] = dic_class_dua_node_sub
		dic_all_classes_dua_edge_sub[clazz] = dic_class_dua_edge_sub
	return 

if __name__ == '__main__':

	# print("Number of parameters: %s" % len(sys.argv))
	if len(sys.argv) < 6 or (sys.argv[4] != "-ochiai" and sys.argv[4] != "-fdp"):
		print("Wrong parameters:")
		print("arg[1]: data directory")
		print("arg[2]: projectid")
		print("arg[3]: faulty version (e.g., 1b)")
		print("arg[4]: -ochiai/-fdp (ochiai or fault detection probability ranking)")
		print("arg[5]: -json (optional; indicates to save the results as a json file)")
		print("arg[7]: <json file name> (optional; due if -json is arg[5]")
		sys.exit(1)

	data_dir = sys.argv[1]
	projectid = sys.argv[2]
	results_dir = os.path.join(data_dir,"results",projectid)
	subsumption_dir = os.path.join(data_dir,"subsumption-files",projectid,"reduce")
	version = sys.argv[3]
	info = sys.argv[4]

	# print("Directory of results data: %s" % results_dir)
	# print("Directory of subsumption data: %s" % subsumption_dir)

	
	jsonoption = ""

	if len(sys.argv) > 5:
		jsonoption = sys.argv[5]
		jsonfile = sys.argv[6]

	if jsonoption != "":
		# print("jsonoption: "+jsonoption)
		# print("jsonfile: "+ jsonfile)
		if jsonfile == "":
			print("No json file name. Ende of story.")
			sys.exit(1)
	# else:
	# 	print("No json option")


	result_file = info.replace('-','')+"-"+projectid+"-"+version+".csv"
	csvfile = os.path.join(results_dir,version,result_file)
	# print(csvfile)
	dicfdp = {}
	
	# Get from the csv file the dic of duas with biggest ranking

	dicfdp = findmaxfpd(csvfile,projectid,version,dicfdp)
	# print('===> Dic fdp:')
	# print(dicfdp)
	# print(dicfdp[projectid+"-"+version][2])

	# Get the max ranking: it may come from uncduas or subduas

	fdp_duas_max_uncduas = float(dicfdp[projectid+"-"+version][2])
	fdp_duas_max_subduas = float(dicfdp[projectid+"-"+version][6])
	fdp_duas_max = max(fdp_duas_max_uncduas,fdp_duas_max_subduas)

	# Get the status of the top ranked duas
	fdp_duas_status = dicfdp[projectid+"-"+version][5]

	# Get the list of top ranked duas

	list_top_uncduas = dicfdp[projectid+"-"+version][4]
	list_top_subduas = dicfdp[projectid+"-"+version][8]
	# print(list_top_subduas)
	# print(list_top_uncduas)
	list_top_duas = list_top_uncduas + list_top_subduas
	#print(list_top_duas)

	clazzlist = []

	dic_duas_info = {}

	# Get the dic of duas info (broken in class, methdod, method id, dua id) and also unfinished information
	# regarding subsumption of the dua (initially, false) and list of subsumers (initially, empty).
	# Also gets the list of classes with top ranking duas

	get_dic_dua_info(dic_duas_info,clazzlist,list_top_duas)

	# print(clazzlist)
	# print('dic_duas_info:')
	# print(dic_duas_info)

	dic_all_classes_dua_node_sub = {} # dic with dua-node subsumption info for each class 
	dic_all_classes_dua_edge_sub = {} # dic with dua-edge subsumption info for each class

	# Get the dics with dua-node subsumption info for all classes 
	create_dic_all_classes_cft_sub(subsumption_dir,version,clazzlist,dic_all_classes_dua_node_sub,dic_all_classes_dua_edge_sub)
	

	# print('dic_all_classes_dua_node_sub:')
	# print(dic_all_classes_dua_node_sub)
	# print('dic_all_classes_dua_edge_sub:')
	# print(dic_all_classes_dua_edge_sub)


	# This dic is a deep copy of dua_dua_info in which dua-edge subsumption info will be added 
	dic_top_duas_subedges = copy.deepcopy(dic_duas_info)

	edgeSubsumption = find_subsumption('edges',dic_all_classes_dua_edge_sub,dic_top_duas_subedges)


	# print('dic_duas_info:')
	# print(dic_duas_info)
	# print('dic_top_duas_subedges:')
	# print(dic_top_duas_subedges)

	dic_top_duas_subnodes = copy.deepcopy(dic_duas_info)
	nodeSubsumption = find_subsumption('nodes',dic_all_classes_dua_node_sub,dic_top_duas_subnodes)
	# print('dic_top_duas_subnodes:')
	# print(dic_top_duas_subnodes)

	dic_comparison = {}

	dic_comparison['DUAMaxFdp'] = dicfdp[projectid+'-'+version]
	dic_comparison['NodeSubsumption'] = nodeSubsumption
	dic_comparison['EdgeSubsumption'] = edgeSubsumption
	dic_comparison['NodeSubsumers'] = dic_top_duas_subnodes
	dic_comparison['EdgeSubsumers'] = dic_top_duas_subedges

	# print(staticComparison)

	if info == "-ochiai":
		info = "OCHIAI   \t"
		finfo = "ochiai"
	else:
		info = "FAULT DETECTION "
		finfo = "fdp"


	# print('===> Dic fdp: dua')
	# print(dic_top_duas_subedges)
	result_file_edge = finfo+"-"+projectid+"-edge-"+version+".json"
	# print('edgefile: '+result_file_edge)
	jsonfile_edge = os.path.join(results_dir,version,result_file_edge)
	# print(csvfile)
	dicfdp_edge = {}
	#dicfdp_edge = findmaxfpd_cft(jsonfile_edge,projectid,version,dicfdp_edge)
	# print('===> Dic fdp: edge')
	# print(dicfdp_edge)
	#print(dicfdp[projectid+"-"+version][4])
	result_file_node = finfo+"-"+projectid+"-node-"+version+".json"
	# print('nodefile: '+result_file_edge)	
	jsonfile_node = os.path.join(results_dir,version,result_file_node)
	# print(csvfile)
	dicfdp_node = {}
	#dicfdp_node = findmaxfpd_cft(jsonfile_node,projectid,version,dicfdp_node)
	# print('===> Dic fdp: node')
	# print(dicfdp_node)


	fdp_duas_max = round(fdp_duas_max,4)
	# print("DUAs x Node")

	# if dicfdp_node[projectid+"-"+version]:
	# 	fdp_nodes_max = round(dicfdp_node[projectid+"-"+version][0][0],4)
	# else:
	fdp_nodes_max = 0.0

	# maxDuaVsmaxNode = compare_dua_cft(projectid, version, fdp_duas_max,fdp_nodes_max,dic_top_duas_subnodes,dicfdp_node)
	# print(maxDuaVsmaxNode)
	
	# print("DUAs x Edges")
	# if dicfdp_edge[projectid+"-"+version]:
	# 	fdp_edges_max = round(dicfdp_edge[projectid+"-"+version][0][0],4)
	# else:
	fdp_edges_max = 0.0
	# maxDuaVsmaxEdge = compare_dua_cft(projectid, version, fdp_duas_max,fdp_edges_max, dic_top_duas_subedges,dicfdp_edge)
	# print(maxDuaVsmaxEdge)
	
	dic_comparison = {}
	dic_comparison['Version'] = projectid+"-"+version
	dic_comparison['TopDUAsStatus'] = fdp_duas_status
	dic_comparison['DUAMaxFdp'] = fdp_duas_max
	dic_comparison['NodeMaxFdp'] = fdp_nodes_max
	dic_comparison['EdgeMaxFdp'] = fdp_edges_max
	# dic_comparison['DUAvsNode'] = 'None' # maxDuaVsmaxNode[0] # >, < or ==
	# dic_comparison['DUAvsEdge'] = 'None' # maxDuaVsmaxEdge[0] # >, < or ==	
	dic_comparison['topDUANodeSubsumption'] = nodeSubsumption
	dic_comparison['topDUAEdgeSubsumption'] = edgeSubsumption
	# dic_comparison['topDUANodeSubsumers'] = dic_top_duas_subnodes
	# dic_comparison['topDUAEdgeSubsumers'] = dic_top_duas_subedges

	# if maxDuaVsmaxNode[1]:
	# 	dic_comparison['topDUAtopNodeSubsumption'] = maxDuaVsmaxNode[1]
	# 	dic_comparison['topDUAtopNodeSubsumers'] = maxDuaVsmaxNode[2]
	# else:
	# 	dic_comparison['topDUAtopNodeSubsumption'] = False
	# 	dic_comparison['topDUAtopNodeSubsumers'] = []

	# if maxDuaVsmaxEdge[1]:
	# 	dic_comparison['topDUAtopEdgeSubsumption'] = maxDuaVsmaxEdge[1]
	# 	dic_comparison['topDUAtopEdgeSubsumers'] = maxDuaVsmaxEdge[2]
	# else:
	# 	dic_comparison['topDUAtopEdgeSubsumption'] = False
	# 	dic_comparison['topDUAtopEdgeSubsumers'] = []

	#print(jsonfile)
	if jsonoption == "-json":
		with open(jsonfile, 'w') as jf:
			json.dump(dic_comparison, jf,  indent=4)		

	# print ("=========================================================")
	# print (projectid +"-" + version +" "+info+ ":Node subsumption of top  DUAs:" + str(nodeSubsumption))
	# print ("=========================================================")

	# print ("=========================================================")
	# print (projectid +"-" + version +" "+info+ ":Edge subsumption of top  DUAs:" + str(edgeSubsumption))
	# print ("=========================================================")

	print("Version;TopDUAsStatus;DUAMaxFdp;NodeMaxFdp;EdgeMaxFdp;topDUANodeSubsumption;topDUAEdgeSubsumption;")
	print (dic_comparison['Version']+";"+dic_comparison['TopDUAsStatus']+ ";" + str(dic_comparison['DUAMaxFdp'])+";"+str(dic_comparison['NodeMaxFdp'])+";"+str(dic_comparison['EdgeMaxFdp'])+";"+str(dic_comparison['topDUANodeSubsumption'])+";"+str(dic_comparison['topDUAEdgeSubsumption'])+";")
