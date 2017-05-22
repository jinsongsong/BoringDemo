//
//  NFSpeechViewController.m
//  LabelDemo
//
//  Created by 金松松 on 2017/5/22.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import "NFSpeechViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@interface NFSpeechViewController ()<SFSpeechRecognitionTaskDelegate>
@property (nonatomic ,strong) UILabel *speechText;
@property (nonatomic ,strong) AVAudioEngine *auengine;
@end

@implementation NFSpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _auengine = [[AVAudioEngine alloc] init];
    [self initSubViews];
}

-(void)initSubViews{
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.backgroundColor=[UIColor brownColor];
    [backBtn addTarget:self action:@selector(goback123) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(10, 100, 150, 50)];
    [btn1 setTitle:@"本地语音文件" forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor brownColor];
    [btn1 addTarget:self action:@selector(locVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(180, 100, 150, 50)];
    btn2.backgroundColor=[UIColor orangeColor];
    [btn2 setTitle:@"说话转文字" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(speechBuffer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    _speechText=[[UILabel alloc]initWithFrame:CGRectMake(15, 170, self.view.bounds.size.width-30, 70)];
    _speechText.textColor=[UIColor blueColor];
    _speechText.numberOfLines=0;
    _speechText.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_speechText];
}
-(void)goback123{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//本地语音文件
-(void)locVoice{
    //请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"123" withExtension:@"mp3"];
            [self recognizeAudioFile:url];
        }
    }];
}
- (void)recognizeAudioFile:(NSURL *)url {
    SFSpeechRecognizer *recongize = [[SFSpeechRecognizer alloc] init];
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    [recongize recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            self.speechText.text = result.bestTranscription.formattedString;
        }
        if (error) {
            self.speechText.text = error.description;
        }
    }];
}
//获取说话
-(void)speechBuffer{
    //请求权限
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
            [self recognizeAudioBuffer];
        }
    }];
}
- (void)recognizeAudioBuffer {
    
    SFSpeechRecognizer *recognize = [[SFSpeechRecognizer alloc] init];
    SFSpeechAudioBufferRecognitionRequest *requestbuffer = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    if (error) {
        self.speechText.text = error.description;
        return;
    }
    [session setMode:AVAudioSessionModeMeasurement error:&error];
    if (error) {
        self.speechText.text = error.description;
        return;
    }
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        self.speechText.text = error.description;
        return;
    }
    
    if (!_auengine.inputNode) {
        self.speechText.text = @"无输入节点";
        return;
        
    }
    
    [_auengine.inputNode installTapOnBus:0 bufferSize:1024 format:[_auengine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        if (buffer) {
            [requestbuffer appendAudioPCMBuffer:buffer];
        }
    }];
    
    
    [recognize recognitionTaskWithRequest:requestbuffer resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if (result) {
            //获取成功
            self.speechText.text = result.bestTranscription.formattedString;
        }
        if (error) {
            self.speechText.text = error.description;
        }
    }];
    
    [_auengine prepare];
    [_auengine startAndReturnError:&error];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_auengine stop];
    _auengine = nil;
}
@end
