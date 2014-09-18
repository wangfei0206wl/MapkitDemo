//
//  GeocoderViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-18.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "GeocoderViewController.h"
#import "PublicDefines.h"

@interface GeocoderViewController () <MKReverseGeocoderDelegate> {
    MKReverseGeocoder *_geocoder;
}

@end

@implementation GeocoderViewController

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
    [btnTestInit setTitle:@"反地理编码" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickReverseGeoCoder:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
    
    btnTestInit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTestInit.frame = CGRectMake(170, offsetY, 120, 30);
    [btnTestInit setTitle:@"坐标转换" forState:UIControlStateNormal];
    [btnTestInit addTarget:self action:@selector(onClickConvertCoord:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnTestInit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"反地理编码"];
    [self createViews];
    
    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(39.905151, 116.401726);
    _geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    _geocoder.delegate = self;
}

- (void)dealloc {
    if (_geocoder) {
        [_geocoder cancel];
        _geocoder = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickReverseGeoCoder:(id)sender {
    if (_geocoder.isQuerying) {
        [_geocoder cancel];
    }
    [_geocoder start];
}

- (void)onClickConvertCoord:(id)sender {
    MKMapSize size = MKMapSizeWorld;
    MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(39.905151, 116.401726));
    NSString *message = [NSString stringWithFormat:@"坐标(39.905151, 116.401726)转换为MKMapPoint(%d, %d)\nworld size(%d, %d)", (int)point.x, (int)point.y, (int)size.width, (int)size.height];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
    
    double dist = MKMetersPerMapPointAtLatitude(30);
    dist = MKMapPointsPerMeterAtLatitude(30);
    CLLocationCoordinate2D coord = MKCoordinateForMapPoint(point);
    
    NSLog(@"");
}

#pragma mark - 
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSString *message = [NSString stringWithFormat:@"反地理编码:\n坐标(39.905151, 116.401726)\n%@ %@ %@ %@", placemark.name, placemark.country, placemark.locality, placemark.thoroughfare];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"反地理编码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

@end
