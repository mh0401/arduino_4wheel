###############################################
## Symmetric 4-wheel system
## Plot torque applied on each wheel
###############################################
import sys, argparse
LIBPATH = '/home/marcel/Proj/lib/py/lib'
sys.path.append(LIBPATH)

import MySciLib as sci
import Motor

#############################
## MAIN - PARAMS
#############################
help_str = """ Generate plots of mechanical/electrical characteristics for different motors vs. load """

rad_wheel = 21*sci.mm

gearHP = [
    ## HP
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,6000*sci.rpm,2*sci.oz_in,5),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,3000*sci.rpm,4*sci.oz_in,10),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,1000*sci.rpm,9*sci.oz_in,30),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,625*sci.rpm,15*sci.oz_in,50),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,400*sci.rpm,22*sci.oz_in,75),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,320*sci.rpm,30*sci.oz_in,100),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,200*sci.rpm,40*sci.oz_in,150),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,140*sci.rpm,50*sci.oz_in,210),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,120*sci.rpm,60*sci.oz_in,250),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,100*sci.rpm,70*sci.oz_in,298),
    ("Brushed_DC_HP",6*sci.V,1.6*sci.A,120*sci.mA,32*sci.rpm,125*sci.oz_in,1000)
]
gearMP = [
    ## MP
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,2200*sci.rpm,3*sci.oz_in,10),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,730*sci.rpm,8*sci.oz_in,30),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,420*sci.rpm,13*sci.oz_in,50),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,290*sci.rpm,17*sci.oz_in,75),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,220*sci.rpm,19*sci.oz_in,100),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,150*sci.rpm,24*sci.oz_in,150),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,75*sci.rpm,46*sci.oz_in,298),
    ("Brushed_DC_MP",6*sci.V,0.7*sci.A,40*sci.mA,25*sci.rpm,80*sci.oz_in,1000)
]
gearLP = [
    ## LP
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,50*sci.mA,2500*sci.rpm,1*sci.oz_in,5),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,1300*sci.rpm,2*sci.oz_in,10),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,440*sci.rpm,4*sci.oz_in,30),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,250*sci.rpm,7*sci.oz_in,50),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,170*sci.rpm,9*sci.oz_in,75),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,120*sci.rpm,12*sci.oz_in,100),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,85*sci.rpm,17*sci.oz_in,150),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,60*sci.rpm,27*sci.oz_in,210),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,50*sci.rpm,32*sci.oz_in,250),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,45*sci.rpm,40*sci.oz_in,298),
    ("Brushed_DC_LP",6*sci.V,0.36*sci.A,40*sci.mA,14*sci.rpm,70*sci.oz_in,1000)
]

## gear_type, speed_max, current_max
gearmotors = [(gearHP, 6, 1), (gearMP, 4, 0.8), (gearLP, 1.5, 0.5)]

#############################
## MAIN - FUNCTIONS
#############################
def get_torque_on_wheel(m_body, r_wheel):
    """Get torque applied on each motor for a 4-wheel system.
    Torque applied due to body weight of the robot.
    Assume highest friction coefficient with wheel as rubber. 
    Assume 4-wheel system is symmetric so weight distributed evenly."""
    friction_coeff = 1.16
    m_body = m_body.to(sci.kg)
    r_wheel = r_wheel.to(sci.m)
    torque = friction_coeff * m_body/4 * sci.G_force * r_wheel
    return torque

def setup_plot_speed_vs_load(ymin, ymax):
    """Setup plot parameters for speed vs. load"""
    ##sci.plt.gcf()
    sci.plt.title('Speed vs. Load')
    sci.plt.axis([0.5, 3, ymin, ymax])
    sci.plt.xlabel('Load mass (lb)')
    sci.plt.ylabel('Linear speed (mph)')
    sci.plt.minorticks_on()
    sci.plt.grid(b=True, which='major', color='g', linestyle='-')
    sci.plt.grid(b=True, which='minor', color='r', linestyle='-.')

def setup_plot_current_vs_speed(ymin, ymax):
    """Setup plot parameters for current vs. speed"""
    ##sci.plt.gcf()
    sci.plt.title('Current consumption vs. Speed')
    sci.plt.axis([0, 4, ymin, ymax])
    sci.plt.xlabel('Linear speed (mph)')
    sci.plt.ylabel('Current consumption (A)')
    sci.plt.minorticks_on()
    sci.plt.grid(b=True, which='major', color='g', linestyle='-')
    sci.plt.grid(b=True, which='minor', color='r', linestyle='-.')

def acquire_opt_argparse():
    """Function to acquire/parse option arguments from command line"""
    parser = argparse.ArgumentParser(description=help_str, prefix_chars='-+')
    parser.add_argument('-t', help='Plot torque vs load', action='store_true', required=False)
    parser.add_argument('-m', help='Plot each motor', action='store_true', required=False)
    parser.add_argument('-s', help='Plot summary', action='store_true', required=False)
    parser.add_argument('-lb', help='Load weight in lb', type=float, metavar='LOAD_WEIGHT', required=True)
    opts = parser.parse_args()
    for x in vars(opts):
        print("Acquired option: %s, value: %s" % (x, vars(opts)[x]))
    return opts

#############################
## MAIN
#############################
usrin = acquire_opt_argparse()

## Torque on wheel vs. body mass
m_load = sci.np.arange(usrin.lb*0.5, usrin.lb*2.5, usrin.lb*0.1)*sci.lb
torque = sci.np.around(get_torque_on_wheel(m_load, rad_wheel), 3)

## Plot torque vs. load
if (usrin.t):
    print ("Plotting torque/load...")
    sci.plt.figure(1)
    sci.plt.subplot(111)
    sci.plt.plot(m_load, torque, 'g-')
    sci.plt.title('Torque vs. Load')
    sci.plt.xlabel('load weight (lb)')
    sci.plt.ylabel('Torque (N*m)')
    sci.plt.minorticks_on()
    sci.plt.grid(b=True, which='major', color='b', linestyle='-')
    sci.plt.axes().yaxis.grid(b=True, which='minor', color='r', linestyle='-.')
    sci.annotate_datapts(sci.plt.subplot(111), zip(m_load.magnitude, torque.magnitude))
    sci.plt.savefig("../plot/torque_vs_load.png")
    sci.plt.close()
else:
    print ("Not plotting torque/load...")

## Plot torque vs. speed w/ various gear motors
for gm in gearmotors:
    if (usrin.s is False and usrin.m is False): 
        print ("Not plotting summary and motor. Exiting...")
        break
    if (usrin.s):
        print ("Creating summary for " + gm[0][0][0])
        sci.plt.figure(2, figsize=(32,16), dpi=75)
    for p in gm[0]:
        gp = Motor.GearMotor(p[0], p[1], p[2], p[3], p[4], p[5], p[6])
        v_angl = gp.calc_inst_omega(torque)
        v_linr = (v_angl*rad_wheel).to(sci.mph)
        I_elec = gp.calc_inst_current(v_angl)
        if (usrin.s):
            sci.plt.figure(2)
            sci.plt.subplot(211)
            sci.plt.plot(m_load.magnitude, v_linr.magnitude, 'o-', label=gp.name)
            sci.plt.subplot(212)
            sci.plt.plot(v_linr.magnitude, I_elec.magnitude, 'o-', label=gp.name)
        if (usrin.m):
            print ("Plotting motor characteristics for " + gp.name)
            gp.plot('../plot/')
    if (usrin.s):
        sci.plt.figure(2)
        sci.plt.subplot(211)
        setup_plot_speed_vs_load(0, gm[1])
        sci.plt.tight_layout()
        sci.plt.legend(loc='best')
        sci.plt.subplot(212)
        setup_plot_current_vs_speed(0, gm[2])
        sci.plt.tight_layout()
        sci.plt.legend(loc='best')
        print ("Plotting summary for " + gm[0][0][0])
        sci.plt.savefig("../plot/speed_vs_load_"+gm[0][0][0]+".png")
        ##sci.plt.show()
        sci.plt.close()
