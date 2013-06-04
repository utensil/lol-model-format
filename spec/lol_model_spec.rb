require 'spec_helper'
require 'model_shared'

describe LolModelFormat::LolModel do

    include_context "model_shared"

    it 'should convert to dae file by erb' do
        @models.each do |model_name, m|         
            dae = m.to_dae_by_erb
            
            @dae_file_name = File.expand_path("../viewer/generated/#{model_name}.erb.dae", __FILE__)
            wio = File.open(@dae_file_name, 'wb')           
            wio.write(dae)
            wio.close        
        end
    end

    it 'should convert to dae file' do
        @models.each do |model_name, m|         
            dae = m.to_dae
            
            @dae_file_name = File.expand_path("../viewer/generated/#{model_name}.dae", __FILE__)
            wio = File.open(@dae_file_name, 'wb')           
            wio.write(dae)
            wio.close        
        end
    end

    it 'should gen_bone_tree_from_skl' do
        @models.each do |model_name, m|
            m.gen_bone_tree_from_skl   
        end
    end
    
end