import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def der_tanh(x):
    return (1 - np.tanh(x)**2)

d = {'x1': [0.,0.,1.,1.],
	'x2': [0.,1.,0.,1.], 
	'd': [0.,1.,1.,0.]}
data = pd.DataFrame(data=d)
#a = pd.DataFrame(np.ones(data.shape[0]))
#print data
#print a

#data = pd.concat([a,data],axis=1)

n_neurons = [data.shape[1]-1,2,1]
nLayers = len(n_neurons) 

w = []
for i in range(1,nLayers):
    w.append(np.random.rand((n_neurons[i-1]+1)*n_neurons[i],1))
eta = .01
print w
errors = []
nerro = 1
tolerance = .01
while (nerro > tolerance):
    nerro = 0
    for j in xrange(0,data.shape[0]):
        datum = []
        print j
        print datum
        dado = np.matrix(data.loc[[j],data.columns != 'd'])
        a = np.append(dado,np.matrix([1]),axis=1)
        datum.append(a)
        nets = []
        for layer in xrange(0,nLayers-1):
            neuron_list = []
            netlist=[]
            for neuron in xrange(0,n_neurons[layer+1]):
                net = np.dot(datum[layer],w[layer][(neuron*3):(neuron*3+3)]).item(0)
                netlist.append(net)
                neuron_list.append(np.tanh(net))
                print neuron_list
            nets.append(np.array(netlist))
            datum.append(np.append(np.matrix(pd.DataFrame(neuron_list).transpose()),np.matrix([1]),axis=1))

        resp = datum[nLayers-1].item(0)#1*(np.dot(data.loc[[j]].drop('d',axis=1),w) > 0)
        erro = (data.loc[[j],'d'] - resp).loc[j]
        nerro += (erro)**2
        print erro

        delta = []
        for layer in xrange(nLayers-1,0,-1):
            netlist = []
            for neuron in xrange(0,n_neurons[layer]):
                w[layer-1] = eta*der_tanh()*nets[nLayers]                

    errors.append(nerro)

print w
x = data.loc[:,'x1']
y = data.loc[:,'x2']

plt.plot(x,y,'o')
plt.plot([-1,-(w[0][0]-w[2][0])/w[1][0]],[-(w[0][0]-w[1][0])/w[2][0],-1],'k-')
axes = plt.gca()
axes.set_xlim([-.5,1.5])
axes.set_ylim([-.5,1.5])
plt.show()
