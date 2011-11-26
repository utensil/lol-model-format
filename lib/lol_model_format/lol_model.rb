require 'lol_model_format/skl_file'
require 'lol_model_format/skn_file'
require 'lol_model_format/anm_file'
require 'lol_model_format/ext/md2_file'

module LolModelFormat
    
    class LolModel
        
        include LolModelFormat::Ext

        #must be set when initialize, can't change for the time being
        attr_reader :skeleton_file, :skin_file, :animation_files
        
        def initialize(skl, skn, anms = {})
            @skeleton_file = skl
            @skin_file = skn
            @animation_files = anms
            
            refresh
        end
        
        def vertex_array
            @vertex_array ||= get_vertex_array
        end
        
        # DEPRECATE I guess this arrays aren't useful in their own form now
        # left here in case of need in the future
        def refresh
            @skin_file.vertices.each do |v|				
                #// Position Information
                @vertex_array = []
                pos = v.position
                @vertex_array << pos.x
                @vertex_array << pos.y
                @vertex_array << pos.z
                
                #// Normal Information
                @normal_array = []
                n = v.normal
                @normal_array << n.x
                @normal_array << n.y
                @normal_array << n.z
                
                
                @texture_array = []
                t = v.tex_coords		
                @texture_array << t.x
                @texture_array << t.y
                #TODO // DDS Texture.
                #tData.Add(1.0f - skn.vertices[i].texCoords.Y);
                
                @bone_index_array = []
                bis = v.bone_index        		
                #TODO check bi.size == BONE_INDEX_SIZE
                bis.each do |bi|
                    @bone_index_array << bi
                end
                
                @bone_weight_array = []
                v.weights.each do |w|
                    @bone_weight_array << w
                end        		
            end
            
            @bone_orientation_array = []
            @bone_position_array = []
            @bone_name_array = []
            @bone_scale_array = []
            @bone_parent_array = []
            @bone_name_array = []
            @bone_name_array = []
            @bone_name_toIndex_map = {}
            @skeleton_file.bones.each_with_index do |bone, i|
                @bone_orientation_array << bone.orientation
                @bone_position_array << bone.position
                @bone_name_array << bone.name
                @bone_scale_array << bone.scale
                @bone_parent_array << bone.parent_id
                @bone_name_array << bone.name
                @bone_name_toIndex_map[bone.name] ||= i
            end
            
            #// I don't know why things need remapped, but they do.
            if @skeleton_file.version == 2
                @bone_index_array = @bone_index_array.map do |bone_index|
                    if bone_index < @skeleton_file.bone_ids.size
                        @skeleton_file.bone_ids[bone_index]
                    else
                        0
                    end
                end
            end
            
            #TODO
        end	
        
        attr_reader :bone_index_array, :bone_weight_array, :bone_orientation_array, 
        :bone_position_array, :bone_name_array, :bone_scale_array, :bone_parent_array,
        :bone_name_array, :bone_name_array, :bone_name_toIndex_map
        
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
            
            v_x_max = vertices.max_by { |v| v.position.x.abs}.position.x
            v_y_max = vertices.max_by { |v| v.position.y.abs}.position.y
            v_z_max = vertices.max_by { |v| v.position.z.abs}.position.z			
            
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
            md2.frames << get_md2_frame('static', @skin_file.vertices)
            
            #add a frame to describe the skeletoned model
            md2.frames << get_md2_frame('skeleton', get_frame_vertices_for_skl)
            
#            @animation_files.each do |name, anm_file|
#            	get_animated_vertice_frames(anm_file).each_with_index do #|frame_vertices, i|
#            		formated_frame_name = "%s%03d" % [escape_md2_frame_name(name), #i + 1]
#            		md2.frames << get_md2_frame(formated_frame_name, #frame_vertices)
#            	end
#            end

            md2
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
            attr_accessor :orientation, :position, :transform
            
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
                root? || @absolute
            end
            
            def parent
                return nil if root?
                @skeleton.bones[parent_id]
            end
            
            def absolutify!        		
                if root?
                    # No parent bone for root bones.
                    # So, just calculate directly.
                    world_transform = RMtx4.new.rotationQuaternion(orientation)
                    world_transform.e30 = position.x * (1.0 / scale)
                    world_transform.e31 = position.y * (1.0 / scale)
                    world_transform.e32 = position.z * (1.0 / scale)
                    
                    self.transform = world_transform
                else
                    #recursively up
                    parent.absolutify! unless parent.absolute? 
                    local_transform = RMtx4.new.rotationQuaternion(self.orientation)
                    local_transform.e30 = position.x * (1.0 / scale)
                    local_transform.e31 = position.y * (1.0 / scale)
                    local_transform.e32 = position.z * (1.0 / scale)
                    
                    # Append matrices for position transform A * B
                    # Append quaternions for rotation transform B * A
                    self.transform = local_transform # * parent.transform
                    self.orientation = self.orientation#parent.orientation * self.orientation
                end
                
                #ensure that now it's absolute
                @absolute = true
                
            rescue => e
                puts self.orientation.inspect
                raise e
            end
        end
        
        class Skeleton
            
            attr_accessor :bones
            
            def initialize        		
                @bones = []
            end
        end
        
        def static_skeleton
            @static_skeleton ||= gen_static_skeleton_from_skl
        end
        
        def gen_static_skeleton_from_skl
            skeleton = Skeleton.new
            
            @skeleton_file.bones.each_with_index do |bone, i|
                
                b = Bone.new skeleton
                
                b.index = i
                b.name = bone.name
                b.parent_id = bone.parent_id
                b.scale = bone.scale
                
                b.transform = bone.transform
                b.orientation = bone.orientation
                b.position = bone.position	
                
                skeleton.bones << b
            end
            
            skeleton.bones.each do |b|
                b.absolutify!
            end
            
            skeleton
        end

        def get_frame_vertices_for_skl
            vertices = []
            
            skeleton = static_skeleton		
            
            @skin_file.vertices.each do |v|
                vertex = SknFile::SknVertex.new
                
                #// Transform the vertex information based on bones.
                position = RVec3.new
                normal = RVec3.new
                
                0.upto 3 do |i|
                    bone_transformer = skeleton.bones[v.bone_index[i]].transform
                    
                    v_postion_4 = RVec4.new(v.position.x.value, v.position.y.value, v.position.z.value, 1.0).transform(bone_transformer)
                    
                    position += v.weights[i] * v_postion_4.xyz
                    
                    v_normal_4 = RVec4.new(v.normal.x.value, v.normal.y.value, v.normal.z.value, 1.0).transform(bone_transformer)
                    
                    normal += v.weights[i] * v_normal_4.xyz
                end
                
                vertex.position.x = position.x
                vertex.position.y = position.y
                vertex.position.z = position.z
                
                vertex.normal.x = normal.x
                vertex.normal.y = normal.y
                vertex.normal.z = normal.z
                
                v.bone_index.each do |bi|
                    vertex.bone_index << bi
                end
                
                v.weights.each do |w|
                    vertex.weights << w
                end
                
                vertex.tex_coords.x = v.tex_coords.x
                vertex.tex_coords.y = v.tex_coords.y
                
                vertices << vertex
            end
            
            vertices
        end

        def get_animated_vertice_frames(anm_file)
            vertice_frames = []
                        
            skeleton = Skeleton.new
            
            #0.upto anm_file.number_of_frames - 1 do |frame_index|
            0.upto 5 do |frame_index|
                puts frame_index	
                
                frame_vertices =[]
                
                anm_file.bones.each_with_index do |bone, i|
                    frame = bone.frames[frame_index]
                    
                    static_bone = static_skeleton.bones[i]
                    
                    b = Bone.new skeleton
                    
                    b.index = i
                    b.name = bone.name
                    b.parent_id = static_bone.parent_id
                    b.scale = static_bone.scale
                    
                    b.transform = static_bone.transform						
                    b.orientation = frame.orientation
                    b.position = frame.position	
                    
                    skeleton.bones << b
                end
                
                skeleton.bones.each do |b|
                    b.absolutify!
                end		
                
                @skin_file.vertices.each do |v|
                    vertex = SknFile::SknVertex.new
                    
                    #// Transform the vertex information based on bones.
                    position = RVec3.new
                    normal = RVec3.new
                    
                    0.upto 3 do |i|
                        bone_transformer = skeleton.bones[v.bone_index[i]].transform
                        
                        v_postion_4 = RVec4.new(v.position.x.value, v.position.y.value, v.position.z.value, 1.0).transform(bone_transformer)
                        
                        position += v.weights[i] * v_postion_4.xyz
                        
                        v_normal_4 = RVec4.new(v.normal.x.value, v.normal.y.value, v.normal.z.value, 1.0).transform(bone_transformer)
                        
                        normal += v.weights[i] * v_normal_4.xyz
                    end
                    
                    vertex.position.x = position.x
                    vertex.position.y = position.y
                    vertex.position.z = position.z
                    
                    vertex.normal.x = normal.x
                    vertex.normal.y = normal.y
                    vertex.normal.z = normal.z
                    
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