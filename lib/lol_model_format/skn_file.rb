require 'lol_model_format/base_types'

module LolModelFormat
    class SknFile < BinData::Record
      endian :little
      
      uint32 :magic
      uint16 :version
      uint16 :num_of_objects
      uint32 :num_of_material_headers, :value => lambda { material_headers.size }
      
      class SknMaterial < BinData::Record
        MATERIAL_NAME_SIZE = 64
        
        endian :little
        
        string :name, :length => MATERIAL_NAME_SIZE
        uint32 :start_vertex
        uint32 :num_vertices
        uint32 :start_index
        uint32 :num_of_indices 
      end
      
      array :material_headers, :type => :skn_material, 
            :read_until => lambda { index == num_of_material_headers - 1 } 
      
      uint32 :num_of_indices, :value => lambda { indices.size }
      uint32 :num_of_vertices, :value => lambda { vertices.size }
      
      array :indices, :type => :uint16, 
            :read_until => lambda { index == num_of_indices - 1 } 
      
      class SknVertex < BinData::Record
        BONE_INDEX_SIZE =  4
        
        endian :little
        
        struct :position do
          float :x
          float :y
          float :z
        end
        
        array :bone_index, :type => :uint8, 
                :read_until => lambda { index == BONE_INDEX_SIZE - 1 }
                            
        array :weights, :type => :float,
                :read_until => lambda { index == BONE_INDEX_SIZE - 1 }
        
        struct :normal do
          float :x
          float :y
          float :z
        end
        
        struct :tex_coords do 
          float :x
          float :y
        end
      end
      
      array :vertices, :type => :skn_vertex, 
            :read_until => lambda { index == num_of_vertices - 1 } 
      
      array :end_tab, :type => :uint32, 
            :read_until => lambda { index == 3 - 1 }, 
            :only_if => lambda { version == 2 }
    end
end