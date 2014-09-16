//
//  DirectionViewController.h
//  MapkitDemo
//
//  Created by busap on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 旅行路线搜索
 1、MKDirections ---- ios7.0以后版本
    旅行相关搜索引擎
    一个对象对应一种搜索
    多个不同旅行搜索需要创建多个对象
    不能同时做多个路线搜索，否则会报错
 2、MKDirectionsRequest
    旅行相关请求
    起点、终点、旅行方式等
 3、MKDirectionsResponse
    搜索结果
    routes 路线数据(MKRoute的集合)
    MKRoute 路线
    MKRouteStep 路线中的一个步
 4、MKETAResponse
    最佳旅行时间查询结果
    expectedTravelTime 最佳旅行时间
 */
@interface DirectionViewController : BaseViewController

@end
