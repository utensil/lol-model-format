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

begin
	require File.expand_path('../../../vendor/ruby-math-3d/RMath.so', __FILE__)
rescue LoadError
	puts "RMath.so does not exist. Require plain version."
	require File.expand_path('../../../vendor/ruby-math-3d/RMath.rb', __FILE__)
end

#require File.expand_path('../../../vendor/ruby-math-3d/RMath.rb', __FILE__)

include RMath


