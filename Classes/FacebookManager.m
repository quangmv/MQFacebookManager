//
//  FacebookManager.m
//  quang.app@gmail.com
//
//  Created by Quang Mai Van on 01/10/15.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookManager

+(void)handleFacebookError:(NSError*)error
{
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using an app to make an action outside of the app to recover
        // The SDK will provide an error message that we have to show the user
        [[[UIAlertView alloc] initWithTitle:@"Something went wrong" message:[FBErrorUtility userMessageForError:error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } else {
        // If the user cancelled login
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            [[[UIAlertView alloc] initWithTitle:@"Facebook Login" message:@"Login cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            // For simplicity, in this sample, for all other errors we show a generic message
            // You can read more about how to handle other errors in our Handling errors guide
            // https://developers.facebook.com/docs/ios/errors/
            NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
                                               objectForKey:@"body"]
                                              objectForKey:@"error"];
            
            [[[UIAlertView alloc] initWithTitle:@"Something went wrong"
                                        message:[NSString stringWithFormat:@"Please retry. \n If the problem persists contact us and mention this error code: %@",
                                                                                 [errorInformation objectForKey:@"message"]]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
             show];
        }
    }
}

+(void)requestPermissions:(NSArray*)permissions success:(void (^)(void))success
{
    if (FBSession.activeSession.isOpen)
    {
        //not set
        if (!permissions) {
            success();
            return;
        }
        
        NSArray* oldPermissions = [[FBSession activeSession] permissions];
        NSMutableArray* newPermissions = [NSMutableArray arrayWithArray:permissions];
        
        for (NSString* permission in oldPermissions) {
            if ([newPermissions indexOfObject:permission] != NSNotFound) {
                [newPermissions removeObject:permission];
            }
        }
        
        //not has new
        if ([newPermissions count] == 0) {
            success();
            return;
        }
        
        //reauthorize
        [[FBSession activeSession] requestNewPublishPermissions:(NSArray*)newPermissions
                                                defaultAudience:FBSessionDefaultAudienceFriends
                                              completionHandler:^(FBSession *session, NSError *error) {
                                                    
                                                    if (error) {
                                                        [FacebookManager handleFacebookError:error];
                                                        return;
                                                    } else if (FB_ISSESSIONOPENWITHSTATE([FBSession.activeSession state])) {
                                                        success();
                                                    }

                                                }];
    }
    else
    {
		//authorize
        [FBSession openActiveSessionWithPublishPermissions:permissions
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (error) {
                                                 [FacebookManager handleFacebookError:error];
                                                 return;
                                             } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                                 success();
                                             }
        }];

		/*
        //authorize
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              [FacebookManager handleFacebookError:error];
                                              return;
                                          } else if (FB_ISSESSIONOPENWITHSTATE(state)) {
                                              success();
                                          }
                                      }];
	   */
    }
}

+(void)shareMessage:(NSString*)message link:(NSString*)link
{
    
    [FacebookManager requestPermissions:@[@"publish_actions"] success:^{
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        if (message) {
            [params setObject:message forKey:@"message"];
        }
        
        if (link) {
            [params setObject:link forKey:@"link"];
        }
        
        [FBRequestConnection startWithGraphPath:@"me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error)
         {
             if (error) {
                 [FacebookManager handleFacebookError:error];
             } else {
                 NSLog(@"%@",result);
             }
         }];
    }];
    
    
}

+(void)likeUrl:(NSString*)urlString
{
    NSAssert(urlString, @"urlString was nil!");
    
    [FacebookManager requestPermissions:@[@"publish_actions"] success:^{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                urlString, @"object",
                                [[[FBSession activeSession] accessTokenData] accessToken],@"access_token",
                                nil
                                ];
        FBRequest *uploadRequest = [FBRequest requestWithGraphPath:@"me/og.likes" parameters:params HTTPMethod:@"POST"];
        /* make the API call */
        [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                [FacebookManager handleFacebookError:error];
            } else {
                NSLog(@"%@",result);
            }
        }];
    }];
}

+(void)requestForMeSuccess:(FacebookResponse)success
{
    [FacebookManager requestPermissions:@[@"public_profile"] success:^{
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (error) {
                [FacebookManager handleFacebookError:error];
                return;
            }
            success(result);
        }];
    }];
}

+(void)postVideo:(NSData*)videoData Title:(NSString*)title andDescription:(NSString*)description
{
    NSAssert(videoData, @"videoData was nil!");
    NSAssert(title, @"title was nil!");
    NSAssert(description, @"description was nil!");
    
    NSMutableDictionary<FBGraphObject>* params = [FBGraphObject graphObject];
    [params setDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                           videoData, @"video.mov",
                           @"video/quicktime", @"contentType",
                           title, @"title",
                           description, @"description",nil]];
    
    FBRequest *uploadRequest = [FBRequest requestWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
    [uploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            return;
        }
    }];
    
    return;
    
}
@end



