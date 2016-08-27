local Scene4 =class("Scene4",function()
	return cc.Scene:create()
	end)

function Scene4.create()
	-- body
	local scene = Scene4.new()
	scene:addChild(scene:createLayer())
	return scene
end

function Scene4:createLayer()
	-- body
	local layer = cc.Layer:create()

	local backB = cc.MenuItemFont:create("返回")
                                   :setPosition(display.cx-150, display.cy - 550)
                                   :setColor(cc.c3b(0, 255, 255))
	local shareB = cc.MenuItemFont:create("分享")
                                   :setPosition(display.cx-150, display.cy - 450)
                                   :setColor(cc.c3b(0, 255, 255))

    local function back()
     	-- body
     	local Scene1 =require("app/views/Scene1")
		        local scene = Scene1.create()
		        if scene then
		        cc.Director:getInstance():replaceScene(scene)
		        end
    end
    backB:registerScriptTapHandler(back)

    local function share()
     	-- body
     	local params = GplayShareParams.new()

				params:setPageUrl("http://192.168.1.3");                                -- 分享页面
				params:setTitle("LUASDKDemo");                                          -- 分享标题
				params:setText("LUASDKDemo 是 GplaySDK 的线下测试版本");                   -- 分享内容
				params:setImgUrl("http://192.168.1.3:8888/moon/icon/large_icon.png");   -- 分享图片
				params:setImgTitle("large_icon");                                       -- 分享图片标题

				gplay:share(params, function(ret, msg)
				    Scene4:showToast("share:返回码："..tostring(ret)..",描述："..msg,self)
				end)
    end
	shareB:registerScriptTapHandler(share)

	local mn = cc.Menu:create(backB,shareB) 
	layer:addChild(mn)

	local four = cc.Sprite:create("4.jpg")
	four:setPosition(display.center)

	local bg = cc.Sprite:create("bg.jpg")
	bg:setPosition(display.cx-430,display.cy+100)
	layer:addChild(four)
	layer:addChild(bg)
	--end)

	return layer
end

function Scene4:showToast(message,node)
 
 
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

return Scene4