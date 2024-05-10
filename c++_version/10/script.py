# Import bpy api
import bpy

# Select the active object
myObject = bpy.context.active_object

# obtain mesh data
verts = myObject.data.vertices
edges = myObject.data.edges
faces = myObject.data.polygons


# iterate through mesh data and capture min x,y,z and max x,y,z values
bounds = [[0,0],[0,0],[0,0]]
for v in verts:
    # Print x,y,z of mesh
    print(v.co[0],v.co[1],v.co[2])    
    copy_verts.append([v.co[0],v.co[1],v.co[2]])
    # Update pairs of min and max x, values
    if(v.co[0] < bounds[0][0]):
        bounds[0][0] = v.co[0]
    if(v.co[0] > bounds[0][1]):
        bounds[0][1] = v.co[0]
    if(v.co[1] < bounds[0][0]):
        bounds[1][0] = v.co[1]
    if(v.co[1] > bounds[0][1]):
        bounds[1][1] = v.co[1]
    if(v.co[2] < bounds[0][0]):
        bounds[2][0] = v.co[2]
    if(v.co[2] > bounds[0][1]):
        bounds[2][1] = v.co[2]
    
#print(copy_verts)
    
# Print out indexes of the vertices in edge-list
for e in edges:
    for v in e.vertices:
        print(v)
        
# Print out indexes of vertices from face
for f in faces:
    for v in f.vertices:
        print(v)
        
# Let's now create a new mesh representing the bounding box
name = "duplicate"
mesh = bpy.data.meshes.new(name)
mesh.from_pydata(copy_verts,edges,faces)
obj = bpy.data.objects.new(name,mesh)
new_collection = bpy.data.collections.new("new_collection")
bpy.context.scene.collection.children.link(new_collection)

new_collection.objects.link(obj)
