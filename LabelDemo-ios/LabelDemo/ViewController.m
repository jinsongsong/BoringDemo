//
//  ViewController.m
//  LabelDemo
//
//  Created by 金松松 on 2017/5/6.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UILabel *_first_lb;
    UILabel *_second_lb;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

-(void)initSubViews{
    CGFloat width = self.view.bounds.size.width;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-20, width, 40)];
    view.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:view];
    
    _first_lb=[[UILabel alloc]initWithFrame:CGRectMake(0,  0, width+30, 40)];
    _first_lb.text=@"UILabel *first_lb=[[UILabel alloc]initWithFrame:CGRectMake";
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


@end
