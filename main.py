import matplotlib.pyplot as plt
import math
import numpy as np
import os
T = 0.0000158
k = 1
import decimal
decimal.getcontext().prec = 10
names = os.listdir('energy_c')
# # E_list, E_values, Q_p, F = [], [] ,[], []

# # for j in range(20,151):
# # 	for i in names:
# # 		j_energy = energy_v[j]

# # 		E_list.append(Q)

# # 	# E_sum = int(sum(q_list))
# # 	# E_values.append(E_sum)
# # 	j += 1


# # j_energy_arr, j_q_value_arr, Q_values = [],[],[]
# # for j in range(20,151):
# # 	for i in names:
# # 		a, b , energy_v = np.loadtxt(i, unpack= True)
# # 		j_energy = energy_v[j]
# # 		Q = (math.exp((-1/(k*T)) * j_energy))
# # 		j_q_value_arr.append(Q)
# # 	Q_sum = int(sum(j_q_value_arr))
# # 	Q_values.append(Q_sum)

# q_sum, temp_array = [], []
# for j in range(0,100):
# 	for i in names:
# 		a, b , energy_v = np.loadtxt(i, unpack= True)
# 		j_energy = ((energy_v[j]))
# 		q = decimal.Decimal(np.exp(decimal.Decimal((-1/(k*T)) * j_energy)))
# 	#	print (q)
# 		temp_array.append(q)
# 	a = sum(temp_array)
# 		#temp_q_array = (math.exp((-1/(k*T)) * j_energy))
# 	q_sum.append(a)

R_c = []
for i in range(20,150):
	R_c.append(i/10.0)
print (R_c)


# print ( q_sum)
# for i in zip(R_c, q_sum):
# 	print (i, i)
# print (len(q_sum))
# F = []
# for i in q_sum:
# 	i = int(i)
# 	a = - k * T * math.log(i)
# 	F.append(a)
# # print (Q_p)
# # print (len(Q_p))


jtemp = []
qtemp = []
qf = []
for j in range(20,150):
	for i in names:
		a, b , energy_v = np.loadtxt(i, unpack= True)
		j_energy = energy_v[j]
		q = (np.exp(decimal.Decimal((-1/(k*T)) * j_energy)))
		qtemp.append(q)
	qprime = sum(qtemp)
	qf.append(qprime)
	j += 1

F = []
for i in qf:
	a = i.ln()
	F.append(a)
print (F)
plt.axis()
plt.plot(R_c,F)
plt.show()
