//
//  CameraExViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-17.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "CameraExViewController.h"
#import "PublicDefines.h"

@interface CameraExViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKMapItem *_destionation;
    MKMapItem *_soure;
}

@end

@implementation CameraExViewController

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
    [btnTestInit setTitle:@"使用Camera" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickUseCamera:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"调用系统地图" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickEchoSysMap:) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"Camera使用"];
    [self createViews];
    [self destionation];
}

- (void)destionation {
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    
    [revGeo geocodeAddressString:@"天安门" completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0) {
            MKPlacemark *item = [[MKPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
            _destionation = [[MKMapItem alloc] initWithPlacemark:item];
        }
    }];
}

- (void)source {
    _soure = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_mkMapView.userLocation.coordinate addressDictionary:nil]];
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
    [self source];
    [self animateToPlace:mapView.userLocation.coordinate coordinateSpan:MKCoordinateSpanMake(0.1, 0.1)];
}

- (void)onClickUseCamera:(id)sender {
    MKMapCamera *camera = [MKMapCamera camera];
    camera.centerCoordinate = _mkMapView.userLocation.coordinate;
    camera.heading = 30.0f;
    camera.pitch = 45.0f;
    camera.altitude = 450.0f;
    
    [_mkMapView setCamera:camera animated:YES];
}

- (void)onClickEchoSysMap:(id)sender {
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:_soure, _destionation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSValue valueWithMKCoordinate:_soure.placemark.coordinate], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsMapCenterKey, nil]]];
}

@end
