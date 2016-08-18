require ("Gplay")
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    gplay:initSDK(gplaydemo,gplaydemo,gplaydemo)--初始化sdk

    local isInGp=gplay:isInGplayEnv()--判断是否在GPlay环境下

    cc.Label:createWithSystemFont("GP环境:"..tostring(isInGp), "Arial", 40)
        :move(display.cx-310, display.cy + 290)
        :setColor(cc.c3b(0, 255, 255))
        :addTo(self)

	local isLogin = gplay:isLogined()--判断登录状态

	cc.Label:createWithSystemFont("登录状态："..tostring(isLogin), "Arial", 40)
        :move(display.cx, display.cy + 290)
        :setColor(cc.c3b(0, 255, 255))
        :addTo(self)

	local userID=gplay:getUserID()--获取用户id
    
    if userID=="" then
    	userID="未登录"
    	end
	cc.Label:createWithSystemFont("用户ID:"..userID, "Arial", 40)
        :move(display.cx+300, display.cy + 290)
        :setColor(cc.c3b(0, 255, 255))
        :addTo(self)

	local netTpye = gplay:getNetworkType()--判断网络类型

	local tpyeString = nil
    if netTpye==0 then
       tpyeString="0-移动数据"
       elseif netTpye==1 then
       	tpyeString="1-WiFi"
       else 
       	tpyeString="无网络"
       end

	cc.Label:createWithSystemFont("网络类型:"..tpyeString, "Arial", 40)
        :move(display.cx-310, display.cy + 200)
        :setColor(cc.c3b(0, 255, 255))
        :addTo(self)

     

    gplay:preloadGroup("mainScene",function ()--加载资源包
    	-- body
    	display.newSprite("bg.jpg")
        :move(display.center)
        :addTo(self)
	display.newSprite("HelloWorld.png")
        :move(display.cx-260,display.cy)
        :addTo(self)

    display.newSprite("HelloWorld.png")
        :move(display.cx+260,display.cy)
        :addTo(self)

    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(45)

    local login = cc.MenuItemFont:create("登录")
                                 :setPosition(display.cx-570, display.cy-550)
    local quit = cc.MenuItemFont:create("退出游戏")
                                 :setPosition(display.cx-845, display.cy-550)
    local skipNext = cc.MenuItemFont:create("界面1")
                                 :setPosition(display.cx-300, display.cy-550)

     local function loginclick()--点击事件：登录
     	-- body
     	gplay:login(function(code, msg)
    	if code == gplay.ActionResultCode.USER_LOGIN_RESULT_SUCCESS then
        -- 登录成功
        self:showToast("login:成功,msg:"..msg,self)
    	elseif code == gplay.ActionResultCode.USER_LOGIN_RESULT_FAIL then
        -- 登录失败
        self:showToast("login:失败,msg:"..msg,self)
        end
            end)
     end                              
    login:registerScriptTapHandler(loginclick)

	local function quitG()--点击事件：退出游戏
		-- body
		gplay:quitGame()
	end
	quit:registerScriptTapHandler(quitG)

    local function skipN(sender)--点击事件：跳转界面1
        -- body
        gplay:backFromGroup("mainScene")
        gplay:preloadGroup("Scene1",function ()
        	-- body
				
                local Scene1 =require("app/views/Scene1")
		        local scene = Scene1.create()
		        if scene then
		        cc.Director:getInstance():pushScene(scene)
		        end
        end)

     end
	skipNext:registerScriptTapHandler(skipN)

    local mn = cc.Menu:create(login,quit,skipNext)
    					:setPosition(display.cx, display.cy)
                        :addTo(self)
    end)

end


function MainScene:showToast(message,node)
 
 
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
return MainScene
