require 'spec_helper'

describe "CG Math" do
	
	before do
		@position = RVec3.new(1.0, 2.0, 3.0)
		@orientation = RQuat.new(1.0, 2.0, 3.0, 4.0)
		@scale = 0.6
		
		@translation_matrix = RMtx4.new.setIdentity.translation(@position.x, @position.y, @position.z)
		@rotation_matrix = RMtx4.new.setIdentity.rotationQuaternion(@orientation)
		@scale_matrix = RMtx4.new.setIdentity.scaling(@scale, @scale, @scale) 
	end
	
	it "1" do
		
		transform = RMtx4.new.setIdentity * @rotation_matrix
		transform.e30 = @position.x * (1.0 / @scale)
		transform.e31 = @position.y * (1.0 / @scale)
		transform.e32 = @position.z * (1.0 / @scale)
		
		readable_transform = RMtx4.new.setIdentity.rotationQuaternion(@orientation)	
		readable_transform *= RMtx4.new.setIdentity.translation(@position.x  * (1.0 / @scale), @position.y * (1.0 / @scale), @position.z * (1.0 / @scale)).getTransposed
		
		readable_transform.should ==  transform
	end
	
	it "2" do		
		(@translation_matrix * @rotation_matrix).should == @rotation_matrix * @translation_matrix 
	end
	
	it "3" do
		RMtx4.new.setIdentity.rotationQuaternion(@orientation).should == RMtx4.new.rotationQuaternion(@orientation)            
        RMtx4.new.setIdentity.translation(@position.x, @position.y, @position.z).should == RMtx4.new.translation(@position.x, @position.y, @position.z)
	end
	
	it "4" do
		RVec3.new(0.0, 0.0, 0.0).transformCoord(RMtx4.new.translation(@position.x, @position.y, @position.z)).should == @position
	end
end