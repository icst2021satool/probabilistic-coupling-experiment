#!/usr/bin/env python3

import numpy as np
import os
import sys
import xml.etree.ElementTree as ET

def line_to_array(line):
	line = line[:-2].split()
	a = np.array(list(map(lambda x: int(x), line)))
	return a

if __name__ == '__main__':
	project_id = sys.argv[1]
	project_ver = sys.argv[2]
	project_dir = sys.argv[3]
	print("Analyzing %s" % project_dir)

	matrix_folder = os.path.join(project_dir, ".jaguar", "matrix")

	tree = ET.parse(os.path.join(project_dir, "badua_report.xml"))
	badua_root = tree.getroot()

	total_duas = 0
	covered_duas = 0

	total_badua_duas = 0
	total_badua_duas_covered = 0 

	for child in badua_root:
		if child.tag == "class":
			counters = child.findall("counter[@type='DU']")
			badua_covered = int(counters[0].attrib["covered"])
			badua_missed = int(counters[0].attrib["missed"])
			clazz = child.attrib["name"].replace("/", ".")
			total_badua_duas += (badua_covered + badua_missed)
			total_badua_duas_covered += badua_covered
			total = None

			matrix_file = clazz + ".matrix"
			with open(os.path.join(matrix_folder, matrix_file), "r") as f:
				for line in f:
					if line.startswith("=0"): continue

					a = line_to_array(line)
					if total is None:
						total = a
					else:
						total |= a

			if total is None: 
				pass
			else:
				jaguar_covered = np.count_nonzero(total)
				jaguar_missed = total.size - jaguar_covered

				total_duas += total.size
				covered_duas += jaguar_covered

				if badua_covered != jaguar_covered:
					print(clazz)
					print("- BA-DUA covered: %s, Jaguar covered: %s" % (badua_covered, jaguar_covered))

	print("DUA coverage for project %s" % project_id)
	print("Total of DUAs (calculated by BA-DUA): %s" % total_badua_duas)
	print("Covered DUAs by Jaguar: %s, coverage perc: %s" % (covered_duas,np.round(100*covered_duas/total_badua_duas,2)))
	print("%s:%s:Jaguar coverage perc: %s" % (project_id, project_ver, np.round(100*covered_duas/total_badua_duas,2)))
