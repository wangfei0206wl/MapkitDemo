//
//  LocalSearchViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "LocalSearchViewController.h"
#import "PublicDefines.h"

@interface LocalSearchViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;

    MKCircle *_circleOverLay;
    MKLocalSearch *_localSearch;
    
    NSMutableArray *_arrAnnotations;
}

@end

@implementation LocalSearchViewController

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
    [btnTestInit setTitle:@"酒店" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSearchHall:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"餐馆" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickSearchRestaurant:) forControlEvents:UIControlEventTouchUpInside];
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
    [self setTitle:@"LocalSearch使用"];
    [self createViews];
    
    _arrAnnotations = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_localSearch) {
        [_localSearch cancel];
        _localSearch = nil;
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
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }
    
    return annotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKOverlayRenderer *overLayRenderer = nil;
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        renderer.lineWidth = 0.0f;
        renderer.strokeColor = [UIColor clearColor];
        renderer.fillColor = [UIColor greenColor];
        renderer.alpha = 0.2f;
        
        overLayRenderer = renderer;
    }
    
    return overLayRenderer;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView *overLayView = nil;
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *view = [[MKCircleView alloc] initWithCircle:overlay];
        view.lineWidth = 0.0f;
        view.strokeColor = [UIColor clearColor];
        view.fillColor = [UIColor greenColor];
        view.alpha = 0.2f;
        
        overLayView = view;
    }
    
    return overLayView;
}

- (void)onClickSearchHall:(id)sender {
    // 删除所有标注
    for (MKPointAnnotation *annotation in _arrAnnotations) {
        [_mkMapView removeAnnotation:annotation];
    }
    [_arrAnnotations removeAllObjects];
    
    if (_circleOverLay) {
        [_mkMapView removeOverlay:_circleOverLay];
        _circleOverLay = nil;
    }
    
    _circleOverLay = [MKCircle circleWithCenterCoordinate:_mkMapView.userLocation.coordinate radius:2500];
    [_mkMapView addOverlay:_circleOverLay];
    
    if (_localSearch) {
        [_localSearch cancel];
        _localSearch = nil;
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"酒店";
    request.region = MKCoordinateRegionMakeWithDistance(_mkMapView.userLocation.coordinate, 5000, 5000);
    
    _localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [_localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        // 搜索结果
        if (response && response.mapItems && response.mapItems.count > 0) {
            for (MKMapItem *item in response.mapItems) {
                MKPlacemark *placeMark = item.placemark;
                
                MKPointAnnotation *pointAnnotion = [[MKPointAnnotation alloc] init];
                pointAnnotion.coordinate = placeMark.location.coordinate;
                pointAnnotion.title = item.name;
                pointAnnotion.subtitle = item.phoneNumber;
                
                [_mkMapView addAnnotation:pointAnnotion];
                
                [_arrAnnotations addObject:pointAnnotion];
            }
        }
    }];
}

- (void)onClickSearchRestaurant:(id)sender {
    // 删除所有标注
    for (MKPointAnnotation *annotation in _arrAnnotations) {
        [_mkMapView removeAnnotation:annotation];
    }
    [_arrAnnotations removeAllObjects];
    
    if (_circleOverLay) {
        [_mkMapView removeOverlay:_circleOverLay];
        _circleOverLay = nil;
    }
    
    _circleOverLay = [MKCircle circleWithCenterCoordinate:_mkMapView.userLocation.coordinate radius:2500];
    [_mkMapView addOverlay:_circleOverLay];
    
    if (_localSearch) {
        [_localSearch cancel];
        _localSearch = nil;
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"餐馆";
    request.region = MKCoordinateRegionMakeWithDistance(_mkMapView.userLocation.coordinate, 5000, 5000);
    
    _localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [_localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        // 搜索结果
        if (response && response.mapItems && response.mapItems.count > 0) {
            for (MKMapItem *item in response.mapItems) {
                MKPlacemark *placeMark = item.placemark;
                
                MKPointAnnotation *pointAnnotion = [[MKPointAnnotation alloc] init];
                pointAnnotion.coordinate = placeMark.location.coordinate;
                pointAnnotion.title = item.name;
                pointAnnotion.subtitle = item.phoneNumber;
                
                [_mkMapView addAnnotation:pointAnnotion];
                
                [_arrAnnotations addObject:pointAnnotion];
            }
        }
    }];
}

@end
