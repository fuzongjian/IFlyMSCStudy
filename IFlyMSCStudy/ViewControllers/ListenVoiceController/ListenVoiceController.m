//
//  ListenVoiceController.m
//  IFlyMSCStudy
//
//  Created by 付宗建 on 17/2/13.
//  Copyright © 2017年 youran. All rights reserved.
//

#import "ListenVoiceController.h"

@interface ListenVoiceController ()

@end

@implementation ListenVoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configListenVoiceUI];
}
- (void)configListenVoiceUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.startRecBtn];
    [self.view addSubview:self.stopRecBtn];
    [self.view addSubview:self.cancelRecBtn];
    
    self.uploader = [[IFlyDataUploader alloc] init];
    //录音文件保存位置
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    // 避免同时产生多个按钮事件
    [self setExclusiveTouchForButtons:self.view];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 初始化识别对象
    [self configRecognizer:NO];
    [_startRecBtn setEnabled:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [_iFlySpeechRecognizer cancel];//取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
}
- (void)configRecognizer:(BOOL)isView{
    if (!isView) {// 无界面
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            // 设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        if (_iFlySpeechRecognizer != nil) {
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            
            //设置语言
            [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
            
            
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
}
- (void)startRecBtnClicked:(UIButton *)sender{
    NSLog(@"%s",__func__);
    [_textView setText:@""];
    [_textView resignFirstResponder];
    self.isCancled = NO;
    if (_iFlySpeechRecognizer == nil) {
        [self configRecognizer:NO];
    }
    [_iFlySpeechRecognizer cancel];
    // 设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:@"1" forKey:@"audio_source"];
    // 设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    // 保存录音文件，保存到sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iFlySpeechRecognizer setDelegate:self];
    if ([_iFlySpeechRecognizer startListening]) {
        NSLog(@"启动成功");
    }else{
        NSLog(@"启动失败");
    }
}
- (void)stopRecBtnClicked:(UIButton *)sender{
    NSLog(@"%s",__func__);

}
- (void)cancleRecBtnClicked:(UIButton *)sender{
    NSLog(@"%s",__func__);

}
- (void)setExclusiveTouchForButtons:(UIView *)view{
    for (UIView * button in [view subviews]) {
        if([button isKindOfClass:[UIButton class]])
        {
            [((UIButton *)button) setExclusiveTouch:YES];
        }
        else if ([button isKindOfClass:[UIView class]])
        {
            [self setExclusiveTouchForButtons:button];
        }
    }
}
#pragma mark - IFlySpeechRecognizerDelegate
/**
 音量回调函数
 volume 0－30
 ****/
- (void)onVolumeChanged:(int)volume{
    NSLog(@"%s___%d",__func__,volume);
}
/**
 开始识别回调
 ****/
- (void)onBeginOfSpeech{
    NSLog(@"%s",__func__);
}
/**
 停止录音回调
 ****/
- (void)onEndOfSpeech{
    NSLog(@"%s",__func__);
}
/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void)onError:(IFlySpeechError *)error{
    NSLog(@"%s",__func__);
    NSString * text;
    if (self.isCancled) {
        text = @"识别取消";
    }else if(error.errorCode == 0){
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
            //清空识别结果
            _result = nil;
        }
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }

}
/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = resultArray[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    NSString * resultFromJson =  [self stringFromJson:resultString];
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_textView.text);

}
- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 200)];
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_textView.layer setCornerRadius:7.0f];

    }
    return _textView;
}
- (UIButton *)startRecBtn{
    if (_startRecBtn == nil) {
        _startRecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRecBtn.frame = CGRectMake(10, 220, (SCREEN_WIDTH - 40)/3, 50);
        _startRecBtn.backgroundColor = [UIColor whiteColor];
        [_startRecBtn setTitle:@"录音识别" forState:UIControlStateNormal];
        _startRecBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_startRecBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startRecBtn addTarget:self action:@selector(startRecBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRecBtn;
}
- (UIButton *)stopRecBtn{
    if (_stopRecBtn == nil) {
        _stopRecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopRecBtn.frame = CGRectMake((SCREEN_WIDTH - 40)/3 + 20, 220, (SCREEN_WIDTH - 40)/3, 50);
        _stopRecBtn.backgroundColor = [UIColor whiteColor];
        [_stopRecBtn setTitle:@"停止录音" forState:UIControlStateNormal];
        _stopRecBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_stopRecBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_stopRecBtn addTarget:self action:@selector(stopRecBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopRecBtn;
}
- (UIButton *)cancelRecBtn{
    if (_cancelRecBtn == nil) {
        _cancelRecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelRecBtn.frame = CGRectMake((SCREEN_WIDTH - 40)/3 * 2 + 30, 220, (SCREEN_WIDTH - 40)/3, 50);
        _cancelRecBtn.backgroundColor = [UIColor whiteColor];
        [_cancelRecBtn setTitle:@"取消识别" forState:UIControlStateNormal];
        _cancelRecBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_cancelRecBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelRecBtn addTarget:self action:@selector(cancleRecBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelRecBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
