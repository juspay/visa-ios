//
//  VisaBenefits.m
//

#import "VisaBenefits.h"
#import "VisaBenefitsTenantMap.h"

@interface VisaBenefits()

@property (nonatomic, strong) NSString *clientId;

@end

@implementation VisaBenefits

- (instancetype)initWithTenantId:(NSString *)tenantId region:(NSString *)region {
    NSMutableString *updatedTenantId = tenantId;
    if (region != nil && region != @"") {
        updatedTenantId = [NSString stringWithFormat:@"%@_%@", tenantId, region];
    }
    VisaBenefitsTenantMap *tenant = [VisaBenefitsTenantMap tenantWithName:updatedTenantId];

    if (!tenant) {
        NSLog(@"Tenant '%@' not found, falling back to DEFAULT", tenantId);
        tenant = [VisaBenefitsTenantMap tenantWithName:@"DEFAULT"];
    }

    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    self.clientId = tenantId;
    tenantParams.clientId = tenantId;
    tenantParams.tenantId = tenant.tenantId;
    tenantParams.releaseConfigURL = tenant.releaseConfigTemplateUrl;

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

@end