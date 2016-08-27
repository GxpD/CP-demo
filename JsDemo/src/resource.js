cc.log("loading resource.js");

var res = {
    HelloWorld_png : "res/HelloWorld.png",
    bg_jpg : "res/bg.jpg",
    one_jpg : "res/1.jpg",
    two_jpg : "res/2.jpg",
    three_jpg : "res/3.jpg",
    four_jpg : "res/4.jpg",
    progress_jpg : "res/progress.jpg",
};

var g_resources = [];
for (var i in res) {
    g_resources.push(res[i]);
}
