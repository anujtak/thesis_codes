import pandas as pd
from os import listdir
from os.path import isfile, join
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure


#path to files
mypath = "./data"


#get names of all the files
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]


beta = 1052.577288
K = 1
T = 300 * 3.1668 * (10**(-6))


#check count of data points in each file
for file in onlyfiles:
	df = pd.read_table(("./data/" + file), sep="\s+", header = None, names = ['a', 'b', 'c'])
	print(len(df))


#exponential of beta_eng_n
def calculate_expo_beta_eng_n(beta, eng_n):
	return np.exp(beta*eng_n)


def read_data(onlyfiles):
	a = {}
	b =[]
	for file in onlyfiles:
		a[(file.split('.')[0].split('_')[1])] = list(pd.Series(pd.read_table(("./data/" + file), sep="\s+", header = None, names = ['a', 'b', 'c'])["c"]))
		b.append(file.split('.')[0].split('_')[1])
	return a, b


#calculate Q
def calculate_q(onlyfiles, beta):
	data, eng_levels = read_data(onlyfiles)
	for eng_level in eng_levels:
		data[eng_level] = np.exp(-np.array(data[eng_level])*beta)
	q_value = sum(data.values())
	return q_value


def calculate_q_first_derivative(onlyfiles, beta):
	data, eng_levels = read_data(onlyfiles)
	for eng_level in eng_levels:
		data[eng_level] = -np.array(data[eng_level])*(np.exp(-np.array(data[eng_level])*beta))
	q_first_derivative = sum(data.values())
	return q_first_derivative


def calculate_q_second_derivative(onlyfiles, beta):
	data, eng_levels = read_data(onlyfiles)
	for eng_level in eng_levels:
		data[eng_level] = np.power(np.array(data[eng_level]), 2)*(np.exp(-np.array(data[eng_level])*beta))
	q_second_derivative = sum(data.values())
	return q_second_derivative


def calculate_f(K, T, q_value):
	F = -K*T*np.log(q_value)
	return F


def calculate_u(q_value, q_first_derivative):
	U = q_first_derivative/q_value
	return U


def calculate_s(K, beta, q_value, Q_second_derivative):
	S = (K*np.log(q_value)) + (K*beta*(q_first_derivative/q_value))
	return S


def calculate_c(K, beta, q_value, q_first_derivative, q_second_derivative):
	C = K*beta*beta*((q_second_derivative/q_value) - (np.power((q_first_derivative/q_value), 2)))
	return C


q_value = calculate_q(onlyfiles, beta)
pd.DataFrame(q_value).to_csv("q_values.csv")

q_first_derivative = calculate_q_first_derivative(onlyfiles, beta)
pd.DataFrame(q_first_derivative).to_csv("q_first_derivative.csv")

q_second_derivative = calculate_q_second_derivative(onlyfiles, beta)
pd.DataFrame(q_second_derivative).to_csv("q_second_derivative.csv")



F = calculate_f(K, T, q_value)
pd.DataFrame(F).to_csv("F_values.csv")

U = calculate_u(q_value, q_first_derivative)
pd.DataFrame(U).to_csv("U_values.csv")

S = calculate_s(K, beta, q_value, q_second_derivative)
pd.DataFrame(S).to_csv("S_values.csv")

C = calculate_c(K, beta, q_value, q_first_derivative, q_second_derivative)
pd.DataFrame(C).to_csv("C_values.csv")




x = np.arange(0.1,19.1,0.1)
x_tick = np.arange(0.1,20,0.5)


figure(num=None, figsize=(24, 15), dpi=120, facecolor='w', edgecolor='k')


plt.plot(x, F)
plt.xticks(x_tick)
plt.title('F vs radius')
plt.xlabel('radius')
plt.ylabel('F')
plt.grid()
plt.savefig('F.png')
plt.clf()
#plt.show()


plt.plot(x, U)
plt.xticks(x_tick)
plt.title('U vs radius')
plt.xlabel('radius')
plt.ylabel('U')
plt.grid()
plt.savefig('U.png')
plt.clf()
#plt.show()


plt.plot(x, S)
plt.xticks(x_tick)
plt.title('S vs radius')
plt.xlabel('radius')
plt.ylabel('S')
plt.grid()
plt.savefig('S.png')
plt.clf()
#plt.show()


plt.plot(x, C)
plt.xticks(x_tick)
plt.title('C vs radius')
plt.xlabel('radius')
plt.ylabel('C')
plt.grid()
plt.savefig('C.png')
plt.clf()
#plt.show()
