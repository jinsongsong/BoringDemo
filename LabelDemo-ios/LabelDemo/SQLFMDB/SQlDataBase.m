//
//  SQLSelectValue.h
//  LabelDemo
//
//  Created by 金松松 on 2017/6/24.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import "SQlDataBase.h"
#import "FMDatabase.h"

@implementation SQlDataBase
{
    FMDatabase *_db;
}
+(SQlDataBase *)sharedDateBase
{
    static SQlDataBase *dataBase = nil;
    if(dataBase == nil){
        
        dataBase = [[SQlDataBase alloc] init];
    }

    return dataBase;
}

- (instancetype)init{
    self = [super init];
    
    if(self){
        
        NSString *filePath = [[NSBundle mainBundle ] pathForResource:@"sys_area.db" ofType:nil];
        
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return self;
}
#pragma mark --查询数据库表中的指定值
-(NSString*)queryDataAccordingID:(int)ID{
    if (![_db open]) [_db open];
    
    FMResultSet *resultSet = [_db executeQuery:[NSString stringWithFormat:@"select * from sys_area where id = %d",ID]];
    
    NSString *name;
    while ([resultSet  next]){
        //查询结果
        name = [resultSet stringForColumn:@"name"];
    }
    
    [_db close];
    
    return name;
}
-(NSDictionary*)queryDataWithAreaID:(int)ID{
    if (![_db open]) [_db open];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //查询区
    FMResultSet *resultSet = [_db executeQuery:[NSString stringWithFormat:@"select * from sys_area where id = %d",ID]];
    
    while ([resultSet  next]){
        //查询区结果
        NSString *areaName = [resultSet stringForColumn:@"name"];
        int cityID = [resultSet intForColumn:@"parent_id"];
        [dic setObject:areaName forKey:@"区"];
        
        //查询市
        FMResultSet *citySet = [_db executeQuery:[NSString stringWithFormat:@"select * from sys_area where id = %d",cityID]];
        while ([citySet next]) {
            //查询市结果
            NSString *cityName = [citySet stringForColumn:@"name"];
            int shengID = [citySet intForColumn:@"parent_id"];
            [dic setObject:cityName forKey:@"市"];
            
            //查询市
            FMResultSet *shengSet = [_db executeQuery:[NSString stringWithFormat:@"select * from sys_area where id = %d",shengID]];
            while ([shengSet next]) {
                NSString *shengName = [shengSet stringForColumn:@"name"];
                [dic setObject:shengName forKey:@"省"];
            }
        }
    }
    
    [_db close];

    return dic;
}

@end
