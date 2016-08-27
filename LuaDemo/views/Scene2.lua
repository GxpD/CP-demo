local Scene2 =class("Scene2",function()
	return cc.Scene:create()
	end)

function Scene2.create()
	-- body
	local scene = Scene2.new()
	scene:addChild(scene:createLayer())
	return scene
end

function Scene2:createLayer()
	-- body
	local layer = cc.Layer:create()
	 --gplay:preloadGroup("Scene1", function ()
		-- body
	
	
	local backB = cc.MenuItemFont:create("返回")
                                   :setPosition(display.cx-150, display.cy - 550)
                                    :setColor(cc.c3b(0, 255, 255))

    local ShortcutB = cc.MenuItemFont:create("创建快捷方式")
                                   :setPosition(display.cx-130, display.cy - 450)
                                    :setColor(cc.c3b(0, 255, 255))                                                            
    
    local function back()--点击返回事件
     	-- body
     	  local Scene1 =require("app/views/Scene1")
		        local scene = Scene1.create()
		        if scene then
		        cc.Director:getInstance():replaceScene(scene)
		        end
    end
    backB:registerScriptTapHandler(back)  

    local function Shortcut()--点击创建快捷方式
		-- body
		gplay:createShortcut(function (code,msg)
			-- body
		Scene2:showToast("Shortcut:返回码："..tostring(code)..",描述："..msg,self)
		end) 
	end
	ShortcutB:registerScriptTapHandler(Shortcut)


	local mn = cc.Menu:create(backB,ShortcutB) 
	layer:addChild(mn)
	local bg = cc.Sprite:create("2.jpg")--背景图
	bg:setPosition(display.center)
	layer:addChild(bg)
	--end)

	return layer
end

function Scene2:showToast(message,node)
 
 
 	local toastlabel = cc.LabelTTF:create(message,"Arial",30)	
 
 	toastlabel:addTo(node)
 	
 	toastlabel:setPosition(display.cx,display.cy/2-20)
    toastlabel:setColor(cc.c3b(0, 0, 0))
 	local seq1 = cc.Sequence:create(cc.FadeIn:create(0.3),cc.DelayTime:create(1.5),cc.FadeOut:create(0),cc.CallFunc:create(function ()
 	-- 	-- body
 	toastlabel:removeSelf()
 	end))
 
 	toastlabel:runAction(seq1)
 end

return Scene2