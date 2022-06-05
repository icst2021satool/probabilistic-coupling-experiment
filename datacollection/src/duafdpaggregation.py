#!/usr/bin/env python3
# 

import csv
import sys
import os

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
            csvvf = csv.DictReader(file, delimiter=';')
            for line in csvvf:
                fdp = float(line['FAULT DETECTION '])

                if fdpfirst:
                    fdplast = fdp
                    fdpfirst = False
                
                if fdp != fdplast:
                    break
                
                if line['Uncon'] == 'True':
                    uncfdpmax = fdp
                    nouncfdpmax = nouncfdpmax + 1
                    if line['Status'] == 'clear':
                        uncstatus = line['Status']
                else:
                    subfdpmax = fdp
                    nosubfdpmax = nosubfdpmax + 1                     
    
        data.append(proj)
        data.append(ver)
        data.append(uncfdpmax)
        data.append(nouncfdpmax)
        data.append(uncstatus)
        data.append(subfdpmax)
        data.append(nosubfdpmax)

        label = proj+"-"+ver
        dicfdp[label] = data
    else:
        print("File " +cvsversionfile+ " does not exist!")

    return dicfdp

    
if __name__ == '__main__':

    if(len(sys.argv) != 6):
        print("Wrong parameters:")
        print("arg[1]: project name.")
        print("arg[2]: start version (only number)")
        print("arg[3]: final version (only number)")
        print("arg[4]: directory with the ranking")
        print("arg[5]: <csv file name>")
        sys.exit(1)

    project = sys.argv[1]
    start = int(sys.argv[2])
    end = int(sys.argv[3])
    dir = sys.argv[4]
    outcvsfile = sys.argv[5]

    ver = start

    dicfdp = {}
    while ver <= end:
        version = str(ver)+"b"
        file = "fdp-"+project+"-"+version+".csv"
        csvfile = os.path.join(dir, project,version,file)
        #print(csvfile)
        dicfdp = findmaxfpd(csvfile,project,version,dicfdp)
        ver = ver + 1

    labels = ['Program','Version', 'UncFdpMax', 'NoUncFdpMax','Status','SubFdpMax','NoSubFdpMax']
    float_formatter = "{:.6f}".format

    dicfdp = dict(sorted(dicfdp.items(), key = lambda kv: kv[1], reverse = False))

    with open(outcvsfile,"w") as f:
        f.write ("Program;Version;UncFdpMax;NoUncFdpMax;Status;SubFdpMax;NoSubFdpMax;LessFdpUnc;MoreFdpUnc\n")
        #print("Begin")
        for v in dicfdp:
            lessfdpunc = False
            morefdpunc = False
            if dicfdp[v][2] < dicfdp[v][5]:
                lessfdpunc = True
            else:
                if dicfdp[v][2] > dicfdp[v][5]:
                    morefdpunc = True 

            f.write(dicfdp[v][0]+";"+ dicfdp[v][1]+ ";" + float_formatter(dicfdp[v][2])+";"+str(dicfdp[v][3])+";"+dicfdp[v][4]+ ";"+ float_formatter(dicfdp[v][5])+";"+ str(dicfdp[v][6])+";"+str(lessfdpunc)+";"+str(morefdpunc)+";\n")
    f.close()

