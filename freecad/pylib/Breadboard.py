## Only works with python 2.7
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## breadboards
########################################
dim = [2.125, 3.25, 0.375+2/32, 0, "inch"]
board = Shape.box("Breadboard", "board", dim)
board.show()
board.create()
board.color(0.7,0.7,0.7)
board.loc(0, 0, 0)

########################################
## MAIN
########################################
FreeCADGui.ActiveDocument.ActiveView.viewAxometric()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
