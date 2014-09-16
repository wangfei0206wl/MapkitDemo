//
//  LocalSearchViewController.h
//  MapkitDemo
//
//  Created by busap on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 本地搜索
 1、MKLocalSearch
    地图搜索引擎(搜索address和poi)
 2、MKLocalSearchRequest
    地图搜索条件
    自然语言搜索条件、搜索区域
 3、MKlocalSearchResponse
    搜索返回结果
    mapItems为MKMapItem集合
 
 注意：一个搜索使用一个MKLocalSearch对象，多种搜索必须要创建多个MKLocalSearch对象，不能共用同一个对象
 */
@interface LocalSearchViewController : BaseViewController

@end
