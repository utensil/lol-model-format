# Check preloading (-rRMath.so or -rRMath.rb)
unless $".find { |lib| lib =~ /RMath\.so|RMath\.rb/ }
  # Load RMath normally.
  begin
    require 'RMath.so'
  rescue LoadError
    # RMath.so does not exist. Require plain version.
    require 'RMath.rb'
  end
end
include RMath

# Test::Unit
require 'test/unit'

# Test cases
require 'test/test_RVec3.rb'
require 'test/test_RVec4.rb'
require 'test/test_RQuat.rb'
require 'test/test_RMtx3.rb'
require 'test/test_RMtx4.rb'
