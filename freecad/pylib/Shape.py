import sys
FREECADPATH = '/usr/lib/freecad/lib'
sys.path.append(FREECADPATH)

import FreeCAD, FreeCADGui, Part, PartGui

##############################
## LIBRARIES
##############################
SCREWS = {
    ## name, screw dim, head radius, hole radius, spacer dim
    ## screw dim: angle, radius, height, thickness, measurement
    ## spacer dim: number of sides, poly radius, inner hole radius (w/o thread)

    ## screw 6-32
    "6_32_0p25": ([360, 4.0/64, 0.25, 0, "inch"], 7.5/64, 4.5/64, (6, 5.0/32, 2.5/32, "inch")),
    "6_32_0p50": ([360, 4.0/64, 0.50, 0, "inch"], 7.5/64, 4.5/64, (6, 5.0/32, 2.5/32, "inch")),
    "6_32_0p75": ([360, 4.0/64, 0.75, 0, "inch"], 7.5/64, 4.5/64, (6, 5.0/32, 2.5/32, "inch")),
    "6_32_1p00": ([360, 4.0/64, 1.00, 0, "inch"], 7.5/64, 4.5/64, (6, 5.0/32, 2.5/32, "inch")),

    ## screw 4-40
    "4_40_0p25": ([360, 3.0/64, 0.25, 0, "inch"], 6.5/64, 3.5/64, (6, 5.0/32, 2.0/32, "inch")),
    "4_40_0p50": ([360, 3.0/64, 0.50, 0, "inch"], 6.5/64, 3.5/64, (6, 5.0/32, 2.0/32, "inch")),
    "4_40_0p75": ([360, 3.0/64, 0.75, 0, "inch"], 6.5/64, 3.5/64, (6, 5.0/32, 2.0/32, "inch")),
    "4_40_1p00": ([360, 3.0/64, 1.00, 0, "inch"], 6.5/64, 3.5/64, (6, 5.0/32, 2.0/32, "inch"))
}

##===================================================
## 
## FUNCTIONS
##
##===================================================
########################################
## Fuser
########################################
def fuser(fusion_name, base, tool):
    docGctive = FreeCADGui.ActiveDocument
    FreeCAD.Console.PrintMessage("===============FUSER=============\n")
    FreeCAD.Console.PrintMessage("Fuse: " + fusion_name + "\n")
    FreeCAD.Console.PrintMessage("Base: %s, %s\n" % (base.Name, base.Label))
    FreeCAD.Console.PrintMessage("Tool: %s, %s\n" % (tool.Name, tool.Label))
    FreeCAD.activeDocument().addObject("Part::Fuse", fusion_name)
    FreeCAD.activeDocument().getObject(fusion_name).Base = base
    FreeCAD.activeDocument().getObject(fusion_name).Tool = tool
    FreeCADGui.activeDocument().hide(base.Name)
    FreeCADGui.activeDocument().hide(tool.Name)
    FreeCAD.Console.PrintMessage("Hide: %s, %s\n" % (base.Name, tool.Name))
    docGctive.getObject(fusion_name).ShapeColor=docGctive.getObject(base.Name).ShapeColor
    docGctive.getObject(fusion_name).DisplayMode=docGctive.getObject(base.Name).DisplayMode
    FreeCAD.Console.PrintMessage("============END FUSER=============\n")

########################################
## Cutter
########################################
def cutter(cut_name, base, tool):
    docGctive = FreeCADGui.ActiveDocument
    FreeCAD.Console.PrintMessage("===============CUTTER=============\n")
    FreeCAD.Console.PrintMessage("Cut: " + cut_name + "\n")
    FreeCAD.Console.PrintMessage("Base: %s, %s\n" % (base.Name, base.Label))
    FreeCAD.Console.PrintMessage("Tool: %s, %s\n" % (tool.Name, tool.Label))
    FreeCAD.activeDocument().addObject("Part::Cut", cut_name)
    FreeCAD.activeDocument().getObject(cut_name).Base = base
    FreeCAD.activeDocument().getObject(cut_name).Tool = tool
    FreeCADGui.activeDocument().hide(base.Name)
    FreeCADGui.activeDocument().hide(tool.Name)
    FreeCAD.Console.PrintMessage("Hide: %s, %s\n" % (base.Name, tool.Name))
    docGctive.getObject(cut_name).ShapeColor=docGctive.getObject(base.Name).ShapeColor
    docGctive.getObject(cut_name).DisplayMode=docGctive.getObject(base.Name).DisplayMode
    FreeCAD.Console.PrintMessage("============END CUTTER=============\n")

########################################
## Placer
########################################
def placer(x,y,z,a,ax,ay,az):
    FreeCAD.Console.PrintMessage("===============PLACER=============\n")
    msg = "x: %.2f, y: %.2f, z: %.2f, a: %.2f, ax: %.2f, ay: %.2f, az: %.2f\n"
    FreeCAD.Console.PrintMessage(msg % (x, y, z, a, ax, ay, az))
    p = FreeCAD.Placement(FreeCAD.Vector(x, y, z), FreeCAD.Rotation(a, ax, ay, az))
    FreeCAD.Console.PrintMessage("============END PLACER=============\n")
    return p


##===================================================
## 
## CLASSES
##
##===================================================
########################################
## 
## FreeCAD related parameters
##
########################################
class CADobj():
    """ Basic CAD object """
    def __init__(self,docname,objtype,objname):
        self.doc = docname
        self.obj = objtype
        self.name = objtype[6:]+"_"+objname
        self.lx = 0
        self.ly = 0
        self.lz = 0
        self.weight = 0
        
    def cprint(self, strin):
        """ Print to CAD console """
        FreeCAD.Console.PrintMessage(strin + "\n")

    def show(self):
        """ Print info for this object """
        self.cprint(self.name + ", in doc: " + self.doc)
        self.cprint(self.name + ", loc: %.2f %.2f %.2f" % (self.lx, self.ly, self.lz))
        self.cprint(self.name + ", weight: %.2f" % self.weight)

    def select(self):
        """ Update current document to allow obj selection """
        try :
            tmp = FreeCAD.getDocument(self.doc)
        except NameError:
            self.cprint(self.name + ", Need new doc " + self.doc)
            FreeCAD.newDocument(self.doc)

        self.cprint(self.name + ", move to doc " + self.doc)
        FreeCAD.setActiveDocument(self.doc)
        self.docA = FreeCAD.ActiveDocument
        self.docG = FreeCADGui.ActiveDocument

    def create(self):
        """ Create the obj in CAD """
        self.cprint("============ CREATE ==============")
        self.cprint(self.name + ", create this obj")        
        self.select()
        self.docA.addObject(self.obj, self.name)
        self.docA.recompute()
        self.objA = self.docA.getObject(self.name)
        self.objG = self.docG.getObject(self.name)        
        self.cprint("============END CREATE=============")

    def loc(self, x,y,z):
        """ Modify location of obj in CAD """
        self.cprint(self.name + ", move obj to %.2f %.2f %.2f" % (x,y,z))
        self.objA.Placement = FreeCAD.Placement(FreeCAD.Vector(x,y,z),FreeCAD.Rotation(0,0,0,1))
        self.lx = x
        self.ly = y
        self.lz = z

    def color(self,r,g,b):
        """ Modify color in CAD """
        self.objG.ShapeColor = (r,g,b)


########################################
##
## Any 3D object, extension of CAD object
##
########################################
class obj3d(CADobj):
    """ Basic shape class for CAD drawing """
    def __init__(self,doc,t,n,x,y,z,th):
        CADobj.__init__(self, doc, t, n)
        self.dx = x
        self.dy = y
        self.dz = z
        self.thick = th

    def fillet(self, arr):
        name_org = self.name
        self.obj = "Part::Fillet"
        self.name = obj[6:]+"_"+self.name
        self.cprint(self.name + ", old name: " + name_org)
        self.cprint(self.name + ", fillets: ")
        FreeCAD.Console.PrintMessage(arr)
        self.cprint("")
        CADobj.create(self)
        self.objA.Base = self.docA.getObject(name_org)
        self.objA.Edges = arr
        self.docG.getObject(name_org).Visibility = False

    def hollow(self, arr):
        self.cprint("============HOLLOW=============\n")
        name_org = self.name
        self.thick = arr[0]
        self.obj = "Part::Thickness"
        self.name = self.obj[6:]+"_"+self.name
        CADobj.create(self)
        self.cprint(self.name + ", old name: " + name_org)
        self.cprint(self.name + ", faces: ")
        FreeCAD.Console.PrintMessage(arr[3])
        self.cprint("")
        self.objA.Faces = (self.docA.getObject(name_org), arr[3])
        self.objA.Value = self.thick
        self.objA.Mode = arr[1]
        self.objA.Join = arr[2]
        self.objA.Intersection = False
        self.objA.SelfIntersection = False
        self.docA.recompute()
        self.docG.getObject(name_org).Visibility = False
        self.cprint("============END HOLLOW=============\n")

    def extrude(self, arr):
        self.cprint("============EXTRUDE=============\n")
        name_org = self.name
        self.obj = "Part::Extrusion"
        self.name = self.obj[6:]+"_"+self.name
        CADobj.create(self)
        self.cprint(self.name + ", old name: " + name_org)
        self.cprint(self.name + ", faces: ")
        FreeCAD.Console.PrintMessage(arr)
        self.cprint("")
        self.objA.Base = self.docA.getObject(name_org)
        self.objA.Dir = arr[0]
        self.objA.Solid = arr[1]
        self.objA.TaperAngle = arr[2]
        self.docA.recompute()
        self.docG.getObject(name_org).Visibility = False
        self.cprint("============END EXTRUDE=============\n")

    def cut(self, name_cut):
        self.cprint("============CUT=============\n")
        name_org = self.name
        self.obj = "Part::Cut"
        self.name = self.obj[6:]+"_"+self.name
        CADobj.create(self)
        self.cprint(self.name + ", old name: " + name_org)
        self.cprint(self.name + ", cut from: " + name_cut)
        self.objA.Base = self.docA.getObject(name_org)
        self.objA.Tool = self.docA.getObject(name_cut)
        self.docG.hide(name_org)
        self.docG.hide(name_cut)
        self.objG.ShapeColor = self.docG.getObject(name_org).ShapeColor
        self.objG.DisplayMode = self.docG.getObject(name_org).DisplayMode
        self.cprint("============END CUT=============\n")


########################################
##
## Box representation
##
########################################
class box(obj3d):
    """ Box for CAD drawing """
    def __init__(self,doc,n,dim):
        x = dim[0] if (dim[4] == "mm") else dim[0]*25.4
        y = dim[1] if (dim[4] == "mm") else dim[1]*25.4
        z = dim[2] if (dim[4] == "mm") else dim[2]*25.4
        t = dim[3] if (dim[4] == "mm") else dim[3]*25.4
        obj3d.__init__(self, doc, "Part::Box", n,x,y,z,t)

    def show(self):
        """ Print dimension of the box """
        CADobj.show(self)
        self.cprint("============SHOW BOX=============\n")
        msg = "%s, (in mm) length: %.2f, width: %.2f, depth: %.2f"
        self.cprint(msg % (self.name, self.dx, self.dy, self.dz))
        self.cprint("============END SHOW=============\n")

    def reshape(self):
        """ Update its dimension in CAD """
        self.cprint("============RESHAPING=============\n")
        self.cprint("Re-shaping " + self.name)
        CADobj.select(self)
        self.cprint("Obj name " + self.name + ", " + self.objA.Name)
        self.objA.Length = self.dx
        self.objA.Width = self.dy
        self.objA.Height = self.dz
        self.cprint("Done re-shaping " + self.name)
        self.cprint("============END RESHAPING=============\n")

    def create(self):
        """ Create this obj in CAD """
        self.cprint("Creating "+ self.name)
        CADobj.create(self)
        self.reshape()
        self.docG.sendMsgToViews("ViewFit")
        self.cprint("Done creating " + self.name)


########################################
##
## Cylinder representation
##
########################################
class cylinder(obj3d):
    """ Cylinder for CAD drawing """
    def __init__(self,doc,n,dim):
        x = dim[0]
        y = dim[1] if (dim[4] == "mm") else dim[1]*25.4
        z = dim[2] if (dim[4] == "mm") else dim[2]*25.4
        t = dim[3] if (dim[4] == "mm") else dim[3]*25.4
        obj3d.__init__(self, doc, "Part::Cylinder", n,x,y,z,t)

    def show(self):
        """ Print dimension of the box """
        CADobj.show(self)
        self.cprint("============SHOW CYLINDER=============\n")
        msg = "%s, (in mm) angle: %.2f, radius: %.2f, height: %.2f, thick: %.2f"
        self.cprint(msg % (self.name, self.dx, self.dy, self.dz, self.thick))
        self.cprint("============END SHOW=============\n")

    def reshape(self):
        """ Update its dimension in CAD """
        self.cprint("============RESHAPE=============\n")
        self.cprint("Re-shaping " + self.name)
        CADobj.select(self)
        self.objA.Angle = self.dx
        self.objA.Radius = self.dy
        self.objA.Height = self.dz
        self.cprint("Done re-shaping obj")
        self.cprint("============END RESHAPE=============\n")

    def create(self):
        """ Create this obj in CAD """
        self.cprint("Creating obj " + self.name)
        CADobj.create(self)
        self.reshape()
        self.docG.sendMsgToViews("ViewFit")
        self.cprint("Done creating obj")


########################################
##
## Polygon representation
##
########################################
class polygon(obj3d):
    """ Polygon for CAD drawing """
    def __init__(self,doc,n,dim):
        x = dim[0]
        y = dim[1] if (dim[4] == "mm") else dim[1]*25.4
        z = dim[2] if (dim[4] == "mm") else dim[2]*25.4
        t = dim[3] if (dim[4] == "mm") else dim[3]*25.4
        obj3d.__init__(self, doc, "Part::RegularPolygon", n,x,y,z,t)

    def show(self):
        """ Print dimension of the polygon """
        self.cprint("============SHOW POLYGON=============\n")
        CADobj.show(self)
        msg = "%s, (in mm) num_sides: %.2f, radius: %.2f, height: %.2f, thick: %.2f"
        self.cprint(msg % (self.name, self.dx, self.dy, self.dz, self.thick))
        self.cprint("============END SHOW=============\n")

    def reshape(self):
        """ Update its dimension in CAD """
        self.cprint("============RESHAPE=============\n")
        self.cprint("Re-shaping " + self.name)
        CADobj.select(self)
        self.objA.Polygon = self.dx
        self.objA.Circumradius = self.dy
        self.cprint("Done Re-shaping obj")
        self.cprint("============END RESHAPE=============\n")

    def create(self):
        """ Create this obj in CAD """
        self.cprint("Creating obj " + self.name)
        CADobj.create(self)
        self.reshape()
        self.docG.sendMsgToViews("ViewFit")
        self.cprint("Done creating obj")

