//
//  CameraViewController.h
//  MapkitDemo
//
//  Created by busap on 14-9-16.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 地图上截图
 自定义标注、层是不能截取下来的，只能通过在截取的图片上绘制上去
 
 1、MKMapSnapshotter 地图截图类
    initWithOptions 创建
    startWithCompletionHandler 进行地图截图
        这里当app进入background时，此操作将停止，在app重新切回foreground后会继续此操作
    startWithQueue 在指定queue中进行地图截图
 2、MKMapSnapshotOptions 地图截图条件设置
 3、MKMapSnapshot 生成的快照
    image 快照
    pointForCoordinate 坐标转换到快照上坐标的方法
 4、MKMapCamera 地图摄像
 */
@interface CameraViewController : BaseViewController

@end
