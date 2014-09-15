//
//  OverlayTwoViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-11.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "OverlayTwoViewController.h"
#import "PublicDefines.h"

@interface OverlayTwoViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKCircle *_circleOverLay;
    MKGeodesicPolyline *_geodesicPolyline;
}

@end

@implementation OverlayTwoViewController

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
    [btnTestInit setTitle:@"添加圆形层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCircle:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"添加大地曲线" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickGeodesicPolyline:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    offsetY += (30 + 20);
    height -= offsetY;
    _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, height)];
    _mkMapView.mapType = MKMapTypeStandard;
    _mkMapView.showsUserLocation = YES;
    _mkMapView.delegate = self;
    
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overLayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        renderer.lineWidth = 2.0f;
        renderer.strokeColor = [UIColor blackColor];
        renderer.fillColor = [UIColor redColor];
        renderer.alpha = 0.5f;
        
        overLayRenderer = renderer;
    }
    else if ([overlay isKindOfClass:[MKGeodesicPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 2.0f;
        renderer.strokeColor = [UIColor blackColor];
        
        overLayRenderer = renderer;
    }
    
    return overLayRenderer;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView *overLayView = nil;
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *view = [[MKCircleView alloc] initWithCircle:overlay];
        view.lineWidth = 2.0f;
        view.strokeColor = [UIColor blackColor];
        view.fillColor = [UIColor redColor];
        view.alpha = 0.5;
        
        overLayView = view;
    }
    else if ([overlay isKindOfClass:[MKGeodesicPolyline class]]) {
        MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:overlay];
        view.lineWidth = 2.0f;
        view.strokeColor = [UIColor blackColor];
        
        overLayView = view;
    }
    
    return overLayView;
}

- (void)onClickCircle:(id)sender {
    if (_geodesicPolyline) {
        [_mkMapView removeOverlay:_geodesicPolyline];
        _geodesicPolyline = nil;
    }
    if (_circleOverLay) {
        [_mkMapView removeOverlay:_circleOverLay];
        _circleOverLay = nil;
    }
    
    _circleOverLay = [MKCircle circleWithCenterCoordinate:_mkMapView.userLocation.coordinate radius:20000];
    [_mkMapView addOverlay:_circleOverLay];
}

- (void)onClickGeodesicPolyline:(id)sender {
    if (_geodesicPolyline) {
        [_mkMapView removeOverlay:_geodesicPolyline];
        _geodesicPolyline = nil;
    }
    if (_circleOverLay) {
        [_mkMapView removeOverlay:_circleOverLay];
        _circleOverLay = nil;
    }
 
    CLLocationCoordinate2D coords[] = {{39.905151, 116.401726}, {39.785151, 116.521726}, {39.865151, 116.301726}};
    int count = sizeof(coords) / sizeof(CLLocationCoordinate2D);
    _geodesicPolyline = [MKGeodesicPolyline polylineWithCoordinates:coords count:count];
    [_mkMapView addOverlay:_geodesicPolyline];
}

@end
