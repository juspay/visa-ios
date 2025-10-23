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
    VisaBenefitsTenantMap *tenantMap = [VisaBenefitsTenantMap tenantWithName:@"visabenefits"];

    if (!tenant) {
        NSLog(@"Tenant '%@' not found, falling back to DEFAULT", tenant);
        tenant = [VisaBenefitsTenantMap tenantWithName:@"DEFAULT"];
    }

    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    self.clientId = clientId;
    tenantParams.clientId = clientId;
    tenantParams.tenantId = tenantMap.tenantId;
    tenantParams.releaseConfigURL = [tenantMap.releaseConfigTemplateUrl stringByReplacingOccurrencesOfString:@"$client" withString:clientId];
    tenantParams.moduleNames = @[@"VisaBenefitsModule"];
//    
//    tenantParams.baseContent =
//    @"<html><head><title>Axis-MFA</title></head><body><script type='text/javascript'>var headID = document.getElementsByTagName('head')[0];var newScript = document.createElement('script');newScript.type = 'text/javascript';newScript.id = 'boot_loader';function whenAvailable(name, callback) {var interval = 10;window.setTimeout(function() {if (window[name]) {callback();} else {whenAvailable(name, callback);}}, interval);}whenAvailable(\"JBridge\",() => {window.__OS = 'IOS';window.DUIGatekeeper = window.JBridge;window.loadBundle = function () {newScript.src = 'http://172.20.10.6:8091/payments-in.juspay.hyperpay-v1-index_bundle.js';newScript.onload = function(){window.JBridge.runInJuspayBrowser('onMicroAppLoaded', null, null);};headID.appendChild(newScript);};window.loadBundle()});window.onerror = function (event, src, lineNo, colNo, error) {/* TODO: Error handling */};</script></body></html>";

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
