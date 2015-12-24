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
 *  删除class对应表的所有记录
 *
 *  @param cls 数据库Model对应的class
 *
 *  @return 是否清除成功
 */
+ (BOOL)removeAll:(Class)cls;

/**
 *  根据WHERE条件删除class对应的表记录
 *
 *  @param cls 数据库Model的class
 *  @param condition WHERE条件
 *
 *  @return 是否删除成功
 */
+ (BOOL)remove:(Class)cls where:(NSString *)condition;

/**
 *  根据主键修改Model对象对应的记录
 *
 *  @param model 将要修改的Model对象
 *
 *  @return 是否修改成功
 */
+ (BOOL)modify:(YHBaseModel *)model;

/**
 *  根据WHERE条件修改class对应的表记录
 *
 *  @param cls 数据库Model的class
 *  @param condition WHERE条件
 *
 *  @return 是否修改成功
 */
+ (BOOL)modify:(YHBaseModel *)model where:(NSString *)condition;

/**
 *  查询class对应表的所有记录
 *
 *  @param cls 数据库Model对应的class
 *
 *  @return 所有记录列表
 */
+ (NSArray *)search:(Class)cls;

/**
 *  根据WHERE条件查询class对应的表记录
 *
 *  @param cls       数据库Model对应的class
 *  @param condition WHERE条件
 *
 *  @return 符合条件的记录列表
 */
+ (NSArray *)search:(Class)cls where:(NSString *)condition;

/**
 *  根据条件查询class对应的表记录
 *
 *  @param cls       数据库Model对应的class
 *  @param condition WHERE条件
 *  @param orderBy 排序
 *
 *  @return 符合条件的记录列表
 */
+ (NSArray *)search:(Class)cls where:(NSString *)condition orderBy:(NSString *)orderBy;

/**
 *  根据条件查询class对应的表记录
 *
 *  @param cls       数据库Model对应的class
 *  @param condition WHERE条件
 *  @param orderBy 排序
 *  @param limit 分页
 *
 *  @return 符合条件的记录列表
 */
+ (NSArray *)search:(Class)cls where:(NSString *)condition orderBy:(NSString *)orderBy limit:(NSString *)limit;

/**
 *  查询class对应的表记录的个数
 *
 *  @param cls 数据库Model对应的class
 *
 *  @return 记录个数
 */
+ (int)count:(Class)cls;

/**
 *  根据WHERE条件查询class对应的表记录的个数
 *
 *  @param cls       数据库Model对应的class
 *  @param condition WHERE条件
 *
 *  @return 符合条件的记录个数
 */
+ (int)count:(Class)cls where:(NSString *)condition;

@end
