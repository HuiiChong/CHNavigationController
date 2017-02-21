This provides an fullScreen pop and push gesture for UINavigationController. 

## Features

- [x] FullScreen pop gesture support
- [x] FullScreen push gesture support
- [x] Customize UINavigationBar for each single viewController support
- [x] Customize pop and push gesture distance on the left side of the screen support
- [x] Close pop gesture for single viewController support
- [x] show alert when pop viewController support


## How To Use

#### Initialize

```objective-c
Objective-C:

#import "CHNavigationController.h"

CHNavigationController *nav = [[CHNavigationController alloc] initWithRootViewController:YourVc];
```

#### PushViewController

```objective-c
Objective-C:

[self.navigationController pushViewController:YourVc animated:YES];
```


#### Add push gesture connect viewController

```objective-c
Objective-C:

// Become the delegate of CHNavigationControllerDelegate protocol and, implemented protocol method, then you own left-slip to push function.
self.ch_navigationController.nav_delegate = self;

// Implementation protocol method
-(void)didLeftPush{
    [self.navigationController pushViewController:YourVc animated:YES];
}
```

#### show alert when you pop viewController

```objective-c
Objective-C:

self.ch_gestureEnabled = NO;

- (BOOL)didPopClick{
    //alert code
    return NO;
}
```


#### Close pop gesture for single viewController

```objective-c
Objective-C:

self.ch_gestureEnabled = NO;
```

