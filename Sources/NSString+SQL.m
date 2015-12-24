//
//  NSObject+SQL.m
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/19.
//  Copyright © 2015年 302li. All rights reserved.
//

#import "NSString+SQL.h"

@implementation NSString (SQL)

static YHObjectType YHObjectGetType(NSObject *value) {
    if (!value || value == (id)kCFNull) {
        return YHObjectTypeNil;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return YHObjectTypeNumber;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return YHObjectTypeString;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return YHObjectTypeArray;
    }
    return YHObjectTypeUnknow;
}

static NSString *YHGetOperatorString(YHOperatorType operatorType) {
    NSString *result = nil;
    switch (operatorType) {
        case YHOperatorTypeEq: {
            result = @" = ";
            break;
        }
        case YHOperatorTypeNotEq: {
            result = @" != ";
            break;
        }
        case YHOperatorTypeGt: {
            result = @" > ";
            break;
        }
        case YHOperatorTypeGtAndEq: {
            result = @" >= ";
            break;
        }
        case YHOperatorTypeLt: {
            result = @" < ";
            break;
        }
        case YHOperatorTypeLtAndEq: {
            result = @" <= ";
            break;
        }
        case YHOperatorTypeLk: {
            result = @" LIKE ";
            break;
        }
        case YHOperatorTypeNotLk: {
            result = @" NOT LIKE ";
            break;
        }
        case YHOperatorTypeIn: {
            result = @" IN ";
            break;
        }
        case YHOperatorTypeNotIn: {
            result = @" NOT IN ";
            break;
        }
        case YHOperatorTypeAnd: {
            result = @" AND ";
            break;
        }
        case YHOperatorTypeOr: {
            result = @" OR ";
            break;
        }
    }
    return result;
}

NSString *YHEscapeChar(NSString *value) {
    NSString *tmpStr = [value stringByReplacingOccurrencesOfString:@"\'" withString:@"'"];
    tmpStr = [value stringByReplacingOccurrencesOfString:@"'" withString:@"\\\'"];
    return tmpStr;
}

- (NSString *)appendOperator:(YHOperatorType)operatorType value:(NSObject *)value {
    YHObjectType type = YHObjectGetType(value);
    NSString *operator= YHGetOperatorString(operatorType);

    switch (type) {
        case YHObjectTypeNumber: {
            return [NSString stringWithFormat:@"%@ %@ %@", self, operator, value];
        }
        case YHObjectTypeString: {
            return [NSString stringWithFormat:@"%@ %@ '%@'", self, operator, YHEscapeChar((NSString *)value)];
        }
        default:
            return @"";
    }
}

// =  equal
- (NSString * (^)(NSObject *value))eq {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeEq value:value];
    };
}

// !=
- (NSString * (^)(NSObject *value)) not_eq {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeNotEq value:value];
    };
}

// >  gt  greater than
- (NSString * (^)(NSObject *value))gt {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeGt value:value];
    };
}

// >=
- (NSString * (^)(NSObject *value))gt_and_eq {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeGtAndEq value:value];
    };
}

// <  lt  less than
- (NSString * (^)(NSObject *value))lt {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeLt value:value];
    };
}

// <=
- (NSString * (^)(NSObject *value))lt_and_eq {
    return ^id(NSObject *value) {
      return [self appendOperator:YHOperatorTypeLtAndEq value:value];
    };
}

// between and
- (NSString * (^)(NSArray *values))btw_and {
    return ^id(NSArray *values) {
      YHObjectType type = YHObjectGetType(values);

      switch (type) {
          case YHObjectTypeArray: {
              if (values.count >= 2) {
                  NSObject *value1 = values[0];
                  NSObject *value2 = values[1];
                  YHObjectType value1Type = YHObjectGetType(value1);
                  YHObjectType value2Type = YHObjectGetType(value2);
                  if (value1Type == YHObjectTypeNumber && value2Type == YHObjectTypeNumber) {
                      return [NSString stringWithFormat:@"%@ BETWEEN %@ AND %@", self, value1, value2];
                  } else {
                      return @"";
                  }
              }
          }
          default:
              return @"";
      }
    };
}

// not between and
- (NSString * (^)(NSArray *values))not_btw_and {
    return ^id(NSArray *values) {
      YHObjectType type = YHObjectGetType(values);

      switch (type) {
          case YHObjectTypeArray: {
              if (values.count >= 2) {
                  NSObject *value1 = values[0];
                  NSObject *value2 = values[1];
                  YHObjectType value1Type = YHObjectGetType(value1);
                  YHObjectType value2Type = YHObjectGetType(value2);
                  if (value1Type == YHObjectTypeNumber && value2Type == YHObjectTypeNumber) {
                      return [NSString stringWithFormat:@"%@ NOT BETWEEN %@ AND %@", self, value1, value2];
                  } else {
                      return @"";
                  }
              }
          }
          default:
              return @"";
      }
    };
}

// is not null
- (NSString * (^)())is_not_null {
    return ^id() {
      return [NSString stringWithFormat:@"%@ IS NOT NULL", self];
    };
}

// is null
- (NSString * (^)())is_null {
    return ^id() {
      return [NSString stringWithFormat:@"%@ IS NULL", self];
    };
}

// like
- (NSString * (^)(NSString *value))lk {
    return ^id(NSString *value) {
      if ([NSString isEmpty:value]) {
          return @"";
      }

      return [NSString stringWithFormat:@"%@ LIKE '%%%@%%'", self, value];
    };
}

// not like
- (NSString * (^)(NSString *value))not_lk {
    return ^id(NSString *value) {
      if ([NSString isEmpty:value]) {
          return @"";
      }
      return [NSString stringWithFormat:@"%@ NOT LIKE '%%%@%%'", self, value];
    };
}
// in
- (NSString * (^)(NSObject *value))in {
    return ^id(NSObject *value) {
      YHObjectType type = YHObjectGetType(value);

      switch (type) {
          case YHObjectTypeArray: {
              NSArray *values = (NSArray *)value;
              NSMutableString *appendStr = [@"" mutableCopy];
              for (int i = 0; i < values.count; i++) {
                  NSObject *item = values[i];
                  YHObjectType itemType = YHObjectGetType(item);
                  if (itemType == YHObjectTypeString) {
                      if (i == 0) {
                          [appendStr appendFormat:@"'%@'", item];

                      } else {
                          [appendStr appendFormat:@",'%@'", item];
                      }
                  }
              }
              return [NSString stringWithFormat:@"%@ IN (%@)", self, appendStr];
          }
          case YHObjectTypeString: {
              return [NSString stringWithFormat:@"%@ IN ('%@')", self, (NSString *)value];
          }
          default:
              return @"";
      }
    };
}
// not in
- (NSString * (^)(NSObject *value))not_in {
    return ^id(NSObject *value) {
      YHObjectType type = YHObjectGetType(value);

      switch (type) {
          case YHObjectTypeArray: {
              NSArray *values = (NSArray *)value;
              NSMutableString *appendStr = [@"" mutableCopy];
              for (int i = 0; i < values.count; i++) {
                  NSObject *item = values[i];
                  YHObjectType itemType = YHObjectGetType(item);
                  if (itemType == YHObjectTypeString) {
                      if (i == 0) {
                          [appendStr appendFormat:@"'%@'", item];

                      } else {
                          [appendStr appendFormat:@",'%@'", item];
                      }
                  }
              }
              return [NSString stringWithFormat:@"%@ NOT IN (%@)", self, appendStr];
          }
          case YHObjectTypeString: {
              return [NSString stringWithFormat:@"%@ NOT IN ('%@')", self, (NSString *)value];
          }
          default:
              return @"";
      }
    };
}

// and
- (NSString * (^)(NSString *value))AND {
    return ^id(NSString *value) {
      if ([NSString isEmpty:value]) {
          return self;
      }
      return [NSString stringWithFormat:@"(%@ AND %@)", self, value];
    };
}
// or
- (NSString * (^)(NSString *value))OR {
    return ^id(NSString *value) {
      if ([NSString isEmpty:value]) {
          return self;
      }
      return [NSString stringWithFormat:@"(%@ OR %@)", self, value];
    };
}

// desc
- (NSString * (^)())desc {
    return ^id() {
      if ([NSString isEmpty:self]) {
          return @"";
      }
      return [NSString stringWithFormat:@"%@ DESC", self];
    };
}

// asc
- (NSString * (^)())asc {
    return ^id() {
      if ([NSString isEmpty:self]) {
          return @"";
      }
      return [NSString stringWithFormat:@"%@ ASC", self];
    };
}

// limit‘s offset
- (NSString * (^)(NSNumber *offset))offset {
    return ^id(NSNumber *offset) {
      if (!offset || [NSString isEmpty:self]) {
          return @"";
      }
      return [NSString stringWithFormat:@"%@ OFFSET %@", self, offset];
    };
}

@end

#pragma mark 工具方法

@implementation NSString (FMDBHelper)

+ (NSString *)generateUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);

    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);

    CFRelease(uuid_ref);

    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];

    CFRelease(uuid_string_ref);

    return uuid;
}

+ (BOOL)isEmpty:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }

    if (string == NULL) {
        return YES;
    }

    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    //去除空格
    NSString *realString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (realString.length == 0) {
        return YES;
    }

    return NO;
}

@end
