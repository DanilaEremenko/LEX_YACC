import sys

if (sys.argv.__len__() != 3):
    raise Exception("Illegal number of arguments")

in_file = open(sys.argv[1], 'r')
out_file = open(sys.argv[2], 'w')

lines = in_file.readlines()

line_num = 0
i = 0

while i < lines.__len__():
    line = lines[i]
    if (line[:2] != "/*" and line[:2] != '\n'):
        out_file.write(("%.3o" % line_num) + ":" + line)
        line_num += 1
    else:
        while (not line.__contains__("*/") and line[:2] != '\n'):
            out_file.write(line)
            i += 1
            line = lines[i]
        out_file.write(line)
    i += 1

in_file.close()
out_file.close()
