#ifndef __GPLAY_PRELOAD_LAYER_V2_H__
#define __GPLAY_PRELOAD_LAYER_V2_H__

#include "cocos2d.h"

#if COCOS2D_VERSION < 0x00030000

using namespace cocos2d;

namespace gplay {
    
    class GPlayLayer :  public CCLayer{
    public:
        GPlayLayer();

        virtual bool init(const CCSize & size, bool touchEnabled, bool touchAllAtOnce, int touchPriority);

        virtual void onEnter();

        virtual void onExit();

        virtual bool ccTouchBegan(cocos2d::CCTouch *touch, cocos2d::CCEvent *event) {
            return true;
        }

    protected:
        bool _touchEnabled;
        bool _touchAllAtOnce;
        int _touchPriority;

        bool _keypadEnabled;
    };

    class PreloadMessageBox;

    class GPlayPreloadLayer : public GPlayLayer {
    public:
        static GPlayPreloadLayer* getInstance();

        static GPlayPreloadLayer* getCurrInstance();

        ~GPlayPreloadLayer();
        
        void onUpdateProgress(double progress, double downloadSpeed);

        void onPreloadSuccessed();

        void onPreloadFailed(int errorCode);
        
        void listenToForeground(cocos2d::CCObject *obj);

        void menuCancelCallback(PreloadMessageBox* sender);
        void menuQuitCallback(PreloadMessageBox* sender);
        void menuRetryCallback(PreloadMessageBox* sender);

        virtual bool init();
        
        virtual void keyBackClicked();
    protected:
        GPlayPreloadLayer();

        cocos2d::CCProgressTimer* _progressBar;
        cocos2d::CCLabelTTF* _percentLabel;
        cocos2d::CCLabelTTF* _hintLabel;

        int _currentProgress;
    };
}
#endif //# COCOS2D_VERSION < 0x00030000
#endif /** __GPLAY_PRELOAD_LAYER_V2_H__ */
