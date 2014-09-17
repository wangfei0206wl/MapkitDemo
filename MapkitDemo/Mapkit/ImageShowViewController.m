//
//  ImageShowViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-17.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "ImageShowViewController.h"

@interface ImageShowViewController () {
    UIImageView *_imageView;
}

@end

@implementation ImageShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (_imageView) {
        _imageView.image = _image;
    }
}

- (void)createViews {
    self.view.backgroundColor = [UIColor blackColor];
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = _image;
    
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBack)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
