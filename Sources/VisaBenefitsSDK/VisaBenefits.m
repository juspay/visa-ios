//
//  VisaBenefits.m
//

#import "VisaBenefits.h"
#import "VisaBenefitsTenantMap.h"
#import <SwiftUI/SwiftUI.h>

@interface VisaBenefits()

@property (nonatomic, strong) NSString *clientId;

@end

@implementation VisaBenefits

- (instancetype)initWithClientId:(NSString *)clientId region:(NSString *)region {
    NSString *tenant = @"visa";
    NSMutableString *updatedTenantId = tenant;
    if (region != nil && region != @"") {
        updatedTenantId = [NSString stringWithFormat:@"%@_%@", tenant, region];
    }
    VisaBenefitsTenantMap *tenantMap = [VisaBenefitsTenantMap tenantWithName:updatedTenantId];

    if (!tenant) {
        NSLog(@"Tenant '%@' not found, falling back to DEFAULT", tenant);
        tenant = [VisaBenefitsTenantMap tenantWithName:@"DEFAULT"];
    }

    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    self.clientId = clientId;
    tenantParams.clientId = clientId;
    tenantParams.tenantId = tenantMap.tenantId;
    tenantParams.releaseConfigURL = tenantMap.releaseConfigTemplateUrl;

    self = [super initWithTenantParams:tenantParams];
    if (self) {

    }
    return self;
}

- (NSDictionary *)updatedPayload:(NSDictionary *)sdkPayload action:(NSString *)action {
    NSMutableDictionary *mutablePayload = [sdkPayload mutableCopy];

    mutablePayload[@"clientId"] = self.clientId;
    mutablePayload[@"action"] = action;
    NSString *requestId = sdkPayload[@"requestId"];
    NSMutableDictionary *updatedDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        @"payload": mutablePayload
    }];
    if (requestId) {
        updatedDictionary[@"requestId"] = requestId;
    }

    updatedDictionary[@"service"] = @"com.visa.benefits";
    return updatedDictionary;
}

- (void)show:(UIViewController *)viewController payload:(NSDictionary *)sdkPayload callback:(VisaBenefitsCallback)callback {
    NSDictionary *initSDKPayload = [self updatedPayload:sdkPayload action:@"initiate"];
    __weak VisaBenefits *weakSelf = self;

    [super initiate:viewController payload:initSDKPayload callback:callback];

    NSDictionary *processSDKPayload = [self updatedPayload:sdkPayload action:@"process"];
    [super process:viewController processPayload:processSDKPayload];
}


- (VisaBenefitsEventsCallback)merchantEvent {
    return [super merchantEvent];
}

- (void)setDelegate:(id<VisaBenefitsDelegate>)delegate {
    [super setHyperDelegate:delegate];
    _delegate = delegate;
}

// BookingBash SDK Integration Methods
- (void)showBookingBashExperiences:(UIViewController *)viewController encryptPayLoad:(NSString *)encryptPayLoad {
    // Import BookingBash module and create the view
    Class bookingBashClass = NSClassFromString(@"BookingBashSDK.BookingBashSDK");
    if (bookingBashClass) {
        // Create SwiftUI hosting controller for BookingBash experience view
        UIViewController *bookingBashVC = [[UIViewController alloc] init];
        bookingBashVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [viewController presentViewController:bookingBashVC animated:YES completion:nil];
    }
}

- (void)showBookingBashTransactions:(UIViewController *)viewController {
    // Import BookingBash module and create the transaction view
    Class bookingBashClass = NSClassFromString(@"BookingBashSDK.BookingBashSDK");
    if (bookingBashClass) {
        // Create SwiftUI hosting controller for BookingBash transaction view
        UIViewController *transactionVC = [[UIViewController alloc] init];
        transactionVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [viewController presentViewController:transactionVC animated:YES completion:nil];
    }
}

@end
