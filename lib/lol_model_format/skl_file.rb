require 'lol_model_format/base_types'

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
            array :transform_matrix4, :type => :float, 
                  :read_until => lambda { index == TRANSFORM_SIZE - 1 }
                  
            def position
                v = Vector3.new
                v.x = transform_matrix4[3]
                v.y = transform_matrix4[7]
                v.z = transform_matrix4[11]
                v
            end
            
            def orientation            	
                q = RQuat.new.rotationMatrix( transform )
                q
            end
            
            def transform
                m = RMtx4.new.setIdentity
                
                m.e00 = transform_matrix4[0];
                m.e10 = transform_matrix4[1];
                m.e20 = transform_matrix4[2];
                
                m.e01 = transform_matrix4[4];
                m.e11 = transform_matrix4[5];
                m.e21 = transform_matrix4[6];
                
                m.e02 = transform_matrix4[8];
                m.e12 = transform_matrix4[9];
                m.e22 = transform_matrix4[10]
                
                #TODO how about postion?                
                m
            end
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