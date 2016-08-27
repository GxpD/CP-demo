
cc.log("loading app.js");

var HelloWorldLayer = cc.Layer.extend({
    sprite:null,
    ctor:function () {
        //////////////////////////////
        // 1. super init first
        this._super();

        /////////////////////////////
        // 2. add a menu item with "X" image, which is clicked to quit the program
        //    you may modify it.
        // ask the window size
        var size = cc.winSize;

        
        gplay.initSDK("gplaydemo", "gplaydemo", "gplaydemo");
        var isInGplay=gplay.isInGplayEnv();
        var isInGplayW = new cc.LabelTTF("GPlay环境:"+isInGplay.toString(), "Arial", 38);
        // position the label on the center of the screen
        isInGplayW.x = size.width / 2-300;
        isInGplayW.y = size.height / 2 + 260;
        isInGplayW.setColor(cc.color(0,255, 255));
        // add the label as a child to this layer
        this.addChild(isInGplayW, 5);
        
        
        var channelID=gplay.getChannelId();
        var channelIDW = new cc.LabelTTF("渠道ID:"+channelID.toString(), "Arial", 38);
        channelIDW.x = size.width / 2;
        channelIDW.y = size.height / 2 + 190;
        channelIDW.setColor(cc.color(0,255, 255));
        this.addChild(channelIDW, 5);

        var loginSt=gplay.isLogined();
        var loginStW = new cc.LabelTTF("登录状态:"+loginSt.toString(), "Arial", 38);
        loginStW.x = size.width / 2;
        loginStW.y = size.height / 2 + 260;
        loginStW.setColor(cc.color(0,255, 255));
        this.addChild(loginStW, 5);

        /*var userID=gplay.getUserID();
        var userIDW = new cc.LabelTTF("用户ID:"+userID, "Arial", 38);
        userIDW.x = size.width / 2+200;
        userIDW.y = size.height / 2 + 250;
        userIDW.setColor(cc.color(0,255, 255));
        this.addChild(userIDW, 5);*/

        var netType=gplay.getNetworkType();
        var netTypeW=null;
        switch(netType){
            case gplay.NetworkType.NO_NETWORK:
                 netTypeW=netType+"-无网络"
            break;
            case gplay.NetworkType.MOBILE:
                 netTypeW=netType+"-移动网络"
            break;
            case gplay.NetworkType.WIFI:
                 netTypeW=netType+"-WIFI"
            break;
            default:
            break;
        }

        var isInGplayS= new cc.LabelTTF("网络类型:"+netTypeW, "Arial", 38);
        isInGplayS.x = size.width / 2-300;
        isInGplayS.y = size.height / 2 + 190;
        isInGplayS.setColor(cc.color(0,255, 255));
        this.addChild(isInGplayS, 5);

        var quitGame=new cc.MenuItemFont("退出游戏",this.quitGameF,this);
        quitGame.x = size.width / 2-800;
        quitGame.y = size.height / 2 - 560;
        quitGame.setColor(cc.color(0,255, 255));

        var login=new cc.MenuItemFont("登录",this.loginF,this);
        login.x = size.width / 2-480;
        login.y = size.height / 2 - 560;
        login.setColor(cc.color(0,255, 255));

        var next=new cc.MenuItemFont("界面1",this.toNext,this);
        next.x = size.width / 2-200;
        next.y = size.height / 2 - 560;
        next.setColor(cc.color(0,255, 255));
        var m=this;
        gplay.preloadResourceBundle("mainScene",function(){

            var bg = new cc.Sprite(res.HelloWorld_png);
            bg.x=size.width / 2-300;
            bg.y=size.height / 2;
            m.addChild(bg);
            var bg1 = new cc.Sprite(res.bg_jpg);
            bg1.x=size.width / 2;
            bg1.y=size.height / 2;
            m.addChild(bg1);
            var bg2 = new cc.Sprite(res.HelloWorld_png);
            bg2.x=size.width / 2+300;
            bg2.y=size.height / 2;
            m.addChild(bg2);
        });

           
        
        var mn=new cc.Menu(quitGame,login,next);
        this.addChild(mn);
        return true;
    },
    quitGameF:function(sender){
      gplay.quitGame();
    },
    loginF:function(sender){
        gplay.login(function(code,msg){
            cc.log("点击登录:code"+code+",msg-"+msg);
            
                var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("code:"+code+",msg:"+msg);
                toastLayer.show();
        }.bind(this));
    },
    toNext:function(sender){
        gplay.backFromGroup("mainScene");
        gplay.preloadResourceBundle("Scene1",function(){

            var scene=new SceneOneScene();
            cc.director.replaceScene(scene);
        });
    },
    

});

var HelloWorldScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new HelloWorldLayer();
        this.addChild(layer);
    }
});

