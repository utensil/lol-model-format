require 'lol_model_format/skl_file'
require 'lol_model_format/skn_file'
require 'lol_model_format/anm_file'
require 'lol_model_format/ext/md2_file'
module LolModelFormat
	
	class LolModel
		
		include LolModelFormat::Ext
		
		class Joint
			#public int parent;
	        #public float scale;
	        #public Vector3 worldPosition;
	        #public Quaternion worldOrientation;
	        #public Matrix4 worldTransform;

        	attr_accessor :parent, :scale, :world_position, 
        	:world_orientation, :world_transform
		end
		
		class Rig
			MAX_BONES = 128
			
			attr_accessor :binding_joints, :current_frame, :next_frame
			
			def initialize
				@binding_joints = []
				@current_frame = []
				@next_frame = []
			end			
		end
		
		#must be set when initialize, can't change for the time being
		attr_reader :skeleton_file, :skin_file, :animation_file
		
		def initialize(skl, skn, anm)
			@skeleton_file = skl
			@skin_file = skn
			@animation_file = anm
			
			refresh
		end
		
		def vertex_array
			@vertex_array ||= get_vertex_array
		end
		
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
        		bw = v.weights
        		@bone_weight_array << bw.x
        		@bone_weight_array << bw.y
        		@bone_weight_array << bw.z
        		@bone_weight_array << bw.w        		
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
		
		def to_md2
			md2 = Md2File.new
			md2.header.skinwidth = 256
			md2.header.skinheight = 256
			#md2.skin_names = []
			#skin_name = Md2File::SkinName.new
			#skin_name.name = 'testing'
			#md2.skin_names << skin_name
			
			#skin_coord = Md2File::SkinCoord.new
			#skin_coord.s = 0
			#skin_coord.t = 0
			#md2.skin_coords << skin_coord
			
			md2.skin_names = []
	        md2.skin_coords = []
	        md2.gl_cmds = []
	        
	        v_x_max = @skin_file.vertices.max_by { |v| v.position.x.abs}.position.x
	        v_y_max = @skin_file.vertices.max_by { |v| v.position.y.abs}.position.y
	        v_z_max = @skin_file.vertices.max_by { |v| v.position.z.abs}.position.z
			
			frame = Md2File::Frame.new
			frame.scale.x = 2 * v_x_max / 256.0
			frame.scale.y = 2 * v_y_max / 256.0
			frame.scale.z = 2 * v_z_max / 256.0
			
			frame.translate.x = -v_x_max
			frame.translate.y = -v_y_max
			frame.translate.z = -v_z_max
			
			frame.name = 'static'			
			
			@skin_file.vertices.each do |v|
				vertex = Md2File::Vertex.new	
				x = ((v.position.x - frame.translate.x) / frame.scale.x).to_i
				y = ((v.position.y - frame.translate.y) / frame.scale.y).to_i
				z = ((v.position.z - frame.translate.z) / frame.scale.z).to_i
				
				#puts "[#{v.inspect}] => [#{x}, #{y}, #{z}]"
							
				vertex.v = [x, y, z]
				
				normal = v.normal
				vertex.normal_index = 0
				#Md2File.get_anorms_index(
				#						normal.x, normal.y, normal.z)
				frame.verts << vertex		
				
				coord = Md2File::SkinCoord.new
				coord.s = (md2.header.skinwidth * v.tex_coords.x).to_i
				coord.t = (md2.header.skinheight * v.tex_coords.y).to_i
				md2.skin_coords	<< coord
			end
			
			md2.frames << frame
			
			0.upto (@skin_file.indices.size / 3) do |i|
				a = @skin_file.indices[3 * i]
				b = @skin_file.indices[3 * i + 1]
				c = @skin_file.indices[3 * i + 2]
				
				tri = Md2File::Triangle.new
				tri.index_xyz = [a, b, c]
				tri.index_st = [a, b, c]
				
				md2.triangles << tri
			end
			
	    	md2
		end
        
        def get_bone_index_array
        	ba = []
			@skin_file.vertices.each do |v|
				t = v.tex_coords
				na << t.x
				na << t.y
			end
    	end
	end
end