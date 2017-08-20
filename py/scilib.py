###############################################
## Lib for Anything science related
###############################################
import numpy as np
import scipy.constants as sc
import matplotlib.pyplot as plt
import pint

#############################
## Universal units
#############################
ureg = pint.UnitRegistry()
V = ureg.volt
A = ureg.ampere
lb = ureg.lb
mA = 0.001*ureg.ampere
W = ureg.watt
J = ureg.joule
P = ureg.pascal
m = ureg.meter
mm = 0.001*ureg.meter
kg = ureg.kilogram
rps = ureg.rps
rpm = ureg.rpm
mph = ureg.mile/ureg.hour
mps = ureg.meter/ureg.second
mps2 = ureg.meter/(ureg.second**2)
Nm = ureg.newton*ureg.meter
oz_in = ureg.oz*ureg.inch
G_force = sc.g*mps2

#############################
## Add annotations
#############################
def annotate_datapts(ax, plot_arr):
    for xy in plot_arr:
        ax.annotate("(%s, %s)" % xy[0:4], xy=xy, textcoords='offset points')
