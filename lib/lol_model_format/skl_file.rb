require 'base_types.rb'

module LolModelFormat
    class SklFile < BinData::Record
        endian :little
           
        uint32 :magic_1
        uint32 :magic_2
        uint32 :version
        uint32 :designer_id
        uint32 :num_of_bones, :value => lambda { bones.size }
            
        class SklBone < BinData::Record
            BONE_NAME_SIZE = 32
            TRANSFORM_SIZE = 12
            
            endian :little
            
            string :name, :length => BONE_NAME_SIZE
            uint32 :parent_id
            float :scale                    
            array :orientation_transform, :type => :float, 
                  :read_until => lambda { index == TRANSFORM_SIZE - 1 }
        end
        
        array :bones, :type => :skl_bone, 
              :read_until => lambda { index == num_of_bones - 1 }
    
        uint32 :num_of_bone_ids, :value => lambda { bone_ids.size }, 
               :only_if => lambda { version == 2 }
                
        array :bone_ids, :type => :uint32, 
              :read_until => lambda { index == num_of_bone_ids - 1 }, 
              :only_if => lambda { version == 2 }
    end
end