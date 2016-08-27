#include "GPlayPreloadLayerV2.h"
#if COCOS2D_VERSION < 0x00030000
#include <android/log.h>
#include "gplay.h"

#define  LOG_TAG    "GPlayPreloadLayer"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define  LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

using namespace cocos2d;

#ifndef EVENT_COME_TO_FOREGROUND
#define EVENT_COME_TO_FOREGROUND EVNET_COME_TO_FOREGROUND  
#endif

struct PreloadTextConf
{
    std::string networkError;
    std::string networkRetryText;
    std::string networkCancelText;
    
    std::string verifyError;
    std::string verifyRetryText;
    std::string verifyCancelText;

    std::string noSpaceError;
    std::string noSpaceContinueText;
    std::string noSpaceCancelText;

    std::string unknownError;
    std::string unknownQuitText;

    std::string quitTip;
    std::string quitCancelText;
    std::string quitConfirmText;

    std::string downloadText;
};

/*
typedef enum LanguageType
{
    kLanguageEnglish = 0,
    kLanguageChinese,
    kLanguageFrench,
    kLanguageItalian,
    kLanguageGerman,
    kLanguageSpanish,
    kLanguageRussian,
    kLanguageKorean,
    kLanguageJapanese,
    kLanguageHungarian,
    kLanguagePortuguese,
    kLanguageArabic
} ccLanguageType;
*/

static std::map<ccLanguageType, PreloadTextConf> s_preloadTextMap;

namespace gplay {

    static ccLanguageType s_choiceLanguage = kLanguageEnglish;

    GPlayLayer::GPlayLayer()
    : _touchEnabled(false)
    , _keypadEnabled(false)
    {
        m_bIgnoreAnchorPointForPosition = true;
        setAnchorPoint(ccp(0.5f, 0.5f));
    }

    bool GPlayLayer::init(const CCSize & size, bool touchEnabled, bool touchAllAtOnce, int touchPriority)
    {
        setContentSize(size);
        _touchEnabled = touchEnabled;
        _touchAllAtOnce = touchAllAtOnce;
        _touchPriority = touchPriority;

        return true;
    }

    void GPlayLayer::onEnter()
    {
        CCDirector* director = CCDirector::sharedDirector();
        // register 'parent' nodes first
        // since events are propagated in reverse order
        if (_touchEnabled)
        {
            if( _touchAllAtOnce == true )
                director->getTouchDispatcher()->addStandardDelegate(this, 0);
            else
                director->getTouchDispatcher()->addTargetedDelegate(this, _touchPriority, true);
        }

        CCNode::onEnter();

        if (_keypadEnabled)
            director->getKeypadDispatcher()->addDelegate(this);
    }

    void GPlayLayer::onExit()
    {
        CCDirector* director = CCDirector::sharedDirector();
        if( _touchEnabled )
            director->getTouchDispatcher()->removeDelegate(this);
    
        if (_keypadEnabled)
            director->getKeypadDispatcher()->removeDelegate(this);
    
        CCNode::onExit();
    }

    class PreloadMessageBox;

    typedef void (CCObject::*GPlayButtonCallback)(PreloadMessageBox*);

    class PreloadMessageBox : public GPlayLayer
    {
    public:
        static PreloadMessageBox* create(const std::string& message, 
            const std::string& btnText1, const std::string& btnText2, 
            GPlayButtonCallback callback1, GPlayButtonCallback callback2)
        {
            PreloadMessageBox* box = new PreloadMessageBox();
            if (box)
            {
                box->initView(message, btnText1, btnText2, callback1, callback2);
                box->autorelease();
                return box;
            }

            delete box;
            return NULL;
        }

        static PreloadMessageBox* create(const std::string& message, 
            const std::string& btnText1, GPlayButtonCallback callback1)
        {
            PreloadMessageBox* box = new PreloadMessageBox();
            if (box)
            {
                box->autorelease();
                box->initView(message, btnText1, "", callback1, NULL);
                return box;
            }

            delete box;
            return NULL;
        }

        PreloadMessageBox()
        : buttonBG1(NULL)
        , buttonBG2(NULL)
        , _callback1(NULL)
        , _callback2(NULL)
        , _bg(NULL)
        {
        }

        ~PreloadMessageBox()
        {
            if (_bg)
                _bg->removeFromParentAndCleanup(true);
            CCNotificationCenter::sharedNotificationCenter()->removeObserver(this, EVENT_COME_TO_FOREGROUND);
        }
        
        void onEnter()
        {
            GPlayLayer::onEnter();
            if (_bg == NULL && m_pParent)
            {
                _bg = CCLayerColor::create(ccc4(0,0,0,160));
                m_pParent->addChild(_bg);
            }
        }

        void initView(const std::string& message, 
            const std::string& btnText1, const std::string& btnText2,
            GPlayButtonCallback callback1, GPlayButtonCallback callback2)
        {
            CCDirector* director = CCDirector::sharedDirector();
            CCSize visibleSize = director->getVisibleSize();
            float visibleWidth = visibleSize.width;
            float visibleHeight = visibleSize.height;
            float designWidth,designHeight;
            if (visibleWidth > visibleHeight)
            {
                designWidth = 640;
                designHeight = 360;
            }
            else
            {
                designWidth = 360;
                designHeight = 640;
            }

            float contentSizeHeight = visibleHeight * 186 / designHeight;

            CCSprite* bg = CCSprite::create("res/gplay_custom_resource/new_wendang_bg.png");
            float sacleCoefficient = contentSizeHeight / bg->getContentSize().height;
            bg->setScale(sacleCoefficient);
            addChild(bg);

            float contentSizeWidth = bg->getContentSize().width * sacleCoefficient;
            GPlayLayer::init(CCSize(contentSizeWidth, contentSizeHeight), true, false, INT_MIN);

            bg->setPosition(CCPoint(m_obContentSize.width/2,m_obContentSize.height/2));

            ignoreAnchorPointForPosition(false);

            _messageText = message;
            _btnText1 = btnText1;
            _btnText2 = btnText2;

            float fontSize = 50.f;

            _messageLabel = CCLabelTTF::create(message.c_str(),"serif", fontSize);
            _messageLabel->setColor(ccc3(74,74,74));
            addChild(_messageLabel);
            CCSize messageLabelSize = _messageLabel->getContentSize();
            if (message.find('\n') != std::string::npos)
            {
                float tipScale = visibleHeight * 40/designHeight / messageLabelSize.height;
                _messageLabel->setScale(tipScale);
            }
            else
            {
                float tipScale = visibleHeight * 19/designHeight / messageLabelSize.height;
                _messageLabel->setScale(tipScale);
            }
            _messageLabel->setPosition(CCPoint(m_obContentSize.width/2, visibleHeight * 125/designHeight));

            if (btnText2.empty())
            {
                buttonBG1 = CCSprite::create("res/gplay_custom_resource/new_progress_button3.png");
                CCSize buttonSize = buttonBG1->getContentSize();
                buttonBG1->setScale(sacleCoefficient);
                buttonBG1->setPosition(CCPoint(m_obContentSize.width/2, visibleHeight * 48/designHeight));
                addChild(buttonBG1);

                _button1 = CCLabelTTF::create(btnText1.c_str(),"serif", fontSize);
                _button1->setScale(visibleHeight * 18/designHeight / _button1->getContentSize().height);
                _button1->setPosition(CCPoint(m_obContentSize.width/2, visibleHeight * 48/designHeight));
                addChild(_button1);
            }
            else
            {
                buttonBG1 = CCSprite::create("res/gplay_custom_resource/new_progress_button1.png");
                addChild(buttonBG1);
                buttonBG2 = CCSprite::create("res/gplay_custom_resource/new_progress_button2.png");
                addChild(buttonBG2);
                _button1 = CCLabelTTF::create(btnText1.c_str(),"serif",fontSize);
                addChild(_button1);
                _button2 = CCLabelTTF::create(btnText2.c_str(),"serif",fontSize);
                addChild(_button2);
    
                CCSize buttonSize = buttonBG1->getContentSize();
                buttonBG1->setScale(sacleCoefficient);
                buttonBG1->setPosition(CCPoint(m_obContentSize.width*0.283f, visibleHeight * 48/designHeight));
                buttonBG2->setScale(sacleCoefficient);
                buttonBG2->setPosition(CCPoint(m_obContentSize.width*0.717f, visibleHeight * 48/designHeight));
    
                _button1->setScale(visibleHeight * 18/designHeight / _button1->getContentSize().height);
                _button1->setPosition(CCPoint(m_obContentSize.width*0.283f, visibleHeight * 48/designHeight));
    
                _button2->setScale(visibleHeight * 18/designHeight / _button2->getContentSize().height);
                _button2->setPosition(CCPoint(m_obContentSize.width*0.717f, visibleHeight * 48/designHeight));
                _button2->setColor(ccc3(244,191,86));
            }

            _callback1 = callback1;
            _callback2 = callback2;

            //拦截按键事件
            _keypadEnabled = true;

            //响应程序进入前台运行的事件，更新文本以避免文本纹理丢失
            CCNotificationCenter::sharedNotificationCenter()->addObserver(this,
                                                                  callfuncO_selector(PreloadMessageBox::listenToForeground),
                                                                  EVENT_COME_TO_FOREGROUND,
                                                                  NULL);
        }

        void listenToForeground(CCObject *obj)
        {
            _messageLabel->setString("");
            _button1->setString("");
            _button2->setString("");

            _messageLabel->setString(_messageText.c_str());
            _button1->setString(_btnText1.c_str());
            _button2->setString(_btnText2.c_str());
        }

        void ccTouchEnded(CCTouch *touch, CCEvent *event)
        {
            CCPoint touchLocation = touch->getLocation();
            CCPoint local = buttonBG1->convertToNodeSpace(touchLocation);
            CCSize buttonSize = buttonBG1->getContentSize();
            if (local.x > 0 && local.y >0 && local.x < buttonSize.width && local.y < buttonSize.height)
            {
                (_listener1->*_callback1)(this);
            }
            else if(buttonBG2)
            {
                buttonSize = buttonBG2->getContentSize();
                local = buttonBG2->convertToNodeSpace(touchLocation);
                if (local.x > 0 && local.y >0 && local.x < buttonSize.width && local.y < buttonSize.height)
                    (_listener2->*_callback2)(this);
            }
        }

        protected:
            CCSprite* buttonBG1;
            CCSprite* buttonBG2;

            CCObject* _listener1;
            CCObject* _listener2;
            GPlayButtonCallback _callback1;
            GPlayButtonCallback _callback2;

            CCLabelTTF* _messageLabel;
            CCLabelTTF* _button1;
            CCLabelTTF* _button2;

            std::string _messageText;
            std::string _btnText1;
            std::string _btnText2;

            CCLayerColor* _bg;
    };

    static GPlayPreloadLayer* s_preloadProgressLayer = NULL;

    GPlayPreloadLayer* GPlayPreloadLayer::getCurrInstance()
    {
        return s_preloadProgressLayer;
    }

    GPlayPreloadLayer* GPlayPreloadLayer::getInstance()
    {
        if(s_preloadProgressLayer)
            return s_preloadProgressLayer;

        GPlayPreloadLayer* ret = new GPlayPreloadLayer();
        if (ret && ret->init())
        {
            ret->autorelease();
            return ret;
        }

        delete ret;
        return NULL;
    }

    bool GPlayPreloadLayer::init()
    {
        CCDirector* director = CCDirector::sharedDirector();
        CCSize size = director->getWinSize();
        if(!GPlayLayer::init(size, true, false, INT_MIN + 1)) {
            return false;
        }
        addChild(CCLayerColor::create(ccc4(0,0,0,150), size.width, size.height));

        ccLanguageType currentLanguage = CCApplication::sharedApplication()->getCurrentLanguage();
        if (currentLanguage != s_choiceLanguage && 
            s_preloadTextMap.find(currentLanguage) != s_preloadTextMap.end())
        {
            s_choiceLanguage = currentLanguage;
        }
        PreloadTextConf& choiceTextConf = s_preloadTextMap[s_choiceLanguage];

        //拦截按键事件
        _keypadEnabled = true;

        CCSize visibleSize = director->getVisibleSize();
        CCPoint origin = director->getVisibleOrigin();
        float visibleWidth = visibleSize.width;
        float visibleHeight = visibleSize.height;

        CCSprite* loadBg = CCSprite::create("res/gplay_custom_resource/new_progress_bg.png");
        CCSize loadBgSize = loadBg->getContentSize();

        float designWidth,designHeight;
        if (visibleWidth > visibleHeight)
        {
            designWidth = 640;
            designHeight = 360;
        }
        else
        {
            designWidth = 360;
            designHeight = 640;
        }
        float sacle = visibleHeight * 86 / designHeight / loadBgSize.height;
        loadBg->setScale(sacle);
        loadBg->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height * 75 / designHeight));
        this->addChild(loadBg);

        CCSprite* spriteProgressBar = CCSprite::create("res/gplay_custom_resource/new_progress_bar.png");
        CCSize progressBarSize = spriteProgressBar->getContentSize();
        _progressBar = CCProgressTimer::create(spriteProgressBar);
        _progressBar->setScale(sacle);
        _progressBar->setType(kCCProgressTimerTypeBar);
        //_progressBar->setMidpoint(Vec2(0,1));
        _progressBar->setPercentage(0.f);
        this->addChild(_progressBar);

        float fontSize = 50;

        _hintLabel = CCLabelTTF::create(choiceTextConf.downloadText.c_str(),"serif",fontSize);
        _hintLabel->setColor(ccc3(74,74,74));
        this->addChild(_hintLabel);

        _percentLabel = CCLabelTTF::create("0%","serif",fontSize);
        _percentLabel->setColor(ccc3(74,74,74));
        this->addChild(_percentLabel);
        
        _progressBar->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height * 75 / designHeight));
        _percentLabel->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height * 75 / designHeight));
        _hintLabel->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height * 92 / designHeight));

        _percentLabel->setScale(visibleHeight * 14/designHeight / _percentLabel->getContentSize().height);
        _hintLabel->setScale(visibleHeight * 14/designHeight / _hintLabel->getContentSize().height);

        CCNotificationCenter::sharedNotificationCenter()->addObserver(this,
                                                                  callfuncO_selector(GPlayPreloadLayer::listenToForeground),
                                                                  EVENT_COME_TO_FOREGROUND,
                                                                  NULL);
        return true;
    }

    void GPlayPreloadLayer::listenToForeground(cocos2d::CCObject *obj)
    {
        _percentLabel->setString("");
        _hintLabel->setString("");

        _hintLabel->setString(s_preloadTextMap[s_choiceLanguage].downloadText.c_str());

        char buf_str[16];  
        sprintf(buf_str,"%d%%", _currentProgress);
        _percentLabel->setString(buf_str);
    }

    static bool s_showQuitConfirm = true;

    void GPlayPreloadLayer::menuCancelCallback(PreloadMessageBox* sender)
    {
        sender->runAction(CCSequence::create(CCDelayTime::create(0.01f), 
                    CCRemoveSelf::create(), NULL));
        s_showQuitConfirm = true;
    }

    void GPlayPreloadLayer::menuQuitCallback(PreloadMessageBox* sender)
    {
        common::quitGame();
    }

    void GPlayPreloadLayer::menuRetryCallback(PreloadMessageBox* sender)
    {
        sender->runAction(CCSequence::create(CCDelayTime::create(0.01f), CCRemoveSelf::create(), NULL));

        GPlayPreloadLayer* preloadLayer = GPlayPreloadLayer::getInstance();
        CCScene* scene = CCDirector::sharedDirector()->getRunningScene();
        scene->addChild(preloadLayer, INT_MAX);
    
        common::retryPreload();
    }

    void GPlayPreloadLayer::keyBackClicked()
    {
        if(!s_showQuitConfirm)
            return;

        s_showQuitConfirm = false;
        PreloadTextConf& choiceTextConf = s_preloadTextMap[s_choiceLanguage];

        PreloadMessageBox* box = PreloadMessageBox::create(choiceTextConf.quitTip, choiceTextConf.quitCancelText, 
            choiceTextConf.quitConfirmText,
            GPlayButtonCallback(&GPlayPreloadLayer::menuCancelCallback),
            GPlayButtonCallback(&GPlayPreloadLayer::menuQuitCallback));
        box->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height/2));
        this->addChild(box, INT_MAX);
    }

    void GPlayPreloadLayer::onUpdateProgress(double progress, double downloadSpeed) {
        if ((int)progress != _currentProgress)
        {
            _currentProgress = (int)progress;

            char buf_str[16];  
            sprintf(buf_str,"%d%%", _currentProgress);
            _percentLabel->setString(buf_str);
            _progressBar->setPercentage(_currentProgress);
        }
    }

    void GPlayPreloadLayer::onPreloadSuccessed()
    {
        this->removeFromParentAndCleanup(true);
    }

    void GPlayPreloadLayer::onPreloadFailed(int errorCode)
    {
        PreloadTextConf& choiceTextConf = s_preloadTextMap[s_choiceLanguage];

        std::string errorMessage;
        std::string retryText;
        std::string quitText;

        if (common::PRELOAD_ERROR_VERIFY_FAILED == errorCode) {
            errorMessage = choiceTextConf.verifyError;
            retryText = choiceTextConf.verifyRetryText;
            quitText = choiceTextConf.verifyCancelText;
        }
        else if (common::PRELOAD_ERROR_NETWORK == errorCode) {
            errorMessage = choiceTextConf.networkError;
            retryText = choiceTextConf.networkRetryText;
            quitText = choiceTextConf.networkCancelText;
        }
        else if (common::PRELOAD_ERROR_NO_SPACE == errorCode) {
            errorMessage = choiceTextConf.noSpaceError;
            retryText = choiceTextConf.noSpaceContinueText;
            quitText = choiceTextConf.noSpaceCancelText;
        }
        else {
            errorMessage = choiceTextConf.unknownError;
            quitText = choiceTextConf.unknownQuitText;
        }

        PreloadMessageBox* preloadMessageBox;
        if (retryText.empty())
        {
            preloadMessageBox = PreloadMessageBox::create(errorMessage, quitText, 
                GPlayButtonCallback(&GPlayPreloadLayer::menuQuitCallback));
        }
        else
        {
            preloadMessageBox = PreloadMessageBox::create(errorMessage, retryText, quitText,
                GPlayButtonCallback(&GPlayPreloadLayer::menuRetryCallback),
                GPlayButtonCallback(&GPlayPreloadLayer::menuQuitCallback));
        }
        
        preloadMessageBox->setPosition(CCPoint(m_obContentSize.width/2, m_obContentSize.height/2));
        getParent()->addChild(preloadMessageBox, INT_MAX);

        this->removeFromParentAndCleanup(true);
    }

    GPlayPreloadLayer::GPlayPreloadLayer()
    : _progressBar(NULL)
    , _percentLabel(NULL)
    , _currentProgress(0)
    {
        s_preloadProgressLayer = this;
        
        PreloadTextConf englishConf = 
        {
            "Bah! Download interrupted!\nPick up where you left off? ", "Of course", "No",
            "Oops! Something went wrong.\nDownload failed.", "Retry", "Cancel",
            "No more storage space! Free up some\nspace before pressing continue!", "Continue", "Cancel", 
            "Hm, something isn't right\n but we're trying to fix it.", "Quit",
            "Download incomplete, \nare you sure you want to exit?", "No, must finish!", "YES",
            "Downloading game assets, patience is a virtue :)"
        };
        s_preloadTextMap[kLanguageEnglish] = englishConf;
 
        PreloadTextConf chineseConf = {
            "下载意外中断\n请确认网络通畅后点击继续!", "继续", "取消",
            "下载失败，请重试!", "重试", "取消",
            "存储空间满了\n请释放出一些空间后继续!", "继续", "取消",
            "遇到了未知的问题\n我们正在尝试解决当中!", "退出",
            "下载未完成，是否退出？", "取消", "确认退出",
            "正在下载游戏必要资源，请稍候…"
        };
        s_preloadTextMap[kLanguageChinese] = chineseConf;
    }

    GPlayPreloadLayer::~GPlayPreloadLayer() {
        s_preloadProgressLayer = NULL;
        CCNotificationCenter::sharedNotificationCenter()->removeObserver(this, EVENT_COME_TO_FOREGROUND);
    }
}

#endif
