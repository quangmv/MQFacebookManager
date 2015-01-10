//
//  ViewController.m
//  Example
//
//  Created by setacinq on 1/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ViewController.h"
#import <FacebookManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Request for me
    
    
}

- (IBAction)meButtonTapped:(id)sender {
    [FacebookManager requestForMeSuccess:^(id result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
