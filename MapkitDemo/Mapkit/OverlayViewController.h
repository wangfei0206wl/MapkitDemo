//
//  OverlayViewController.h
//  MapkitDemo
//
//  Created by wangfei on 14-9-9.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 地图上添加overlay
 1、添加polyline层 ---- 大地曲线
    使用MKPolyline、MKPolylineView、MKPolylineRenderer
 2、添加polygon层
    使用MKPolygon、MKPolygonView、MKPolygonRenderer
 
 说明:
 MKMultiPoint类为抽象超类，必须由此继承才能使用，是不能做为实例化类使用的。
 由多点组成的抽象地图形状，继承于MKShape
 */
@interface OverlayViewController : BaseViewController

@end
