## Only works with python 2.7
##
## Requirements:
## 1. Works only after PCB is generated thru "PCB_Generic"
##    and hole is punched thru "PCB_Hole". 
## 2. PCB still contains dimension info (still in Fusion type).
## 3. Spacers are all imported and labeled "XXX_Spacer_XpXX_inch_XXX"
##    with the height measurement
## 4. Screws are all imported and labeled "Screw_XXX"
##
## Summary:
## 1. Position spacers/screws underneath the hole
## 2. Fuse the spacers/screws and PCB together
##
import sys
LIBPATH = '/home/marcel/Proj/lib/freecad/pylib'
sys.path.append(LIBPATH)

import Shape

########################################
## Get dimension of holes/board
########################################
loc = []
for hole in FreeCAD.activeDocument().findObjects("Part::Feature", "Cylinder_hole.*"):
    loc.append([hole.Placement.Base.x, hole.Placement.Base.y])

########################################
## Get PCB object
########################################
pcb = 0
for obj in FreeCAD.activeDocument().findObjects("Part::Feature", ".*Fusion.*"):
    if (obj.Label.find("Fusion") == -1):
        pcb = obj
        break

FreeCAD.Console.PrintMessage("PCB is " + pcb.Label + "\n")

########################################
## SPACERS
########################################
dz = 0
i = 0
for spacer in FreeCAD.ActiveDocument.findObjects("Part::Feature", ".*Spacer.*"):
    ## Get height of spacer
    if (dz == 0):
        dz = spacer.Label[spacer.Label.find("_",7)+1:spacer.Label.find("inch")-1]
        dz = float(dz.replace('p', '.'))*(-25.4)
        FreeCAD.Console.PrintMessage("Height offset (mm): " + str(dz) + "\n")

    ## Position spacer under holes and fuse
    spacer.Placement = Shape.placer(loc[i][0], loc[i][1], dz, 0,0,0,1)
    fusion_name = "Fuse_PCB_spacer" if (i == 0) else "Fuse_PCB_spacer"+"00"+str(i)
    Shape.fuser(fusion_name, pcb, spacer)
    pcb = FreeCAD.activeDocument().getObject(fusion_name)
    i += 1

########################################
## SCREWS
########################################
i = 0
for screw in FreeCAD.ActiveDocument.findObjects("Part::Feature", ".*Screw.*"):
    screw.Placement = Shape.placer(loc[i][0], loc[i][1], 0, 0, 0, 0, 1)
    fusion_name = "Fuse_PCB_spacer_screw" if (i == 0) else "Fuse_PCB_spacer_screw"+"00"+str(i)
    Shape.fuser(fusion_name, pcb, screw)
    pcb = FreeCAD.activeDocument().getObject(fusion_name)
    i += 1

