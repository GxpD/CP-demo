local Scene3 =class("Scene3",function()
	return cc.Scene:create()
	end)

function Scene3.create()
	-- body
	local scene = Scene3.new()
	scene:addChild(scene:createLayer())
	return scene
end

function Scene3:createLayer()
	-- body
	local layer = cc.Layer:create()
	 --gplay:preloadGroup("Scene1", function ()
		-- body
	
	
	local backB = cc.MenuItemFont:create("返回")
                                   :setPosition(display.cx-150, display.cy - 550)
                                    :setColor(cc.c3b(0, 255, 255)) 
    local payB = cc.MenuItemFont:create("支付")
                                   :setPosition(display.cx-150, display.cy - 450)
                                    :setColor(cc.c3b(0, 255, 255))                                                             
    local function back()
     	-- body
     	cc.Director:getInstance():popScene()
    end
    backB:registerScriptTapHandler(back)

	local function pay()
     	-- body
     	local params = GplayPayParams.new();

		params:setProductID("id_gold");      -- 商品 ID
		params:setProductName("gold");       -- 商品名称
		params:setProductPrice(1);           -- 商品单价 number 类型
		params:setProductCount(1);           -- 商品数量 number 类型
		params:setProductDescription("game currency, use to purchase in app"); -- 商品描述
		params:setGameUserID("lixiaoyaoid"); -- 玩家 ID
		params:setGameUserName("lixiaoyao"); -- 玩家昵称
		params:setServerID("skybigid");      -- 服务器 ID
		params:setServerName("skybig");      -- 服务器名称
		params:setExtraData('{"key1":"value1", "key2":"value2"}'); -- 扩展参数, 默认为空

		gplay:pay(params, function (ret, msg)
		    
		    Scene3:showToast("pay:返回码："..tostring(ret)..",描述："..msg,self)
		end)
    end
	payB:registerScriptTapHandler(pay)

	local mn = cc.Menu:create(backB,payB) 
	layer:addChild(mn)
	local bg = cc.Sprite:create("3.jpg")
	bg:setPosition(display.center)
	layer:addChild(bg)
	--end)

	return layer
end

function Scene3:showToast(message,node)
 
 
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

return Scene3