//
//  YHFMDBHelper.m
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import "NSString+SQL.h"
#import "YHFMDBOperator.h"
#import "YHFMDBUtils.h"

@implementation YHFMDBUtils

// create table with model
+ (BOOL)createTable:(Class)cls {
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator createTable:cls];
}

#pragma mark Save

+ (BOOL)save:(YHBaseModel *)model {
    if (!model) {
        return NO;
    }
    // Generate uuid for primary key
    if (![model valueForKey:kModelPrimaryKey]) {
        NSString *uuid = [NSString generateUUID];
        [model setValue:uuid forKey:kModelPrimaryKey];
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator insert:model];
}

#pragma mark Remove

+ (BOOL)remove:(YHBaseModel *)model {
    if (!model) {
        return NO;
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator delete:model];
}

+ (BOOL)clearAll:(Class)cls {
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator deleteAll:cls];
}

+ (BOOL)remove:(Class)cls where:(NSString *)condition {
    if (!condition || [NSString isEmpty:condition]) {
        return NO;
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator delete:cls where:condition];
}

#pragma mark Modify

+ (BOOL)modify:(YHBaseModel *)model {
    if (!model) {
        return NO;
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator update:model];
}
+ (BOOL)modify:(YHBaseModel *)model where:(NSString *)condition {
    if (!model) {
        return NO;
    }
    if (!condition || [NSString isEmpty:condition]) {
        return [[self class] modify:model];
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator update:model where:condition];
}

#pragma mark Search

+ (NSArray *)searchAll:(Class)cls {
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator findAll:cls];
}

+ (NSArray *)search:(Class)cls where:(NSString *)condition {
    if (!condition || [NSString isEmpty:condition]) {
        return [[self class] searchAll:cls];
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator find:cls where:condition];
}

#pragma mark Count
+ (int)count:(Class)cls{
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator count:cls];
}


+ (int)count:(Class)cls where:(NSString *)condition{
    if (!condition || [NSString isEmpty:condition]) {
        return [[self class] count:cls];
    }
    YHFMDBOperator *operator= [YHFMDBOperator shareOperator];
    return [operator count:cls where:condition];}

@end
