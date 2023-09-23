# SMESH-exporter
A MAXScript to export static meshes

I first created this script as a replacement for the B3DExporter for 3D Max. 
B3D was a file format used by Blitz3D (from BlitzBasic) and later MiniB3D on BlitzMax.

<br>The exported file format is very simple:<br>

* byte : mesh name (ended by chr$(0))
* int  : number of vertex
* float: (vertex (x,y,z), normal(x,y,z)) * number of vertex
* int  : number of UV coords
* float: (uv) * number of UV
* int  : number of faces
* float: (face (i1,i2,i3), faces (uvi1, uvi2, uvi3)) * number of UV
  * byte: has material
  * byte : two sided? (if yes, disable backface culling)
  * byte : faceted
  * byte : material color: red, green, blue
  * float: shineness
  * byte : mapCount (has mapping applied? (0 if no textures))
    * texture name (ended by chr$(0)) * mapCount
