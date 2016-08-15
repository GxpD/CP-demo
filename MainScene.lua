require("Gplay")
--require ("Cocos2d")
--require ("Cocos2dConstants")

local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()

    gplay:initSDK(gplaydemo,gplaydemo,gplaydemo)

    -- add background image
    gplay:preloadGroup("mainScene",function ()
        -- body
        display.newSprite("he.jpg")
        :move(display.center)
        :addTo(self)
    display.newSprite("HelloWorld.png")
        :move(display.cx-200,display.cy)
        :addTo(self)
    display.newSprite("HelloWorld.png")
        :move(display.cx+200,display.cy)
        :addTo(self)
   local bool=gplay:isInGplayEnv()

   cc.Label:createWithSystemFont("GP环境:"..tostring(bool), "Arial", 40)
        :move(display.cx-250, display.cy + 200)
        :setColor(cc.c3b(255, 0, 0))
        :addTo(self)
local x = gplay:getNetworkType()
cc.Label:createWithSystemFont("网络类型:"..tostring(x), "Arial", 40)
        :move(display.cx+250, display.cy + 200)
        :setColor(cc.c3b(0, 255, 0))
        :addTo(self)

        cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :setColor(cc.c3b(0, 0, 255))
        :addTo(self)
     local button = cc.MenuItemFont:create("跳转")
                                   :setColor(cc.c3b(0, 0, 0))
                                   :setPosition(display.cx-550, display.cy - 550)

     --local dir = cc.Director:getInstance()
     local function clicklisent(sender)
        -- body
        --gplay:backFromGroup("mainScene")
        local twoSnece =require("app/views/Two")
        local snece = twoSnece.create()
        if snece then
        cc.Director:getInstance():pushScene(snece)
        end
        release_print("touch clicklisent")
     end

     button:registerScriptTapHandler(clicklisent)
     local mn = cc.Menu:create(button)
                       --:setPosition(display.cx, display.cy - 400)
                        :addTo(self)

    end)
    
   --[[cc.Label:createWithSystemFont("NO_NET:"..tostring(gplay.NetworkType.NO_NETWORK), "Arial", 40)
        :move(display.cx+200, display.cy + 100)
        :addTo(self)
   cc.Label:createWithSystemFont("MOBILE:"..tostring(gplay.NetworkType.MOBILE), "Arial", 40)
        :move(display.cx+400, display.cy + 100)
        :addTo(self)
    cc.Label:createWithSystemFont("WIFI:"..tostring(gplay.NetworkType.WIFI), "Arial", 40)
        :move(display.cx+450, display.cy+50 )
        :addTo(self) ]]
    -- add HelloWorld label
    

end

return MainScene
