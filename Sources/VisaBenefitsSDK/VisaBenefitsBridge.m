//
//  VisaBenefitsBridge.m
//  JuspayBankSDK
//
//  Created by Namit Goel on 11/09/25.
//

#import "VisaBenefitsBridge.h"
#import <UIKit/UIKit.h>
@import BookingBashSDK;

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
    [self launchBookingBashWithEnv :encryptedPayload :callback :@"production"];
}

- (void)launchBookingBashWithEnv:(NSString *)encryptedPayload :(NSString *)callback :(NSString *)environment {
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
    
    // Create a callback block that will be passed to BookingBashSDK
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
    
    // Directly call BookingBashSDK method
    _bookingBashVC = [BookingBashSDK createExperienceHomeViewWithEncryptPayLoad:encryptedPayload callback:onFinisCallbck environment:environment];
    
    if (_bookingBashVC) {
        _bookingBashVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [baseViewController presentViewController:_bookingBashVC animated:YES completion:nil];
    } else {
        NSString *jsString =
            [NSString stringWithFormat:
                @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash View Controller\"}')"
                , callback
            ];
        [_bridgeComponent executeOnWebView:jsString];
    }
}

@end

