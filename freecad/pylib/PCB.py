## Only works with python 2.7
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## PARAMS
########################################
DOC = "PCB"
SPACING = (125, 0, 0)

########################################
## PCB
## Name: (dimension, holes..., 
##        components and their location (mm)...)
########################################
BOARDS = {
    "Intel_Galileo_Gen2": (
        [72, 123.8, 2.0/32*25.4, 0, "mm"], 
        ("6_32_0p25", 4, 4, 0), 
        ("6_32_0p25", 4, 123.8-4, 0),
        ("6_32_0p25", 72-4, 4, 0),
        ("6_32_0p25", 72-4, 123.8-4, 0),
        ("Capacitor2", 66, 17, 0),
        ("Ethernet", 0, (1.0+1.0/20)*10.0, 0),
        ("mPCIe_x1", 72-(0.2*25.4), 50, (-9.0/32)*25.4),
        ("Wire_set1", 61, 81.5, 0), 
        ("Wire_set2", 11, (7.0+7.0/20)*10, 0),
        ("mUSB_2p0", 0, (3.0+18.0/20)*10.0, 0),
        ("USB_2p0", 0, (5.0+11.0/20)*10.0, 0),
        ("uSDCard", (3.0+17.0/20)*10.0, 5, 0),
        ("PowerJack", (2.0+9.0/20)*10.0, 0, 0)
    ),
    "DFRobot_DC_DC_25W": (
        [45, 50, 1.5, 0, "mm"], 
        ("4_40_0p25", 4, 4, 0),
        ("4_40_0p25", 4, 50-4, 0),
        ("4_40_0p25", 45-4, 4, 0),
        ("4_40_0p25", 45-4, 50-4, 0),
        ("Capacitor1", 5, 15, 0),
        ("Capacitor1", 10, 35, 0)
    ),
    "Arduino_Motor_v3": (
        [2.125, 2.75, 1.5/25.4, 0, "inch"], 
        ("6_32_0p25", 3, 15, 0),
        ("6_32_0p25", 2.125*25.4-3, 15, 0),
        ("6_32_0p25", 25.4*22.0/32, 2.75*25.4-3, 0),
        ("6_32_0p25", 25.4*1.75, 2.75*25.4-3, 0),
        ("Wire_set1", 50+25.4/32, 25.4, 0),
        ("Wire_set2", 25.4/32, 25.4*23/32, 0)
    )
}

########################################
## COMPONENTS
## Name: (shape, dimension)
########################################
COMPONENTS = {
    "Ethernet"  : ("box", (21, 15.5, 14, 0, "mm")),
    "Capacitor1": ("cyl", (360, 6.0/32, 0.625, 0, "inch")),
    "Capacitor2": ("cyl", (360, 6.0/32, 12.5/32, 0, "inch")),
    "Wire_set1" : ("box", (2.0/32, 25.0/16, 10.0/32, 0, "inch")),
    "Wire_set2" : ("box", (2.0/32, 1.85, 10.0/32, 0, "inch")),
    "mPCIe_x1"  : ("box", (0.2, 19.5/16, 9.0/32, 0, "inch")),
    "mUSB_2p0"  : ("box", (3.0/16, 10.0/32, 4.5/32, 0, "inch")),
    "USB_2p0"   : ("box", (14, 14, 7, 0, "mm")),
    "uSDCard"   : ("box", (15.0/32, 7.0/16, 2.0/32, 0, "inch")),
    "PowerJack" : ("box", (11.0/32, 12.0/32, 12.0/32, 0, "inch"))
}


########################################
## MAIN
########################################
dx = 0
for name, dim in BOARDS.iteritems():
    ## Create PCB itself
    pcb = Shape.box(DOC, name, dim[0])
    pcb.show()
    pcb.create()
    pcb.color(0.0, 0.0, 0.7)
    pcb.loc(dx, 0, 0)

    ## Create components and attach to PCB
    for i in range(1, len(dim)):
        cname = dim[i][0]
        oname = name+cname if (i-1 == 0) else name+cname+"_00" + str(i-1)
        if (cname in COMPONENTS):
            if (COMPONENTS[cname][0] == "box"):
                comp = Shape.box(DOC, oname, COMPONENTS[cname][1])
            else:
                comp = Shape.cylinder(DOC, oname, COMPONENTS[cname][1])
            comp.show()
            comp.create()
            comp.loc(dx+dim[i][1], dim[i][2], dim[i][3])
            Shape.fuser("Fuse_"+oname, pcb.objA, comp.objA)
            pcb.objA = FreeCAD.activeDocument().getObject("Fuse_"+oname)
        else:
            d = (360, Shape.SCREWS[cname][2]*25.4, pcb.dz, 0, "mm")
            comp = Shape.cylinder(DOC, oname, d)
            comp.show()
            comp.create()
            comp.loc(dx+dim[i][1], dim[i][2], dim[i][3])
            Shape.cutter("Cut_"+oname, pcb.objA, comp.objA)
            pcb.objA = FreeCAD.activeDocument().getObject("Cut_"+oname)

    ## Update name and location
    pcb.objA.Label = name
    dx += SPACING[0]

########################################
## FINISH
########################################
FreeCADGui.ActiveDocument.ActiveView.viewAxometric()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
