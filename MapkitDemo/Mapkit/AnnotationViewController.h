//
//  AnnotationViewController.h
//  MapkitDemo
//
//  Created by wangfei on 14-9-3.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) NSString *messages;

@end

/*
 MKAnnotation的使用
 1、MKAnnotation
 2、MKAnnotationView
 3、MKShape
 4、MKPointAnnotation
 5、MKPinAnnotationView
 */
@interface AnnotationViewController : BaseViewController

@end
