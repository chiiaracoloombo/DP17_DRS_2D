import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from matplotlib.gridspec import GridSpec
mpl.rcParams.update(mpl.rcParamsDefault)
import pandas as pd

bluePoli = (0.36, 0.54, 0.60)

# Step 1: Load the data from the .dat file
filename = './postProcessing/F2_forceCoeffs/0/coefficient.dat'  # replace with the actual path to your .dat file
data = pd.read_csv(filename, comment='#', skiprows=13, sep=r'\s+')


# Step 2: Extract columns
time = data.iloc[:, 0]
Cd = data.iloc[:, 1]
Cl = data.iloc[:, 4]
Cm = data.iloc[:, 7]



plt.plot(time, Cd, label=r'Cd', linewidth=1.3)
plt.plot(time, Cl, label=r'Cl', linewidth=1.3)
plt.plot(time, Cm, label=r'Cm', linewidth=1.3)
plt.xlabel(r'Iteration')
plt.ylabel(r'Residuals')
plt.grid(True)
plt.legend(loc='upper right')
plt.show()

#plt.title('Residuals Convergence over Time', fontsize=14)
# ax1.set_legend(loc='center left', bbox_to_anchor=(1, 0.5))