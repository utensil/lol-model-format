require 'lol_model_format/base_types.rb'

module LolModelFormat
    
    class AnmFile < BinData::Record
        endian :little
        
        uint32 :magic_1
        uint32 :magic_2
        uint32 :version
        uint32 :magic_3
        uint32 :number_of_bones , :value => lambda { bones.size }
        uint32 :number_of_frames ,
               #they should be the same but we just pick the first one here
               #TODO add validation for this
               :value => lambda { bones[0].frames.size } 
        uint32 :playback_fps
        
        class AnmBone < BinData::Record
            BONE_NAME_LENGTH = 32
            
            endian :little
            
            string :name, :length => BONE_NAME_LENGTH
            uint32 :flag
              
            class AnmFrame < BinData::Record
                endian :little
                
                quaternion :orientation
                vector3 :position
            end
            		
            array :frames, :type => :anm_frame, 
                  :read_until => lambda { index == number_of_frames - 1 }
        end
        	
        array :bones, :type => :anm_bone, 
              :read_until => lambda { index == number_of_bones - 1 }
    end
end
