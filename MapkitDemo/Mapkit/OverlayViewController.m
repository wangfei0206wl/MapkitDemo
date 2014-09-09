//
//  OverlayViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-9.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "OverlayViewController.h"
#import "PublicDefines.h"

@interface OverlayViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
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
    [btnTestInit setTitle:@"添加层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"添加自定义层" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCustomOverlay:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onClickOverlay:(id)sender {
    
}

- (void)onClickCustomOverlay:(id)sender {
    
}

@end
