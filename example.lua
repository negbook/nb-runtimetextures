CreateThread(function()
	local index = RegisterRuntimeTexture("hello","world",64,64)
	DrawRuntimeTexture(index,0.8,0.8,0.1,0.1)
	local index2 = RegisterRuntimeTexture("hello2","world2",64,64)
	DrawRuntimeTexture(index2,0.5,0.5,0.1,0.1)
	local randomslot = {"CHAR_FACEBOOK","CHAR_DEFAULT"}
		CreateThread(function()
			while true do Wait(1000)
				local t = randomslot[GetRandomIntInRange(1,3)]
				print(t,GetLastIndexOfRuntimeTexture())
				exports['nb-imagedata']:GetTextureData(t,t,64,64,function(result)
					SetRuntimeTextureData(index,result.buffer)
				end)
				local t = randomslot[GetRandomIntInRange(1,3)]
				print(t,GetLastIndexOfRuntimeTexture())
				exports['nb-imagedata']:GetTextureData(t,t,64,64,function(result2)
					SetRuntimeTextureData(index2,result2.buffer)
				end)
			end 
		end)
end)