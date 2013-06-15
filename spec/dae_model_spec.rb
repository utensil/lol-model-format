require 'spec_helper'
require 'model_shared'
include LolModelFormat::Dae

describe LolModelFormat::Dae::DaeModel do

    include_context "model_shared" 

    it 'should convert to dae file' do
        @models.each do |model_name, m|         
            dae = DaeModel.new(m).to_dae
            
            @dae_file_name = File.expand_path("../viewer/generated/#{model_name}.dae", __FILE__)
            wio = File.open(@dae_file_name, 'wb')           
            wio.write(dae)
            wio.close        
        end
    end
end