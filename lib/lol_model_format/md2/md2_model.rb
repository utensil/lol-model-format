require 'lol_model_format/md2/md2_file'

module LolModelFormat
    module Md2
        class Md2Model

            def initialize(lol_model)
                @lol_model = lol_model
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

                static_skeleton = @lol_model.static_skeleton
                
                #trianle that determines how all vertexes form faces TODO
                puts static_skeleton.bones.size
                
                #TODO 
                static_vertices = @lol_model.get_vertices_from_skl(static_skeleton, offset)
                md2.triangles = get_md2_skl_trianles(static_vertices.size / 3)
                
                #add a frame to describe the static skeleton
                md2.frames << get_md2_frame("skl_static001", static_vertices)
                
                if false
                    @lol_model.animation_files.each do |name, anm_file|
                        
                        0.upto anm_file.number_of_frames - 1 do |frame_index|
                        #1.upto 2 do |frame_index|
                            puts frame_index    
                                            
                                formated_frame_name = "skl_%s%03d" % [escape_md2_frame_name(name), frame_index + 1] 
                                
                                skeleton = get_skl_from_anm_frame(anm_file, frame_index)
                                                
                                md2.frames << get_md2_frame(formated_frame_name, get_vertices_from_skl(skeleton, offset))
                            end
                    end             
                else            
                    @lol_model.animation_files.each do |name, anm_file|
                        @lol_model.get_animated_vertice_frames(static_vertices, anm_file).each_with_index do |frame_vertices, i|
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
                md2.frames << get_md2_frame('static001', @lol_model.skin_file.vertices)

                @lol_model.animation_files.each do |name, anm_file|
                    @lol_model.get_animated_vertice_frames(@lol_model.skin_file.vertices, anm_file).each_with_index do |frame_vertices, i|
                        formated_frame_name = "%s%03d" % [escape_md2_frame_name(name), i + 1]
                        md2.frames << get_md2_frame(formated_frame_name, frame_vertices)
                    end
                end

                md2
            end

            private

            def get_md2_skin_coords(skinwidth, skinheight)
                skin_coords = []
                
                @lol_model.skin_file.vertices.each do |v|
                    coord = Md2File::SkinCoord.new
                    coord.s = (skinwidth * v.tex_coords.x).to_i
                    coord.t = (skinheight * v.tex_coords.y).to_i
                    skin_coords << coord
                end
                
                skin_coords
            end

            def get_md2_trianles()
                triangles = []
                
                0.upto (@lol_model.skin_file.indices.size / 3) do |i|
                    
                    #three vertex of a single triangle
                    a = @lol_model.skin_file.indices[3 * i]
                    b = @lol_model.skin_file.indices[3 * i + 1]
                    c = @lol_model.skin_file.indices[3 * i + 2]
                    
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

            def escape_md2_frame_name(name)
                #          0 1 2 3 4 5 6 7 8 9
                table = %W[Z A B C D E F G H I]
                escaped_name = name.gsub(/\d/) do |digit|
                    table[digit.to_i]
                end
                
                escaped_name
            end
        end
    end
end