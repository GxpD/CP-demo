cc.log("loading SceneThree.js");

var SceneThreeLayer=cc.Layer.extend({
    ctor:function(){
        this._super();
        var size = cc.winSize;
        
          var bg = new cc.Sprite(res.three_jpg);
            bg.x=size.width / 2-200;
            bg.y=size.height / 2;
            this.addChild(bg);

        var backB=new cc.MenuItemFont("返回",this.back,this);
        backB.x = size.width / 2-200;
        backB.y = size.height / 2 - 530;
        backB.setColor(cc.color(0,255, 255));

        var payB=new cc.MenuItemFont("支付",this.pay,this);
        payB.x = size.width / 2-200;
        payB.y = size.height / 2 - 450;
        payB.setColor(cc.color(0,255, 255));

        var mn=new cc.Menu(backB,payB);
        this.addChild(mn);
        return true;
    },
    back:function(sender){
         //cc.director.popScene();
         gplay.backFromGroup("Scene3");
        var scene=new SceneOneScene();
        cc.director.replaceScene(scene);
    },
    pay:function(sender){
         //cc.director.popScene();
        var params = new GplayPayParams();

            params.setProductID("id_gold");    // 商品 ID
            params.setProductName("gold");     // 商品名称
            params.setProductPrice(1);         // 商品单价 number 类型
            params.setProductCount(1);         // 商品数量 number 类型
            params.setProductDescription("game currency, use to purchase in app");    // 商品描述
            params.setGameUserID("lixiaoyaoid");     // 玩家 ID
            params.setGameUserName("lixiaoyao");     // 玩家昵称
            params.setServerID("skybigid");          // 服务器 ID
            params.setServerName("skybig");          // 服务器名称
            params.setExtraData('{"key1":"value1", "key2":"value2"}'); // 扩展参数, 默认为空

            gplay.pay(params, function (code, msg) {
               cc.log("点击支付:code-"+code+",msg-"+msg);
               var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("code:"+code+",msg:"+msg);
                toastLayer.show();
            }.bind(this));   
    }
});

var SceneThreeScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new SceneThreeLayer();
        this.addChild(layer);
    }
});