//
//  YHBaseModel.h
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <Foundation/Foundation.h>

// 主键常量
#define kModelPrimaryKey @"pk"

// Document目录
#define kDocumentsDirectory \
    ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

// 数据库路径
#define kDataBasePath [kDocumentsDirectory stringByAppendingFormat:@"/sqllite.db"]

@interface YHBaseModel : NSObject

// 主键 primary key
@property(nonatomic, copy) NSString *pk;

// 创建数据库时需要忽略的字段列表
+ (NSArray *)ignoredPropertiesForDB;

@end
