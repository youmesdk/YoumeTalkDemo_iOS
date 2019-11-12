//
//  ViewController.h
//  VoiceTest
//
//  Created by kilo on 16/7/12.
//  Copyright © 2016年 kilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceEngineCallback.h"

@interface ViewController : UIViewController
{
    NSString *mRoomID;
    NSString *mTips;
    bool mMicEnable;
    bool mMonitorEnable;
    int mMode;
    bool mTalkEnable;
    
}

@property (weak, nonatomic) IBOutlet UIButton *buttonMic;
@property (weak, nonatomic) IBOutlet UIButton *buttonMonitor;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoinRoom;

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UITextField *tfRoomID;
@property (weak, nonatomic) IBOutlet UILabel *labelBgVolume;
@property (weak, nonatomic) IBOutlet UISlider *sliderBgVolume;
@property (weak, nonatomic) IBOutlet UITextField *tfTips;
@property (weak, nonatomic) IBOutlet UIButton *buttonAnchor;
@property (weak, nonatomic) IBOutlet UIButton *buttonListenAnchor;
@property (weak, nonatomic) IBOutlet UIButton *buttonLeaveRoom;
@property (weak, nonatomic) IBOutlet UIButton *buttonPauseTalk;
@property (weak, nonatomic) IBOutlet UILabel *labelDelay;
@property (weak, nonatomic) IBOutlet UISlider *sliderDelay;

- (IBAction)onClickButtonMonitor:(id)sender;
- (IBAction)onClickButtonMic:(id)sender;
- (IBAction)onClickButtonJoinRoom:(id)sender;
- (IBAction)onClickButtonAnchor:(id)sender;
- (IBAction)onClickButtonLeaveRoom:(id)sender;
- (IBAction)onSliderBgVolumeChange:(id)sender;
- (IBAction)onClickButtonPlayBackgroundMusic:(id)sender;
- (IBAction)onClickButtonStopBackgroundMusic:(id)sender;
- (IBAction)onClickButtonPauseTalk:(id)sender;
- (IBAction)onSliderDelayChange:(id)sender;


@property (atomic, assign) BOOL mBInitOK;
@property (atomic, assign) BOOL mBInRoom;

@end


