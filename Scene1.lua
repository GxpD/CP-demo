require("src/cocos/cocos2d/json")
local Scene1 =class("Scene1",function()
	return cc.Scene:create()
	end)

function Scene1.create()
	-- body
	local scene = Scene1.new()
	scene:addChild(scene:createLayer())
	return scene
end

function Scene1:createLayer()
	-- body
	local layer = cc.Layer:create()
	 --gplay:preloadGroup("Scene1", function ()
		-- body
	local bg = cc.Sprite:create("1.jpg")
	bg:setPosition(display.center)

    local SyncB = cc.MenuItemFont:create("同步:getVersion")
                                   :setPosition(display.cx-200, display.cy - 300)
                                    :setColor(cc.c3b(0, 255, 255))
    local AsyncB = cc.MenuItemFont:create("异步:register")
                                   :setPosition(display.cx-200, display.cy - 400)
                                    :setColor(cc.c3b(0, 255, 255))
	local backB = cc.MenuItemFont:create("返回")
                                   :setPosition(display.cx-300, display.cy - 550)
    local Scene2B = cc.MenuItemFont:create("界面2")
                                   :setPosition(display.cx-450, display.cy - 550)
    local Scene3B = cc.MenuItemFont:create("界面3")
                                   :setPosition(display.cx-600, display.cy - 550)
    local Scene4B = cc.MenuItemFont:create("界面4")
                                   :setPosition(display.cx-750, display.cy - 550)                                                                                             
     local function back()
     	-- body
     	cc.Director:getInstance():popScene()
     end
      backB:registerScriptTapHandler(back)  

    local function scene2()
     	-- body
         gplay:preloadGroup("Scene2",function ()
         	-- body
         	local Scene =require("app/views/Scene2")
		        local scene = Scene.create()
		        if scene then
		        cc.Director:getInstance():pushScene(scene)
		        end
         end)
         
    end 
    Scene2B:registerScriptTapHandler(scene2)

    local function scene3()
     	-- body
         gplay:preloadGroups("Scene3",function ()
         	-- body
         	local Scene =require("app/views/Scene3")
		        local scene = Scene.create()
		        if scene then
		        cc.Director:getInstance():pushScene(scene)
		        end
         end)
    end 
    Scene3B:registerScriptTapHandler(scene3)
    
    local function scene4()
     	-- body
         gplay:preloadGroups({"Scene4","scene4"},function ()
         	-- body
         	local Scene =require("app/views/Scene4")
		        local scene = Scene.create()
		        if scene then
		        cc.Director:getInstance():pushScene(scene)
		        end
         end)
    end 
    Scene4B:registerScriptTapHandler(scene4)

    local function Sync()
        -- body
        --Scene1:showToast("点击",self)
         local params = json.encode()
         local result=gplay:callSyncFunc("getVersion",params)
             
         if result=="" then
        result="没有该方法"
        end
         Scene1:showToast("SDK版本号："..result,self)
    end 
    SyncB:registerScriptTapHandler(Sync)  

    local function Async()
        -- body
        local params = json.encode()
        gplay:callAsyncFunc("register",params,function (code,msg)
            -- body
            Scene1:showToast("注册结果：code："..code.."，msg："..msg,self)
        end)
    end
    AsyncB:registerScriptTapHandler(Async)

	local mn = cc.Menu:create(backB,Scene2B,Scene3B,Scene4B,AsyncB,SyncB) 
	layer:addChild(mn)
	layer:addChild(bg)
	--end)
    
	return layer
end

function Scene1:showToast(message,node)
 
 
 	local toastlabel = cc.LabelTTF:create(message,"Arial",30)	
 
 	toastlabel:addTo(node)
 	
 	toastlabel:setPosition(display.cx,display.cy/2-20)
    toastlabel:setColor(cc.c3b(0, 255, 0))
 	local seq1 = cc.Sequence:create(cc.FadeIn:create(0.3),cc.DelayTime:create(1.5),cc.FadeOut:create(0),cc.CallFunc:create(function ()
 	-- 	-- body
 	toastlabel:removeSelf()
 	end))
 
 	toastlabel:runAction(seq1)
 end

return Scene1