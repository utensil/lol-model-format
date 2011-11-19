require 'lol_model_format.rb'

describe LolModelFormat::Ext::Md2File do
	
	include LolModelFormat::Ext
	
	context 'dummy' do
		
		it 'should be ok to initilize' do
			Md2File.new
		end
	end
end