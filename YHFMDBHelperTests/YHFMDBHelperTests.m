//
//  YHFMDBHelperTests.m
//  YHFMDBHelperTests
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YHContact.h"
#import "YHFMDBHelper.h"

@interface YHFMDBHelperTests : XCTestCase

@end

@implementation YHFMDBHelperTests

- (YHContact *)contact {
    static int number = 0;
    number++;

    YHContact *contact = [[YHContact alloc] init];
    contact.name = [NSString stringWithFormat:@"name_%d", number];
    contact.age = number + 10;
    contact.married = number % 2;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    contact.birthday = [formatter stringFromDate:[NSDate date]];
    contact.height = 0.3 + (float)number * 0.1;
    contact.homeAddress = [NSString stringWithFormat:@"home_address_%d", number];
    contact.mobilePhone = [NSString stringWithFormat:@"1380000%d", (number + 1000)];
    return contact;
}

- (void)setUp {
    [super setUp];
    [YHFMDBUtils createTable:[YHContact class]];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test00_Save {
    for (int i = 0; i < 20; i++) {
        YHContact *contact = [self contact];

        BOOL flag = [YHFMDBUtils save:contact];

        XCTAssertTrue(flag);
    }
}

- (void)test10_SearchAll {
    NSArray *contacts = [YHFMDBUtils searchAll:[YHContact class]];

    XCTAssertTrue(contacts.count > 0);
}

- (void)test11_SearchWhereEq {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.name).eq(@"");
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count == 0);
}

- (void)test12_SearchWhereNot_Eq {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.married).not_eq (@YES);
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count > 0);
}

- (void)test13_SearchWhereGt {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.age).gt(@100);
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count == 0);
}

- (void)test14_SearchWhereGt_Eq {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.age).gt_and_eq(@11);
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count > 0);
}

- (void)test15_SearchWhereLt {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.height).lt(@0.0f);
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count == 0);
}

- (void)test16_SearchWhereLt_Eq {
    YHContact *contact = [[YHContact alloc] init];

    NSString *condtion = @key(contact.height).lt_and_eq(@1.5f);
    NSArray *contacts = [YHFMDBUtils search:[YHContact class] where:condtion];

    XCTAssertTrue(contacts.count > 0);
}

- (void)test99999_RemoveAll {
    BOOL flag = [YHFMDBUtils clearAll:[YHContact class]];

    XCTAssertTrue(flag);
}
@end
