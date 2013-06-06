require 'spec_helper'
require 'model_shared'
include LolModelFormat::Md2

describe LolModelFormat::Md2::Md2Model do

    include_context "model_shared"    

    it 'should convert to md2 file' do
        @models.each do |model_name, m|         
            md2 = Md2Model.new(m).to_md2
            
            @md2_file_name = File.expand_path("../viewer/generated/#{model_name}.md2", __FILE__)
            wio = File.open(@md2_file_name, 'wb')           
            md2.write(wio)
            wio.close        
        end
    end

    it 'should convert to md2 file for skeleton' do
        @models.each do |model_name, m|           
            md2 = Md2Model.new(m).to_md2_skl            
            @md2_skl_file_name = File.expand_path("../viewer/generated/#{model_name}_skl.md2", __FILE__)
            wio = File.open(@md2_skl_file_name, 'wb')        
            md2.write(wio)
            wio.close     
        end
    end
end