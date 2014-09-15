//
//  LocalSearchViewController.m
//  MapkitDemo
//
//  Created by busap on 14-9-15.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "LocalSearchViewController.h"
#import "PublicDefines.h"

@interface LocalSearchViewController ()

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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"LocalSearch使用"];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
