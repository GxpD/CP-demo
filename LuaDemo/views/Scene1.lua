

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
	local bg = cc.Sprite:create("1.jpg")--背景图
	bg:setPosition(display.cx-150, display.cy)

    local SyncB = cc.MenuItemFont:create("同步扩展API:getVersion")
                                   :setPosition(display.cx-300, display.cy - 300)
                                    :setColor(cc.c3b(0, 255, 255))
    local AsyncB = cc.MenuItemFont:create("异步扩展API:register")
                                   :setPosition(display.cx-300, display.cy - 400)
                                    :setColor(cc.c3b(0, 255, 255))

    local extendB = cc.MenuItemFont:create("扩展JAR：返回数值")
                                   :setPosition(display.cx-300, display.cy - 200)
                                    :setColor(cc.c3b(0, 255, 255))

	local backB = cc.MenuItemFont:create("返回")
                                   :setPosition(display.cx-300, display.cy - 550)
    local Scene2B = cc.MenuItemFont:create("界面2")
                                   :setPosition(display.cx-450, display.cy - 550)
    local Scene3B = cc.MenuItemFont:create("界面3")
                                   :setPosition(display.cx-600, display.cy - 550)
    local Scene4B = cc.MenuItemFont:create("界面4")
                                   :setPosition(display.cx-750, display.cy - 550) 

    local function extend()
        -- body
       --local x = javafunc(10,20)
       --Scene1:showToast("sum="..tostring(x),self)
       local c = showName("kangkang")
       cc.Label:createWithSystemFont("返回值:"..tostring(c), "Arial", 40)
        :move(display.cx+200, display.cy + 200)
        :setColor(cc.c3b(0, 255, 255))
        :addTo(self)
    end
    
       extendB:registerScriptTapHandler(extend)
           

     local function back()
     	-- body
     	cc.Director:getInstance():popScene()
     end
      backB:registerScriptTapHandler(back)  

    local function scene2()
     	-- body
         gplay:preloadGroup("Scene2",function ()--加载单个资源包
         	-- body
           gplay:backFromGroup("Scene2")
            local Scene =require("app/views/Scene2")
                local scene = Scene.create()
                if scene then
                cc.Director:getInstance():replaceScene(scene)
                end
         end)
        
         
    end 
    Scene2B:registerScriptTapHandler(scene2)

    local function scene3()
     	-- body
         gplay:preloadGroups("Scene3",function ()--加载单个资源包
         	-- body
            gplay:backFromGroup("Scene3")
         	local Scene =require("app/views/Scene3")
		        local scene = Scene.create()
		        if scene then
		        cc.Director:getInstance():replaceScene(scene)
		        end
         end)
         
    end 
    Scene3B:registerScriptTapHandler(scene3)
    
    local function scene4()
     	-- body
         gplay:preloadGroups({"Scene4","scene4"},function ()--加载多个资源包
         	-- body
            gplay:backFromGroup("Scene4")
            gplay:backFromGroup("scene4")
         	local Scene =require("app/views/Scene4")
		        local scene = Scene.create()
		        if scene then
		        cc.Director:getInstance():replaceScene(scene)
		        end
         end)   
    end 
    Scene4B:registerScriptTapHandler(scene4)

    local function Sync()--同步接口：获取sdk版本号
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

    local function Async()--异步接口：调用注册方法
        -- body
        local params = json.encode()
        gplay:callAsyncFunc("register",params,function (code,msg)
            -- body
            Scene1:showToast("注册结果：code："..code.."，msg："..msg,self)
        end)
    end
    AsyncB:registerScriptTapHandler(Async)

    gplay:setPreloadResponseCallback(function(resultCode, errorCode, groupName, percent, speed)  
          --Scene1:showToast("resultCode:"..tostring(resultCode)..",".."errorCode:"..tostring(errorCode)..",groupName:"..groupName..",percent:"..tostring(percent)..",speed:"..tostring(speed),self)
        if percent>=0 then
         local to1 = cc.ProgressTo:create(0.1,100)
         local left = cc.ProgressTimer:create(cc.Sprite:create("progress.jpg"))  
          -- 设置进度条类型，这里是条形进度类型  

          left:setType(cc.PROGRESS_TIMER_TYPE_BAR)  
          
          left:setMidpoint(cc.p(0, 0))  
           
          left:setBarChangeRate(cc.p(0.5, 0))  
           
          left:setPosition(display.cx, display.cy-160)  
          
          left:runAction(cc.RepeatForever:create(to1))  
           
          layer:addChild(left)
        end
        if errorCode ~= gplay.ActionResultCode.PRELOAD_ERROR_NONE then
           if errorCode ==gplay.ActionResultCode.PRELOAD_ERROR_NETWORK then
             Scene1:showToast("网络错误!",self)
         elseif errorCode ==gplay.ActionResultCode.PRELOAD_ERROR_VERIFY_FAILED then
             Scene1:showToast("校验错误!",self)
         elseif errorCode ==gplay.ActionResultCode.PRELOAD_ERROR_NO_SPACE then
             Scene1:showToast("存储空间不足!",self)
         elseif errorCode ==gplay.ActionResultCode.PRELOAD_ERROR_UNKNOWN then
             Scene1:showToast("未知错误!",self)
         end

        end
          print("resultCode:"..tostring(resultCode)..",".."errorCode:"..tostring(errorCode)..",groupName:"..groupName..",percent:"..tostring(percent)..",speed:"..tostring(speed))
          
         end)
    

	local mn = cc.Menu:create(backB,Scene2B,Scene3B,Scene4B,AsyncB,SyncB,extendB) 
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