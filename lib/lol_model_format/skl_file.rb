require 'lol_model_format/base_types'

module LolModelFormat
    class SklFile < BinData::Record
        ID_SIZE = 8

        endian :little
           
        #uint32 :magic_1
        #uint32 :magic_2
        string :id, :length => ID_SIZE #, :trim_padding => true

        # newest version is 0, and it's not fully understood yet
        uint32 :version, :assert => lambda { value == 1 || value == 2 }
        uint32 :designer_id
        uint32 :num_of_bones, :value => lambda { bones.size }
            
        class SklBone < BinData::Record
            BONE_NAME_SIZE = 32
            TRANSFORM_SIZE = 12            

            endian :little
            
            string :name, :length => BONE_NAME_SIZE, :trim_padding => true
            uint32 :parent_id
            float :scale   
            #transform_matrix4                 
            array :matrix, :type => :float, 
                  :read_until => lambda { index == TRANSFORM_SIZE - 1 }
            
            #TODO validate
            def orientation
                unless @orientation    
                    orientation_transform = RMtx4.new.setIdentity
                    
                    orientation_transform.e00 = matrix[0].value
                    orientation_transform.e10 = matrix[1].value
                    orientation_transform.e20 = matrix[2].value

                    orientation_transform.e01 = matrix[4].value
                    orientation_transform.e11 = matrix[5].value
                    orientation_transform.e21 = matrix[6].value

                    orientation_transform.e02 = matrix[8].value
                    orientation_transform.e12 = matrix[9].value
                    orientation_transform.e22 = matrix[10].value                    

                    @orientation = RQuat.new.setIdentity.rotationMatrix( orientation_transform )

                    @orientation = RQuat.new(@orientation.x, @orientation.y, -@orientation.z, -@orientation.w)

                    #TODO flip Z and W
                end
                @orientation
            end
            
            #TODO validate    
            def position
                @position ||= RVec3.new(matrix[3].value, matrix[7].value, -matrix[11].value)
                #TODO flip Z?
                @position
            end

            #TODO validate
            def transform
                unless @transform
                    @transform = RMtx4.new.setIdentity
                    @transform *= RMtx4.new.translation(position.x, position.y, position.z)
                    @transform *= RMtx4.new.scaling(scale.value, scale.value, scale.value)
                    @transform *= RMtx4.new.rotationQuaternion(orientation)                    
                end
                @transform
            end
        end
        
        array :bones, :type => :skl_bone, 
              :read_until => lambda { index == num_of_bones - 1 }
    
        uint32 :num_of_bone_ids, :value => lambda { bone_ids.size }, 
               :only_if => lambda { version == 2 || version == 0 }
                
        array :bone_ids, :type => :uint32, 
              :read_until => lambda { index == num_of_bone_ids - 1 }, 
              :only_if => lambda { version == 2 || version == 0 }
    end
end