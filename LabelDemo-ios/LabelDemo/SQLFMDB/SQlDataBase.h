//
//  SQLSelectValue.h
//  LabelDemo
//
//  Created by 金松松 on 2017/6/24.
//  Copyright © 2017年 金松松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SQlDataBase : NSObject

+(SQlDataBase *)sharedDateBase;

/**
 *  根据ID查询数据库值 
 *  返回指定name
 */
-(NSString*)queryDataAccordingID:(int)ID;

/**
 *  根据区ID查询数据库值
 *  返回指定 省 市 区
 *  key值为 "省" "市" "区"
 */
-(NSDictionary*)queryDataWithAreaID:(int)ID;
@end
