# MQFacebookManager

An iOS application using MQFacebookManager is available at [Example](https://github.com/quangmv/MQFacebookManager/tree/master/Example).

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

### Request permissions blocks

```objc
// request permissions block
[FacebookManager requestPermissions:@[@"public_profile"] success:^{
// success
// do somethings
}];

```

### Request for Me blocks

```objc

// request for me informations
[FacebookManager requestForMeSuccess:^(id result) {
NSLog(@"%@",result);
}];
```

### Share link or message

```objc
[FacebookManager shareMessage:@"message" link:@"link"];
```

### Likes website url

```objc
[FacebookManager likeUrl:@"https://www.google.com/"];
```

### Post video

```objc
[FacebookManager postVideo:data Title:@"title" andDescription:@"description"];
```

## Authors

* [QuangMV](https://twitter.com/quangmv)