//
//  Defines.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/21/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#define kVibrationOn @"Vibrate"
#define kSoundOn @"Sound"
#define kPushNotificationsOn @"Push"

#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif