-- SMesh Exporter version 0.02
-- export static meshes with uv and normal coords from max to file
-- (c) Ikone Soft Programas de Computador ltda
-- Selling or distributing this code, in part or full, without prior written consent is expressly forbidden.
--
-- If you use this with commercial purposes, please make a donation at
-- https://ko-fi.com/icongames
--
-- use: open in maxscript, select this whole piece of code and eval it
-- it will export every EDITABLE MESH on the scene to a .smesh file
-- use STANDARD MATERIAL on meshes!
-- mesh must have UV mapping!
--
-- this was created on a very old version of MAX
-- I have no idea how this will behave on modern versions

fname = getSaveFileName caption:"Export to file:" filename:"test.smesh"
deletefile fname
f = fopen fname "wb"
 
 	for mesh in objects do
 	(
	    --
 		if superclassof mesh == GeometryClass and ClassOf mesh == Editable_mesh then
 		(
		   -- if editable poly, fix it...
		   -- convertto mesh Editable_mesh
			--local mesh = snapshotAsMesh tmp_mesh
			
 			-- object name
 			writestring f mesh.name 
 			
			writelong f mesh.numVerts
 			if mesh.numVerts > 0 then	
 			(
 				-- vertex and normal data
 				for i = 1 to mesh.numVerts do
 				(
 					vert = ((GetVert mesh i))
 					writefloat f vert.x
 					writefloat f vert.y
 					writefloat f vert.z
 					
 					normal = GetNormal mesh i
 					writefloat f normal.x
 					writefloat f normal.y
 					writefloat f normal.z
 				)
 			)
 
			writelong f mesh.numTVerts
 			if mesh.numTVerts > 0 then 	
 			(
 				-- UV tex coords
 				for i = 1 to mesh.numTVerts do
 				(
 					uvw = GetTVert mesh i
 					writefloat f uvw.x
 					writefloat f uvw.y
 				)
 			)
 
 			--debug = newScript()
			--format "Faces: %\n" mesh.NumFaces to:debug
			
			writelong f mesh.numFaces
 			if mesh.NumFaces > 0 then
 			(
 				-- faces (1 face = 2 triangles)
 				for i = 1 to mesh.numFaces do
 				(
 					poly = GetFace mesh i
 					tvert = GetTVFace mesh i
 					-- write face index
 					writelong f (poly.x as integer -1)
 					writelong f (poly.y as integer -1)
 					writelong f (poly.z as integer -1)
 					-- write face uv index
 					writelong f (tvert.x as integer -1) 
 					writelong f (tvert.y as integer -1) 
 					writelong f (tvert.z as integer -1)					
 				)
 			)
 			
			mat = mesh.material
        	if (mat != undefined) then 			
			(
				--debug = newScript()
				--print "has material" to:debug

				-- mesh has a material applied!
				writebyte f 1

				materialClass = classof mesh.material
				
				--print "material class:" to:debug
				--print materialClass to:debug
				
				if(materialClass == Standardmaterial) then
				(
					--print "faceted" to:debug 
					--print mat.faceted to:debug 
					--print "two sided" to:debug 
					--print mat.twosided to:debug 
					--print "glossiness:" to:debug
					--print mat.specularLevel to:debug
					--print "opacity" to:debug
					--print mat.opacity to:debug
					--print "number of maps" to:debug
					--print mat.maps to:debug
					
					--print "diffuse texture" to:debug
					--texfile = filenameFromPath mat.diffuseMap.fileName
					--print texfile to:debug
					
					--subtexcount = getNumSubTexmaps mat
					--print "materials count:" to:debug
					--print subtexcount to:debug
					
					--for i = 1 to subtexcount do
					--(
					--    print i to:debug
					--)
					
					-- two sided
					if (mat.twosided) then ( writebyte f 1 ) else ( writebyte f 0 )
					-- faceted?
					if (mat.faceted) then ( writebyte f 1 ) else ( writebyte f 0 )
	
					-- material diffuse color (save ambient/specular later?)
					writebyte f mat.diffuse.r
					writebyte f mat.diffuse.g
					writebyte f mat.diffuse.b
					
					-- shininess? (specular level)
					writefloat f mat.specularLevel
					
					-- opacity (entityAlpha)
					writefloat f mat.opacity
	
					-- texture
					--texfile = filenameFromPath mat.diffuseMap.fileName
					--writestring f texfile
					
					-- count available materials
					map_count=0
					for m = 1 to mat.maps.count do
					(
					   if (mat.maps[m]!=undefined) then ( map_count = map_count + 1 )
					)
					--print map_count to:debug
					writebyte f map_count
					
					for m = 1 to mat.maps.count do
					(
					   if (mat.maps[m]!=undefined) then 
					   ( 
					      --print mat.maps[m].filename to:debug
						  texfile = filenameFromPath mat.maps[m].filename
						  writestring f texfile
					   )
					)
					

				)
				
			) else (
				writebyte f 0 	-- no material
			)
 		)
 	)

fclose f
messagebox "File exported!"
 