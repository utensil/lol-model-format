require 'lol_model_format/base_types'
require 'lol_model_format/ext/md2_anorms'

module LolModelFormat
    module Ext
        
        class Md2File < BinData::Record
            endian :little
        
            #/* MD2 header */
            class Md2Header < BinData::Record
                endian :little
                
                #     /* magic number: "IDP2" */
                #ident must be equal to 844121161 or to the string “IDP2”. We can obtain this number with the expression (('2'<<24) + ('P'<<16) + ('D'<<8) + 'I').	
                int32 :ident, :value => 844121161
                #string :ident, :value => 'IDP2' FIXME string no working 
                
                #     /* version: must be 8 */	                          
                int32 :version, :value => 8       
                int32 :skinwidth          #     /* texture width */
                int32 :skinheight         #     /* texture height */
                #     /* size in bytes of a frame */
                int32 :framesize, :value => lambda { frames[0].num_bytes }
                
                #for the nums,
                #they should be the same but we just pick the first one here
                #TODO add validation for this
                
                #TODO improve texture coord names aka. skin coords, or st	
         
                 #     /* number of skins */
                int32 :num_skins, :value => lambda { skin_names.size }          
                #     /* number of vertices per frame */
                int32 :num_vertices, :value => lambda { frames[0].verts.size }        
                #     /* number of texture coordinates */
                int32 :num_st, :value => lambda { skin_coords.size }               
                #     /* number of triangles */
                int32 :num_tris, :value => lambda { triangles.size }
                #     /* number of opengl commands */            
                int32 :num_glcmds, :value => lambda { gl_cmds.size } 
                #     /* number of frames */	        
                int32 :num_frames, :value => lambda { frames.size }  
                
                #FIXME consider empty case for each field
                
                # Offsets		
                #     /* offset skin data */      
                int32 :offset_skins, 
                    :value => lambda { header.num_bytes }  
                #     /* offset texture coordinate data */      
                int32 :offset_st, 
                    :value => lambda { header.offset_skins + 
                                        skin_names[0].num_bytes * header.num_skins  }     
                #     /* offset triangle data */      
                int32 :offset_tris, 
                    :value => lambda { header.offset_st + 
                                        skin_coords[0].num_bytes * header.num_st }  
                #     /* offset frame data */       
                int32 :offset_frames, 
                    :value => lambda { header.offset_tris + 
                                        triangles[0].num_bytes * header.num_tris  }  
                #     /* offset OpenGL command data */     
                int32 :offset_glcmds, 
                    :value => lambda { header.offset_frames + 
                                        frames[0].num_bytes * header.num_frames }  
                #     /* offset end of file */     
                int32 :offset_end, 
                    :value => lambda { header.offset_glcmds + 
                                        gl_cmds[0].num_bytes * header.num_glcmds  }  
                    
            end	
            
            #TODO use base_types
            #The vector, composed of three floating coordinates (x, y, z):	
            class Vector3 < BinData::Record
                endian :little
                
                float :x
                float :y
                float :z
            end
                
            #/* texture file name */
            #Texture informations are the list of texture names associated to the model
            class SkinName < BinData::Record
                string :name, :length => 64
            end
            
            #/* Texture coords */
            #Texture coordinates are stored in a structure as short integers. To get the true #texture coordinates, you have to divide s by skinwidth and t by skinheight:
            class SkinCoord < BinData::Record
                endian :little
                
                int16 :s
                int16 :t
            end
            
            #/* Triangle info */
            #Each triangle has an array of vertex indices and an array of texture coordinate 	#indices.
            class Triangle < BinData::Record
                endian :little
                
                # /* vertex indices of the triangle */
                array :index_xyz, :type => :uint16, 
                      :read_until => lambda { index == 3 - 1 }
                # /* tex. coord. indices */
                array :index_st, :type => :uint16, 
                      :read_until => lambda { index == 3 - 1 }
            end
            
            #Vertices are composed of “compressed” 3D coordinates, which are stored in one byte #for each coordinate, and of a normal vector index. The normal vector array is stored #in the anorms.h file of Quake 2 and hold 162 vectors in floating point (3 float).
            #
            #/* Compressed vertex */
            #To uncompress vertex coordinates, you need to multiply each component by the scale #factor and then add the respective translation component:
            #
            #vec3_t v;                     /* real vertex coords. */
            #struct md2_vertex_t vtx;      /* compressed vertex */
            #struct md2_frame_t frame;     /* a model frame */
            #
            #v[i] = (vtx.v[i] * frame.scale[i]) + frame.translate[i];
            class Vertex < BinData::Record
                endian :little
                
                # /* position */
                array :v, :type => :uint8, 
                      :read_until => lambda { index == 3 - 1 }
                # /* normal vector index */
                uint8 :normal_index
            end
            
            #Frames
            #
            #Frames have specific informations for itself and the vertex list of the frame. #Informations are used to uncompress vertices and obtain the real coordinates.
            class Frame < BinData::Record
                endian :little
                
                #/* scale factor */
                vector3 :scale
                #/* translation vector */
                vector3 :translate
                #/* frame name */
                string :name, :length => 16
                #/* list of frame's vertices */
                array :verts, :type => :vertex, 
                      :read_until => lambda { index == header.num_vertices - 1 }
            end
            
            #/* GL command packet */
            class GlCmd < BinData::Record
                endian :little
                #/* s texture coord. */
                float :s
                #/* t texture coord. */
                float :t		
                #/* vertex index */
                int32 :v_index
            end
            
            # HERE BEGINS the actual fields
            
            # header
            md2_header :header
                    
            # skin names 
            array :skin_names, :type => :skin_name,
                    :adjust_offset => lambda { header.offset_skins },
                    :read_until => lambda { index == header.num_skins - 1 }
                    
            # texture coordinates 
            array :skin_coords, :type => :skin_coord,
                    :adjust_offset => lambda { header.offset_st },
                    :read_until => lambda { index == header.num_st - 1 }
                        
            # triangle indexes
            array :triangles, :type => :triangle,
                    :adjust_offset => lambda { header.offset_tris },
                    :read_until => lambda { index == header.num_tris - 1 }
                    
            # frame data (vertices)
            array :frames, :type => :frame, 
                    :adjust_offset => lambda { header.offset_frames }, 
                    :read_until => lambda { index == header.num_frames - 1 }

            #OpenGL Commands
            #OpenGL commands are stored in an array of integer (int). 
            array :gl_cmds, :type => :int32,
                    :adjust_offset => lambda { header.offset_glcmds },
                    :read_until => lambda { index == header.num_glcmds - 1 }
        end
    end
end



