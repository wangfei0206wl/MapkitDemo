//
//  OverlayViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-9.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "OverlayViewController.h"
#import "PublicDefines.h"

#define ENABLE_OVERLAY_RENDER   0

@interface OverlayViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKPolyline *_polyline;
    MKPolygon *_polygon;
}

@end

@implementation OverlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createViews {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, SCREEN_WIDTH, height)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    CGFloat offsetY = 20;
    UIButton *btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(30, offsetY, 120, 30);
    [btnTestInit setTitle:@"添加曲线层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickPolylineOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"添加多边形" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickPolygonOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    offsetY += (30 + 20);
    height -= offsetY;
    _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, height)];
    _mkMapView.mapType = MKMapTypeStandard;
    _mkMapView.showsUserLocation = YES;
    _mkMapView.delegate = self;
//    _mkMapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    [contentView addSubview:_mkMapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Overlay使用"];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateToPlace:(CLLocationCoordinate2D)coordinate
        coordinateSpan:(MKCoordinateSpan)coordinateSpan {
    MKCoordinateRegion region;
    
    region.center = coordinate;
    region.span = coordinateSpan;
    region = [_mkMapView regionThatFits:region];
    [_mkMapView setRegion:region animated:YES];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self animateToPlace:mapView.userLocation.coordinate coordinateSpan:MKCoordinateSpanMake(0.4, 0.4)];
}

//#if ENABLE_OVERLAY_RENDER
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overlayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 绘制曲线
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth = 4.0f;
        polylineRenderer.strokeColor = [UIColor blackColor];
        overlayRenderer = polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer *polygonRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth = 2.0f;
        polygonRenderer.strokeColor = [UIColor blackColor];
        polygonRenderer.fillColor = [UIColor redColor];
        overlayRenderer = polygonRenderer;
    }
    
    return overlayRenderer;
}
//#else
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView *overlayView = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 绘制曲线
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 4.0f;
        polylineView.strokeColor = [UIColor blackColor];
        overlayView = polylineView;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth = 2.0f;
        polygonView.strokeColor = [UIColor blackColor];
        polygonView.fillColor = [UIColor redColor];
        overlayView = polygonView;
    }
    
    return overlayView;
}
//#endif
- (void)onClickPolylineOverlay:(id)sender {
    if (_polyline) {
        [_mkMapView removeOverlay:_polyline];
        _polyline = nil;
    }
    if (_polygon) {
        [_mkMapView removeOverlay:_polygon];
        _polygon = nil;
    }
 
    CLLocationCoordinate2D coords[] = {{39.905151, 116.401726}, {39.785151, 116.521726}, {39.865151, 116.301726}};
    int count = sizeof(coords) / sizeof(CLLocationCoordinate2D);
    _polyline = [MKPolyline polylineWithCoordinates:coords count:count];
    
    [_mkMapView addOverlay:_polyline];
}

- (void)onClickPolygonOverlay:(id)sender {
    if (_polyline) {
        [_mkMapView removeOverlay:_polyline];
        _polyline = nil;
    }
    if (_polygon) {
        [_mkMapView removeOverlay:_polygon];
        _polygon = nil;
    }
    
    CLLocationCoordinate2D coords[] = {{39.905151, 116.401726}, {39.805151, 116.521726}, {39.905151, 116.201726}};
    int count = sizeof(coords) / sizeof(CLLocationCoordinate2D);
    _polygon = [MKPolygon polygonWithCoordinates:coords count:count];
    
    [_mkMapView addOverlay:_polygon];
}

@end
