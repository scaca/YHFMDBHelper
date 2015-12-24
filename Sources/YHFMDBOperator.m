//
//  YHFMDBOperator.m
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <FMDB/FMDB.h>
#import <objc/runtime.h>
#import "NSString+SQL.h"
#import "YHBaseModel.h"
#import "YHFMDBOperator.h"

// SQLite数据类型
#define kSQL_TEXT @"TEXT"
#define kSQL_REAL @"REAL"
#define kSQL_BLOB @"BLOB"
#define kSQL_INTEGER @"INTEGER"

@interface YHFMDBOperator ()

@property(nonatomic, strong) FMDatabase *db;
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@property(nonatomic, strong) NSString *dbPath;

// Save object property mapping dictionary
@property(nonatomic, strong) NSMutableDictionary *modelMappingDictionary;

@end

@implementation YHFMDBOperator
static YHFMDBOperator *operator= nil;

+ (YHFMDBOperator *)shareOperator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      operator= [[YHFMDBOperator alloc] initWithPath:kDataBasePath];
    });
    return operator;
}

//初始化数据库对象
- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.dbPath = path;
        self.db = [FMDatabase databaseWithPath:path];
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
        self.modelMappingDictionary = @{}.mutableCopy;
    }
    return self;
}

- (BOOL)executeSql:(NSString *)sql {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
      result = [db executeUpdate:sql];
    }];
    return result;
}

#pragma mark Insert
- (BOOL)insert:(YHBaseModel *)data {
    __block BOOL result = NO;

    NSString *className = NSStringFromClass(data.class);
    NSMutableDictionary *propertyDictionary = self.modelMappingDictionary[className];

    NSArray *allKeys = propertyDictionary.allKeys;
    NSMutableArray *cols = @[].mutableCopy;
    // filter nil column
    for (NSString *key in allKeys) {
        if ([data valueForKey:key]) {
            [cols addObject:key];
        }
    }

    [self.dbQueue inDatabase:^(FMDatabase *db) {
      NSMutableString *sql = [@"" mutableCopy];
      if (cols.count > 0) {
          [sql appendFormat:@"INSERT INTO %@ (%@", NSStringFromClass(data.class), cols[0]];
          for (int i = 1; i < cols.count; i++) {
              [sql appendFormat:@",%@", cols[i]];
          }
          [sql appendString:@") VALUES(?"];
          for (int i = 1; i < cols.count; i++) {
              [sql appendString:@",?"];
          }
          [sql appendString:@")"];

          NSMutableArray *array = [[NSMutableArray alloc] init];
          for (int i = 0; i < cols.count; i++) {
              [array addObject:[data valueForKey:cols[i]]];
          }
          result = [db executeUpdate:sql withArgumentsInArray:array];
      }
    }];
    return result;
}

#pragma mark Delete

- (BOOL) delete:(YHBaseModel *)data {
    __block BOOL result = NO;

    if (!data) {
        return NO;
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
      NSString *sql =
          [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", NSStringFromClass(data.class), kModelPrimaryKey];
      NSString *pkValue = [data valueForKey:kModelPrimaryKey];
      result = [db executeUpdate:sql withArgumentsInArray:@[ pkValue ]];
    }];
    return result;
}

- (BOOL)deleteAll:(Class)cls {
    __block BOOL result = NO;

    [self.dbQueue inDatabase:^(FMDatabase *db) {
      NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ ", NSStringFromClass(cls)];
      result = [db executeStatements:sql];
    }];
    return result;
}

- (BOOL) delete:(Class)cls where:(NSString *)condition {
    __block BOOL result = NO;

    [self.dbQueue inDatabase:^(FMDatabase *db) {
      if (![NSString isEmpty:condition]) {
          NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", NSStringFromClass(cls), condition];
          result = [db executeStatements:sql];
      }
    }];
    return result;
}

#pragma mark Update
- (BOOL)update:(YHBaseModel *)data {
    return [self update:data where:nil];
}

- (BOOL)update:(YHBaseModel *)data where:(NSString *)condition {
    __block BOOL result = NO;

    if (!data) {
        return NO;
    }
    NSString *className = NSStringFromClass(data.class);
    NSMutableDictionary *propertyDictionary = self.modelMappingDictionary[className];

    NSArray *allKeys = propertyDictionary.allKeys;
    NSMutableArray *cols = @[].mutableCopy;
    // filter nil column
    for (NSString *key in allKeys) {
        if ([data valueForKey:key]) {
            [cols addObject:key];
        }
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {

      NSMutableString *sql = [@"" mutableCopy];
      if (cols.count > 1) {
          [sql appendFormat:@"UPDATE %@ SET ", NSStringFromClass(data.class)];
          for (int i = 0; i < cols.count; i++) {
              [sql appendFormat:@"%@ = ?,", cols[i]];
          }
          //删除最后那个逗号
          [sql deleteCharactersInRange:NSMakeRange(sql.length - 1, 1)];

          NSMutableArray *array = [[NSMutableArray alloc] init];
          for (int i = 0; i < cols.count; i++) {
              [array addObject:[data valueForKey:cols[i]]];
          }
          if (![NSString isEmpty:condition]) {
              [sql appendFormat:@" WHERE %@", condition];
          } else {
              [sql appendFormat:@" WHERE %@ = ?", kModelPrimaryKey];
              [array addObject:[data valueForKey:kModelPrimaryKey]];
          }
          result = [db executeUpdate:sql withArgumentsInArray:array];
      }
    }];
    return result;
}

#pragma mark Select
- (NSArray *)select:(Class)cls {
    return [self select:cls where:nil];
}

- (NSArray *)select:(Class)cls where:(NSString *)condition {
    return [self select:cls where:condition orderBy:nil];
}

- (NSArray *)select:(Class)cls where:(NSString *)condition orderBy:(NSString *)orderBy {
    return [self select:cls where:condition orderBy:orderBy limit:nil];
}

- (NSArray *)select:(Class)cls where:(NSString *)condition orderBy:(NSString *)orderBy limit:(NSString *)limit {
    __block NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    [self.dbQueue inDatabase:^(FMDatabase *db) {
      NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", NSStringFromClass(cls)];
      if (![NSString isEmpty:condition]) {
          sql = [NSString stringWithFormat:@"%@ WHERE %@", sql, condition];
      }
      if (![NSString isEmpty:orderBy]) {
          sql = [NSString stringWithFormat:@"%@ %@", sql, orderBy];
      }
      if (![NSString isEmpty:limit]) {
          sql = [NSString stringWithFormat:@"%@ %@", sql, limit];
      }
      FMResultSet *result = [db executeQuery:sql];
      while ([result next]) {
          NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
          for (NSString *col in result.columnNameToIndexMap.allKeys) {
              dict[col] = [result objectForColumnName:col];
          }
          [resultArray addObject:dict];
      }
    }];

    return resultArray;
}

#pragma mark Count
// count all
- (int)count:(Class)cls {
    return [self count:cls where:nil];
}

// count by condition
- (int)count:(Class)cls where:(NSString *)condition {
    __block int recordCount = 0;

    [self.dbQueue inDatabase:^(FMDatabase *db) {
      NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) FROM %@", kModelPrimaryKey, NSStringFromClass(cls)];
      if (![NSString isEmpty:condition]) {
          sql = [NSString stringWithFormat:@"%@ WHERE %@", sql, condition];
      }
      FMResultSet *result = [db executeQuery:sql];
      while ([result next]) {
          NSString *col = result.columnNameToIndexMap.allKeys[0];
          NSNumber *value = [result objectForColumnName:col];
          recordCount = value.intValue;
      }
    }];

    return recordCount;
}

#pragma mark Create Table
// create table with model
- (BOOL)createTable:(Class)cls {
    NSMutableString *colsSql = [NSMutableString new];

    NSDictionary *propertyDic = [self getPropertyMapInfoWithClass:cls];
    NSArray *allKeys = propertyDic.allKeys;

    for (int i = 0; i < allKeys.count; i++) {
        NSString *propertyName = allKeys[i];

        if ([propertyName isEqualToString:kModelPrimaryKey]) {
            continue;
        }
        NSString *propertyTypeString = propertyDic[propertyName];
        [colsSql appendFormat:@", %@ %@", propertyName, propertyTypeString];
    }

    NSString *tableName = NSStringFromClass(cls);

    NSString *createTableSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ VARCHAR PRIMARY KEY %@)",
                                                          tableName, kModelPrimaryKey, colsSql];
    BOOL isSuccess = [self executeSql:createTableSql];
    if (!isSuccess) {
        NSLog(@"===YHFMDBHelper=== [%@] TABLE CREATE FAIL!", tableName);
    } else {
        NSLog(@"===YHFMDBHelper=== [%@] TABLE CREATE SUCCESS!", tableName);
    }

    return isSuccess;
}

#pragma mark Help Function
// Get class property info
- (NSDictionary *)getPropertyMapInfoWithClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    if ([self.modelMappingDictionary.allKeys containsObject:className]) {
        return self.modelMappingDictionary[className];
    }
    // ignored properties
    NSArray *ignoredPropertyNames = [cls ignoredPropertiesForDB];

    NSMutableDictionary *propertyDictionary = @{}.mutableCopy;
    Class class = cls;
    while (class != [NSObject class]) {
        unsigned int outCount;
        objc_property_t *propertyList = class_copyPropertyList(class, &outCount);

        for (int i = 0; i < outCount; i++) {
            objc_property_t property = propertyList[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];

            if (ignoredPropertyNames && [ignoredPropertyNames containsObject:propertyName]) {
                continue;
            }
            NSString *propertyType = [NSString stringWithUTF8String:property_getAttributes(property)];
            if ([propertyType hasPrefix:@"T@"]) {
                propertyType = kSQL_TEXT;
            } else if ([propertyType hasPrefix:@"Ti"] || [propertyType hasPrefix:@"TI"] ||
                       [propertyType hasPrefix:@"Ts"] || [propertyType hasPrefix:@"TS"] ||
                       [propertyType hasPrefix:@"TB"]) {
                propertyType = kSQL_INTEGER;
            } else {
                propertyType = kSQL_REAL;
            }
            [propertyDictionary setObject:propertyType forKey:propertyName];
        }
        class = class_getSuperclass(class);
    }
    [self.modelMappingDictionary setObject:propertyDictionary forKey:className];
    return propertyDictionary;
}
@end
