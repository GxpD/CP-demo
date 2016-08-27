cc.log("loading SceneFour.js");

var SceneFourLayer=cc.Layer.extend({
    ctor:function(){
        this._super();
        var size = cc.winSize;
        
        var bg = new cc.Sprite(res.four_jpg);
            bg.x=size.width / 2-200;
            bg.y=size.height / 2;
            this.addChild(bg);
        var bg1= new cc.Sprite(res.bg_jpg);
            bg1.x=size.width / 2+240;
            bg1.y=size.height /2+100;
            this.addChild(bg1);

        var backB=new cc.MenuItemFont("返回",this.back,this);
        backB.x = size.width / 2-200;
        backB.y = size.height / 2 - 530;
        backB.setColor(cc.color(0,255, 255));

        var shareB=new cc.MenuItemFont("分享",this.share,this);
        shareB.x = size.width / 2-200;
        shareB.y = size.height / 2 - 450;
        shareB.setColor(cc.color(0,255, 255));

        var mn=new cc.Menu(backB,shareB);
        this.addChild(mn);
        return true;
    },
    back:function(sender){
         //cc.director.popScene();
         gplay.backFromGroup("Scene4","scene4");
        var scene=new SceneOneScene();
        cc.director.replaceScene(scene);
    },
    share:function(sender){
         //cc.director.popScene();
         var params = new GplayShareParams();

            params.setPageUrl("http://192.168.1.3");                                // 分享页面 Url
            params.setTitle("JSSDKDemo");                                           // 分享标题
            params.setText("JSSDKDemo 是 GplaySDK 的线下测试版本");                    // 分享内容
            params.setImgUrl("http://192.168.1.3:8888/moon/icon/large_icon.png");   // 分享图片 Url
            params.setImgTitle("large_icon");                                       // 分享图片标题

            gplay.share(params, function (code, msg) {
                cc.log("点击分享:code-"+code+",msg-"+msg);
                var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("code:"+code+",msg:"+msg);
                toastLayer.show();
            }.bind(this));
    }
});

var SceneFourScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new SceneFourLayer();
        this.addChild(layer);
    }
});