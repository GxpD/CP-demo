#include "bind.h"

#include "cocos2d.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include "test.h"

int javafunction(lua_State *pL){
	int a = lua_tonumber(pL, 1);
	int b = lua_tonumber(pL, 2);
	int sum = a+b;

    lua_pushnumber(pL, sum);

    return 1;
}

int showNa(lua_State *pL){

	const char *Name = lua_tostring(pL, 1);
	int number=showName(Name);
	lua_pushnumber(pL,number);	
    return 1;
}
