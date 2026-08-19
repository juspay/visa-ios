//
//  VisaBenefitsBridge.m
//  JuspayBankSDK
//
//  Created by Namit Goel on 11/09/25.
//

#import "VisaBenefitsBridge.h"
#import <UIKit/UIKit.h>

@interface VisaBenefitsBridge ()

@property (nonatomic, strong) id<BridgeComponent> bridgeComponent;

@end

@implementation VisaBenefitsBridge

- (void) dealloc {
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
    
    // BookingBashSDK has been removed; always report failure
    NSString *jsString =
        [NSString stringWithFormat:
            @"window.callUICallback('%@', '{\"success\": false, \"error\": \"Error Occured while getting Booking Bash View Controller\"}')"
            , callback
        ];
    [_bridgeComponent executeOnWebView:jsString];
}

@end
