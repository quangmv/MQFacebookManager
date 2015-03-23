//
//  ViewController.m
//  Example
//
//  Created by setacinq on 1/10/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "ViewController.h"
#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FBSession activeSession] closeAndClearTokenInformation];
    NSLog(@"%@",[[FBSession activeSession] permissions]);
}

- (IBAction)meButtonTapped:(id)sender {
    [FacebookManager requestForMeSuccess:^(id result) {
        NSLog(@"%@",result);
    }];
}
- (IBAction)postStatus:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Updating status at %@", [NSDate date]];
    [FacebookManager shareMessage:message link:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
