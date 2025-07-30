//
//  VisaBenefits.m
//

#import "VisaBenefits.h"
#import "VisaBenefitsUtils.h"
#import "VisaBenefitsConstants.h"

@interface VisaBenefits()

@property (nonatomic, strong) NSString *tenantServiceName;

@end

@implementation VisaBenefits

- (instancetype)init
{
    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    tenantParams.tenantId = VISA_BENEFITS_HYPER_TENANT_ID;
    tenantParams.releaseConfigURL = VISA_BENEFITS_HYPER_RELEASE_CONFIG_URL;
    
    self = [super initWithTenantParams:tenantParams];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithClientId:(NSString *)clientId {
    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    tenantParams.clientId = clientId;
    tenantParams.tenantId = VISA_BENEFITS_HYPER_TENANT_ID;
    tenantParams.releaseConfigURL = VISA_BENEFITS_HYPER_RELEASE_CONFIG_URL;
    
    self = [super initWithTenantParams:tenantParams];
    if (self) {
        
    }
    return self;
}

- (void)initiate:(UIViewController *)viewController payload:(NSDictionary *)initiationPayload callback:(VisaBenefitsCallback)callback {
    self.tenantServiceName = initiationPayload[@"service"];
    NSDictionary *updatedPayload = [VisaBenefitsUtils updateServiceNameInPayload:initiationPayload tenantServiceName:self.tenantServiceName isResponse:false];
    __weak VisaBenefits *weakSelf = self;
    [super initiate:viewController payload:updatedPayload callback:^(NSDictionary * _Nullable dictionary) {
        NSDictionary *finalPayload = [VisaBenefitsUtils updateServiceNameInPayload:dictionary tenantServiceName:weakSelf.tenantServiceName isResponse:true];
        callback(finalPayload);
    }];
}

- (void)process:(UIViewController *)viewController processPayload:(NSDictionary *)processPayload {
    NSDictionary *updatedPayload = [VisaBenefitsUtils updateServiceNameInPayload:processPayload tenantServiceName:self.tenantServiceName isResponse:false];
    [super process:viewController processPayload:updatedPayload];
}

- (void)process:(NSDictionary *)processPayload {
    NSDictionary *updatedPayload = [VisaBenefitsUtils updateServiceNameInPayload:processPayload tenantServiceName:self.tenantServiceName isResponse:false];
    [super process:updatedPayload];
}

- (VisaBenefitsEventsCallback)merchantEvent {
    return [super merchantEvent];
}

- (void)setDelegate:(id<VisaBenefitsDelegate>)delegate {
    [super setHyperDelegate:delegate];
    _delegate = delegate;
}

@end