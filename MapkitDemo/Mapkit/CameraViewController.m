//
//  CameraViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-16.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "CameraViewController.h"
#import "PublicDefines.h"
#import "ImageShowViewController.h"

@interface CameraViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
    
    MKMapSnapshotter *_mkSnapshotter;
    MKPointAnnotation *_annotion;
    MKPolyline *_polyline;
}

@end

@implementation CameraViewController

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
    [btnTestInit setTitle:@"地图截图" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"视图截图" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickViewSnapshot:) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_mkSnapshotter) {
        [_mkSnapshotter cancel];
        _mkSnapshotter = nil;
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
    [self addAnnotationAndOverlay];
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
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overLayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 4.0f;
        renderer.strokeColor = [UIColor greenColor];
        
        overLayRenderer = renderer;
    }
    
    return overLayRenderer;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView *overLayView = nil;
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *view = [[MKPolylineView alloc] initWithPolyline:overlay];
        view.lineWidth = 4.0f;
        view.strokeColor = [UIColor greenColor];
        
        overLayView = view;
    }
    
    return overLayView;
}

- (void)addAnnotationAndOverlay {
    _annotion = [[MKPointAnnotation alloc] init];
    _annotion.coordinate = CLLocationCoordinate2DMake(_mkMapView.userLocation.coordinate.latitude - 0.1, _mkMapView.userLocation.coordinate.longitude - 0.1);
    _annotion.title = @"你好";
    [_mkMapView addAnnotation:_annotion];
    
    CLLocationCoordinate2D coords[] = {{39.905151, 116.401726}, {39.785151, 116.521726}, {39.865151, 116.301726}};
    int count = sizeof(coords) / sizeof(CLLocationCoordinate2D);
    _polyline = [MKPolyline polylineWithCoordinates:coords count:count];
    
    [_mkMapView addOverlay:_polyline];
}

- (void)onClickSnapshot:(id)sender {
    if (_mkSnapshotter) {
        [_mkSnapshotter cancel];
        _mkSnapshotter = nil;
    }
    MKMapCamera *camera = [MKMapCamera camera];
    camera.centerCoordinate = _mkMapView.userLocation.coordinate;
    camera.heading = 90.0f;
    camera.pitch = 30.0f;
    camera.altitude = 450.0f;
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.camera = camera;
    options.region = MKCoordinateRegionMakeWithDistance(_mkMapView.userLocation.coordinate, 5000, 5000);
    options.showsPointsOfInterest = YES;
    options.showsBuildings = YES;
    options.size = CGSizeMake(512, 512);
    options.scale = 2.0f;
    _mkSnapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [_mkSnapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        // 自定义标注与层没有被截取
        if (snapshot && snapshot.image) {
            ImageShowViewController *controller = [[ImageShowViewController alloc] init];
            controller.image = snapshot.image;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)onClickViewSnapshot:(id)sender {
    UIGraphicsBeginImageContext(_mkMapView.frame.size);
    [_mkMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    ImageShowViewController *controller = [[ImageShowViewController alloc] init];
    controller.image = image;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
