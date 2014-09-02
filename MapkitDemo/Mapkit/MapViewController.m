//
//  MapViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-2.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "MapViewController.h"
#import "PublicDefines.h"

@interface MapViewController () <MKMapViewDelegate> {
    MKMapView *_mkMapView;
}

@end

@implementation MapViewController

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
    
    _mkMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, SCREEN_WIDTH, height)];
    _mkMapView.mapType = MKMapTypeStandard;
    _mkMapView.showsUserLocation = YES;
    _mkMapView.delegate = self;
    
    [self.view addSubview:_mkMapView];
    
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake(20, [[UIScreen mainScreen] bounds].size.height - 53, 33, 33);
    [btnLocation setImage:[UIImage imageNamed:@"btn_gpslocation_normal"] forState:UIControlStateNormal];
    [btnLocation setImage:[UIImage imageNamed:@"btn_gpslocation_down"] forState:UIControlStateHighlighted];
    [btnLocation addTarget:self action:@selector(onClickLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocation];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [_mkMapView addGestureRecognizer:gesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"MKMapView使用"];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLocation:(id)sender {
    if (_mkMapView.userLocation && _mkMapView.userLocation.location) {
        [self animateToPlace:_mkMapView.userLocation.coordinate coordinateSpan:MKCoordinateSpanMake(0.8, 0.8)];
    }
}

- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"------------onTapGesture");
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

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {

}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self animateToPlace:mapView.userLocation.coordinate coordinateSpan:MKCoordinateSpanMake(0.8, 0.8)];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
}

@end
