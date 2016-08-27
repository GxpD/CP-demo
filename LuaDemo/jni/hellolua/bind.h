#ifndef bind_H
#define bind_H
 
#include "cocos2d.h"

extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
};

int javafunction(lua_State *pL);

using namespace cocos2d;
 
int showNa(lua_State *pL);
 
#endif