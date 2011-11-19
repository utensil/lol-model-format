require 'lol_model_format.rb'

describe LolModelFormat::SknFile do
	
	include LolModelFormat
	
	context 'dummy' do
		
		it 'should be ok to initilize' do
			SknFile.new
		end
	end
end