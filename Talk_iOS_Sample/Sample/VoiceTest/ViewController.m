//
//  ViewController.m
//  VoiceTest
//
//  Created by kilo on 16/7/12.
//  Copyright © 2016年 kilo. All rights reserved.
//

#import "ViewController.h"
#import "YMVoiceService.h"


@interface ViewController ()<VoiceEngineCallback>

@end

@implementation ViewController

//1 主播模式, 2 听主播模式, 3 普通房间模式，4 离开房间
const int ANCHOR_MODE = 1;
const int LISTEN_ANCHOR_MODE = 2;
const int NORMAL_ROOM_MODE = 3;
const int NOT_INROOM_MODE = 4;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 启动YoumeService
    YMVoiceService *youMeVoiceEngineOC = [YMVoiceService getInstance];
    //允许使用移动网络
    [youMeVoiceEngineOC setUseMobileNetworkEnabled:true];
    
    //获取版本号显示到相应标签
    NSString* strTmp = @"ver:";
    NSString* strVersion = [NSString stringWithFormat:@"%d",[youMeVoiceEngineOC getSDKVersion]];
    _labelVersion.text = [strTmp stringByAppendingString:strVersion];
    
    mTips = @"No tips Now!";
    mRoomID = @"hostroom1";
    mMicEnable = true;
    mMonitorEnable = true;
    mMode = 0;
    mTalkEnable = true;
    
    _tfTips.text = mTips;
    _tfTips.enabled = false;
    _tfRoomID.text = mRoomID;
    
    _buttonAnchor.enabled = false;
    _buttonListenAnchor.enabled = false;
    _buttonJoinRoom.enabled = false;
    _buttonLeaveRoom.enabled = false;
    _buttonMic.enabled = false;
    _buttonMonitor.enabled = false;
    _buttonPauseTalk.enabled = false;
    
    self.mBInRoom = false;
    self.mBInitOK = false;
    
    [[YMVoiceService getInstance] initSDK:self appkey:@"YOUME670584CA1F7BEF370EC7780417B89BFCC4ECBF78" appSecret:@"yYG7XY8BOVzPQed9T1/jlnWMhxKFmKZvWSFLxhBNe0nR4lbm5OUk3pTAevmxcBn1mXV9Z+gZ3B0Mv/MxZ4QIeDS4sDRRPzC+5OyjuUcSZdP8dLlnRV7bUUm29E2CrOUaALm9xQgK54biquqPuA0ZTszxHuEKI4nkyMtV9sNCNDMBAAE=" regionId:RTC_CN_SERVER serverRegionName:@"cn"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 反初始化
    [[YMVoiceService getInstance] unInit];
    [YMVoiceService destroy];
}

////反初始化，释放SDK相关资源
//- (IBAction)onClickButtonUnInit:(id)sender {
//    [[YouMeVoiceEngineOC getInstance] unInit];
//    //设置加入会议按钮不可用
//    [self.buttonJoinRoom setEnabled:false];
//}

- (void)refreshUI{
    _buttonAnchor.enabled = false;
    _buttonListenAnchor.enabled = false;
    _buttonJoinRoom.enabled = false;
    _buttonLeaveRoom.enabled = false;
    _buttonMic.enabled = false;
    _buttonMonitor.enabled = false;
    _buttonPauseTalk.enabled = false;
    mMicEnable = true;
    mMonitorEnable = true;
    mTalkEnable = true;
    [_buttonPauseTalk setTitle:@"暂停通话" forState:UIControlStateNormal];
    [_buttonMic setTitle:@"关闭麦克风" forState:UIControlStateNormal];
    [_buttonMonitor setTitle:@"关闭监听" forState:UIControlStateNormal];
}


//主播模式
-(void)joinAnchorMode{
    
    int value = (arc4random() % 1000) + 1;
    NSString* strTmp = @"Anchor";
    NSString* strValue = [NSString stringWithFormat:@"%d",value];
    NSString* strUserID = [strTmp stringByAppendingString:strValue];
    self->mRoomID = _tfRoomID.text;
    mTips = @"正进入主播模式,麦克风:开";
    _tfTips.text = mTips;
    
    //单频道，自由麦模式进入频道
    [[YMVoiceService getInstance] joinChannelSingleMode:strUserID channelID:mRoomID userRole:YOUME_USER_HOST checkRoomExist:false];
}
//听主播模式
-(void)joinListenAnchorMode{
    
    int value = (arc4random() % 1000) + 1;
    NSString* strTmp = @"Listener";
    NSString* strValue = [NSString stringWithFormat:@"%d",value];
    NSString* strUserID = [strTmp stringByAppendingString:strValue];
    self->mRoomID = _tfRoomID.text;
    mTips = @"正进入听主播模式,麦克风:关";
    _tfTips.text = mTips;
    
    [[YMVoiceService getInstance] joinChannelSingleMode:strUserID channelID:mRoomID userRole:YOUME_USER_LISTENER ];
}

//普通房间模式
-(void)joinNormalRoomMode{
    
    int value = (arc4random() % 1000) + 1;
    NSString* strTmp = @"Userid";
    NSString* strValue = [NSString stringWithFormat:@"%d",value];
    NSString* strUserID = [strTmp stringByAppendingString:strValue];
    self->mRoomID = _tfRoomID.text;
    mTips = @"正进入普通房间模式,麦克风:开";
    _tfTips.text = mTips;
    
    [[YMVoiceService getInstance] joinChannelSingleMode:strUserID channelID:mRoomID userRole:YOUME_USER_TALKER_FREE ];
}



//主播模式按钮响应
- (IBAction)onClickButtonAnchor:(id)sender {
    mMode = ANCHOR_MODE;
    [self refreshUI];
    if(self.mBInRoom){
        [[YMVoiceService getInstance] leaveChannelAll];
    }else {
        [self joinAnchorMode];
    }
}


//听主播模式按钮响应
- (IBAction)onClickButtonListenAnchor:(id)sender {
    mMode = LISTEN_ANCHOR_MODE;
    [self refreshUI];
    if(self.mBInRoom){
        [[YMVoiceService getInstance] leaveChannelAll];
    }else {
        [self joinListenAnchorMode];
    }
}

//普通房间模式按钮响应
- (IBAction)onClickButtonJoinRoom:(id)sender {
    mMode = NORMAL_ROOM_MODE;
    [self refreshUI];
    if(self.mBInRoom){
        [[YMVoiceService getInstance] leaveChannelAll];
    }else {
        [self joinNormalRoomMode];
    }
}

//离开房间按钮响应
- (IBAction)onClickButtonLeaveRoom:(id)sender {
    mMode = NOT_INROOM_MODE;
    [self refreshUI];
    
    [[YMVoiceService getInstance] leaveChannelAll];
}





- (IBAction)onSliderBgVolumeChange:(id)sender {
    UISlider* slider = (UISlider *)sender;
    int volumeNum = roundf(slider.value);
    [[YMVoiceService getInstance] setBackgroundMusicVolume:volumeNum];
    //输出当前音量
    _labelBgVolume.text =[NSString stringWithFormat:@"%d",volumeNum];
    
}

- (IBAction)onClickButtonPlayBackgroundMusic:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kanong" ofType:@"mp3"];
    NSLog(@"Music file path:%@", path);
    [[YMVoiceService getInstance] playBackgroundMusic:path repeat:true];
}

- (IBAction)onClickButtonStopBackgroundMusic:(id)sender {
    [[YMVoiceService getInstance] stopBackgroundMusic];
}

-(IBAction)onClickRequestRestAPI:(id)sender{
    int rid=0;
    [[YMVoiceService getInstance] requestRestApi: @"query_im_gift_score_rank" strQueryBody:@"{\"StartDate\":20170706,\"EndDate\":20170706,\"Limit\":50,\"NeedFavoriteAnchor\":1}" requestID:&rid];
}


- (IBAction)onClickButtonPauseTalk:(id)sender {
    if(mTalkEnable)
    {
        [[YMVoiceService getInstance] pauseChannel];
        [_buttonPauseTalk setTitle:@"恢复通话" forState:UIControlStateNormal];
        mTalkEnable = false;
    }
    else
    {
        [[YMVoiceService getInstance] resumeChannel];
        [_buttonPauseTalk setTitle:@"暂停通话" forState:UIControlStateNormal];
        mTalkEnable = true;
    }
    
}

- (IBAction)onSliderDelayChange:(id)sender {
    //TODO

}


//点击空白屏幕收起编辑键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//通用事件回调
- (void)onYouMeEvent:(YouMeEvent_t)eventType errcode:(YouMeErrorCode_t)iErrorCode roomid:(NSString *)roomid param:(NSString *)param
{
    switch (eventType)
    {
        //case案例只覆盖了部分，仅供参考，详情请查询枚举类型YouMeEvent_t
        case YOUME_EVENT_INIT_OK:
        {
            self.mBInitOK = TRUE;
            mTips = @"SDK验证成功!";
            dispatch_async (dispatch_get_main_queue (), ^{
                [self.tfTips setText:mTips];
                [self.buttonAnchor setEnabled:self.mBInitOK];
                [self.buttonListenAnchor setEnabled:self.mBInitOK];
                [self.buttonJoinRoom setEnabled:self.mBInitOK];
                int rid=0;
            });
        }
            break;
        case YOUME_EVENT_INIT_FAILED:
        {
            // "初始化失败，错误码：" + errorCode;
            self.mBInitOK = FALSE;
            mTips = @"SDK验证失败!";
            dispatch_async (dispatch_get_main_queue (), ^{
                [self.tfTips setText:mTips];
                [self.buttonAnchor setEnabled:self.mBInitOK];
                [self.buttonListenAnchor setEnabled:self.mBInitOK];
                [self.buttonJoinRoom setEnabled:self.mBInitOK];
            });
        }
            break;
        case YOUME_EVENT_JOIN_OK:
        {
            mTips = @"加入频道成功";
            self.mBInRoom = true;
            
            //通知主线程刷新
            dispatch_async (dispatch_get_main_queue (), ^{
                switch (mMode) {
                    case ANCHOR_MODE:
                        //默认开启监听
                        [[YMVoiceService getInstance] setMicrophoneMute:false];
                        [[YMVoiceService getInstance] setSpeakerMute:false];
                        [[YMVoiceService getInstance] setHeadsetMonitorMicOn:true];
                        mTips = @"已进入主播模式,麦克风:开";
                        _buttonMic.enabled = true;
                        _buttonMonitor.enabled = true;
                        break;
                    case LISTEN_ANCHOR_MODE:
                        [[YMVoiceService getInstance] setMicrophoneMute:true];
                        [[YMVoiceService getInstance] setSpeakerMute:false];
                        mTips = @"已进入听主播模式,麦克风:关";
                        break;
                    case NORMAL_ROOM_MODE:
                        [[YMVoiceService getInstance] setMicrophoneMute:false];
                        [[YMVoiceService getInstance] setSpeakerMute:false];
                        mTips = @"已进入普通房间模式,麦克风:开";
                        break;
                    default:
                        break;
                }
                _buttonPauseTalk.enabled = true;
                _buttonAnchor.enabled = true;
                _buttonListenAnchor.enabled = true;
                _buttonJoinRoom.enabled = true;
                _buttonLeaveRoom.enabled = true;
                [self.tfTips setText:mTips];
            });
        
        }
            break;
        case YOUME_EVENT_LEAVED_ALL:
        {
            mTips = @"离开频道成功";
            self.mBInRoom = false;
            dispatch_async (dispatch_get_main_queue (), ^{
            switch (mMode) {
                case ANCHOR_MODE:
                    [self joinAnchorMode];
                    break;
                case LISTEN_ANCHOR_MODE:
                    [self joinListenAnchorMode];
                    break;
                case NORMAL_ROOM_MODE:
                    [self joinNormalRoomMode];
                    break;
                case NOT_INROOM_MODE:
                {
                    NSString* strTmp = @"已离开房间,errcode:";
                    NSString* strErrorCode = [NSString stringWithFormat:@"%d",iErrorCode];
                    mTips = [strTmp stringByAppendingString:strErrorCode];
                    [self.tfTips setText:mTips];
                    _buttonAnchor.enabled = true;
                    _buttonListenAnchor.enabled = true;
                    _buttonJoinRoom.enabled = true;
                    break;
                }
                default:
                    break;
            }
            });
            
        }
            break;
        case YOUME_EVENT_JOIN_FAILED:
        {
            mTips = @"进入语音频道失败";
            self.mBInRoom = false;
            NSString* strTmp = @"加入房间失败,errcode:";
            NSString* strErrorCode = [NSString stringWithFormat:@"%d",iErrorCode];
            mTips = [strTmp stringByAppendingString:strErrorCode];
            //通知主线程刷新
            dispatch_async (dispatch_get_main_queue (), ^{
                [self.tfTips setText:mTips];
                _buttonAnchor.enabled = true;
                _buttonListenAnchor.enabled = true;
                _buttonJoinRoom.enabled = true;
            });
        }
            break;
        case YOUME_EVENT_PAUSED:
        {
            NSString* strTmp = @"暂停通话 errcode:";
            NSString* strErrorCode = [NSString stringWithFormat:@"%d",iErrorCode];
            mTips = [strTmp stringByAppendingString:strErrorCode];
            dispatch_async (dispatch_get_main_queue (), ^{
                [self.tfTips setText:mTips];
            });
            
        }
            break;
        case YOUME_EVENT_RESUMED:
        {
            NSString* strTmp = @"恢复通话 errcode:";
            NSString* strErrorCode = [NSString stringWithFormat:@"%d",iErrorCode];
            mTips = [strTmp stringByAppendingString:strErrorCode];
            dispatch_async (dispatch_get_main_queue (), ^{
                [self.tfTips setText:mTips];
            });
            
        }
            break;
        case YOUME_EVENT_REC_PERMISSION_STATUS:
            if(iErrorCode == YOUME_ERROR_REC_NO_PERMISSION) {
                mTips = @"录音启动失败（此时不管麦克风mute状态如何，都没有声音输出";
            }
            break;
        case YOUME_EVENT_RECONNECTING:
            mTips = @"断网了，正在重连";
            break;
        case YOUME_EVENT_RECONNECTED:
            mTips = @"断网重连成功";
            break;
        case  YOUME_EVENT_OTHERS_MIC_OFF:
            mTips = [NSString stringWithFormat:@"其他用户的麦克风关闭,userid:%@",param];
            break;
        case YOUME_EVENT_OTHERS_MIC_ON:
            mTips = @"其他用户的麦克风打开";
            break;
        case YOUME_EVENT_OTHERS_SPEAKER_ON:
            mTips =@"其他用户的扬声器打开";
            break;
        case YOUME_EVENT_OTHERS_SPEAKER_OFF:
            mTips = @"其他用户的扬声器关闭";
            break;
        case YOUME_EVENT_OTHERS_VOICE_ON:
            mTips = [NSString stringWithFormat:@"UserID:%@ 开始讲话",param];
            break;
        case YOUME_EVENT_OTHERS_VOICE_OFF:
            mTips = [NSString stringWithFormat:@"UserID:%@ 停止讲话",param];
            break;
        case YOUME_EVENT_MY_MIC_LEVEL:
            mTips = [NSString stringWithFormat:@"麦克风的录音实时音量级别：%d",iErrorCode];
            break;
        case YOUME_EVENT_MIC_CTR_ON:
            mTips = @"麦克风被其他用户打开";
            break;
        case YOUME_EVENT_MIC_CTR_OFF:
            mTips = @"麦克风被其他用户关闭";
            break;
        case YOUME_EVENT_SPEAKER_CTR_ON:
            mTips = @"扬声器被其他用户打开";
            break;
        case YOUME_EVENT_SPEAKER_CTR_OFF:
            mTips = @"扬声器被其他用户关闭";
            break;
        case YOUME_EVENT_LISTEN_OTHER_ON:
            mTips = @"取消屏蔽某人语音";
            break;
        case YOUME_EVENT_LISTEN_OTHER_OFF:
            mTips = @"屏蔽某人语音";
            break;
        default:
            //"事件类型" + eventType + ",错误码" +
            break;
    }
    
    dispatch_async (dispatch_get_main_queue (), ^{
        [self.tfTips setText:mTips];
    });

}

//RestAPI回调
- (void)onRequestRestAPI: (int)requestID iErrorCode:(YouMeErrorCode_t) iErrorCode  query:(NSString*) strQuery  result:(NSString*) strResult
{
    NSLog(@"code:%d \nstr:%@ \nstrResult:%@",iErrorCode,strQuery,strResult);
    /**
     参考回调结果格式：
     
      code:0 
      str:{"command":"query_im_gift_score_rank","query":"{\"StartDate\":20170706,\"EndDate\":20170706,\"Limit\":50,\"NeedFavoriteAnchor\":1}"} 
      strResult:{"ActionStatus":"OK","ErrorCode":0,"ErrorInfo":"","RankCount":3,"RankList":[{"FavoriteAnchor":[{"AnchorID":"111111","GiftCount":1109,"GiftScore":1109}],"GiftCount":1109,"GiftScore":1109,"Location":"主trunk版本","NickName":"浅笑冷暖","SvrArea":"主干测试","UserID":"261150250951303543219238"},{"FavoriteAnchor":[{"AnchorID":"111111","GiftCount":110,"GiftScore":110}],"GiftCount":112,"GiftScore":112,"Location":"主trunk版本","NickName":"浅笑冷暖","SvrArea":"主干测试","UserID":"51303543219238"},{"FavoriteAnchor":[{"AnchorID":"111111","GiftCount":1,"GiftScore":1}],"GiftCount":1,"GiftScore":1,"Location":"银杏村","NickName":"i玻璃宅","SvrArea":"银杏村","UserID":"243008355219"}]}
     
     */
}

//获取频道用户列表回调
- (void)onMemberChange:(NSString*) channelID changeList:(NSArray*) changeList
{
    
}

//房间内连麦抢麦广播消息回调
- (void)onBroadcast:(YouMeBroadcast_t)bc strChannelID:(NSString*)channelID strParam1:(NSString*)param1 strParam2:(NSString*)param2 strContent:(NSString*)content
{
    
}


- (IBAction)onClickButtonMonitor:(id)sender {
    if(mMonitorEnable){
        [[YMVoiceService getInstance] setHeadsetMonitorMicOn:false];
        mMonitorEnable =  false;
        [_buttonMonitor setTitle:@"开启监听" forState:UIControlStateNormal];        
    }else {
        [[YMVoiceService getInstance] setHeadsetMonitorMicOn:true];
        mMonitorEnable =  true;
        [_buttonMonitor setTitle:@"关闭监听" forState:UIControlStateNormal];

    }
    
    
}

- (IBAction)onClickButtonMic:(id)sender {
    if(mMicEnable){
        [[YMVoiceService getInstance] setMicrophoneMute:true];
        mMicEnable = false;
        [_buttonMic setTitle:@"启用麦克风" forState:UIControlStateNormal];
        //前提是启用麦克风按钮只供主播模式使用;
        mTips = @"已进入主播模式,麦克风关";
        _tfTips.text = mTips;
    }else {
        //启动麦克风
        [[YMVoiceService getInstance] setMicrophoneMute:false];
        mMicEnable = true;
        [_buttonMic setTitle:@"关闭麦克风" forState:UIControlStateNormal];
        //前提是启用麦克风按钮只供主播模式使用;
        mTips = @"已进入主播模式,麦克风开";
        _tfTips.text = mTips;

    }
}

@end
