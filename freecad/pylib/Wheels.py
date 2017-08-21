## Only works with python 2.7
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## tires
########################################
dim = [360, 42/2, 19, 0, "mm"] #diameter
tire = Shape.cylinder("Pololu_wheels_42x19_mm", "tire", dim)
tire.show()
tire.create()
tire.color(0.05,0.1,0.05)
tire.loc(0, 0, 0)

dim = [360, 25.4/2.0, 19, 0, "mm"] #diameter
hole = Shape.cylinder(tire.doc, "hole", dim)
hole.show()
hole.create()
hole.loc(0, 0, 0)

tire.cut(hole.name)

dim = [360, 25.4/2.0, 19, 0, "mm"] #diameter
rim = Shape.cylinder(tire.doc, "rim", dim)
rim.show()
rim.create()
rim.color(1.0, 1.0, 1.0)
rim.loc(0, 0, 0)

########################################
## MAIN
########################################
FreeCADGui.ActiveDocument.ActiveView.viewFront()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
