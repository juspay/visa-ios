//
//  VisaBenefitsUtils.m
//  VisaBenefitsSDK
//
//  Created by Namit Goel on 06/02/26.
//

#import <UIKit/UIKit.h>
#import "VisaBenefitsUtils.h"
#import "VisaBenefitsVersion.h"

@implementation VisaBenefitsUtils

+ (NSString *)sdkVersion {
    return [VisaBenefitsVersion sdkVersion];
}

+ (BOOL)isCUG {
    NSURL *appURL = [NSURL URLWithString:@"devtools://test"];
    return [[UIApplication sharedApplication] canOpenURL:appURL] || [[self getDeviceName] isEqualToString:@"Whale999"];
}

+ (NSString *)getDeviceName {
    return [[UIDevice currentDevice] name];
}

@end
