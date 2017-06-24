//
//  ToolsHeader.h
//  TuTuShoping
//
//  Created by 金松松 on 2017/3/29.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdressModel : NSObject
@property (nonatomic,assign)int ID;
@property (nonatomic,assign)int parent_id;
@property (nonatomic,strong)NSString *name;
@end

@protocol pickviewDelegate <NSObject>

@optional

-(void)selectedProvinceModel:(AdressModel*)provinceStrModel cityModel:(AdressModel*)cityModel areaModel:(AdressModel*)areaModel;

@end

@interface PickView_JSS : UIView

@property(nonatomic,weak)id<pickviewDelegate> delegate;

-(void)viewShowWithAnimation;

@property(nonatomic,copy)void(^completeSelsct)(AdressModel*, AdressModel*,AdressModel*);

//是否改变字体颜色 大小
//@property(nonatomic,assign)BOOL isChangeRowView;

//改变字体颜色
//@property(nonatomic,strong)UIColor *changeColor;

@end
