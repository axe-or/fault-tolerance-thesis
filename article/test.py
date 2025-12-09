

#---------------------|Tt    Tl  Mt    Mx
no_injection = {
	"N/A":            (1542, 12, 2768, 374),
	"CRC32":          (1549, 12, 2768, 856),
	"Reexec":         (4631, 38, 2768, 1074),
	"Reexec + CRC32": (4635, 38, 2768, 1556),
	"TMR":            (4644, 38, 8336, 1126),
	"TMR + CRC32":    (4651, 38, 8336, 1608),
}

#---------------------|Tt    Tl  Mt    Mx
fixed_injection = {
	"N/A":            (1544, 12, 2768, 374),
	"CRC32":          (1565, 12, 2768, 856),
	"Reexec":         (4634, 38, 2768, 1074),
	"Reexec + CRC32": (4676, 38, 2768, 1556),
	"TMR":            (4647, 38, 8336, 1126),
	"TMR + CRC32":    (4654, 38, 8336, 1608),
}

#---------------------|Tt    Tl  Mt    Mx
stack_injection = {
	"N/A":            (1100, 60, 2768, 374),
	"CRC32":          (-1100, 60, 2768, 856),
	"Reexec":         (-100, 0, 2768, 1074),
	"Reexec + CRC32": (2265, 38, 2768, 1556),
	"TMR":            (4625, 38, 8336, 1126),
	"TMR + CRC32":    (4628, 38, 8336, 1608),
}

def div(a, b):
	res = []
	for (x, y) in zip(a, b):
		res.append(round(x / y, 3))
	return tuple(res)

def analyze(tbl):
	baseline = tbl["N/A"]
	for key, value in tbl.items():
		tex =f'{key} & ' + ' & '.join(map(lambda x: str(x), div(value, baseline))) + ' &'
		print(tex)

print('--- NO INJECTION')
analyze(no_injection)

print('--- FIXED')
analyze(fixed_injection)

print('--- STACK')
analyze(stack_injection)
