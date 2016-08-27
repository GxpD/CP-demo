var ToastLayer = cc.Layer.extend({
  contentLabel:null,
  ctor:function (content) {
    this._super();
    var size = cc.winSize;

    this.contentLabel = new cc.LabelTTF(content, "Arial", 23);
    this.contentLabel.setColor(cc.color(255,0, 0));
    this.contentLabel.setAnchorPoint(0,0);
    this.contentLabel.setPosition(80, 100);
    this.contentLabel.setDimensions(cc.size(860,70));
    this.contentLabel.textAlign = cc.TEXT_ALIGNMENT_CENTER;
    this.contentLabel.verticalAlign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER;
    this.addChild(this.contentLabel, 1);
    this.setCascadeOpacityEnabled(true);
  },
  //设置Toast显示内容
  setContent:function(content) {
    this.contentLabel.setString(content);
  },
  //设置Toast显示时间，包括显示持续时间和淡出持续时间
  show:function(delay, sec) {
    var delayOut = delay || 1.5;
    var timeOut = sec || 0.5;
    this.setOpacity(255);
    this.runAction(cc.sequence(cc.delayTime(delayOut), cc.fadeOut(timeOut)));
  }
});