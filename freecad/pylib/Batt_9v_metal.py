## Only works with python 2.7
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## batteries
########################################
wthick = 1.0/32.0
dim = [1.125+wthick, 1.875+wthick, 0.75+wthick, 0, "inch"]
batt9v = Shape.box("Batt9v_holder_metal", "batt_9v", dim)
batt9v.show()
batt9v.create()
batt9v.color(0.8, 0.0, 0.0)
batt9v.loc(0, 0, 0)

########################################
## BRACKET
########################################
## create the bracket by cutting
wthick = wthick * 25.4
dim = [batt9v.dx, batt9v.dy-wthick, batt9v.dz-wthick, 0, "mm"]
tmp = Shape.box(batt9v.doc, "ebox", dim)
tmp.show()
tmp.create()
tmp.loc(0, 0, wthick)

## cut in order to create bracket
batt9v.cut(tmp.name)

########################################
## SCREW HOLES
########################################
## Hole location in mm
hole_x = 60/20
hole_y = 120/20

## wthick already in mm
dim = [360, Shape.SCREWS["4_40_0p25"][2]*25.4, wthick, 0, "mm"]
tmp = Shape.cylinder(batt9v.doc, "screw_hole_0", dim)
tmp.show()
tmp.create()
tmp.loc(hole_x, hole_y, 0)

# cut 1st one
Shape.cutter("Cut_hole_0", batt9v.objA, tmp.objA)

tmp = Shape.cylinder(batt9v.doc, "screw_hole_1", dim)
tmp.show()
tmp.create()
tmp.loc(batt9v.dx-hole_x, hole_y, 0)

# cut 2nd one
Shape.cutter("Cut_hole_1", FreeCAD.ActiveDocument.getObject("Cut_hole_0"), tmp.objA)

########################################
## NODES
########################################
## positive node
dim = [360, 0.375/2.0, 0.1, 0, "inch"] ## diameter
tmp = Shape.cylinder(batt9v.doc, "pos_node", dim)
tmp.show()
tmp.create()
tmp.objA.Placement = Shape.placer(0.7*batt9v.dx, batt9v.dy, batt9v.dz/2, 0.707107,0,0,0.707107)

# fuse 1st one
Shape.fuser("Fusion_Batt9v", FreeCAD.ActiveDocument.getObject("Cut_hole_1"), tmp.objA)

## negative node
dim = [360, 0.125, 0.1, 0, "inch"] ##radius
tmp = Shape.cylinder(batt9v.doc, "neg_node", dim)
tmp.show()
tmp.create()
tmp.objA.Placement = Shape.placer(0.2*batt9v.dx, batt9v.dy, batt9v.dz/2, 0.707107,0,0,0.707107)

Shape.fuser("Batt_9v", FreeCAD.ActiveDocument.getObject("Fusion_Batt9v"), tmp.objA)

########################################
## MAIN
########################################
FreeCADGui.ActiveDocument.ActiveView.viewAxometric()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
