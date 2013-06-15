require 'lol_model_format/skl_file'
require 'lol_model_format/skn_file'
require 'lol_model_format/anm_file'
require "erb"
require "haml"
require "json"

module LolModelFormat
    
    class LolModel

        #must be set when initialize, should't change for the time being
        attr_reader :skeleton_file, :skin_file, :animation_files
        
        def initialize(skl, skn, anms = {})
            @skeleton_file = skl
            @skin_file = skn
            @animation_files = anms
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
            current_bone = { :bone => skeleton.bones[i], :children => [] }
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