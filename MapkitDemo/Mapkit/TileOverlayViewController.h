//
//  TileOverlayViewController.h
//  MapkitDemo
//
//  Created by wangfei on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

// 自定义MKTileOverlay
// 可以重写部分函数，来修改url
@interface MYTileOverlay : MKTileOverlay

@end

/*
 地图添加MKTileOverlay(瓦片层) ---- ios7及以后版本才有
 1、TileOverlay
    MKTileOverlay、MKTileOverlayRenderer
    MKTileOverlay需要指定URLTemplate、minimumZ、maximumZ
 */
@interface TileOverlayViewController : BaseViewController

@end
