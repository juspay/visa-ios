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

- (VisaBenefitsEventsCallback)merchantEvent {
    __weak VisaBenefits *weakSelf = self;
    return ^(NSDictionary * _Nullable dictionary) {
        NSDictionary *finalPayload = [VisaBenefitsUtils updateServiceNameInPayload:dictionary tenantServiceName:weakSelf.tenantServiceName isResponse:true];
        if ([weakSelf.delegate respondsToSelector:@selector(onEvent:)]) {
            [weakSelf.delegate onEvent:finalPayload];
        }
    };
}

@end