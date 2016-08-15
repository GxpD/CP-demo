#include "HelloLua.h"

int HelloLua(lua_State *pL ) {
   int number = lua_tonumber(pL, 1);

    number = number + 1;

    lua_pushnumber(pL, number);

    return 1;
}

int sd(lua_State *pL ) {
   int number = lua_tonumber(pL, 1);

    number = number - 3;

    lua_pushnumber(pL, number);

    return 1;
}
