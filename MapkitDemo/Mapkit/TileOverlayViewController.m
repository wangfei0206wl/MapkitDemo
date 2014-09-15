//
//  TileOverlayViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "TileOverlayViewController.h"
#import "PublicDefines.h"

@interface TileOverlayViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKTileOverlay *_tileOverlay;
    MKTileOverlayRenderer *_tileOverlayRenderer;
}

@end

@implementation TileOverlayViewController

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
    [btnTestInit setTitle:@"添加瓦片层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickTileOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"刷新瓦片层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickRefreshOverlay:) forControlEvents:UIControlEventTouchUpInside];
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
    [self animateToPlace:mapView.userLocation.coordinate coordinateSpan:MKCoordinateSpanMake(0.1, 0.1)];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overlayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        _tileOverlayRenderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
        overlayRenderer = _tileOverlayRenderer;
    }
    
    return overlayRenderer;
}

- (void)onClickTileOverlay:(id)sender {
    if (_tileOverlay) {
        [_mkMapView removeOverlay:_tileOverlay];
        _tileOverlay = nil;
    }
    
    _tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:@"http://58.83.237.121/TrafficTile?x={x}&y={y}&zoom={z}&time=6789"];
    _tileOverlay.minimumZ = 5;
    _tileOverlay.maximumZ = 18;
    
    [_mkMapView addOverlay:_tileOverlay];
}

- (void)onClickRefreshOverlay:(id)sender {
    [_tileOverlayRenderer reloadData];
}

@end
