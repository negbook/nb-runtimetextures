local RuntimeTextures = {}
local RuntimeTexturesDraws = {}
local RuntimeTxd = {}
local DrawStart = false 
RegisterRuntimeTexture = function(txd,txn,width,height)
	local temp_txd = CreateRuntimeTxd(txd)
	local temp_handle = CreateRuntimeTexture(temp_txd, txn, width, height)
	if RuntimeTxd[txd] then error("Runtime Dict '"..txd.."' Exist",2) end 
	local index = #RuntimeTextures + 1
	RuntimeTxd[txd] = true
	table.insert(RuntimeTextures,{
		txd = txd,
		txn = txn,
		handle = temp_handle,
		width = width,
		height = height,
		index = index
	})
	return index
end 
GetLastIndexOfRuntimeTexture = function()
	return #RuntimeTextures
end 
SetRuntimeTextureData = function(index,pixeldata)
	return SetRuntimeTextureArgbData(RuntimeTextures[index].handle, pixeldata , #pixeldata)
end 
DrawRuntimeTexture = function(index,x,y,w,h)
	if not DrawStart then 
		CreateThread(function()
			DrawStart = true 
			table.insert(RuntimeTexturesDraws,{RuntimeTextures[index].txd,RuntimeTextures[index].txn,x,y,w,h,index})
			while true do 
				Wait(0)
				for i=1,#RuntimeTexturesDraws do 
					DrawSprite(RuntimeTexturesDraws[i][1], RuntimeTexturesDraws[i][2] , RuntimeTexturesDraws[i][3],RuntimeTexturesDraws[i][4],RuntimeTexturesDraws[i][5],RuntimeTexturesDraws[i][6]*GetAspectRatio(false), 0.0, 255, 255, 255, 255)
				end 
			end 
		end)
	end 
end 
UnDrawRuntimeTexture = function(index)
	for i=1,#RuntimeTexturesDraws do 
		if RuntimeTexturesDraws[i] and RuntimeTexturesDraws[i][7] == index then 
			table.remove(RuntimeTexturesDraws,i)
			break
		end 
	end 
	return GetLastIndexOfRuntimeTexture()
end 
CreateThread(function()
	local index = RegisterRuntimeTexture("hello","world",64,64)
	DrawRuntimeTexture(index,0.8,0.8,0.1,0.1)
	local index2 = RegisterRuntimeTexture("hello2","world2",64,64)
	DrawRuntimeTexture(index2,0.5,0.5,0.1,0.1)
	local randomslot = {"CHAR_FACEBOOK","CHAR_DEFAULT"}
		CreateThread(function()
			while true do Wait(1000)
				local t = randomslot[1]
				print(t,GetLastIndexOfRuntimeTexture())
				exports['nb-imagedata']:GetTextureData(t,t,64,64,function(result)
					SetRuntimeTextureData(index,result.buffer)
				end)
				local t = randomslot[2]
				print(t,GetLastIndexOfRuntimeTexture())
				exports['nb-imagedata']:GetTextureData(t,t,64,64,function(result2)
					SetRuntimeTextureData(index2,result2.buffer)
				end)
			end 
		end)
end)