//
//  VisaBenefitsBridge.m
//  JuspayBankSDK
//
//  Created by Harsh Garg on 11/09/25.
//

#import "VisaBenefitsBridge.h"
#import <UIKit/UIKit.h>

@interface VisaBenefitsBridge ()

@property (nonatomic, strong) id<BridgeComponent> bridgeComponent;
@property (nonatomic, weak) UIViewController *presentedBookingBashVC;

@end

@implementation VisaBenefitsBridge

- (NSString *)launchBookingBash:(NSString *)encryptedPayload :(NSString *)callback {
    // Get the base view controller from bridge component
    UIViewController *baseViewController = [self.bridgeComponent getBaseViewController];
    
    if (!baseViewController) {
        return @"Error: No base view controller available";
    }
    
    // Import BookingBash module and create the view
    Class bookingBashClass = NSClassFromString(@"BookingBashSDK.BookingBashSDK");
    if (bookingBashClass) {
        // Create a dummy callback block that will be passed to BookingBashSDK
        void (^dummyCallback)(void) = ^{
            NSLog(@"BookingBash completion callback triggered");
            // Dismiss the BookingBash view controller
            if (self.presentedBookingBashVC) {
                [self.presentedBookingBashVC dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"BookingBash view dismissed");
                    self.presentedBookingBashVC = nil;
                }];
            }
        };
        
        // Call createExperienceHomeView static method with callback
        SEL selector = NSSelectorFromString(@"createExperienceHomeViewWithEncryptPayLoad:callback:");
        NSMethodSignature *signature = [bookingBashClass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:bookingBashClass];
        [invocation setSelector:selector];
        [invocation setArgument:&encryptedPayload atIndex:2];
        [invocation setArgument:&dummyCallback atIndex:3];
        
        UIViewController *bookingBashVC;
        [invocation invoke];
        [invocation getReturnValue:&bookingBashVC];
        
        if (bookingBashVC) {
            bookingBashVC.modalPresentationStyle = UIModalPresentationFullScreen;
            // Store reference to the presented view controller
            self.presentedBookingBashVC = bookingBashVC;
            [baseViewController presentViewController:bookingBashVC animated:YES completion:nil];
            return @"BookingBash launched successfully";
        } else {
            return @"Error: Failed to create BookingBash view";
        }
    } else {
        return @"Error: BookingBashSDK not found";
    }
}

@end
