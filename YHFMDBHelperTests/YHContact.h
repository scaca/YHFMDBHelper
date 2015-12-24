//
//  YHContact.h
//  YHFMDBHelper
//
//  Created by wangyuehong on 15/12/23.
//  Copyright © 2015年 302li. All rights reserved.
//

#import "YHBaseModel.h"
#import <Foundation/Foundation.h>

@interface YHContact : YHBaseModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) int age;
@property(nonatomic, assign) float height;
@property(nonatomic, assign) BOOL married;
@property(nonatomic, copy) NSString *birthday;
@property(nonatomic, copy) NSString *homeAddress;
@property(nonatomic, copy) NSString *mobilePhone;

@end
