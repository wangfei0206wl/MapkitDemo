//
//  CameraExViewController.h
//  MapkitDemo
//
//  Created by busap on 14-9-17.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 地图Camera使用
 1、MKMapCamera
    使用MKMapCamera来改变地图样式(地图倾角、旋转角度等)
    MKMapCamera的参数要尽可能设置完整，否则会出意外
 2、MKMapItem
    使用MKMapItem的openMapsWithItems来调用系统地图app，来完成路径规划、地图展现等功能。
    具体参见官方文档
 */
@interface CameraExViewController : BaseViewController

@end
