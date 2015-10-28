#!/usr/env python

import sys


allthepatches = open("goods.txt")
patchlist = []

patchlist = allthepatches.read().split(';\n')

compareit = sys.argv[1].strip()

for item in range(len(patchlist)):
	if patchlist[item] == compareit:
		print item
		break


