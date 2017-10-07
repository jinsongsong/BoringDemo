//
//  ViewController.m
//  LabelDemo
//
//  Created by 金松松 on 2017/5/6.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import "ViewController.h"
#import "EMAlertView.h"
#import "NFSpeechViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "SQlDataBase.h"

#import "PickView_JSS.h"  //地址选择

@interface ViewController ()<AVSpeechSynthesizerDelegate,pickviewDelegate>
{
    UILabel *_first_lb;
    UILabel *_second_lb;
    UITextField *_filed;
}
@property(nonatomic, strong) AVSpeechSynthesizer *aVSpeechSynthesizer;
@property(nonatomic, strong)PickView_JSS* areaPick;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    
    _filed=[[UITextField alloc]initWithFrame:CGRectMake(50, 150, 260, 30)];
    _filed.placeholder=@"输入要说的话";
    [self.view addSubview:_filed];
    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(50, 200, 100, 50)];
    [btn1 setTitle:@"文字转语音" forState:UIControlStateNormal];
    btn1.backgroundColor=[UIColor brownColor];
    [btn1 addTarget:self action:@selector(readText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(160, 200, 100, 50)];
    btn2.backgroundColor=[UIColor orangeColor];
    [btn2 setTitle:@"语音转文字" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(changeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UIButton *btn11=[[UIButton alloc]initWithFrame:CGRectMake(50, 300, 200, 50)];
    [btn11 setTitle:@"选择地址" forState:UIControlStateNormal];
    btn11.backgroundColor=[UIColor brownColor];
    [btn11 addTarget:self action:@selector(selectAdress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn11];
    
    //MARK:地址选择
    _areaPick=[[PickView_JSS alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //_areaPick.delegate=self;
    _areaPick.hidden=YES;
    [self.view addSubview:_areaPick];
    [self.view bringSubviewToFront:_areaPick];

    _areaPick.completeSelsct = ^(AdressModel *provinceStrModel, AdressModel *cityModel, AdressModel *areaModel) {
        NSLog(@"省->>%@--省ID->>%d--父ID->>%d",provinceStrModel.name,provinceStrModel.ID,provinceStrModel.parent_id);
        NSLog(@"市->>%@--市ID->>%d--父ID->>%d",cityModel.name,cityModel.ID,cityModel.parent_id);
        NSLog(@"区->>%@--区ID->>%d--父ID->>%d",areaModel.name,areaModel.ID,areaModel.parent_id);
    };
    
}
//MARK:地址选择
-(void)selectAdress:(UIButton*)btn{
    [_areaPick viewShowWithAnimation];
    
    
}
//MARK:代理
-(void)selectedProvinceModel:(AdressModel*)provinceStrModel cityModel:(AdressModel*)cityModel areaModel:(AdressModel*)areaModel{

    NSLog(@"省->>%@--省ID->>%d--父ID->>%d",provinceStrModel.name,provinceStrModel.ID,provinceStrModel.parent_id);
    NSLog(@"市->>%@--市ID->>%d--父ID->>%d",cityModel.name,cityModel.ID,cityModel.parent_id);
    NSLog(@"区->>%@--区ID->>%d--父ID->>%d",areaModel.name,areaModel.ID,areaModel.parent_id);
}

-(void)changeVC{
    //市-->>阿克苏地区--ID-->>652900--父类ID-->>650000
    //[[SQlDataBase sharedDateBase] queryDataAccordingID:652900];
    
    //跳转图图
    //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"baisidatushoping://com.baisida.tutu"]];
    
    //跳转 语音
    [self presentViewController:[NFSpeechViewController new] animated:YES completion:nil];
}
-(void)readText{
    //区-->>中原区--ID-->>410102--父类ID-->>410100
    //NSDictionary *dic=[[SQlDataBase sharedDateBase] queryDataWithAreaID:410102];

    
    if (_filed.text.length==0) {
        [self read:@"周叙真是个逗逼啊"];
    }
    else{
        [self read:_filed.text];
    }
}
//公告动画
-(void)initSubViews{
    CGFloat width = self.view.bounds.size.width;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-20, width, 40)];
    view.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:view];
    
    _first_lb=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, 8180, 40)];
    _first_lb.text=@"为有效的激励市场，推动平台快速发展，最大力度让利给会员，特推出如下奖励方案:第一档：当你的累计收益达到三万元（不扣除充值图点的费用，即系统中的“累计业绩”），赠送厦门精品三天两夜游。在此期间，报销1000元作为来往路费，其中包括参观公司了解公司最新动态。第二档：当你的累计收益达到六万元（不扣除充值图点的费用，即系统中的“累计业绩”），赠送华为MATE 9手机一部（运行内存6G，机身内存128G）支持民族品牌，弘扬中华文化。第三档：当你的累计收益达到三十万元（不扣除充值图点的费用，即系统中的“累计业绩”），申请公司车贷补助，按业绩的百分十提取 可累加。第四档：当你的累计收益达到两百万元（不扣除充值图点的费用，即系统中的“累计业绩”），一次性奖励三十万元购车款（扣除第三档申请且已发放的金额）第五档：当你的累计收益达到两千万元（不扣除充值图点的费用，即系统中的“累计业绩”），公司一次性奖励200万住房补贴。区域代理从正式上线起至贰零壹柒年六月三十号团队业绩（兑换图贝的业绩）达到一百万（小区业绩达到三十万）赠送区域代理名额一个（市值五十万）享受伞下所有团队和商家提现的0.5%。    尊敬的“图什么”系统用户，接技术部门通知，系统开发已经全部完统开发已经全部完成，即日起1.0版系统正式上线统开发已经全部完成，即日起1.0版系统正式上线成，即日起1.0版系统正式上线。全国市场正式开始内排。现就系统上线内排期间相关问题做如下说明：1、内排期仅支持微信充值，支付宝及银行快捷支付后续开放；2、内排期所有用户提现均由公司财务手动打款到支付宝（没有支付宝的提到银行卡所1345";
    [view addSubview:_first_lb];
    
    _second_lb=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_first_lb.frame)+15,  0, width+30, 40)];
    _second_lb.text=@"UILabel *first_lb=[[UILabel alloc]initWithFrame:CGRectMake";
    [view addSubview:_second_lb];
    
    [self animatedForText];
}
-(void)animatedForText{
    CGFloat width = self.view.bounds.size.width;
    
    [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _first_lb.frame=CGRectMake(-width-30, 0, width+30, 40);
        _second_lb.frame=CGRectMake(CGRectGetMaxX(_first_lb.frame)+15,  0, width+30, 40);
        
    } completion:^(BOOL finished) {
        _first_lb.frame=_second_lb.frame;
        _second_lb.frame=CGRectMake(CGRectGetMaxX(_first_lb.frame)+15,  0, width+30, 40);
        [self animatedForText];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/********************************************************
*                                                       *
*                下面是文字转语音                          *
*                                                       *
*********************************************************/
- (void)read:(NSString *)str{
    //AVSpeechUtterance: 可以假想成要说的一段话
    AVSpeechUtterance * aVSpeechUtterance = [[AVSpeechUtterance alloc] initWithString:str];
    
    aVSpeechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    //AVSpeechSynthesisVoice: 可以假想成人的声音
    aVSpeechUtterance.voice =[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    //发音
    [self.aVSpeechSynthesizer speakUtterance:aVSpeechUtterance];
    
}
- (void)stopRead{
    [self.aVSpeechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance;{
    NSLog(@"阅读完毕");
}
//AVSpeechSynthesizer: 语音合成器, 可以假想成一个可以说话的人
- (AVSpeechSynthesizer *)aVSpeechSynthesizer{
    if (!_aVSpeechSynthesizer) {
        _aVSpeechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        _aVSpeechSynthesizer.delegate = self;
    }
    return _aVSpeechSynthesizer;
}

@end
