//
//  DirectionViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "DirectionViewController.h"
#import "PublicDefines.h"

@interface DirectionViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
 
    MKPolyline *_polyline;
    MKPointAnnotation *_sourceAnnotation;
    MKPointAnnotation *_destAnnotation;
    MKDirections *_directions;
    MKMapItem *_destionation;
    MKMapItem *_soure;
}

@end

@implementation DirectionViewController

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
    [btnTestInit setTitle:@"天安门路线" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickDirection:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"天安门预估时长" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickETA:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    offsetY += (30 + 20);
    height -= offsetY;
    _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, height)];
    _mkMapView.mapType = MKMapTypeStandard;
    _mkMapView.showsUserLocation = YES;
    _mkMapView.delegate = self;
    
    [contentView addSubview:_mkMapView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Direction使用"];
    [self createViews];
    [self destionation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_directions) {
        [_directions cancel];
        _directions = nil;
    }
    NSLog(@"--------dealloc");
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *myAnnotationIdentifier = @"MyAnnotationIdentifier";
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myAnnotationIdentifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myAnnotationIdentifier];
        }
        annotationView.annotation = annotation;
        annotationView.pinColor = MKPinAnnotationColorRed;
//        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overlayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 绘制曲线
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth = 4.0f;
        polylineRenderer.strokeColor = [UIColor greenColor];
        polylineRenderer.alpha = 0.5f;
        overlayRenderer = polylineRenderer;
    }
    
    return overlayRenderer;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView *overlayView = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 绘制曲线
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 4.0f;
        polylineView.strokeColor = [UIColor greenColor];
        polylineView.alpha = 0.5f;
        overlayView = polylineView;
    }
    
    return overlayView;
}

- (void)onClickDirection:(id)sender {
    if (_polyline) {
        [_mkMapView removeOverlay:_polyline];
        _polyline = nil;
    }
    if (_sourceAnnotation) {
        [_mkMapView removeAnnotation:_sourceAnnotation];
        _sourceAnnotation = nil;
    }
    if (_destAnnotation) {
        [_mkMapView removeAnnotation:_destAnnotation];
        _destAnnotation = nil;
    }
    if (_directions) {
        [_directions cancel];
        _directions = nil;
    }
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = _soure; request.destination = _destionation;
    request.transportType = MKDirectionsTransportTypeWalking;
    
    _directions = [[MKDirections alloc] initWithRequest:request];

    [_directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (response && response.routes && response.routes.count > 0) {
            MKRoute *route = [response.routes objectAtIndex:0];
            
            _polyline = route.polyline;
            [_mkMapView addOverlay:_polyline];
            
            _sourceAnnotation = [[MKPointAnnotation alloc] init];
            _sourceAnnotation.coordinate = _soure.placemark.coordinate;
            _sourceAnnotation.title = @"起点";
            [_mkMapView addAnnotation:_sourceAnnotation];
            
            _destAnnotation = [[MKPointAnnotation alloc] init];
            _destAnnotation.coordinate = _destionation.placemark.coordinate;
            _destAnnotation.title = @"终点";
            [_mkMapView addAnnotation:_destAnnotation];
        }
    }];
}

- (void)onClickETA:(id)sender {
    if (_directions) {
        [_directions cancel];
        _directions = nil;
    }
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = _soure; request.destination = _destionation;
    request.transportType = MKDirectionsTransportTypeWalking;

    _directions = [[MKDirections alloc] initWithRequest:request];
    
    [_directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        if (response) {
            NSString *message = [NSString stringWithFormat:@"此地去天安门预估时长为:%@", [self getTimeString:response.expectedTravelTime]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }];
}

- (NSString *)getTimeString:(NSTimeInterval)timeInteval {
    NSMutableString *string = [[NSMutableString alloc] init];
    
    int time = timeInteval;
    int day = time / (24 * 3600); time = time % (24 * 3600);
    int hour = time / 3600; time = time % 3600;
    int minute = time / 60; time = time % 60;
    int second = time;
    
    if (day > 0) {
        [string appendFormat:@"%d天%d小时%d分%d秒", day, hour, minute, second];
    }
    else {
        if (hour > 0) {
            [string appendFormat:@"%d小时%d分%d秒", hour, minute, second];
        }
        else {
            if (minute > 0) {
                [string appendFormat:@"%d分%d秒", minute, second];
            }
            else {
                [string appendFormat:@"%d秒", second];
            }
        }
    }
    
    return string;
}

@end
