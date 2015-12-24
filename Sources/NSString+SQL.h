//
//  NSObject+SQL.h
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/19.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <Foundation/Foundation.h>

#define key(PATH) (((void)(NO && ((void)PATH, NO)), strchr(#PATH, '.') + 1))

typedef NS_ENUM(NSInteger, YHObjectType) {
    YHObjectTypeUnknow,  // 未知
    YHObjectTypeNil,     // Nil
    YHObjectTypeNumber,  // 基本数据类型
    YHObjectTypeString,  // NSString
    YHObjectTypeArray    // 数组Array
};

// 操作符类型
typedef NS_ENUM(NSInteger, YHOperatorType) {
    YHOperatorTypeEq,       // =
    YHOperatorTypeNotEq,    // !=
    YHOperatorTypeGt,       // >
    YHOperatorTypeGtAndEq,  // >=
    YHOperatorTypeLt,       // <
    YHOperatorTypeLtAndEq,  // <=
    YHOperatorTypeNotGt,    // !>
    YHOperatorTypeNotLt,    // !<
    YHOperatorTypeLk,       // like
    YHOperatorTypeNotLk,    // not like
    YHOperatorTypeIn,       // in
    YHOperatorTypeNotIn,    // not in
    YHOperatorTypeAnd,      // and
    YHOperatorTypeOr        // or
};

@interface NSString (SQL)

// =  equal
- (NSString * (^)(NSObject *value))eq;

// !=
- (NSString * (^)(NSObject *value)) not_eq ;

// >  gt  greater than
- (NSString * (^)(NSObject *value))gt;

// >=
- (NSString * (^)(NSObject *value))gt_and_eq;

// <  lt  less than
- (NSString * (^)(NSObject *value))lt;

// <=
- (NSString * (^)(NSObject *value))lt_and_eq;

// !<
- (NSString * (^)(NSObject *value))not_lt;

// !>
- (NSString * (^)(NSObject *value))not_gt;

// between and
- (NSString * (^)(NSArray *values))btw_and;

// not between and
- (NSString * (^)(NSArray *values))not_btw_and;

// is not null
- (NSString * (^)())is_not_null;

// is null
- (NSString * (^)())is_null;

// like
- (NSString * (^)(NSString *value))lk;

// not like
- (NSString * (^)(NSString *value))not_lk;

// in
- (NSString * (^)(NSObject *value))in;

// not in
- (NSString * (^)(NSObject *value))not_in;

// and
- (NSString * (^)(NSString *value))AND;

// or
- (NSString * (^)(NSString *value))OR;

// order by
- (NSString * (^)(NSArray *array))order_by;

// desc
- (NSString * (^)())desc;

// asc
- (NSString * (^)())asc;

@end

#pragma mark 工具方法

@interface NSString (Utils)

// 生成UUID
+ (NSString *)generateUUID;

// 是否空字符串
+ (BOOL)isEmpty:(NSString *)string;

@end
