#include "cocos2d.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include "test.h"

#define CLASS_NAME "org/cocos2dx/lua/TestH"

using namespace cocos2d;

extern "C"
{

int showName(const char *name) 
{
	JniMethodInfo t;
	jint number=0;
	if(JniHelper::getStaticMethodInfo(t, CLASS_NAME, "showName", "(Ljava/lang/String;)I"))
	{	
		jstring jTitle = t.env->NewStringUTF(name);
		number=t.env->CallStaticIntMethod(t.classID, t.methodID, jTitle);
		t.env->DeleteLocalRef(jTitle);
	}
	return number;
}

int Java_org_cocos2dx_lua_TestH_getSum(JNIEnv* env,jobject thiz,jint num){
     num++;
     return num;
}
}
