//
//  ListenVoiceController.h
//  IFlyMSCStudy
//
//  Created by 付宗建 on 17/2/13.
//  Copyright © 2017年 youran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/iflyMSC.h"
/**
    语音听写demo，四步
    1、创建识别对象；
    2、设置识别参数；
    3、有选择的实现回调；
    4、启动识别
 */
// forward declare
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;
@interface ListenVoiceController : UIViewController<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate>
@property (nonatomic,strong) NSString * pcmFilePath;// 音频文件路径
@property (nonatomic,strong) IFlySpeechRecognizer * iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic,strong) IFlyRecognizerView * iFlyRecognizerView;// 带界面的识别对象
@property (nonatomic,strong) IFlyDataUploader * uploader;//数据上传对象

@property (strong, nonatomic)  UIButton * startRecBtn;
@property (strong, nonatomic)  UIButton * stopRecBtn;
@property (strong, nonatomic)  UIButton * cancelRecBtn;

@property (strong, nonatomic)  UITextView * textView;

@property (nonatomic,strong) NSString * result;
@property (nonatomic,assign) BOOL  isCancled;


@end
