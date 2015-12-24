//
//  YHFMDBHelper.h
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHBaseModel.h"

@interface YHFMDBUtils : NSObject

/**
 *  根据Model类的class创建Sqlite表
 *
 *  @param cls 数据库Model的class
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls;

/**
 *  保存Model对象到Sqlite表中
 *
 *  @param model 将要新增的Model对象
 *
 *  @return 是否保存成功
 */
+ (BOOL)save:(YHBaseModel *)model;

/**
 *  从数据库中删除Model对象对应的记录
 *
 *  @param model 将要删除的Model对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)remove:(YHBaseModel *)model;

/**
 *  删除Model的class对应的整张表
 *
 *  @param cls 数据库Model的class
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearAll:(Class)cls;

+ (BOOL)remove:(Class)cls where:(NSString *)condition;

+ (BOOL)modify:(YHBaseModel *)model;

+ (BOOL)modify:(YHBaseModel *)model where:(NSString *)condition;

+ (NSArray *)searchAll:(Class)cls;

+ (NSArray *)search:(Class)cls where:(NSString *)condition;

@end
