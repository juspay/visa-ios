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
@property (nonatomic, strong) UIViewController *bookingBashVC;

@end

@implementation VisaBenefitsBridge

- (void) dealloc {
    _bookingBashVC = nil;
    _bridgeComponent = nil;
}

- (void)launchBookingBash:(NSString *)encryptedPayload :(NSString *)callback {
    // Get the base view controller from bridge component
    UIViewController *baseViewController = [_bridgeComponent getBaseViewController];
    
    if (!baseViewController) {
        NSString *jsString =
            [NSString stringWithFormat:
                @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error: No base view controller available\"}')"
                , callback
            ];
        [_bridgeComponent executeOnWebView:jsString];
        return; // Always return after error handling
    }
    
    // Import BookingBash module and create the view
    Class bookingBashClass = NSClassFromString(@"BookingBashSDK.BookingBashSDK");
    if (bookingBashClass) {
        // Create a dummy callback block that will be passed to BookingBashSDK
        __weak typeof(self) weakSelf = self;
        void (^onFinisCallbck)(void) = ^{
            // Dismiss the BookingBash view controller
            if (weakSelf && weakSelf.bookingBashVC) {
                [weakSelf.bookingBashVC dismissViewControllerAnimated:YES completion:^{
                    NSString *jsString = [NSString stringWithFormat:@"window.callUICallback('%@', '{\"success\": true}')", callback];
                    [weakSelf.bridgeComponent executeOnWebView:jsString];
                }];
            }
        };
        
        // The selector and argument approach
        SEL selector = NSSelectorFromString(@"createExperienceHomeViewWithEncryptPayLoad:callback:");
        NSMethodSignature *signature = [bookingBashClass methodSignatureForSelector:selector];
        if (!signature) {
            NSString *jsString =
                [NSString stringWithFormat:
                    @"window.callUICallback('%@', '{\"success\": false, \"error\": \"BookingBashSDK method not found\"}')"
                    , callback
                ];
            [_bridgeComponent executeOnWebView:jsString];
            return;
        }
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];

        [invocation setTarget:bookingBashClass];
        [invocation setSelector:selector];
        [invocation setArgument:&encryptedPayload atIndex:2];
        [invocation setArgument:&onFinisCallbck atIndex:3];
        
        [invocation invoke];

        // FIX: Use a local variable of type UIViewController*
        [invocation getReturnValue:&_bookingBashVC];
        
        if (_bookingBashVC) {
            _bookingBashVC.modalPresentationStyle = UIModalPresentationFullScreen;
            // Store reference to the presented view controller
            [baseViewController presentViewController:_bookingBashVC animated:YES completion:nil];
        } else {
            NSString *jsString =
                [NSString stringWithFormat:
                    @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash View Controller\"}')"
                    , callback
                ];
            [_bridgeComponent executeOnWebView:jsString];
        }
    } else {
        NSString *jsString =
            [NSString stringWithFormat:
                @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash Class\"}')"
                , callback
            ];
        [_bridgeComponent executeOnWebView:jsString];
    }
}

@end

