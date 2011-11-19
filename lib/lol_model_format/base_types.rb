module LolModelFormat
    class Quaternion < BinData::Record
        endian :little
        
        float :x
        float :y
        float :z
        float :w
    end
    
    class Vector3 < BinData::Record
        endian :little
        
        float :x
        float :y
        float :z
    end
end