require 'lol_model_format/skl_file'
require 'lol_model_format/skn_file'
require 'lol_model_format/anm_file'
require 'lol_model_format/ext/md2_file'
require "erb"
require "haml"
require "json"

module LolModelFormat
    
    class LolModel
        
        include LolModelFormat::Ext

        #must be set when initialize, can't change for the time being
        attr_reader :skeleton_file, :skin_file, :animation_files
        
        def initialize(skl, skn, anms = {})
            @skeleton_file = skl
            @skin_file = skn
            @animation_files = anms
        end
        
        def get_md2_skin_coords(skinwidth, skinheight)
            skin_coords = []
            
            @skin_file.vertices.each do |v|
                coord = Md2File::SkinCoord.new
                coord.s = (skinwidth * v.tex_coords.x).to_i
                coord.t = (skinheight * v.tex_coords.y).to_i
                skin_coords	<< coord
            end
            
            skin_coords
        end
        
        def get_md2_trianles()
            triangles = []
            
            0.upto (@skin_file.indices.size / 3) do |i|
                
                #three vertex of a single triangle
                a = @skin_file.indices[3 * i]
                b = @skin_file.indices[3 * i + 1]
                c = @skin_file.indices[3 * i + 2]
                
                tri = Md2File::Triangle.new
                tri.index_xyz = [a, b, c]
                tri.index_st = [a, b, c]
                
                triangles << tri
            end
            
            triangles
        end
        
        def get_md2_frame(frame_name, vertices)
            puts frame_name
            
            frame = Md2File::Frame.new
            
            v_x_max = vertices.max_by { |v|  v.position.x.abs}.position.x
            v_y_max = vertices.max_by { |v|  v.position.y.abs}.position.y
            v_z_max = vertices.max_by { |v|  v.position.z.abs}.position.z			
            
            frame.scale.x = 2 * v_x_max / 256.0
            frame.scale.y = 2 * v_y_max / 256.0
            frame.scale.z = 2 * v_z_max / 256.0
            
            frame.translate.x = -v_x_max
            frame.translate.y = -v_y_max
            frame.translate.z = -v_z_max
            
            frame.name = frame_name			
            
            vertices.each do |v|
                
                vertex = Md2File::Vertex.new	
                x = ((v.position.x - frame.translate.x) / frame.scale.x).to_i
                y = ((v.position.y - frame.translate.y) / frame.scale.y).to_i
                z = ((v.position.z - frame.translate.z) / frame.scale.z).to_i
                
                #puts "[#{v.inspect}] => [#{x}, #{y}, #{z}]"
                            
                vertex.v = [x, y, z]
                
                normal = v.normal
                vertex.normal_index = 0
                vertex.normal_index = Md2File.get_anorms_index(
                                        normal.x, normal.y, normal.z)
                frame.verts << vertex		
            end
            
            frame
        end
        
        def get_md2_skl_trianles(count)
            triangles = []
            
            0.upto count do |i|
                
                #three vertex of a single triangle
                a = 4 * i
                b = 4 * i + 1
                c = 4 * i + 2
                
                tri = Md2File::Triangle.new
                tri.index_xyz = [a, b, c]
                tri.index_st = [a, b, c]
                
                triangles << tri
                
                #three vertex of a single triangle
                a = 4 * i
                b = 4 * i + 1
                c = 4 * i + 3
                
                tri = Md2File::Triangle.new
                tri.index_xyz = [a, b, c]
                tri.index_st = [a, b, c]
                
                triangles << tri
                
                #three vertex of a single triangle
                a = 4 * i
                b = 4 * i + 3
                c = 4 * i + 2
                
                tri = Md2File::Triangle.new
                tri.index_xyz = [a, b, c]
                tri.index_st = [a, b, c]
                
                triangles << tri
                
                #three vertex of a single triangle
                a = 4 * i + 3
                b = 4 * i + 1
                c = 4 * i + 2
                
                tri = Md2File::Triangle.new
                tri.index_xyz = [a, b, c]
                tri.index_st = [a, b, c]
                
                triangles << tri
            end
            
            triangles       	
        end
        
        def apply_joint_vertext_default(vertex, bone_id)
	        vertex.normal.x = -0.525731
	        vertex.normal.y = 0.000000
	        vertex.normal.z = 0.850651
	        
	        [bone_id, 0, 0, 0].each do |bi|
	            vertex.bone_index << bi
	        end
	        
            [1.0, 0.0, 0.0, 0.0].each do |w|
                vertex.weights << w
            end
            
            #vertex.tex_coords.x = v.tex_coords.x
            #vertex.tex_coords.y = v.tex_coords.y
            
            vertex
        end
        
        def get_vertices_from_skl(skl, offset)
            vertices = []
            
            skl.bones.each do |i, b|
                
                next unless @skeleton_file.bone_ids.include? i    
                
                unless b.root?
                	
                	bone_transformer = skl.bones[i].transform
                	
                	b_position = RVec3.new(0.0, 0.0, 0.0).transformCoord(bone_transformer)
                	
                	b_position = RVec3.new(b.position.x, b.position.y, b.position.z)
                	
                    #top
                    vertex = SknFile::SknVertex.new
                    vertex.position.x = b_position.x
                    vertex.position.y = b_position.y
                    vertex.position.z = b_position.z

                    vertex = apply_joint_vertext_default(vertex, i)
                    
                    #bottom three vertexes
                    
                    bone_parent_transformer = skl.bones[b.parent_id].transform
                    
                    bp_position = RVec3.new(0.0, 0.0, 0.0).transformCoord(bone_parent_transformer)                    
                    bp = b.parent                    
                    bp_position = RVec3.new(bp.position.x, bp.position.y, bp.position.z)
                                
                    #parent                    
                    vertex_parent = SknFile::SknVertex.new
                    vertex_parent.position.x = bp_position.x
                    vertex_parent.position.y = bp_position.y
                    vertex_parent.position.z = bp_position.z
                    
                    vertex_parent = apply_joint_vertext_default(vertex_parent, b.parent_id)
                    
                    #slightly offset
                    vertex_helper = SknFile::SknVertex.new
                    vertex_helper.position.x = bp_position.x + offset
                    vertex_helper.position.y = bp_position.y - offset
                    vertex_helper.position.z = bp_position.z + offset
                    
                    vertex_helper = apply_joint_vertext_default(vertex_helper, b.parent_id)
                    
                    #slightly offset 2
                    vertex_helper2 = SknFile::SknVertex.new
                    vertex_helper2.position.x = bp_position.x - offset
                    vertex_helper2.position.y = bp_position.y + offset
                    vertex_helper2.position.z = bp_position.z - offset
                    
                    vertex_helper2 = apply_joint_vertext_default(vertex_helper2, b.parent_id)        			
                    
                    vertices << vertex
                    vertices << vertex_parent
                    vertices << vertex_helper
                    vertices << vertex_helper2
                else
                	bone_transformer = skl.bones[i].transform
                	
                	b_position = RVec3.new(0.0, 0.0, 0.0).transformCoord(bone_transformer)
                	b_position = RVec3.new(b.position.x, b.position.y, b.position.z)
                	
                    vertex = SknFile::SknVertex.new
                    vertex.position.x = b_position.x
                    vertex.position.y = b_position.y
                    vertex.position.z = b_position.z
                    
                    vertex = apply_joint_vertext_default(vertex, i)
                    
                    vertices << vertex
                    vertices << vertex
                    vertices << vertex
                    vertices << vertex 			
                end
            end
            
            vertices	        	
        end
        
        def get_skl_from_anm_frame(anm_file, frame_index)
            skeleton = Skeleton.new
            
            anm_file.bones.each_with_index do |bone, i|
                frame = bone.frames[frame_index]
                
                static_bone = static_skeleton.bones[i]
                
                b = Bone.new skeleton
                
                b.index = i
                b.name = bone.name
                b.parent_id = static_bone.parent_id
                b.scale = static_bone.scale
            
                b.orientation = frame.orientation
                b.position = frame.position	
                
                skeleton.bones[i] = b
            end
            
            skeleton.absolutify!
            skeleton
        end
        
        
        def to_md2_skl
            md2 = Md2File.new
            
            #TODO make skin size configurable
            md2.header.skinwidth = 512
            md2.header.skinheight = 512
            
            #Skin files are always external, so skin names aren't always useful
            md2.skin_names = []
            #OpenGL Commands aren't always useful too
            md2.gl_cmds = []	        
            
            #skin coord to UV-map the texturre/skin on the model
            md2.skin_coords = get_md2_skin_coords(md2.header.skinwidth, md2.header.skinheight)
            
            offset = 0.3
            
            #trianle that determines how all vertexes form faces TODO
            puts static_skeleton.bones.size
            
            static_vertices = get_vertices_from_skl(static_skeleton, offset)
            md2.triangles = get_md2_skl_trianles(static_vertices.size / 3)
            
            #add a frame to describe the static skeleton
            md2.frames << get_md2_frame("skl_static001", static_vertices)
            
            if false
	            @animation_files.each do |name, anm_file|
	                
	                0.upto anm_file.number_of_frames - 1 do |frame_index|
	                #1.upto 2 do |frame_index|
	                    puts frame_index	
	                                    
	                        formated_frame_name = "skl_%s%03d" % [escape_md2_frame_name(name), frame_index + 1] 
	                        
	                        skeleton = get_skl_from_anm_frame(anm_file, frame_index)
	                                        
	                        md2.frames << get_md2_frame(formated_frame_name, get_vertices_from_skl(skeleton, offset))
	                    end
	            end	            
            else            
	            @animation_files.each do |name, anm_file|
	                get_animated_vertice_frames(static_vertices, anm_file).each_with_index do |frame_vertices, i|
	                    formated_frame_name = "skl_%s%03d" % [escape_md2_frame_name(name), i + 1]
	                    md2.frames << get_md2_frame(formated_frame_name, frame_vertices)
	                end
	            end
            end

            md2
        end

        def to_md2
            md2 = Md2File.new
            
            #TODO make skin size configurable
            md2.header.skinwidth = 512
            md2.header.skinheight = 512
            
            #Skin files are always external, so skin names aren't always useful
            md2.skin_names = []
            #OpenGL Commands aren't always useful too
            md2.gl_cmds = []	        
            
            #skin coord to UV-map the texturre/skin on the model
            md2.skin_coords = get_md2_skin_coords(md2.header.skinwidth, md2.header.skinheight)
            
            #trianle that determines how all vertexes form faces
            md2.triangles = get_md2_trianles
            
            #add a frame to describe the static model
            md2.frames << get_md2_frame('static001', @skin_file.vertices)

            @animation_files.each do |name, anm_file|
                get_animated_vertice_frames(@skin_file.vertices, anm_file).each_with_index do |frame_vertices, i|
                    formated_frame_name = "%s%03d" % [escape_md2_frame_name(name), i + 1]
                    md2.frames << get_md2_frame(formated_frame_name, frame_vertices)
                end
            end

            md2
        end

        #COLLADA 
        def to_dae(model_name = nil)
            @model = {}

            positions = []
            normals = []
            tex_coords = []
            triangles = []
            weights = []
            vcount_array = []
            v_array = []

            @skin_file.vertices.each_with_index do |v, i|
                positions << v.position.x.to_f.round(4)
                positions << v.position.y.to_f.round(4)
                positions << v.position.z.to_f.round(4)

                normals << v.normal.x.to_f.round(6)
                normals << v.normal.y.to_f.round(6)
                normals << v.normal.z.to_f.round(6)

                tex_coords << v.tex_coords.x.to_f.round(6)
                tex_coords << -v.tex_coords.y.to_f.round(6)

                v.weights.to_a.each do |weight|
                   weights << weight.to_f.round(6)
                end

                vcount_array << 4

                v_array << 4 * i
                v_array << 4 * i + 1
                v_array << 4 * i + 2
                v_array << 4 * i + 3
            end
            
            @model["positions-array"] = positions.join " "
            @model["positions-array-size"] = positions.size

            @model["normals-array"] = normals.join " "
            @model["normals-array-size"] = normals.size

            @model["map-array"] = tex_coords.join " "
            @model["map-array-size"] = tex_coords.size

            @skin_file.indices.each do |i|
                1.upto 3 do
                    triangles << i
                end                
            end

            @model["triangles-array"] = triangles.to_a.join " "

            #computedLen = ((triangleData.length) / cl_inputmap.length) / 3;
            # cl_inputmap: [VERTEX NORMAL TEXCOORD].size == 3
            @model["triangles-array-size"] = triangles.size / 9
            @model["texture-file-name"] = "#{model_name || 'texture'}.jpg" 

            @model["weights-array-size"] = weights.size
            @model["weights-array"] = weights.join ' '

            @model["vcount-array"] = vcount_array.join " "
            @model["v-array"] = v_array.join " "

            @model["vertex-weights-count"] = @skin_file.vertices.size

            bone_trees, name_arrays = gen_bone_tree_from_skl

            puts JSON.pretty_generate(bone_trees)
            puts JSON.pretty_generate(name_arrays)

            @model["bone-tree"] = bone_trees
            @model["skeleton-names"] = name_arrays["root"]            
            @model["joints-name-array"] = @model["skeleton-names"].join ' '
            @model["joints-name-array-size"] = @model["skeleton-names"].size 

            bind_poses_array = []

            @model["skeleton-names"].each do |joint_name|
                bind_poses_array += skeleton_file.bones[bone_name_to_index_map[joint_name]].transform.getInverse.getTransposed.to_a
            end

            #bone_name_to_index_map

            @model["bind-poses-array"] = bind_poses_array.join " "
            @model["bind-poses-array-size"] = bind_poses_array.size

            @model["bind-shape-matrix"] = "1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"

            static_skeleton

            #builder = Nokogiri::XML::Builder.new do |xml|
            #  xml.root {
            #    xml.products {
            #      xml.widget {
            #        xml.id_ "10"
            #        xml.name "Awesome widget"
            #      }
            #    }
            #  }
            #end
            #puts builder.to_xml

            haml_engine = Haml::Engine.new(File.read(File.expand_path('../ext/model.dae.haml', __FILE__)), 
                :attr_wrapper => '"', :format => :xhtml)

            haml_engine.render binding

            #· Bind Pose: visual_scenes node[type="JOINT"] matrix 
            #· Inverse Bind Pose: library_controllers controller skin source
            #· Bind Shape matrix: library_controllers controller skin bind_shape_matrix 
            #· Bone Weights: library_controllers controller skin vertex_weights 
            #· Time and Matrix for each key frame for a specific joint:
            #  library_animations animation#"joint’s name and “matrix”"

            # mesh: not visual_scenes instance_geometry
            # visual_scenes instance_controller 
            #doc = Nokogiri::XML(open(''))
            #doc.css("visual_scene > node:not([type='JOINT']) > instance_geometry")
            #instance_controller = doc.css("visual_scene > node:not([type='JOINT']) > instance_controller")
            #controller = doc.css("controller#{instance_controller.attr('url')}")
            #"geometry#{controller.css(' > skin').attr('source')}"
            #root_joint_node = nil
            #instance_controller.css('> skeleton').each do |skeleton|
            #    if node = doc.css("visual_scenes > node#{skeleton.text}")
            #        root_joint_node = node
            #    end
            #end
#
            #controller.css(' > skin bind_shape_matrix')
            #joint_name_source = controller.css(' > skin > joints > input[semantic="JOINT"]').attr('source')
            #inv_bind_matrix_source_id = controller.css(' > skin > joints > input[semantic="INV_BIND_MATRIX"]').attr('source')
            #inv_bind_matrix_source = controller.css(" > skin > source#{inv_bind_matrix_source_id}" # float array
            #controller.css(' > skin > vertex_weights > input[semantic="WEIGHT"]').attr('source')
            #controller.css(' > skin > vertex_weights > vcount')
            #controller.css(' > skin > vertex_weights > v')
#


            #Position = VertexPosition x (Bind Shape x Σ(MatrixPallette[n] x Weight[n]))
            #where 0<=n<4
            #MatrixPallette[n] = inverseBindPose[n] x worldTransforms[n]
            #worldTransforms[n] = BindPose[n] x worldTransforms[parent]

            #One major difference in the reading of a skinned mesh in comparison to a static
            #mesh in COLLADA is that when you find the mesh’s node representation in the
            #<visual_scenes> it will not have an <instance_geometry> child, it will instead
            #have an <instance_controller> child and finding the geometry for it requires a
            #bit of extra work. But it’s an important note because it’s an easy mistake to make.
            #Another note that I think deserves a mention, you may be thinking that if you
            #have the bind pose for a joint, then you can get the inverse bind pose by just
            #inversing it using a D3DXMatrixInverse() function etc, I have found that this is not
            #the case unfortunately, though I haven’t tested this too thoroughly. You shouldn’t
            #ever really need to make your own inverse bind pose anyway but I thought it was
            #still an important note.
        end

        #COLLADA 
        def to_dae_by_erb(model_name = nil)
            @model = {}

            positions = []
            normals = []
            tex_coords = []
            triangles = []

            @skin_file.vertices.each do |v|
                positions << v.position.x.to_f.round(4)
                positions << v.position.y.to_f.round(4)
                positions << v.position.z.to_f.round(4)

                normals << v.normal.x.to_f.round(6)
                normals << v.normal.y.to_f.round(6)
                normals << v.normal.z.to_f.round(6)

                tex_coords << v.tex_coords.x.to_f.round(6)
                tex_coords << -v.tex_coords.y.to_f.round(6)
            end
            
            @model["positions-array"] = positions.join " "
            @model["positions-array-size"] = positions.size

            @model["normals-array"] = normals.join " "
            @model["normals-array-size"] = normals.size

            @model["map-array"] = tex_coords.join " "
            @model["map-array-size"] = tex_coords.size

            @skin_file.indices.each do |i|
                1.upto 3 do
                    triangles << i
                end                
            end

            @model["triangles-array"] = triangles.to_a.join " "

            #computedLen = ((triangleData.length) / cl_inputmap.length) / 3;
            # cl_inputmap: [VERTEX NORMAL TEXCOORD].size == 3
            @model["triangles-array-size"] = triangles.size / 9
            @model["texture-file-name"] = "#{model_name || 'texture'}.jpg" 


            ##· Bind Pose: visual_scenes node[type="JOINT"] matrix 
            ##· Inverse Bind Pose: library_controllers controller skin source
            ##· Bind Shape matrix: library_controllers controller skin bind_shape_matrix 
            ##· Bone Weights: library_controllers controller skin vertex_weights 
            ##· Time and Matrix for each key frame for a specific joint:
            ##  library_animations animation#"joint’s name and “matrix”"
#
            ## mesh: not visual_scenes instance_geometry
            ## visual_scenes instance_controller 
            #doc = Nokogiri::XML(open(''))
            #doc.css("visual_scene > node:not([type='JOINT']) > instance_geometry")
            #instance_controller = doc.css("visual_scene > node:not([type='JOINT']) > instance_controller")
            #controller = doc.css("controller#{instance_controller.attr('url')}")
            #"geometry#{controller.css(' > skin').attr('source')}"
            #root_joint_node = nil
            #instance_controller.css('> skeleton').each do |skeleton|
            #    if node = doc.css("visual_scenes > node#{skeleton.text}")
            #        root_joint_node = node
            #    end
            #end
#
            #controller.css(' > skin bind_shape_matrix')
            #joint_name_source = controller.css(' > skin > joints > input[semantic="JOINT"]').attr('source')
            #inv_bind_matrix_source_id = controller.css(' > skin > joints > input[semantic="INV_BIND_MATRIX"]').attr('source')
            #inv_bind_matrix_source = controller.css(" > skin > source#{inv_bind_matrix_source_id}" # float array
            #controller.css(' > skin > vertex_weights > input[semantic="WEIGHT"]').attr('source')
            #controller.css(' > skin > vertex_weights > vcount')
            #controller.css(' > skin > vertex_weights > v')
#
#
#
            ##Position = VertexPosition x (Bind Shape x Σ(MatrixPallette[n] x Weight[n]))
            ##where 0<=n<4
            ##MatrixPallette[n] = inverseBindPose[n] x worldTransforms[n]
            ##worldTransforms[n] = BindPose[n] x worldTransforms[parent]
#
            ##One major difference in the reading of a skinned mesh in comparison to a static
            ##mesh in COLLADA is that when you find the mesh’s node representation in the
            ##<visual_scenes> it will not have an <instance_geometry> child, it will instead
            ##have an <instance_controller> child and finding the geometry for it requires a
            ##bit of extra work. But it’s an important note because it’s an easy mistake to make.
            ##Another note that I think deserves a mention, you may be thinking that if you
            ##have the bind pose for a joint, then you can get the inverse bind pose by just
            ##inversing it using a D3DXMatrixInverse() function etc, I have found that this is not
            ##the case unfortunately, though I haven’t tested this too thoroughly. You shouldn’t
            ##ever really need to make your own inverse bind pose anyway but I thought it was
            ##still an important note.
#
            ERB.new(File.read(File.expand_path('../ext/model.dae.erb', __FILE__))).result binding
        end
        
        def escape_md2_frame_name(name)
            #          0 1 2 3 4 5 6 7 8 9
            table = %W[Z A B C D E F G H I]
            escaped_name = name.gsub(/\d/) do |digit|
                table[digit.to_i]
            end
            
            escaped_name
        end
        
        class Bone
            
            attr_accessor :skeleton
            attr_accessor :index, :name, :parent_id, :scale
            attr_accessor :orientation, :position, :transform, :local_transform
            attr_reader :reverse_transform
            
            def initialize(skl)        		
                @absolute = false   
                @skeleton = skl     		
                ##-1 reserved for root
                #@parent = -2
                #@scale = 0.0
                #@transform = RMtx4.new
                ##Quaternion
                #@orientation = RQuat.new
            end
            
            def root?
                @parent_id == -1 || @parent_id == 4294967295
            end
            
            def absolute?
                #root? ||                 
                @absolute
            end
            
            def parent
                return nil if root?
                @skeleton.bones[parent_id]
            end            
            
            def absolutify!
                return if absolute?                
                
                
                local_transform = RMtx4.new.rotationQuaternion(@orientation)      
                local_transform *= RMtx4.new.translation(@position.x, @position.y, @position.z)
                  
                #local_transform *= RMtx4.new.scaling(scale, scale, scale) 
                
                #/ 
                if root?
                    # No parent bone for root bones.
                    # So, just calculate directly.                                       
                    @transform = local_transform
                    @reverse_transform = @transform.getInverse
                    @orientation = @orientation
                else
                    #recursively up
                    parent.absolutify! unless parent.absolute? 
                    
                    # Append matrices for position transform A * B
                    # Append quaternions for rotation transform B * A
                    @transform = local_transform * parent.transform
                    @reverse_transform = @transform.getInverse
                    @orientation = parent.orientation * @orientation
                end
                
                #ensure that now it's absolute
                @absolute = true
            end

            def to_s
                "bone<#{index}:#{name}:#{position}:#{orientation}:#{scale}:[#{local_transform}]>"
            end

            def to_json(*a)
                to_s
            end

            def toAxisAngle
                aixs, angle = orientation.toAxisAngle
                [aixs.x, aixs.y, aixs.z, angle * 180 / 3.14159]
            end
        end
        
        class Skeleton
            
            attr_accessor :bones
            
            def initialize        		
                @bones = {}
            end
            
            def absolutify!
                bones.each do |i, b|
                    b.absolutify!
                end
            end
        end
        
        def static_skeleton
            @static_skeleton ||= gen_static_skeleton_from_skl
        end

        def bone_name_to_index_map
            unless @bone_name_to_index_map
                @bone_name_to_index_map = {}
                static_skeleton.bones.each do |index, bone|
                    @bone_name_to_index_map[bone.name.to_s] = bone.index
                end
            end
            @bone_name_to_index_map
        end
        
        def gen_static_skeleton_from_skl
            skeleton = Skeleton.new
            
            @skeleton_file.bones.each_with_index do |bone, i|
                
                b = Bone.new skeleton
                
                b.index = i
                b.name = bone.name
                b.parent_id = bone.parent_id
                b.scale = bone.scale

                b.orientation = bone.orientation
                b.position = bone.position	

                skeleton.bones[i] = b
            end
            
            skeleton.absolutify!
                        
            skeleton
        end

        def gen_bone_tree_from_skl
            bone_trees = []

            skeleton = Skeleton.new
            
            @skeleton_file.bones.each_with_index do |bone, i|
                
                b = Bone.new skeleton
                
                b.index = i
                b.name = bone.name
                b.parent_id = bone.parent_id
                b.scale = bone.scale

                b.orientation = bone.orientation
                b.position = bone.position
                b.local_transform = bone.transform

                skeleton.bones[i] = b
            end

            #puts skeleton.bones
            
            root_bone_index = []

            skeleton.bones.each { |i, bone| root_bone_index << bone.index if bone.root? }

            puts root_bone_index

            raise "root bone not found!" if root_bone_index.size == 0
            #raise "more than one root bone!" if root_bone_index.size > 1 
            name_arrays = {}

            root_bone_index.each do |index|
                bone_tree, name_array = add_children_recursively(skeleton, index)
                bone_trees << bone_tree
                name_arrays[skeleton.bones[index].name.to_s] = name_array
            end

            [bone_trees, name_arrays]
        end

        def add_children_recursively(skeleton, i, name_array = [])
            current_bone = { bone: skeleton.bones[i], children: [] }
            name_array << skeleton.bones[i].name.to_s

            skeleton.bones.each do |j, bone|
                if bone.parent_id == skeleton.bones[i].index
                    current_bone_tree, name_array = add_children_recursively(skeleton, bone.index, name_array)   
                    current_bone[:children] << current_bone_tree
                end
            end

            #puts current_bone[:bone].index

            [current_bone, name_array]
        end
        
        def remap_bone_index(i)

            bone_index = 0
            
            if @skeleton_file.version == 2
                if i < @skeleton_file.bone_ids.size     
                    bone_index = @skeleton_file.bone_ids[i]
                else
                    puts "ALERT: #{i} => 0"
                    bone_index = 0
                end	 
            else
                bone_index = i
            end
            
            bone_index
        end

        def get_animated_vertice_frames(vertices, anm_file)
            vertice_frames = []
            
            #0.upto anm_file.number_of_frames - 1 do |frame_index|
            0.upto 5 do |frame_index|
                puts frame_index
                
                frame_vertices =[]
                
                skeleton = get_skl_from_anm_frame(anm_file, frame_index)
                
                vertices.each do |v|
                    vertex = SknFile::SknVertex.new
                    
                    #// Transform the vertex information based on bones.
                    position = RVec3.new
                    normal = RVec3.new
                    total_weight = 0.0
                    
                    0.upto 3 do |i|
                        bone_index = remap_bone_index(v.bone_index[i])
                        
                        static_bone = static_skeleton.bones[bone_index]
                        
                        scale = static_bone.scale.value
                        
                        bone_transformer =  static_bone.reverse_transform
                        bone_transformer *= skeleton.bones[bone_index].transform
                        
                         #static_skeleton.bones[bone_index].reverse_transform * 
                        
                        
                        #bone_transformer = RMtx4.new.rotationY(0.314 * frame_index)
                        
                        v_postion = RVec3.new(v.position.x.value, v.position.y.value, v.position.z.value).transformCoord(bone_transformer)
                        
                        position += v.weights[i] * v_postion
                        
                        v_normal = RVec3.new(v.normal.x.value, v.normal.y.value, v.normal.z.value).transformNormal(bone_transformer)
                        
                        normal += v.weights[i] * v_normal
                        
                        total_weight += v.weights[i]
                    end
                    
                    vertex.position.x = position.x / total_weight
                    vertex.position.y = position.y / total_weight
                    vertex.position.z = position.z / total_weight
                    
                    vertex.normal.x = normal.x / total_weight
                    vertex.normal.y = normal.y / total_weight
                    vertex.normal.z = normal.z / total_weight
                    
                    v.bone_index.each do |bi|
                        vertex.bone_index << bi
                    end
                    
                    v.weights.each do |w|
                        vertex.weights << w
                    end
                    
                    vertex.tex_coords.x = v.tex_coords.x
                    vertex.tex_coords.y = v.tex_coords.y
                                   
                    frame_vertices << vertex

                end
            
                vertice_frames << frame_vertices
            end
            
            vertice_frames
        end
    end
end