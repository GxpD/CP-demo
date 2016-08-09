--require ("Cocos2d")
--require ("Cocos2dConstants")

local Two =class("Two",function()
	return cc.Scene:create()
	end)

function Two.create()
	-- body
	local snece = Two.new()
	snece:addChild(snece:createLayer())
	return snece
end

function Two:createLayer()
	-- body
	local layer = cc.Layer:create()
	 gplay:preloadGroup("twoSC", function ()
		-- body
	local bg = cc.Sprite:create("HelloWorld.png")
	bg:setPosition(display.center)

	local button = cc.MenuItemFont:create("检查登录状态")
                                   :setPosition(display.cx-550, display.cy - 550)

    local button1 = cc.MenuItemFont:create("登录")
                                   :setPosition(display.cx-700, display.cy - 550)
    local button2 = cc.MenuItemFont:create("退出")
                                   :setPosition(display.cx-400, display.cy - 550)
    local button3 = cc.MenuItemFont:create("支付")
                                   :setPosition(display.cx-790, display.cy - 550)
	local button4 = cc.MenuItemFont:create("创建快捷")
                                   :setPosition(display.cx-300, display.cy - 550)
    local button5 = cc.MenuItemFont:create("分享")
                                   :setPosition(display.cx-850, display.cy - 550) 
     local function click(sender)
        -- body
        --gplay:backFromGroup("mainScene")
        --local label = cc.LabelTTF:create("开始检查","Arial",40)
        	  --label:setPosition(display.center)
        --layer.addChild(label)
		local bool=gplay:isLogined()
		cc.Label:createWithSystemFont("登录状态:"..tostring(gplay.ActionResultCode.USER_RESULT_NETWROK_ERROR), "Arial", 40)
        :move(display.cx-250, display.cy + 200)
        :addTo(self)
        --local bg2 = cc.Sprite:create("he.jpg")
	        --bg2:setPosition(display.center)
		--layer:addChild(bg2)
     end

     button:registerScriptTapHandler(click)
     local function loginclick()
     	-- body
     	gplay:login(function(code, msg)
    	if code == gplay.ActionResultCode.USER_LOGIN_RESULT_SUCCESS then
        -- 登录成功
        release_print("login:成功")
    	elseif code == gplay.ActionResultCode.USER_LOGIN_RESULT_FAIL then
        -- 登录失败
        release_print("login:失败")
        end
            end)
     end
	button1:registerScriptTapHandler(loginclick)
	local function quit()
		-- body
		gplay:quitGame()
	end
	button2:registerScriptTapHandler(quit)
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
		    release_print("pay:点击支付")
		    release_print("pay:返回码："..tostring(ret)..",描述："..msg)
		end)
	end
	button3:registerScriptTapHandler(pay)

	local function Shortcut()
		-- body
		gplay:createShortcut(function (code,msg)
			-- body
		release_print("Shortcut:返回码："..tostring(code)..",描述："..msg)
		end) 
	end
	button4:registerScriptTapHandler(Shortcut)
	local function share()
		-- body
		local params = GplayShareParams.new()

				params:setPageUrl("http://192.168.1.3");                                -- 分享页面
				params:setTitle("LUASDKDemo");                                          -- 分享标题
				params:setText("LUASDKDemo 是 GplaySDK 的线下测试版本");                   -- 分享内容
				params:setImgUrl("http://192.168.1.3:8888/moon/icon/large_icon.png");   -- 分享图片
				params:setImgTitle("large_icon");                                       -- 分享图片标题

				gplay:share(params, function(ret, msg)
				    release_print("share:返回码："..tostring(ret)..",描述："..msg)
				end)
	end
	button5:registerScriptTapHandler(share)
     local mn = cc.Menu:create(button,button1,button2,button3,button4,button5) 
	layer:addChild(mn)
	layer:addChild(bg)
	end)
	return layer
end

return Two