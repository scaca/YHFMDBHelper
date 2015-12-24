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

// insert given model to db
- (BOOL)insert:(YHBaseModel *)data;

// delete given model
- (BOOL) delete:(YHBaseModel *)data;

// delete all model data for the class
- (BOOL)deleteAll:(Class)cls;

// delete model data for the class specified condition
- (BOOL) delete:(Class)cls where:(NSString *)condition;

// update model
- (BOOL)update:(YHBaseModel *)data;

// update model data for the class specified condition
- (BOOL)update:(YHBaseModel *)data where:(NSString *)condition;

// find all
- (NSArray *)findAll:(Class)cls;

//
- (NSArray *)find:(Class)cls where:(NSString *)condition;

@end
