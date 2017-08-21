## Only works with python 2.7
##

FREECADPATH = '/usr/lib/freecad/lib'
import sys
sys.path.append(FREECADPATH)

import FreeCADGui
FreeCADGui.showMainWindow()
