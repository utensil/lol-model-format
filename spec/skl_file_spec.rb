require 'lol_model_format.rb'

describe LolModelFormat::SklFile do
	
	include LolModelFormat
	
	context 'dummy' do
		
		it 'should be ok to initilize' do
			SklFile.new
		end
	end
end