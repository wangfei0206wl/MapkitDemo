//
//  TestObject.h
//  MapkitDemo
//
//  Created by wangfei on 14-9-3.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <NSObject>

@property (nonatomic, retain) NSString *userName;

@optional
@property (nonatomic, assign) int age;
@property (nonatomic, retain) NSString *address;

- (void)changeUserInfo:(NSString *)name;

@end

@interface TestObject : NSObject <TestProtocol>

@property (nonatomic, assign) int age;
@property (nonatomic, retain) NSString *address;

@end

@interface TestImplObject : TestObject

@property (nonatomic, retain) NSString *userName;

@end