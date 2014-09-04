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

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (id)initWithLocation:(CLLocationCoordinate2D)newCoordinate {
    if (self = [super init]) {
        _coordinate = newCoordinate;
    }
    
    return self;
}

@end

@implementation MyAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.annotation = annotation;
        [self createViews];
    }
   
    return self;
}

- (void)createViews {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    
    CGFloat maxWidth = 235.0f;
    CGSize addSize1 = [self.annotation.title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize addSize2 = [self.annotation.subtitle sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    float width = (addSize1.width > addSize2.width)?addSize1.width:addSize2.width;
    width = (width > 80)?width:80;
    
    CGRect frame = CGRectMake(0, 0, width + 10 + 65, 162);
    // 添加下方的标注
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 16) / 2, 56, 16, 33)];
    imageView.image = [UIImage imageNamed:@"anjuke_icon_itis_position"];
    [_contentView addSubview:imageView];
    
    self.frame = frame;
    frame = CGRectMake(0, 0, width + 10 + 65, 56);
    _contentView.frame = frame;
    
    // 添加尖角图片
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 16) / 2, 65 - 20, 16, 10)];
    imageView.image = [UIImage imageNamed:@"wl_map_icon_4"];
    [_contentView addSubview:imageView];
    
    // 上方背景
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 10)];
    imageView.image = [[UIImage imageNamed:@"wl_map_icon_5"] stretchableImageWithLeftCapWidth:28 topCapHeight:16];
    [_contentView addSubview:imageView];
    
    // 创建按钮
    UIButton *btnNavi = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNavi.frame = CGRectMake(width + 10, 0, 65, 46);
    [btnNavi setImage:[UIImage imageNamed:@"wl_map_icon_1"] forState:UIControlStateNormal];
    [btnNavi addTarget:self action:@selector(onClickNavi) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:btnNavi];
    
    // 创建主标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width, 15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.text = self.annotation.title;
    titleLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:titleLabel];
    
    // 创建副标题
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, width, 15)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
    subTitleLabel.text = self.annotation.subtitle;
    subTitleLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:subTitleLabel];

    [self addSubview:_contentView];
}

- (void)initWithAnnotation:(MyAnnotation *)annotation {
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    
    self.annotation = annotation;
    
    [self createViews];
}

- (void)onClickNavi {
    NSLog(@"-----------onClickNavi");
    if (_delegate && [_delegate respondsToSelector:@selector(MyAnnotationDidNavi:)]) {
        [_delegate MyAnnotationDidNavi:self];
    }
}

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
#if 0
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
#else
        if (annotationView == nil) {
            MyAnnotationView *tmpAnnotationView = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myAnnotationIdentifier];
            tmpAnnotationView.delegate = self;
            annotationView = tmpAnnotationView;
        }
        else {
            MyAnnotationView *tmpAnnotationView = (MyAnnotationView *)annotationView;
            [tmpAnnotationView initWithAnnotation:annotation];
        }
        
#endif
    }
    
    return annotationView;
}

- (void)MyAnnotationDidNavi:(MyAnnotationView *)view {
    NSLog(@"---------broadcast to main view controller.");
}

@end
