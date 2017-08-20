###############################################
## Lib for Motors/GearMotors
###############################################
import sys
LIBPATH = '/home/marcel/Proj/lib/py/lib'
sys.path.append(LIBPATH)

import MySciLib as sci

#############################
## Gear Motor
#############################
class GearMotor():
    def __init__(self, motorType, Vdc, Istall, Ifree, rpm, torque, gr):
        self.mtype = motorType
        self.V_op = Vdc
        self.I_stall = Istall.to(sci.A)
        self.I_free = Ifree.to(sci.A)
        self.O_free = rpm.to(sci.rps)
        self.T_stall = (torque.to(sci.kg*sci.m))*sci.G_force
        self.GR = gr
        self.name = self.mtype+'_'+str(self.GR)
        self.calc()

    def calc(self):
        """ Calculates stuff based on given parameters """
        self.P_stall_elec = (self.V_op * self.I_stall).to(sci.W)
        self.P_free_elec = (self.V_op * self.I_free).to(sci.W)

    def calc_inst_torque(self, O_inst):
        """ Calculates instantaneous torque given angular velocity """
        return (self.T_stall-(self.T_stall/self.O_free)*O_inst)

    def calc_inst_omega(self, T_inst):
        """ Calculates instantaneous angular velocity given torque """
        return ((self.T_stall-T_inst)*self.O_free/self.T_stall)

    def calc_inst_current(self, O_inst):
        """Calculate instantaneous current consumption given angular velocity"""
        return (self.I_stall-(self.I_stall/self.O_free)*O_inst)

    def calc_inst_power(self, T_inst, O_inst):
        """ Calculates instantaneous power given torque and angular velocity """
        P = T_inst * O_inst
        I = P / self.V_op
        return (P, I)

    def show(self):
        print("\n====== GEAR MOTOR ======")
        msg = """Motor type: %s\nOperating voltage: %s\nStall current: %s\nFree run current: %s\nNo load speed: %s\nStall Torque: %s\nGear Ratio: %s\n\nStall Power Consumption: %s\nFree Run Power Consumption: %s"""
        print(msg % (format(self.mtype), format(self.V_op), 
                     format(self.I_stall), format(self.I_free),
                     format(self.O_free), format(self.T_stall), 
                     format(self.GR),
                     format(self.P_stall_elec), format(self.P_free_elec)))
        print("========================")

    def plot(self, hier):
        ofree = self.O_free.magnitude
        tstall = self.T_stall.magnitude 
        x = sci.np.around(sci.np.arange(0, ofree, ofree/20), 3)
        yi_e = self.calc_inst_current(x*sci.rps)
        yt = self.calc_inst_torque(x*sci.rps)
        yp, yi = self.calc_inst_power(yt, x*sci.rps)
        eff = 100*yi/yi_e

        fig = sci.plt.figure(figsize=(32, 16), dpi=75)
        fig.suptitle(self.name, fontsize=18)

        ax = fig.add_subplot(211)
        sci.plt.plot(x, yt.magnitude, 'go-', label='Torque')
        sci.plt.title('Torque/Current vs. Speed')
        sci.plt.xlabel('Angular velocity (rad/sec)')
        sci.plt.ylabel('Torque (N*m)')
        sci.plt.minorticks_on()
        sci.plt.grid(b=True, which='major', color='b', linestyle='-')
        sci.plt.grid(b=True, which='minor', color='r', linestyle='-.')
        sci.plt.legend(loc='right')
        ax2 = ax.twinx()
        ax2.plot(x, yi_e.magnitude, 'c^-', label='I_elec')
        ax2.plot(x, yi.magnitude, 'ms-', label='I_mech')
        ax2.grid(b=True, which='major', color='#d2691e', linestyle='-')
        ax2.set_ylabel('Current (A)')
        if (x.size < 10):
            sci.annotate_datapts(ax, zip(x, sci.np.around(yt.magnitude, 3)))
            sci.annotate_datapts(ax2, zip(x, sci.np.around(yi_e.magnitude, 3)))
            sci.annotate_datapts(ax2, zip(x, sci.np.around(yi.magnitude, 3)))
        sci.plt.legend(loc='best')

        ax = fig.add_subplot(212)
        sci.plt.plot(yt, yp.magnitude, 'go-', label='P_mech')
        sci.plt.title('Mechanical Power Output vs. Torque')
        sci.plt.xlabel('Torque (N*m)')
        sci.plt.ylabel('Power (Watt)')
        sci.plt.minorticks_on()
        sci.plt.grid(b=True, which='major', color='b', linestyle='-')
        sci.plt.grid(b=True, which='minor', color='r', linestyle='-.')
        sci.plt.legend(loc='right')
        ax2 = ax.twinx()
        ax2.plot(yt, eff, 'c^-', label='Eff')
        ax2.grid(b=True, which='major', color='#d2691e', linestyle='-')
        ax2.set_ylabel('Efficiency (%)')
        if (yt.size < 10):
            sci.annotate_datapts(ax, zip(sci.np.around(yt.magnitude, 3), sci.np.around(yp.magnitude, 3)))
            sci.annotate_datapts(ax2, zip(sci.np.around(yt.magnitude, 3), sci.np.around(eff.magnitude, 3)))
        sci.plt.legend(loc='best')

        ## Final setup
        #fig.tight_layout()
        sci.plt.savefig(hier+self.name+".png")
        sci.plt.close()
