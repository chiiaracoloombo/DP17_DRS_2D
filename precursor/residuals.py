import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.gridspec import GridSpec
mpl.rcParams.update(mpl.rcParamsDefault)
import pandas as pd

bluePoli = (0.36, 0.54, 0.60)

# Step 1: Load the data from the .dat file
filename = './postProcessing/residuals/0/solverInfo.dat'  # replace with the actual path to your .dat file
data = pd.read_csv(filename, comment='#', skiprows=2, sep=r'\s+')


# Step 2: Extract columns
time = data.iloc[:, 0]
p = data.iloc[:, 11]
Ux = data.iloc[:, 3]
Uy = data.iloc[:, 6]
k = data.iloc[:, 16]
omega = data.iloc[:, 21]



plt.semilogy(time, p, label=r'p', linewidth=1.3)
plt.semilogy(time, Ux, label=r'Ux', linewidth=1.3)
plt.semilogy(time, Uy, label=r'Uy', linewidth=1.3)
plt.semilogy(time, k, label=r'k', linewidth=1.3)
plt.semilogy(time, omega, label=r'$\omega$', linewidth=1.3)
plt.xlabel(r'Iteration')
plt.ylabel(r'Residuals')
plt.grid(True)
plt.legend(loc='upper right')
plt.show()

#plt.title('Residuals Convergence over Time', fontsize=14)
# ax1.set_legend(loc='center left', bbox_to_anchor=(1, 0.5))