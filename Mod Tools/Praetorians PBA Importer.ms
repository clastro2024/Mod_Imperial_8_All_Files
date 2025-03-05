--------------------------------------------------------------
--                                                          --
-- Praetorians import/export script for PBA file format		--
-- by Paulus (pauldls@hotmail.com)        			        --
--                                                          --
--						Ave Caesar						    --                                                                 --
--    	     	 Senatvs Popvlvsqve Romanvs  			    --
--                                                          --
--------------------------------------------------------------

global PBA_VERSION  =  0x0002 
global BASE_CHUNK_PBA  =  (0x300)
global CHUNK_PBA_MAIN  = (0x0001+BASE_CHUNK_PBA)
global CHUNK_PBA_POOLGEOMS  = (0x0002+BASE_CHUNK_PBA) 
global CHUNK_PBA_GEOM01 =  (0x0003+BASE_CHUNK_PBA) 
global CHUNK_PBA_POOLANIMACIONES =  (0x0004+BASE_CHUNK_PBA) 
global CHUNK_PBA_ANIMACION01 =  (0x0005+BASE_CHUNK_PBA) 
global CHUNK_PBA_HUESOS  = (0x0006+BASE_CHUNK_PBA)
global CHUNK_PBA_ANIMACIONNODO01 =  (0x0007+BASE_CHUNK_PBA) 
global CHUNK_PBA_POOLMATERIALES  = (0x0004) 
global CHUNK_PBA_MATERIAL01 = (0x0005) 
global CHUNK_PBA_POOLTEXTURAS  = (0x0006) 
global CHUNK_PBA_TEXTURA01 = (0x0007) 

heapsize += 30000000 --add 30mb more memory for the bigger files
IMPORTANIM =  true --if to import animation
--prae to max system: max x = z; max y = -x; max z = y
fn MaxToPraetorians tmesh = (
	for i=1 to (getnumverts tmesh) do(
	vert = coordsys local((getvert tmesh i))
	cvert = point3 -vert.y vert.z vert.x
	coordsys local((setvert tmesh i cvert))
	)
	return tmesh
)
--function to find the middle and radius
struct PBACOLL( middle, radius)
struct PBA_STATE( name,startframe,endframe,time)
--fn to load all the state animations
fn LoadStates = (
bLoop = true
ii =1
pba_States = #()
while (bLoop==true) do 
		(
		local node = selection[1]
		local prop_name
		local tmpState = PBA_STATE 0
		prop_name = "anim_name_" + (ii as string)
		tmpState.name = getUserProp node prop_name 
		
		if( (tmpState.name == undefined) or (tmpState.name == "") ) then bLoop = false
		else (
		prop_name = "anim_firstframe_" + (ii as string)
		tmpState.startframe = getUserProp node prop_name 
		prop_name = "anim_lastframe_" + (ii as string)
		tmpState.endframe = getUserProp node prop_name
		prop_name = "anim_transtime_" + (ii as string)
		tmpState.time = getUserProp node prop_name
		append pba_States tmpState
				)
		ii+=1	
		)

return (pba_States)
		 
)
		
fn GetCollision tmesh = (

mmin = point3 999.0 999.0 999.0
mmax = point3 -999.0 -999.0 -999.0

middle = point3 0.0 0.0 0.0
for i=1 to (getnumverts tmesh) do(
vert = coordsys local((getvert tmesh i))
middle += vert/((getnumverts tmesh) as float)
if (vert.x<mmin.x) then mmin.x = vert.x
if (vert.y<mmin.y) then mmin.y = vert.y
if (vert.z<mmin.z) then mmin.z = vert.z

if (vert.x>mmax.x) then mmax.x = vert.x
if (vert.y>mmax.y) then mmax.y = vert.y
if (vert.z>mmax.z) then mmax.z = vert.z

)
--print ("radius: " + radius1 as string)
radius1 = distance mmin mmax
--radius1 = sqrt radius1
--newsphere =  Sphere radius:(radius1/2.0)
--newsphere.pos = middle
return (PBACOLL middle (radius1/2.0))
)

--fn to write a 32 byte string
fn Write32String fp stringTW =(
	if(stringTW.count > 32) then 
	print "String too big"
	else (
	WriteString fp stringTW
	for i=1 to 31-stringTW.count do
		WriteByte fp 0
	)
)
struct SEQNODE( --unused for now
NodeId,	--dword
NumKeyframes --dword
)
struct KEYFRAME(
time, --dword
byteVect3s --array of byte compressed coords
)
struct ANIMVERTCHUNK(
NodeId,		  --dword
NumKeyframes, --dword
NumVertices,  --dword
MinBox,		  --point3 (3floats)
MaxBox,		  --point3 (3floats)
keyframes,	  --array of KEYFRAME
	fn Read fp =(
	NodeId = ReadLong fp
	NumKeyframes = ReadLong fp
	NumVertices = ReadLong fp
	
	print ("NumVerts:" + (NumVertices as string))
	
	minx = ReadFloat fp
	miny = ReadFloat fp
	minz = ReadFloat fp
	maxx = ReadFloat fp
	maxy = ReadFloat fp
	maxz = ReadFloat fp
	-- prae to max system: 3dmax x = z; 3dmax y = -x; 3dmax z = y
	MinBox = point3 minx miny minz
	MaxBox = point3 maxx maxy maxz
	keyframes = #()
	for i1=1 to NumKeyframes do(
	tmpKF = KEYFRAME 0
	tmpKF.time = ReadLong fp
	tmpKF.byteVect3s = #()
		for k=1 to NumVertices do
		append tmpKF.byteVect3s (point3 (ReadByte fp #unsigned) (ReadByte fp #unsigned) (ReadByte fp #unsigned) )
	append keyframes tmpKF	
	)
	
	
	),
	fn Write fp =(
	WriteLong fp 0
	WriteLong fp NumKeyframes 
	WriteLong fp NumVertices
				 
	--claculate min/max
	MinBox = point3 999.0 999.0 999.0
	MaxBox = point3 -999.0 -999.0 -999.0
	
	for nkf=1 to NumKeyframes do
	for mm=1 to NumVertices do(
	vert = keyframes[nkf].byteVect3s[mm]

	if (vert.x<MinBox.x) then MinBox.x = vert.x
	if (vert.y<MinBox.y) then MinBox.y = vert.y
	if (vert.z<MinBox.z) then MinBox.z = vert.z

	if (vert.x>MaxBox.x) then MaxBox.x = vert.x
	if (vert.y>MaxBox.y) then MaxBox.y = vert.y
	if (vert.z>MaxBox.z) then MaxBox.z = vert.z
	
	)
			
	WriteFloat fp MinBox.x
	WriteFloat fp MinBox.y  
	WriteFloat fp MinBox.z 
	WriteFloat fp MaxBox.x
	WriteFloat fp MaxBox.y  
	WriteFloat fp MaxBox.z
	
	for i1=1 to NumKeyframes do(
	WriteLong fp keyframes[i1].time
		for i2=1 to NumVertices do(
		
			vert = keyframes[i1].byteVect3s[i2]
			
			ex   =vert.x
			ey   =vert.y
			ez   =vert.z
			cx = ((ex-MinBox.x)/(MaxBox.x-MinBox.x) )*255 
			cy = ((ey-MinBox.y)/(MaxBox.y-MinBox.y) )*255 
			cz = ((ez-MinBox.z)/(MaxBox.z-MinBox.z) )*255
			WriteByte fp (cx as integer) #unsinged
			WriteByte fp (cy as integer) #unsinged
			WriteByte fp (cz as integer) #unsinged
			)
		)
	)
)
struct SEQUENCE(
AnimChunk,
sizeTillNext,
Name,		--char[32]
Duration,	--dword
NumSeqNodes,--dword
SeqNodes,   --arra of SEQNODE 
NumAnimatedVertexSeq, --dword
ChunkCheck,  --word
OffsetTillNext, --dword
AnimVerts,	--array of ANIMVERTCHUNK

	fn Read fp = (
	AnimChunk = ReadShort fp
		if (AnimChunk != CHUNK_PBA_ANIMACION01) then  (
		MessageBox("Error Reading Animation or unsupported type")
		print ("AnimChunk " + (AnimChunk as string))
		print ("Pos " + ((ftell fp)as string))
		return false
		)
	sizeTillNext = ReadLong fp
	print sizeTillNext	
	name = ReadString fp
	if(name.count < 32) then fseek fp (31 - name.count) #seek_cur
	Duration = ReadLong fp
	NumSeqNodes = ReadLong fp
	SeqNodes = #()--for now do nothing
	NumAnimatedVertexSeq = ReadLong fp
	ChunkCheck = ReadShort fp
	OffsetTillNext = ReadLong fp
	AnimVerts = #()
	--print (NumSeqNodes)
	for i=1 to NumAnimatedVertexSeq do(
	tmpAV = ANIMVERTCHUNK 0
	tmpAV.Read fp
	append AnimVerts tmpAV
		)
	),
	fn Write fp = (
	WriteShort fp CHUNK_PBA_ANIMACION01
	
	sizeTillNextPos = ftell fp--we'll come back and write the real vlaue
	WriteLong fp -1
		
	Write32String fp name
	
	WriteLong fp Duration
	WriteLong fp 0
	WriteLong fp 1
	WriteShort fp CHUNK_PBA_ANIMACIONNODO01
	OffsetTillNextPos = ftell fp--ten less then sizetillnextpos
	WriteLong fp -1
	
	for i=1 to NumAnimatedVertexSeq do
	AnimVerts[i].Write fp
	bookMark = ftell fp
	fseek fp sizeTillNextPos #seek_set
	WriteLong fp ((bookMark-sizeTillNextPos)+2)
	fseek fp offsetTillNextPos #seek_set
	WriteLong fp (((bookMark-sizeTillNextPos)+2)-10)
	fseek fp bookmark #seek_set
	)


)
struct TD3DVERT(
x,y,z,		--coords as floats
nx,ny,nz,	--normals as floats 
r,g,b,a, 	--color as byte
u,v,		--as floats

fn Read fp = (
	x = ReadFloat fp
	y = ReadFloat fp
	z = ReadFloat fp
	
	nx = ReadFloat fp
	ny = ReadFloat fp
	nz = ReadFloat fp
	
	r = ReadByte fp #unsigned
	g = ReadByte fp #unsigned
	b = ReadByte fp #unsigned
	a = ReadByte fp #unsigned	
	u = ReadFloat fp
	v = ReadFloat fp
	
	),
fn Write fp = (
	WriteFloat fp x
	WriteFloat fp y
	WriteFloat fp z
	
	WriteFloat fp nx 
	WriteFloat fp ny
	WriteFloat fp nz
	
	WriteByte fp r #unsigned
	WriteByte fp g #unsigned
	WriteByte fp b #unsigned
	WriteByte fp a #unsigned	
	WriteFloat fp u
	WriteFloat fp v
	
	)
)

struct FACEGROUP(
TextureId,		--dword
AlphaFlags,		--dword
numVerts,		--dword
NumVertInd,		--dword	
VertInd,		--array of words
NumCivTextures, --dword
CivTextures,	--array of char[32]

fn Read fp = (
	--print "facegroup print"
	TextureId  = ReadLong fp
	AlphaFlags = ReadLong fp
	numVerts   = ReadLong fp
	NumVertInd = ReadLong fp
	VertInd = #()
	for i=1 to NumVertInd do
	( 
	tmp = ReadShort fp
	append VertInd tmp
	)
	NumCivTextures = ReadLong fp
	--print NumCivTextures
	--return 0
	for i=1 to NumCivTextures*32 do
	tmpc = ReadByte fp --read and discard for now
	
	),--end fn read
fn Write fp = (
	--print "facegroup print"
	WriteLong fp TextureId
	WriteLong fp AlphaFlags 
	WriteLong fp numVerts 
	WriteLong fp NumVertInd
	
	for i=1 to NumVertInd do 
	WriteShort fp VertInd[i]
	
	WriteLong fp NumCivTextures
	for i=1 to NumCivTextures do
	Write32String fp CivTextures[i]
	
	)--end fn write
	
	
)

struct GEOMETRIA_ANIMADA (--type 3
numVertices, 	--dword
vertArray,		--TD3DVERT array
numFaceGroups, 	--dword
fgArray,	--array of FACEGROUP's

	fn Read fp 	= (
	fgArray = #()
	vertArray = #()
	numVertices = ReadLong fp
	for i=1 to numVertices do(
	tmpV = TD3DVERT 0
	tmpV.Read fp
	append vertArray tmpV
		)
	numFaceGroups = ReadLong fp 
	for i=1 to numFaceGroups do(
	tmpFg = FACEGROUP 0
	tmpFg.Read fp
	append fgArray tmpFg
		)
	),
	
fn Write fp = (
	WriteLong fp numVertices
	for i=1 to numVertices do
	vertArray[i].Write fp
	
	WriteLong fp numFaceGroups 
	for i=1 to numFaceGroups do
	fgArray[i].write fp
	
	)			
	
)
struct PBA_MESH(
mesh_type, 	--dword
name,		--char[32]
center,		--point3 (3 floats)
radius,		--float
mesh_data,

	fn Read fp 	= (
	mesh_type = ReadLong fp
	name = ReadString fp
	if(name.count < 32) then fseek fp (31 - name.count) #seek_cur
	xf = ReadFloat fp
	yf = ReadFloat fp
	zf = ReadFloat fp
	center = Point3 xf yf zf
	radius = ReadFloat fp
	mesh_data = GEOMETRIA_ANIMADA 0
	mesh_data.Read fp
	),
	
	fn Write fp	= (
	WriteLong fp mesh_type
	Write32String fp name
	
	WriteFloat fp center.x
	WriteFloat fp center.y
	WriteFloat fp center.z
	WriteFloat fp radius
	mesh_data.Write fp
	)

)



rollout a "PBA" width:120 height:58 rolledUp:true
(
	button a1 "Export" pos:[40,33] width:100 height:21 
	button a2 "Import" pos:[40,6] width:100 height:21 
	on a1 pressed do
	(
	local fname = getSaveFileName types:"pba (*.pba)|*.pba|All (*.*)|*.*|"
	
	selNode  = selection[1]
	
	if(selNode == undefined) then (
	MessageBox("Please select the mesh you wish to export")
	return 1
	)
	tmesh =  at time -1 snapshotAsMesh selection[1]
				
		if fname == undefined then return NULL
		fp =  fopen fname "wb"
		WriteLong fp PBA_VERSION
		WriteShort fp CHUNK_PBA_MAIN
		
		filesizePos = (ftell fp) --come back to it later to write
		WriteLong fp -1 --we'll come back to it
		print ("Exporting model " + selNode.name + " ...")
		i =1
		while(fname[i] != ".") do i+=1
		sdot = i-1
		while(fname[i] != "\\") do i-=1
		ffname =  substring fname (i+1) (sdot-i)
		Write32String fp ffname
		WriteShort fp CHUNK_PBA_HUESOS --bones stuff
		WriteLong  fp 10
		WriteLong  fp 0
		--textures used
		WriteLong fp 1
		if (selNode.material == undefined) then return 1
		Write32String fp selNode.material.name 
		
		--CHUNK_PBA_POLEGONS
		WriteShort fp CHUNK_PBA_POOLGEOMS
		offSetTNCpos = ftell fp
		offsetTillNextChunk = -1
		WriteLong fp offsetTillNextChunk --i'll be back :)
		WriteLong fp 1 --number of meshes
		offsetTillNextChunk2 = -1
		
		--CHUNK_PBA_GEOM01
		WriteShort fp CHUNK_PBA_GEOM01
		WriteLong fp offsetTillNextChunk --10 less then prev
		mesh1 = PBA_MESH 3 
		MaxToPraetorians tmesh
		mesh1.name = selNode.name
		collResult = GetCollision tmesh
		mesh1.center = collResult.middle
		mesh1.radius = collResult.radius
		mesh1.mesh_data = GEOMETRIA_ANIMADA 0
		mesh1.mesh_data.numVertices = (getnumverts tmesh)
		mesh1.mesh_data.vertArray = #()
		
		--Loop to setup up the vertices
		for i=1 to mesh1.mesh_data.numVertices do(
		tmpTV = TD3DVERT 0.0 
		xyz = coordsys local((getvert tmesh i))
		tmpTV.x = xyz.x
		tmpTV.y = xyz.y
		tmpTV.z = xyz.z
		nxyz = getnormal tmesh i
		tmpTV.nx = nxyz.x
		tmpTV.ny = nxyz.y
		tmpTV.nz = nxyz.z
		tmpTV.r = tmpTV.g = tmpTV.b = tmpTV.a = 255
		 
		tvertn = 1
		tvertfn = 0
			for k=1 to (getNumFaces tmesh) do(
			tmp3p = getFace tmesh k
			if tmp3p.x == i then (
							ttmp = getTVFace tmesh k
							tvertn = ttmp.x
							)
			if tmp3p.y == i then (
							ttmp = getTVFace tmesh k
							tvertn = ttmp.y
							)
			if tmp3p.z == i then (
							ttmp = getTVFace tmesh k
							tvertn = ttmp.z
							)
			)
		--	tmp3p = getFace tmesh tvertfn
		--	if tmp3p.x == i then tvertn = 1
		--	if tmp3p.y == i then tvertn = 2
		--	if tmp3p.z == i then tvertn = 3
			
		--	tmp3p = getTVFace tmesh tvertfn
		--	if tvertn == 1 then tvertnn = tmp3p.x
		--	if tvertn == 2 then tvertnn = tmp3p.y
		--	if tvertn == 3 then tvertnn = tmp3p.z
		--	print i 
		--	print ","
		--	print tvertnn
			
		uvw1 = getTVert tmesh tvertn
		tmpTV.u = uvw1.x
		tmpTV.v = uvw1.y
		
		append mesh1.mesh_data.vertArray tmpTV
		)

		-- block to setup the facegroups
		mesh1.mesh_data.numFaceGroups =  1
		mesh1.mesh_data.fgArray = #()
		for i=1 to mesh1.mesh_data.numFaceGroups do(
		tmpFg =  FACEGROUP 0 0
		tmpFg.TextureId
		tmpFg.numVerts = mesh1.mesh_data.numVertices
		tmpFg.NumVertInd = (getNumFaces tmesh)*3
		tmpFg.VertInd  = #()
		for k=1 to tmpFg.NumVertInd/3 do(
			facei = getface tmesh k
			--reverse order...
			append tmpFg.VertInd (facei.z-1)
			append tmpFg.VertInd (facei.y-1)
			append tmpFg.VertInd (facei.x-1)
			
		)
		tmpFg.NumCivTextures = 7
		tmpFg.CivTextures = #()
		for k=1 to tmpFg.NumCivTextures do
			append tmpFg.CivTextures ( (substring selnode.material.name 1 (selnode.material.name.count-3) )  + k as string + "_bmp")
		append mesh1.mesh_data.fgArray tmpFg
		)
		
		mesh1.write fp
		--END WRITE GEOMETRY
		WriteShort fp CHUNK_PBA_POOLANIMACIONES
		--grab our current pos
		currentPos = ftell fp
		fseek fp (offSetTNCpos) #seek_set
		WriteLong fp (currentPos-offSetTNCpos)
		fseek fp (offSetTNCpos+10) #seek_set
		WriteLong fp ((currentPos-offSetTNCpos)-10)
		--hop back back
		fseek fp currentPos #seek_set
		WriteLong fp -1 --we'll come back and write this offset till EOF+2
		--START WRITE ANIMATION
		pbaStates = LoadStates()
		WriteLong fp pbaStates.count
		
		if( pbaStates == undefined or pbaStates.count ==0) then Print "No animation states to export"
		else (
		
			
		nthFrame =1
		local sourceObj = snapshot selection[1]
		--fill up our data before we write it
		animSeqs = #()
		for i=1 to pbaStates.count do(
			tmpSeq = SEQUENCE 0
			tmpSeq.AnimVerts = #()
			tmpSeq.name = pbaStates[i].name
			numkeyframes = (pbaStates[i].endframe - pbaStates[i].startframe)+1
			tmpSeq.Duration = numkeyframes * pbaStates[i].time
			tmpSeq.NumAnimatedVertexSeq =1
			tmpSeq.AnimVerts = #()
			for i=1 to tmpSeq.NumAnimatedVertexSeq do(
				tmpAV = ANIMVERTCHUNK 0
				tmpAV.NumKeyframes = numkeyframes
				tmpAV.Numvertices = sourceObj.numVerts
				append tmpSeq.AnimVerts tmpAV
			)
			append animSeqs tmpSeq
		)
		progressStart ("Exporting Frames ...")
		t=0
		tttime=0
		startTime = pbaStates[1].startframe
		endTime = 0 --pbaStates[pbaStates.count].endframe
		for i=1 to pbaStates.count do
			for k=1 to animSeqs[i].NumAnimatedVertexSeq do
			endTime += animSeqs[i].AnimVerts[k].NumKeyFrames
		
		for ol=1 to pbaStates.count do (
				il=1
				ttime = 0
				animSeqs[ol].AnimVerts[il].Keyframes = #()
				t = pbaStates[ol].startframe
			 for nf =1 to animSeqs[ol].AnimVerts[il].NumKeyFrames do( 
			 --sourceObj = snapshot selection[1]
			 	append animSeqs[ol].AnimVerts[il].Keyframes (KEYFRAME ttime)
				animSeqs[ol].AnimVerts[il].Keyframes[nf].byteVect3s = #()
				animSeqs[ol].AnimVerts[il].Keyframes[nf].time = ttime
			 	for i in 1 to sourceObj.numVerts do
				(
					vert = at time t in coordSys selection[1] getVert selection[1] i					
					
					--print (point3 cx cy cz) 
					
					-- prae to max system: max x = z; max y = -x; max z = y
					pvert = point3 -vert.y vert.z vert.x
					append animSeqs[ol].AnimVerts[il].Keyframes[nf].byteVect3s pvert
				)
				ttime+=pbaStates[ol].time
			 	t +=1
				tttime +=1
				local cont = progressUpdate ((tttime - startTime) as float/(endTime - startTime) * 100)
				if NOT cont then return true
			)
		animSeqs[ol].write fp
					
		)--end outer state loop
		delete sourceObj
		progressEnd()
	)--end write aniamtion condition
 	
		
		--our filesize offset
		filesize = ftell fp
		fseek fp filesizePos #seek_set
		WriteLong fp (filesize-4)
		fseek fp currentPos #seek_set
		WriteLong fp ((filesize-currentPos) +2)
		fclose fp	
		print "Export Success"
	) --end button 1
	
	--------------
	--	IMPORT	--
	--------------
	on a2 pressed do --import pba
	(
		local importPly fname = getOpenFileName types:"pba (*.pba)|*.pba|All (*.*)|*.*|"
		if fname == undefined then return NULL
		fp =  fopen fname "rb"
		signature = ReadLong fp
		if(signature != PBA_VERSION) then (
		MessageBox("PBA file version not supported") beep:false
		return NULL
		)
		verision = ReadShort fp
		filesize = ReadLong fp
		name = ReadString fp
		Print name
		for i = 1 to 32-1- name.count do
		tmpchar = ReadByte fp --move the filepointer forward
		fseek fp 10 #seek_cur --skip bones stuff
		numtexts = ReadLong fp
		for i=1 to numtexts do(
		tex_name = ReadString fp
		print tex_name
		if(tex_name.count < 32) then fseek fp (31 - tex_name.count) #seek_cur
		)
		--CHUNK_PBA_POLEGONS
		fseek fp 6 #seek_cur
		numMeshGroups = ReadLong fp
		print numMeshGroups
		for i=1 to numMeshGroups do ( 
		--CHUNK_PBA_GEOM01
		fseek fp 6 #seek_cur
		mesh1 = PBA_MESH 3 
		mesh1.read fp
		print mesh1.name
		print (ftell fp)
		--if(mesh.name.count < 32) then fseek fp (31 - mesh.name.count) #seek_cur
		verts = #()
		faces1 = #()
		normals = #()
		uvw1	= #()
		vc1		= #()
		for k=1 to mesh1.mesh_data.NumVertices do (
		append verts (point3 mesh1.mesh_data.vertArray[k].z -mesh1.mesh_data.vertArray[k].x mesh1.mesh_data.vertArray[k].y)
		append normals (point3 mesh1.mesh_data.vertArray[k].nx mesh1.mesh_data.vertArray[k].ny mesh1.mesh_data.vertArray[k].nz)
		append uvw1 (point3 mesh1.mesh_data.vertArray[k].u mesh1.mesh_data.vertArray[k].v 0.0)
		append vc1 (point3 (mesh1.mesh_data.vertArray[k].r/255) (mesh1.mesh_data.vertArray[k].g/255) (mesh1.mesh_data.vertArray[k].b/255) )
		)
		
		-- prae to max system: max x = z; max y = -x; max z = y
		-- reverse tri ordering
		ic1 = #(0) --keeps track of current entry point of indexes
		for k=1 to mesh1.mesh_data.numFaceGroups do
		append ic1  ((mesh1.mesh_data.fgArray[k].NumVerts) + ic1[k] )
		
		for k=1 to mesh1.mesh_data.numFaceGroups do 
		for j=1 to (mesh1.mesh_data.fgArray[k].NumVertInd) by 3 do(
		--ic2 = icl[k] -- (mesh1.mesh_data.fgArray[k].NumVertInd)
		inda = point3 (mesh1.mesh_data.fgArray[k].VertInd[j+2]+1 ) (mesh1.mesh_data.fgArray[k].VertInd[(j+1)]+1) (mesh1.mesh_data.fgArray[k].VertInd[(j+0)]+1)
		inda.x += (ic1[k])
		inda.y += (ic1[k])
		inda.z += (ic1[k])
		--print ("in k loop : " + k as string)
		append faces1 inda
		 	) --j loop
		 
		local newObj = mesh name:mesh1.name vertices:verts faces:faces1 tverts:uvw1 
		--print (getNumTVerts newObj)
		--setNumTVerts newObj 182
		--setNumCPVVerts newObj mesh1.mesh_data.NumVertices
		defaultVCFaces newObj --buildVCFaces newObj
		for k=1 to mesh1.mesh_data.NumVertices do(
		SetTVert newObj k uvw1[k]
		
		)
		buildTVFaces newObj
		ind = 0
		for k=1 to mesh1.mesh_data.numFaceGroups do 
		for j=1 to (mesh1.mesh_data.fgArray[k].NumVertInd/3) do( --
		ind += 1
		SetTVFace newObj ind faces1[ind]
		SetVCFace newObj ind vc1[ind]
		)
		
		--aniamtion reading
		animCheck = ReadShort fp
		if (animCheck != CHUNK_PBA_POOLANIMACIONES) then  (
		MessageBox("Error Reading Animation or unsupported type")
		print animCheck
		return false
		)
		sizeTillEnd = ReadLong fp
		numSeqs = ReadLong fp
		print numSeqs
		animSeqs = #()
		for i=1 to numSeqs do(
			tmpSeq = SEQUENCE 0
			tmpSeq.Read fp
			append animSeqs tmpSeq
		)
		--print ("File Pointer before closing: " + ( (ftell fp) as string) )
		--return true
		--
		--animation loading
		node_name = newObj.name
		if(IMPORTANIM) then (
		local sourceObj = newObj
		local targObj = snapshot sourceObj
		targObj.parent = sourceObj.parent
		targObj.transform.controller = sourceObj.transform.controller
		animateVertex targObj #all
		local masterCtrl = targObj[4][1]	-- shortcut to vertex controllers

		local masterCtrl = targObj[4][1]	-- shortcut to vertex controllers

						-- assign OOR types
						--for i in 1 to targObj.numVerts do (
						--	setBeforeORT masterCtrl[i].controller (OORTypes[InOORType] as name)
						--	setAfterORT masterCtrl[i].controller (OORTypes[OutOORType] as name)
						--)
		startTime = 0 
		endTime =0
		nthFrame =1
		for i=1 to numSeqs do
			for k=1 to animSeqs[i].NumAnimatedVertexSeq do
			endTime += animSeqs[i].AnimVerts[k].NumKeyFrames
		print ("Number of Keyframes :" + (endtime as string))
		
		progressStart ("Importing Frames ...")
		t=0
		for i in 1 to targObj.numVerts do
				(
					k = addNewKey masterCtrl[i].controller -1
				)
		
				local k								-- key added for each vert
			 for ol=1 to numSeqs do
				for il=1 to 1 do --animSeqs[ol].NumAnimatedVertexSeq
			 for nf =1 to animSeqs[ol].AnimVerts[il].NumKeyFrames do( 
			 		minx =animSeqs[ol].AnimVerts[il].MinBox.x
					maxx =animSeqs[ol].AnimVerts[il].MaxBox.x 
					miny =animSeqs[ol].AnimVerts[il].MinBox.y
					maxy =animSeqs[ol].AnimVerts[il].MaxBox.y
					minz =animSeqs[ol].AnimVerts[il].MinBox.z
					maxz =animSeqs[ol].AnimVerts[il].MaxBox.z
			 	for i in 1 to targObj.numVerts do
				(
					k = addNewKey masterCtrl[i].controller t					
					cx   =animSeqs[ol].AnimVerts[il].keyframes[nf].byteVect3s[i].x as float
					cy   =animSeqs[ol].AnimVerts[il].keyframes[nf].byteVect3s[i].y as float
					cz   =animSeqs[ol].AnimVerts[il].keyframes[nf].byteVect3s[i].z as float
					ex = (((maxx-minx)/255.0) *cx) + minx 
					ey = (((maxy-miny)/255.0) *cy) + miny 
					ez = (((maxz-minz)/255.0) *cz) + minz 
					--print (point3 cx cy cz) 
					
					-- prae to max system: max x = z; max y = -x; max z = y
					k.value = point3 ez -ex ey --at time t in coordSys sourceObj getVert sourceObj i
				)
				--print ("count" + t as string)
			 t +=1 -- animSeqs[ol].AnimVerts[il].NumKeyFrames
			gc() --garbage collection
				local cont = progressUpdate ((t - startTime) as float/(endTime - startTime) * 100)
				if NOT cont then return true
				)
			--)
	
		progressEnd()
		animationRange =  interval 0 endTime
		modelname = newObj.name 
		delete newObj --= targObj
		targObj.name =  modelname
		)
		--end animation
		--add states to scene data
		currentFrame =0
		for ol=1 to  numSeqs do(
		numFrames = animSeqs[ol].AnimVerts[1].NumKeyFrames
		anim_name = animSeqs[ol].Name
		anim_number = ol
		node = getNodeByName node_name
			prop_name = "anim_name_" + (anim_number as string)
			setUserProp node prop_name anim_name
			prop_name = "anim_firstframe_" + (anim_number as string)
			setUserProp node prop_name currentFrame
			prop_name = "anim_lastframe_" + (anim_number as string)
			setUserProp node prop_name (currentFrame + (numFrames-1))
			prop_name = "anim_transtime_" + (anim_number as string)
			setUserProp node prop_name (animSeqs[ol].Duration / (animSeqs[ol].AnimVerts[1].NumKeyFrames-1) )
		currentFrame += numFrames	
		    )
		select(getNodeByName node_name)
		
		--end states
		print ("File Pointer before closing: " + ( (ftell fp) as string) )
		print "Import completed without errors"
		fclose fp
		
		)

	)
)
-------
--  ANIMATION ROLLOUT
-------
rollout AnimationPropRollout "Animation States" width:160 height:488 rolledUp:true
(
	listBox anim_list "" pos:[8,8] width:144 height:9
	groupBox grp1 "Properties" pos:[8,160] width:144 height:128
	button add_anim_button "Add" pos:[8,136] width:40 height:20
	button delete_anim_button "Delete" pos:[56,136] width:48 height:20
	button zoom_to_anim_button "Zoom" pos:[112,136] width:40 height:20
	editText anim_name "" pos:[56,184] width:88 height:16
	spinner first_frame "" pos:[80,208] width:64 height:16 range:[0,10000,0] type:#integer scale:1
	spinner last_frame "" pos:[80,232] width:64 height:16 range:[0,10000,0] type:#integer scale:1
	label lbl1 "First Frame:" pos:[16,208] width:56 height:16
	label lbl2 "Last Frame:" pos:[16,232] width:56 height:16
	label lbl3 "Name:" pos:[16,184] width:32 height:16
	spinner transition "" pos:[80,256] width:64 height:16 range:[0,100,40] type:#integer scale:1
	label lbl4 "Transition" pos:[16,256] width:48 height:16
	
	
			
	fn FindAnimByName lookup_name=
(
	if ((lookup_name == undefined) ) then return undefined
	local node = selection[1]
	if node == undefined then return undefined

	local user_props = getUserPropBuffer(selection[1]) as stringstream
	while not eof user_props do
	(
		local prop = readDelimitedString user_props "\n"
		if ((findString prop "anim_name") == 1) then
		(
			local anim_name = trimleft (trimright (substring prop ((findstring prop "=")+1) -1))
			if (anim_name == lookup_name) then
			(
				local anim_number = substring prop 11 ((findstring prop "=")-11)
				anim_number = trimright anim_number
				return (anim_number as integer)
			)
		)
	)
	return undefined
)
	fn LoadSelectedAnimation=
	(   
		LastAnimNumber = FindAnimByName(AnimationPropRollout.anim_list.selected)
		if (LastAnimNumber != undefined) then
		(
			local node = selection[1]
			local prop_name
			prop_name = "anim_name_" + (LastAnimNumber as string)
			AnimationPropRollout.anim_name.text = getUserProp node prop_name 
			prop_name = "anim_firstframe_" + (LastAnimNumber as string)
			AnimationPropRollout.first_frame.value = getUserProp node prop_name 
			prop_name = "anim_lastframe_" + (LastAnimNumber as string)
			AnimationPropRollout.last_frame.value = getUserProp node prop_name
			prop_name = "anim_transtime_" + (LastAnimNumber as string)
			AnimationPropRollout.transition.value = getUserProp node prop_name
			
		) 
		else
		( 
			AnimationPropRollout.anim_name.text = "" 
			AnimationPropRollout.first_frame.value = 0 
			AnimationPropRollout.last_frame.value = 0
			AnimationPropRollout.transition.value = 0
			
		)
	)

	fn ZoomToAnim=
	(
		local firstframe = AnimationPropRollout.first_frame.value
		local lastframe = AnimationPropRollout.last_frame.value
		if (firstframe < lastframe) then 
		(
			animationRange = (interval firstframe lastframe)
			sliderTime = firstframe
		)
	)
		
	fn ChangeAnimProperty property new_val=
	(
		--if ((LastAnimNumber != undefined) and (AnimRootNodeName != undefined)) then
		--(
			local node = selection[1]
			local prop_name = "anim_" + property + "_" + (AnimationPropRollout.anim_list.selection as string)
			setUserProp node prop_name new_val
			
		--)
	)

	on anim_list selected list_idx do LoadSelectedAnimation()
	on anim_list doubleClicked list_idx do ZoomToAnim()
	fn FindFreeAnimNumber=
	(
	local i = 0
	local node = selection[1]
	while (true) do
	(
		i += 1
		local prop_name = "anim_name_" + (i as string)
		local anim_name = getUserProp node prop_name
		if ((anim_name == undefined) or (anim_name == "")) then return i
	)
	)
	on add_anim_button pressed do
	(
		local node = selection[1]
		if (node != undefined) then
		(
			local anim_number = FindFreeAnimNumber()
			local anim_name = "untitled" + (anim_number as string)
			local prop_name
			prop_name = "anim_name_" + (anim_number as string)
			setUserProp node prop_name anim_name
			prop_name = "anim_firstframe_" + (anim_number as string)
			setUserProp node prop_name 0
			prop_name = "anim_lastframe_" + (anim_number as string)
			setUserProp node prop_name 1
			prop_name = "anim_transtime_" + (anim_number as string)
			setUserProp node prop_name 40

			local newlist = AnimationPropRollout.anim_list.items 
			append newlist anim_name
			AnimationPropRollout.anim_list.items = newlist
			AnimationPropRollout.anim_list.selection = newlist.count
			LoadSelectedAnimation()
		)
	)
	
    on delete_anim_button pressed do
    (
	    local sel = AnimationPropRollout.anim_list.selection
		if (sel > 0) then
		(
			ChangeAnimProperty "name" ""
			AnimationPropRollout.anim_list.selection = 0
			LoadSelectedAnimation()
			
			local newlist = AnimationPropRollout.anim_list.items 
			deleteItem newlist sel
			AnimationPropRollout.anim_list.items = newlist
		)
    )
    
	on zoom_to_anim_button pressed do ZoomToAnim()

	on anim_name changed new_val do 
	(
		ChangeAnimProperty "name" new_val
		if (AnimationPropRollout.anim_list.selection > 0) then
			AnimationPropRollout.anim_list.selected = new_val
	)
	
	on first_frame changed new_val do ChangeAnimProperty "firstframe" new_val
	on last_frame changed new_val do ChangeAnimProperty "lastframe" new_val
	on transition changed new_val do ChangeAnimProperty "transition" new_val

	
)
fn updateUI = (
local user_props = getUserPropBuffer(selection[1]) as stringstream
		local anim_name_array = #()
		while not eof user_props do
		( 
			local prop = readDelimitedString user_props "\n"
			if ((findString prop "anim_name") == 1) then
			(	
				local anim_name = trimleft (trimright (substring prop ((findstring prop "=")+1) -1))
				if (anim_name != "") then append anim_name_array anim_name
			)
		)
		AnimationPropRollout.anim_list.items = anim_name_array	
		AnimationPropRollout.anim_list.selection = 0
)
updateUI -- call it once

rof=newrolloutfloater "PBA Import/Export" 200 350
addrollout a rof  
addrollout AnimationPropRollout rof
rof.size=[200,350]
