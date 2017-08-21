## Only works with python 2.7
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## case
########################################
dim = [4.125, 6.0, 2.5, 5.0/32, "inch"]
casing = Shape.box("Casing_box","case",dim)
casing.show()
casing.create()
attr = [0.5, 0, 0, ["Face3"]]
casing.hollow(attr)
#fillets = [[9,1.00,1.00],[10,1.00,1.00],[11,1.00,1.00],[12,1.00,1.00]]
#casing.fillet(fillets)
#del fillets

########################################
## open box
########################################
dim = [4.125, 6, 1.25, 5.0/32, "inch"]
dbox = Shape.box(casing.doc,"dbox",dim)
dbox.show()
dbox.create()
dbox.hollow(attr)
dbox.loc(0, 0, dbox.dz)
casing.cut(dbox.name)
del attr

########################################
## MAIN
########################################
FreeCADGui.ActiveDocument.ActiveView.viewAxometric()
FreeCADGui.ActiveDocument.ActiveView.setAxisCross(True)
