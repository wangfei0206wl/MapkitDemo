//
//  GeocoderViewController.h
//  MapkitDemo
//
//  Created by busap on 14-9-18.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

/*
 反地理编码
 1、MKReverseGeocoder --- ios5以后不建议使用，请使用CoreLocation.framework中的CLGeocoder进行反地理编码
    提供经纬坐标，通过代理方式得到MKPlacemark
 */
@interface GeocoderViewController : BaseViewController

@end
