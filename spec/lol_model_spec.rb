require 'spec_helper'
require 'model_shared'

describe LolModelFormat::LolModel do

    include_context "model_shared"

    it 'should gen_bone_tree_from_skl' do
        @models.each do |model_name, m|
            m.gen_bone_tree_from_skl   
        end
    end
    
end