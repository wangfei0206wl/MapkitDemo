//
//  AnnotationViewController.h
//  MapkitDemo
//
//  Created by wangfei on 14-9-3.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

// 自定义标注
@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString *messages;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)newCoordinate;

@end

@class MyAnnotationView;

@protocol MyAnnotationDelegate <NSObject>

- (void)MyAnnotationDidNavi:(MyAnnotationView *)view;

@end

// 自定义标注视图
@interface MyAnnotationView : MKAnnotationView {
    UIView *_contentView;
}

@property (nonatomic, assign) id<MyAnnotationDelegate> delegate;

- (void)initWithAnnotation:(MyAnnotation *)annotation;

@end

/*
 MKAnnotation的使用
 1、MKAnnotation
 2、MKAnnotationView
 3、MKShape
 4、MKPointAnnotation
 5、MKPinAnnotationView
 */
@interface AnnotationViewController : BaseViewController <MyAnnotationDelegate>

@end
