//
//  YHFMDBOperator.h
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHBaseModel.h"

@interface YHFMDBOperator : NSObject

+ (YHFMDBOperator *)shareOperator;

// create table for the class
- (BOOL)createTable:(Class)cls;

// execute sql
- (BOOL)executeSql:(NSString *)sql;

// insert
- (BOOL)insert:(YHBaseModel *)data;

// delete by primary key
- (BOOL) delete:(YHBaseModel *)data;

// delete all
- (BOOL)deleteAll:(Class)cls;

// delete by condition
- (BOOL) delete:(Class)cls where:(NSString *)condition;

// update by primary key
- (BOOL)update:(YHBaseModel *)data;

// update by condition
- (BOOL)update:(YHBaseModel *)data where:(NSString *)condition;

// find all
- (NSArray *)select:(Class)cls;

// find by condition
- (NSArray *)select:(Class)cls where:(NSString *)condition;

- (NSArray *)select:(Class)cls where:(NSString *)condition orderBy:(NSString*)orderBy;

- (NSArray *)select:(Class)cls where:(NSString *)condition orderBy:(NSString*)orderBy limit:(NSString*)limit;


// count all
- (int)count:(Class)cls;

// count by condition
- (int)count:(Class)cls where:(NSString *)condition;

@end
