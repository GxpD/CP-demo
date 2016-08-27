cc.log("loading SceneOne.js");

var SceneOneLayer=cc.Layer.extend({
	ctor:function(){
		this._super();
		var size = cc.winSize;
		var isInGplayW = new cc.LabelTTF("界面1", "Arial", 42);
        isInGplayW.x = size.width / 2;
        isInGplayW.y = size.height / 2 + 200;
        isInGplayW.setColor(cc.color(0,255, 255));
        this.addChild(isInGplayW, 1);

          var bg = new cc.Sprite(res.one_jpg);
            bg.x=size.width / 2-200;
            bg.y=size.height / 2;
            this.addChild(bg);

		var backB=new cc.MenuItemFont("返回",this.back,this);
        backB.x = size.width / 2-300;
        backB.y = size.height / 2 - 560;
        backB.setColor(cc.color(0,255, 255));

        var Scene2B=new cc.MenuItemFont("界面2",this.Scene2,this);
        Scene2B.x = size.width / 2-450;
        Scene2B.y = size.height / 2 - 560;
        Scene2B.setColor(cc.color(0,255, 255));

		var Scene3B=new cc.MenuItemFont("界面3",this.Scene3,this);
        Scene3B.x = size.width / 2-600;
        Scene3B.y = size.height / 2 - 560;
        Scene3B.setColor(cc.color(0,255, 255));

        var Scene4B=new cc.MenuItemFont("界面4",this.Scene4,this);
        Scene4B.x = size.width / 2-750;
        Scene4B.y = size.height / 2 - 560;
        Scene4B.setColor(cc.color(0,255, 255));

		var extendB=new cc.MenuItemFont("扩展JAR:返回数值",this.extend,this);
        extendB.x = size.width / 2-300;
        extendB.y = size.height / 2 - 240;
        extendB.setColor(cc.color(0,255, 255));

        var SyncB=new cc.MenuItemFont("同步扩展API:getVersion",this.Sync,this);
        SyncB.x = size.width / 2-300;
        SyncB.y = size.height / 2 - 320;
        SyncB.setColor(cc.color(0,255, 255));

        var AsyncB=new cc.MenuItemFont("异步扩展API:register",this.Async,this);
        AsyncB.x = size.width / 2-300;
        AsyncB.y = size.height / 2 - 400;
        AsyncB.setColor(cc.color(0,255, 255));

		var m=this;

		gplay.setPreloadResponseCallback(function(resultCode, errorCode, groupName, percent, speed) {
			if(percent==0){
				var to1 = cc.ProgressTo(0.01,100);
                var progressCooling = new cc.ProgressTimer(cc.Sprite(res.progress_jpg));  
		        progressCooling.setType(cc.ProgressTimer.TYPE_BAR);

		       // progressCooling.setPercentage(0);  // 回复到0  
		        progressCooling.x = cc.winSize.width / 2;
        		progressCooling.y = cc.winSize.height / 2 - 200;
	          progressCooling.setVisible(true);
	          progressCooling.runAction(cc.RepeatForever(to1));  
	          m.addChild(progressCooling, 5); 
			}
			
	          cc.log("resultCode:"+resultCode+",errorCode:"+errorCode+",groupName:"+groupName+",percent:"+percent+",speed:"+speed);
		});

        var mn=new cc.Menu(backB,Scene2B,Scene3B,Scene4B,extendB,SyncB,AsyncB);
        this.addChild(mn);
        return true;
	},
	back:function(sender){

         gplay.backFromGroup("Scene1");
        var scene=new HelloWorldScene();
        cc.director.replaceScene(scene);
	},
	Scene4:function(sender){

         gplay.backFromGroup("Scene1");
         gplay.preloadResourceBundles(["Scene4","scene4"],function(){
           var scene=new SceneFourScene();
        cc.director.replaceScene(scene);
        });
        
	},
	Scene3:function(sender){

         gplay.backFromGroup("Scene1");
         gplay.preloadResourceBundles("Scene3",function(){
           var scene=new SceneThreeScene();
        cc.director.replaceScene(scene);
        });
	},
	Scene2:function(sender){

        gplay.backFromGroup("Scene1");
        gplay.preloadResourceBundle("Scene2",function(){
           var scene=new SceneTwoScene();
           cc.director.replaceScene(scene);
        });
	},
	extend:function(sender){
		cc.log("点击扩展按钮");
		jsb.reflection.callStaticMethod("org/cocos2dx/javascript/JStest", "hello", "(Ljava/lang/String;)V", "this is a message from js");
	    var result = jsb.reflection.callStaticMethod("org/cocos2dx/javascript/JStest", "sum", "(I)I", 3);
	    var extendS = new cc.LabelTTF("返回数值:"+result, "Arial", 38);
        extendS.x = cc.winSize.width / 2+300;
        extendS.y = cc.winSize.height / 2 + 200;
        extendS.setColor(cc.color(0,255, 255));
        this.addChild(extendS, 1);
	},
	Sync:function(sender){
        var s={"id":2};
		var params = JSON.stringify(s);
		var version=gplay.callSyncFunc("getVersion",params);
		cc.log("点击同步按钮:sdk版本="+version);
		var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("sdk版本="+version);
                toastLayer.show();
	},
	Async:function(sender){
		var s={"id":2};
		var params = JSON.stringify(s);
		gplay.callAsyncFunc("register",params, function(code,msg){
			cc.log("点击异步按钮:code:"+code+",msg:"+msg);
			var toastLayer = new ToastLayer("Welcome to Toast");
                toastLayer.setOpacity(0);
                this.addChild(toastLayer);
                toastLayer.setContent("code:"+code+",msg:"+msg);
                toastLayer.show();
		}.bind(this));
       
	},

});

var SceneOneScene = cc.Scene.extend({
    onEnter:function () {
        this._super();
        var layer = new SceneOneLayer();
        this.addChild(layer);
    }
});
