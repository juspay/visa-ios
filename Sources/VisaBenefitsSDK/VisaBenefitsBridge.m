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
@property (nonatomic, strong) UIViewController *presentedBookingBashVC;

@end

@implementation VisaBenefitsBridge

- (void)launchBookingBash:(NSString *)encryptedPayload :(NSString *)callback {
    // Get the base view controller from bridge component
    UIViewController *baseViewController = [self.bridgeComponent getBaseViewController];
    
    if (!baseViewController) {
        NSString *jsString =
            [NSString stringWithFormat:
                @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error: No base view controller available\"}')"
                , callback
            ];
        [self.bridgeComponent executeOnWebView:jsString];
    }
    
    // Import BookingBash module and create the view
    Class bookingBashClass = NSClassFromString(@"BookingBashSDK.BookingBashSDK");
    if (bookingBashClass) {
        // Create a dummy callback block that will be passed to BookingBashSDK
        __weak VisaBenefitsBridge *weakSelf = self;
        void (^onFinisCallbck)(void) = ^{
            // Dismiss the BookingBash view controller
            if (weakSelf && weakSelf.presentedBookingBashVC) {
                [weakSelf.presentedBookingBashVC dismissViewControllerAnimated:YES completion:^{
                    NSString *jsString = [NSString stringWithFormat:@"window.callUICallback('%@', '{\"success\": true}')", callback];
                    [self.bridgeComponent executeOnWebView:jsString];
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
        [invocation setArgument:&onFinisCallbck atIndex:3];
        
        UIViewController *bookingBashVC;
        [invocation invoke];
        [invocation getReturnValue:&bookingBashVC];
        
        if (bookingBashVC) {
            bookingBashVC.modalPresentationStyle = UIModalPresentationFullScreen;
            // Store reference to the presented view controller
            if (self.presentedBookingBashVC) {
                self.presentedBookingBashVC = nil;
            }
            self.presentedBookingBashVC = bookingBashVC;
            [baseViewController presentViewController:bookingBashVC animated:YES completion:nil];
        } else {
            NSString *jsString =
                [NSString stringWithFormat:
                    @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash View Controller\"}')"
                    , callback
                ];
            [self.bridgeComponent executeOnWebView:jsString];
        }
    } else {
        NSString *jsString =
            [NSString stringWithFormat:
                @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash Class\"}')"
                , callback
            ];
        [self.bridgeComponent executeOnWebView:jsString];
    }
}

@end
