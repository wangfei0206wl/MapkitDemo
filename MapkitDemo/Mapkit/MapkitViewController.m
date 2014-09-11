//
//  MapkitViewController.m
//  MapkitDemo
//
//  Created by wangfei on 14-9-2.
//  Copyright (c) 2014年 busap. All rights reserved.
//

#import "MapkitViewController.h"
#import "PublicDefines.h"
#import "MapViewController.h"
#import "AnnotationViewController.h"
#import "OverlayViewController.h"
#import "OverlayTwoViewController.h"

@interface MapkitViewController () {
    NSArray *_arrMenus;
}

@end

@implementation MapkitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initDatas {
    _arrMenus = [NSArray arrayWithObjects:@"Mapview显示", @"Annotation使用", @"Overlay使用", @"Overlay使用之二", nil];
}

- (void)createViews {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7?64:44, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = (id)self;
    tableView.dataSource = (id)self;
    
    [self.view addSubview:tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Mapkit"];
    [self initDatas];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(indexPath.row) {
        case 0:
        {
            MapViewController *controller = [[MapViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:
        {
            AnnotationViewController *controller = [[AnnotationViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            OverlayViewController *controller = [[OverlayViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:
        {
            OverlayTwoViewController *controller = [[OverlayTwoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [_arrMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MenuCell";
    NSString *item = [_arrMenus objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = item;
    
    return cell;
}

@end
