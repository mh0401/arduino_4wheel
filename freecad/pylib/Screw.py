## Only works with python 2.7
##
## Summary:
## Creates spacers and screws
################################################
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

##############################
## PARAMS
##############################
DOC = "Screws"
SPACING = (32.0/64*25.4, 0, 25.4)

##############################
## MAIN
##############################
dx = 0
for screw, dim in Shape.SCREWS.iteritems():

    ##---------
    ## SCREWS
    ##---------
    ## Create the thread
    ## Has to be done first, since it creates the doc
    thread = Shape.cylinder(DOC, "thread_"+screw, dim[0])
    thread.show()
    thread.create()

    ## position thread under xy-plane
    thread.objA.Placement = Shape.placer(dx,0,-thread.dz,0,0,0,1)

    ## Create the curve top
    label = "Sphere_top_"+screw
    FreeCAD.ActiveDocument.addObject("Part::Sphere", label)
    FreeCAD.ActiveDocument.recompute()
    FreeCADGui.activeDocument().activeView().viewAxometric()
    screwtop = FreeCAD.ActiveDocument.getObject(label)
    screwtop.Angle1 = 0.00
    screwtop.Radius = dim[1]*25.4
    screwtop.Placement = Shape.placer(dx,0,0, 0,0,0,1)

    ## Combine top and thread
    Shape.fuser("Screw_curve_"+screw, thread.objA, screwtop)

    ##----------
    ## SPACERS
    ##----------
    ## Create hex polygon cylinder
    spacer = Shape.polygon(DOC, "Poly_hex_"+screw, (dim[3][0], dim[3][1], dim[0][2], 0, "inch"))
    spacer.show()
    spacer.create()
    spacer.extrude([(0, 0, spacer.dz), True, 0])
    spacer.loc(dx, 0, SPACING[2])
    spacer.show()

    ## Create hole for the spacer
    thread = Shape.cylinder(DOC, "hole_"+screw, (360, dim[3][2], dim[0][2], 0, "inch"))
    thread.show()
    thread.create()
    thread.loc(dx, 0, SPACING[2])

    ## Cut hex poly and hole
    Shape.cutter("Spacer_hex_"+screw, spacer.objA, thread.objA)

    ##--------------------------------
    ## Update spacing for next parts
    ##--------------------------------
    dx += SPACING[0]

##############################
## END
##############################
FreeCADGui.ActiveDocument.ActiveView.viewAxometric()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
