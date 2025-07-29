//
//  VisaBenefitsCheckoutLite.h
//

#import <Foundation/Foundation.h>
#import <HyperSDK/HyperCheckoutLite.h>

NS_ASSUME_NONNULL_BEGIN

typedef HyperSDKCallback VisaBenefitsCallback;

@interface VisaBenefitsCheckoutLite : HyperCheckoutLite

+ (void)openPaymentPage:(UIViewController * _Nonnull)viewController payload:(NSDictionary * _Nonnull)sdkPayload callback:(VisaBenefitsCallback _Nonnull)callback;

@end

NS_ASSUME_NONNULL_END