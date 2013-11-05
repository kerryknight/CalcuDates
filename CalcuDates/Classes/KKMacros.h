//
//  KKMacros.h
//  CalcuDates
//
//  Created by Kerry Knight on 11/5/13.
//  Copyright (c) 2013 Kerry Knight. All rights reserved.
//

#ifdef DEBUG

#define NS_BUILD_32_LIKE_64 1

#define CpyStr(s) (s ? [NSString stringWithString:s] : @"")
#define CpyDict(d) [NSDictionary dictionaryWithDictionary:d] //knightka 17Jul2012
#define IsNull(s) (!s || ([s class] == [NSNull class]))
#define Image(i) [UIImage imageNamed:i]

// NSLog alternatives
// DLog will output like NSLog only when the DEBUG variable is set
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ALog will always output like NSLog
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

// ULog will show the UIAlertView only when the DEBUG variable is set
#define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#else
#define DLog(...)
#define ULog(...)

#endif
