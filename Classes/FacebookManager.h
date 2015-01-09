//
//  FacebookManager.h
//  quang.app@gmail.com
//
//  Created by Quang Mai Van on 01/10/15.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FacebookResponse)(id result);

@interface FacebookManager : NSObject

+(void)handleFacebookError:(NSError*)error;

+(void)requestPermissions:(NSArray*)permissions success:(void (^)(void))success;

+(void)shareMessage:(NSString*)message link:(NSString*)link;

+(void)likeUrl:(NSString*)urlString;

+(void)requestForMeSuccess:(FacebookResponse)success;

+(void)postVideo:(NSData*)videoData Title:(NSString*)title andDescription:(NSString*)description;

@end
