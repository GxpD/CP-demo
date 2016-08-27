cc.log("loading SceneTwo.js");

var SceneTwoLayer=cc.Layer.extend({
	ctor:function(){
		this._super();
		var size = cc.winSize;
		
          var bg = new cc.Sprite(res.two_jpg);
            bg.x=size.width / 2-200;
            bg.y=size.height / 2;
            this.addChild(bg);

		var backB=new cc.MenuItemFont("返回",this.back,this);
        backB.x = size.width / 2-200;
        backB.y = size.height / 2 - 530;
        backB.setColor(cc.color(0,255, 255));

        var ShortcutB=new cc.MenuItemFont("创建快捷方式",this.Shortcut,this);
        ShortcutB.x = size.width / 2-200;
        ShortcutB.y = size.height / 2 - 450;
        ShortcutB.setColor(cc.color(0,255, 255));

        var mn=new cc.Menu(backB,ShortcutB);
        this.addChild(mn);
        return true;
	},
	back:function(sender){
         //cc.director.popScene();
         gplay.backFromGroup("Scene2");
        var scene=new SceneOneScene();
        cc.director.replaceScene(scene);

	},
    Shortcut:function(sender){
         //cc.director.popScene();
         gplay.createShortcut(function(code,msg){
            cc.log("点击创建快捷方式:code-"+code+",msg-"+msg);
            var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("code:"+code+",msg:"+msg);
                toastLayer.show();
         }.bind(this));
    }
});

var SceneTwoScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new SceneTwoLayer();
        this.addChild(layer);
    }
});