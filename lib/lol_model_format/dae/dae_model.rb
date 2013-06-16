module LolModelFormat
    module Dae
        class DaeModel

            def initialize(lol_model)
                @lol_model = lol_model
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

                @lol_model.skin_file.vertices.each_with_index do |v, i|
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

                @lol_model.skin_file.indices.each do |i|
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

                @model["vertex-weights-count"] = @lol_model.skin_file.vertices.size

                bone_trees, name_arrays = @lol_model.gen_bone_tree_from_skl

                puts JSON.pretty_generate(bone_trees)
                puts JSON.pretty_generate(name_arrays)

                @model["bone-tree"] = bone_trees
                @model["skeleton-names"] = name_arrays["root"]            
                @model["joints-name-array"] = @model["skeleton-names"].join ' '
                @model["joints-name-array-size"] = @model["skeleton-names"].size 

                bind_poses_array = []

                @model["skeleton-names"].each do |joint_name|
                    bind_poses_array += @lol_model.skeleton_file.bones[
                            # bone id remapping
                            @lol_model.remap_bone_index(
                                # bone name to bone original id
                                @lol_model.bone_name_to_index_map[joint_name]
                            )                            
                        ].transform.getInverse.getTransposed.to_a
                end

                #bone_name_to_index_map

                @model["bind-poses-array"] = bind_poses_array.join " "
                @model["bind-poses-array-size"] = bind_poses_array.size

                @model["bind-shape-matrix"] = "1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"


                #@model["animations"] = []

                #["anm_bones"] = []

                @lol_model.static_skeleton

                @enable_animation = true



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

                haml_engine = Haml::Engine.new(File.read(File.expand_path('../model.dae.haml', __FILE__)), 
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
        end
    end
end