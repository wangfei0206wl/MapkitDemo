//
//  AnnotationViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-3.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "AnnotationViewController.h"
#import "PublicDefines.h"

@implementation MyAnnotation

@end

@interface AnnotationViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKPointAnnotation *_pinAnnotation;
    MyAnnotation *_myAnnotation;
}

@end

@implementation AnnotationViewController

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
    [btnTestInit setTitle:@"添加Pin标注" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickPinAnnotation:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"添加自定义标注" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickCustomAnnotaition:) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"Annotation使用"];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickPinAnnotation:(id)sender {
    if (_pinAnnotation) {
        [_mkMapView removeAnnotation:_pinAnnotation];
        _pinAnnotation = nil;
    }
    _pinAnnotation = [[MKPointAnnotation alloc] init];
    _pinAnnotation.coordinate = _mkMapView.userLocation.coordinate;
    _pinAnnotation.title = @"你好";
    _pinAnnotation.subtitle = @"how are you?";
    [_mkMapView addAnnotation:_pinAnnotation];
}

- (void)onClickCustomAnnotaition:(id)sender {
    if (_myAnnotation) {
        [_mkMapView removeAnnotation:_myAnnotation];
        _myAnnotation = nil;
    }
    CLLocationCoordinate2D coordinate = _mkMapView.userLocation.coordinate;
    _myAnnotation = [[MyAnnotation alloc] init];
    _myAnnotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude - 0.1, coordinate.longitude - 0.1);
    _myAnnotation.title = @"你好";
    _myAnnotation.subtitle = @"how old are you";
    _myAnnotation.messages = @"找到你啦！";
    [_mkMapView addAnnotation:_myAnnotation];
    [_mkMapView selectAnnotation:_myAnnotation animated:YES];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        static NSString *myAnnotationIdentifier = @"MyAnnotationIdentifier";
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:myAnnotationIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myAnnotationIdentifier];
            annotationView.canShowCallout = YES;
        }
        else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:@"startAnnotation"];
        annotationView.frame = CGRectMake(0, 0, 23, 30);
        annotationView.centerOffset = CGPointMake(0, - (annotationView.frame.size.height) / 2);
    }
    
    return annotationView;
}

@end
