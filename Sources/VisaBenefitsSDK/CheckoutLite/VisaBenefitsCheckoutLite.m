//
//  VisaBenefitsCheckoutLite.m
//

#import "VisaBenefitsCheckoutLite.h"
#import "VisaBenefitsUtils.h"

@implementation VisaBenefitsCheckoutLite

static NSString *tenantServiceName;

+ (void)openPaymentPage:(UIViewController *)viewController payload:(NSDictionary *)sdkPayload callback:(VisaBenefitsCallback)callback {
    tenantServiceName = sdkPayload[@"service"];
    NSDictionary *updatedPayload = [VisaBenefitsUtils updateServiceNameInPayload:sdkPayload tenantServiceName:tenantServiceName isResponse:false];
    [super openPaymentPage:viewController payload:updatedPayload callback:^(NSDictionary * _Nullable dictionary) {
        NSDictionary *finalPayload = [VisaBenefitsUtils updateServiceNameInPayload:dictionary tenantServiceName:tenantServiceName isResponse:true];
        callback(finalPayload);
    }];
}

@end