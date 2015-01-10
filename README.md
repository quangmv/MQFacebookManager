# MQFacebookManager

[![Build Status](https://travis-ci.org/mobile-web-messaging/MQTTKit.svg?branch=master)](https://travis-ci.org/mobile-web-messaging/MQFacebookManager)

MQFacebookManager is a modern event-driven Objective-C library.

An iOS application using MQFacebookManager is available at [MQFacebookManager](https://github.com/quangmv/MQFacebookManager).

## Installation Using CocoaPods

On your ```Podfile``` add this project:

```
...
pod 'MQFacebookManager'
...
```

For the first time, run ```pod install```, if you are updating the project invoke ```pod update```.

## Usage

Import the `FacebookManager.h` header file

```objc
#import <FacebookManager.h>
```

### Send a Message

```objc
// create the client with a unique client ID
NSString *clientID = ...
MQTTClient *client = [[MQTTClient alloc] initWithClientId:clientID];

// connect to the MQTT server
[self.client connectToHost:@"iot.eclipse.org" 
         completionHandler:^(NSUInteger code) {
    if (code == ConnectionAccepted) {
        // when the client is connected, send a MQTT message
        [self.client publishString:@"Hello, MQTT"
                           toTopic:@"/MQTTKit/example"
                           withQos:AtMostOnce
                            retain:NO
                 completionHandler:^(int mid) {
            NSLog(@"message has been delivered");
        }];
    }
}];

```

### Subscribe to a Topic and Receive Messages

```objc

// define the handler that will be called when MQTT messages are received by the client
[self.client setMessageHandler:^(MQTTMessage *message) {
    NSString *text = [message.payloadString];
    NSLog(@"received message %@", text);
}];

// connect the MQTT client
[self.client connectToHost:@"iot.eclipse.org"
         completionHandler:^(MQTTConnectionReturnCode code) {
    if (code == ConnectionAccepted) {
        // when the client is connected, subscribe to the topic to receive message.
        [self.client subscribe:@"/MQTTKit/example"
         withCompletionHandler:nil];
    }
}];
```

### Disconnect from the server

```objc
[self.client disconnectWithCompletionHandler:^(NSUInteger code) {
    // The client is disconnected when this completion handler is called
    NSLog(@"MQTT client is disconnected");
}];
```
## Authors

* [Jeff Mesnil](http://jmesnil.net/)

[mqtt]: http://public.dhe.ibm.com/software/dw/webservices/ws-mqtt/mqtt-v3r1.html
