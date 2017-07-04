//
//  ToolsHeader.h
//  TuTuShoping
//
//  Created by 金松松 on 2017/3/29.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import "PickView_JSS.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#define     kRGBCOLOR(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define     kRGBA(r,g,b,a)    [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@implementation AdressModel

@end

@interface PickView_JSS ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UIPickerView*testPickerView;
@property(nonatomic,strong)UIView *animationView;

@property(nonatomic,strong)AdressModel *provinceModel; //选择的省市区
@property(nonatomic,strong)AdressModel *cityModel;
@property(nonatomic,strong)AdressModel *areaModel;

@property(nonatomic,strong)NSMutableArray *provinceArr;//省数组
@property(nonatomic,strong)NSMutableDictionary *cityDic;//市
@property(nonatomic,strong)NSMutableDictionary *areaDic; //区
@end

@implementation PickView_JSS

-(instancetype)initWithFrame:(CGRect)frame
{
   self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=kRGBA(51, 51, 51, .5);
        
        //异步加载数据 再创建UI
        __weak PickView_JSS *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            //初始化数据
            [weakSelf initSqliteData];
            
            //默认设置第一个
            weakSelf.provinceModel=_provinceArr[0];
            weakSelf.cityModel=_cityDic[_provinceModel.name][0];
            weakSelf.areaModel=_areaDic[_cityModel.name][0];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf initUI];
            });
            
        });
    }
    return self;
}

-(void)initUI
{
    self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 244)];
    [self addSubview:_animationView];
    
    self.testPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, 200)];
    _testPickerView.backgroundColor=kRGBCOLOR(237, 237, 237);
    _testPickerView.dataSource = self;
    _testPickerView.delegate = self;
    //UIPickerView默认只有三个高度：162,180,216
    [_animationView addSubview:self.testPickerView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    bgView.backgroundColor=kRGBCOLOR(244, 244, 244);
    [_animationView addSubview:bgView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 44)];
    cancelBtn.tag = 1998;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kRGBCOLOR(113, 175, 259) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(cancelOrsure:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *sureBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bounds)-60, 0, 50, 44)];
    sureBtn.tag = 1999;
    sureBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:kRGBCOLOR(113, 175, 259) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(cancelOrsure:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
    
}
//MARK:确定取消按钮
-(void)cancelOrsure:(UIButton*)button
{
    [self viewHiddenWithAnimation];
    
    if (button.tag==1999) {
        
        if ([_delegate respondsToSelector:@selector(selectedProvinceModel:cityModel:areaModel:)]) {
            
            [_delegate selectedProvinceModel:_provinceModel cityModel:_cityModel areaModel:_areaModel];
        }
        else{
            if (self.completeSelsct) {
                self.completeSelsct(_provinceModel, _cityModel, _areaModel);
            }
        }
    }
}
#pragma mark 代理方法 && 数据源代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;   //几列
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return _provinceArr.count;
        
    }else if (component==1){
        return [_cityDic[_provinceModel.name] count];
        
    }else{
        return [_areaDic[_cityModel.name] count];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //宽高需要在设置宽高的代理方法里面设置
    UILabel *lb=[[UILabel alloc]init];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font=[UIFont systemFontOfSize:15];
    
    AdressModel *model;
    switch (component) {
        case 0:
        {
            model=_provinceArr[row];
        }
            break;
        case 1:
        {
            model=_cityDic[_provinceModel.name][row];
        }
            break;
        default:
        {
            model=_areaDic[_cityModel.name][row];
        }
            break;
    }
    lb.text= model.name;
    
    return lb;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        _provinceModel=_provinceArr[row];//默认省
        _cityModel=_cityDic[_provinceModel.name][0];
        _areaModel=_areaDic[_cityModel.name][0];
        
        //刷新城市
        [_testPickerView reloadComponent:1];
        
        //刷新区
        [_testPickerView reloadComponent:2];
        
        //设置城市默认选择第一个
        [_testPickerView selectRow:0 inComponent:1 animated:NO];
        [_testPickerView selectRow:0 inComponent:2 animated:NO];
        
    }
    else if(component==1){

        _cityModel=_cityDic[_provinceModel.name][row];
        _areaModel=_areaDic[_cityModel.name][0];
        
        //刷新区
        [_testPickerView reloadComponent:2];
        
        //默认都是从第一个开始
        [_testPickerView selectRow:0 inComponent:2 animated:NO];
        
    }
    else{
        _areaModel=_areaDic[_cityModel.name][row];
    }
    
}
-(void)viewHiddenWithAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0.1;
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}
-(void)viewShowWithAnimation{
    self.hidden=NO;
    self.alpha=1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.animationView.frame = CGRectMake(0, self.bounds.size.height-244, self.bounds.size.width, 244);
        
    } completion:^(BOOL finished) {}];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self viewHiddenWithAnimation];
}

//获取省名字
-(void)initSqliteData{
    NSString *filePath = [[NSBundle mainBundle ] pathForResource:@"sys_area.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    
    if ([db open]) {
        
        _provinceArr = [NSMutableArray array];
        _cityDic = [[NSMutableDictionary alloc]init];
        _areaDic = [[NSMutableDictionary alloc]init];
        
        //根据条件查询 省
        FMResultSet *resultSet = [db executeQuery:@"select * from sys_area where parent_id = 0"];
        
        while ([resultSet  next]){
            
            //查询省
            NSString *name = [resultSet stringForColumn:@"name"];
            int idNum = [resultSet intForColumn:@"id"];
            int superNum = [resultSet intForColumn:@"parent_id"];
            NSLog(@"省-->>%@--ID-->>%d--父类ID-->>%d",name,idNum,superNum);
            
            //设置成省对象
            AdressModel *shengPeople=[[AdressModel alloc]init];
            shengPeople.ID=idNum;
            shengPeople.parent_id=superNum;
            shengPeople.name=name;
            [_provinceArr addObject:shengPeople];
            
            //省的ID是市的parent_id 根据parent_id查询市
            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from sys_area where parent_id = %d",idNum]];
            
            NSMutableArray *cityArr=[NSMutableArray array];
            
            while ([rs next]) {//查询市
                
                NSString *cityName = [rs stringForColumn:@"name"];
                int cityID = [rs intForColumn:@"id"];
                int cityParentID = [rs intForColumn:@"parent_id"];
                NSLog(@"市-->>%@--ID-->>%d--父类ID-->>%d",cityName,cityID,cityParentID);
                
                //设置成市对象
                AdressModel *cityPeople=[[AdressModel alloc]init];
                cityPeople.ID=cityID;
                cityPeople.parent_id=cityParentID;
                cityPeople.name=cityName;
                [cityArr addObject:cityPeople];
                
                //市的ID是区的parent_id 根据parent_id查询区
                FMResultSet *rs1 = [db executeQuery:[NSString stringWithFormat:@"select * from sys_area where parent_id = %d",cityID]];
                
                NSMutableArray *areaArr=[NSMutableArray array];
                
                while ([rs1 next]) { //查询区
                    
                    NSString *areaName = [rs1 stringForColumn:@"name"];
                    int areaID = [rs1 intForColumn:@"id"];
                    int areaParentID = [rs1 intForColumn:@"parent_id"];
                    NSLog(@"区-->>%@--ID-->>%d--父类ID-->>%d",areaName,areaID,areaParentID);
                    
                    //设置成市对象
                    AdressModel *areaPeople=[[AdressModel alloc]init];
                    areaPeople.ID=areaID;
                    areaPeople.parent_id=areaParentID;
                    areaPeople.name=areaName;
                    [areaArr addObject:areaPeople];
                    
                }
                [_areaDic setObject:areaArr forKey:cityName];
            }
            [_cityDic setObject:cityArr forKey:name];
        }
    }
    [db close];
}

@end
