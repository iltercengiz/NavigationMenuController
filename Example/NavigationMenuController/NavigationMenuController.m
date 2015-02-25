//
//  NavigationMenuController.m
//  NavigationMenuController
//
//  Created by Ilter Cengiz on 25/02/15.
//  Copyright (c) 2015 Ilter Cengiz. All rights reserved.
//

#import "NavigationMenuController.h"
#import "NavigationMenuManager.h"

#import <UINavigationMenuController.h>

@interface NavigationMenuController () <UINavigationMenuControllerDelegate>

@end

@implementation NavigationMenuController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Navigation menu controller delegate

- (Class)dataSourceClassForNavigationMenuController:(UINavigationMenuController *)navigationMenuController {
    return [NavigationMenuManager class];
}

@end
