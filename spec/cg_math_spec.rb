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
    
    it "position should be at e30, e31 and e32 of the matrix" do
        
        transform = RMtx4.new.setIdentity * @rotation_matrix
        transform.e30 = @position.x * (1.0 / @scale)
        transform.e31 = @position.y * (1.0 / @scale)
        transform.e32 = @position.z * (1.0 / @scale)
        
        readable_transform = RMtx4.new.setIdentity.rotationQuaternion(@orientation) 
        readable_transform *= RMtx4.new.setIdentity.translation(@position.x  * (1.0 / @scale), @position.y * (1.0 / @scale), @position.z * (1.0 / @scale)).getTransposed
        
        readable_transform.should ==  transform
    end
    
    it "order shouldn't matter" do
        (@scale_matrix * @rotation_matrix)
        .should == @rotation_matrix * @scale_matrix

        #(@translation_matrix * @scale_matrix)
        #.should == @scale_matrix * @translation_matrix

        (@translation_matrix * @rotation_matrix)
        .should == @rotation_matrix * @translation_matrix

    end

    it "order sometimes matters" do
        (@translation_matrix * @scale_matrix)
        .should_not == @scale_matrix * @translation_matrix
    end

    it "op shouldn't equal times" do
        RMtx4.new.translation(@position.x, @position.y, @position.z).rotationQuaternion(@orientation).scaling(@scale, @scale, @scale)
        .should_not == @translation_matrix * @rotation_matrix * @scale_matrix

        RMtx4.new.translation(@position.x, @position.y, @position.z).rotationQuaternion(@orientation).scaling(@scale, @scale, @scale)
        .should_not == @scale_matrix * @rotation_matrix * @translation_matrix 
    end
    
    it "setIdentity shouldn't matter" do
        RMtx4.new.setIdentity.rotationQuaternion(@orientation)
        .should == RMtx4.new.rotationQuaternion(@orientation)

        RMtx4.new.setIdentity.translation(@position.x, @position.y, @position.z)
        .should == RMtx4.new.translation(@position.x, @position.y, @position.z)

        RMtx4.new.setIdentity.scaling(@scale, @scale, @scale)
        .should == RMtx4.new.scaling(@scale, @scale, @scale)
    end
    
    it "translated(x, y, z) = position.new(x, y, z) " do
        RVec3.new(0.0, 0.0, 0.0).transformCoord(
            RMtx4.new.translation(@position.x, @position.y, @position.z))
        .should == @position
    end
end