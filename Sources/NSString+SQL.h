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
    YHOperatorTypeLk,       // like
    YHOperatorTypeNotLk,    // not like
    YHOperatorTypeIn,       // in
    YHOperatorTypeNotIn,    // not in
    YHOperatorTypeAnd,      // and
    YHOperatorTypeOr        // or
};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
// limit
static NSString *limit(NSNumber *value) { return [NSString stringWithFormat:@"LIMIT %@", value]; }

// order by
static NSString *order_by(NSString *col, ...) {
    if (!col) {
        return @"";
    }
    NSMutableArray *argsArray = @[].mutableCopy;
    va_list params;         //定义一个指向个数可变的参数列表指针;
    va_start(params, col);  // va_start 得到第一个可变参数地址,
    id arg;
    //将第一个参数添加到array
    id prev = col;
    [argsArray addObject:prev];
    // va_arg 指向下一个参数地址
    while ((arg = va_arg(params, id))) {
        if (arg) {
            [argsArray addObject:arg];
        }
    }
    //置空
    va_end(params);
    return [NSString stringWithFormat:@"ORDER BY %@", [argsArray componentsJoinedByString:@","]];
}

#pragma clang diagnostic pop

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

// desc
- (NSString * (^)())desc;

// asc
- (NSString * (^)())asc;

// offset
- (NSString * (^)(NSNumber *offset))offset;

@end

@interface NSString (FMDBHelper)

#pragma mark 工具方法

// 生成UUID
+ (NSString *)generateUUID;

// 是否空字符串
+ (BOOL)isEmpty:(NSString *)string;

@end
