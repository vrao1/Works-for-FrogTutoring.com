import sys
import csv
if len(sys.argv) != 2:
	print("Python %s <us_postal_codes.csv>" % (sys.argv[0]))
	exit()

city = dict()
city_r = dict()
state = dict()
state_r = dict()
zip_city = dict()
zip_state = dict()

city_id=1
state_id=1
flag = False

with open(sys.argv[1]) as f:
	for line in f:
		if flag == True:
			a = line.split(",")
		
			'''
			a[0] is zipcode
			a[1] is city
			a[3] is state
			'''
		
			if a[1] not in city_r.keys():
				city_r[a[1]] = city_id
				city[city_id] = a[1]
				city_id=city_id+1
			else:
				zip_city[a[0]] = city_r[a[1]]
	
			if a[3] not in state_r.keys():
				state_r[a[3]] = state_id
				state[state_id] = a[3]
				state_id=state_id+1
			else:
				zip_state[a[0]] = state_r[a[3]]
		else:
			flag = True

zc = open("zip_city.csv" , "w")

for key, value in zip_city.items():
	zc.write("\"" + str(key) + "\"," + str(value) + "\n")

zc.close()

zs = open("zip_state.csv" , "w")
for key,value in zip_state.items():
	zs.write("\"" + str(key) + "\"," + str(value) + "\n")
zs.close()

c = open("city.csv", "w")
for key,value in city.items():
	c.write(str(key) + ",\"" + str(value) + "\"\n")
c.close()

s = open("state.csv", "w")
for key,value in state.items():
	s.write(str(key) + ",\"" + str(value) + "\"\n")
s.close()
