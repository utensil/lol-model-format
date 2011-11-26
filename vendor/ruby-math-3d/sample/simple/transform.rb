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

99999999.times do
  v = RVec3.new( rand(), rand(), rand() )
  m = RMtx3.new.rotationX( Math::PI/4.0 )
  p v
  v2 = v.transformRS( m )
  p v2
end
