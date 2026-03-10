//
//  VisaBenefits.m
//

#import "VisaBenefits.h"
#import "VisaBenefitsTenantMap.h"
#import <SwiftUI/SwiftUI.h>
#import "VisaBenefitsUtils.h"


#define VB_LOG(fmt, ...) NSLog(@"[VisaBenefits] " fmt, ##__VA_ARGS__)

@interface VisaBenefits()

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) UIViewController *storedViewController;
@property (nonatomic, copy) VisaBenefitsCallback merchantCallback;
@property (nonatomic, strong) HyperServices *hyperServices;

@end

@implementation VisaBenefits (BannerContainer)

@end

@implementation VisaBenefits

- (instancetype)initWithClientId:(NSString *)clientId region:(NSString *)region {
    self = [super init];
    if (self) {
        self.clientId = clientId;
    }
    return self;
}

- (void)initHyperServicesWithPayload:(NSDictionary *)sdkPayload {
    VisaBenefitsTenantMap *tenantMap = [VisaBenefitsTenantMap tenantWithName:@"visabenefits"];

    HyperTenantParams *tenantParams = [[HyperTenantParams alloc] init];
    tenantParams.clientId = self.clientId;
    tenantParams.tenantId = tenantMap.tenantId;
    tenantParams.releaseConfigURL = [tenantMap.releaseConfigTemplateUrl stringByReplacingOccurrencesOfString:@"$client" withString:self.clientId];
    tenantParams.moduleNames = @[@"VisaBenefitsModule"];
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    [headers setObject:([VisaBenefitsUtils isCUG] ? @"true" : @"false") forKey:@"isCug"];
    tenantParams.releaseConfigHeaders = headers;
//
//  tenantParams.baseContent =
//  @"<html><head><title>Axis-MFA</title></head><body><script type='text/javascript'>var headID = document.getElementsByTagName('head')[0];var newScript = document.createElement('script');newScript.type = 'text/javascript';newScript.id = 'boot_loader';function whenAvailable(name, callback) {var interval = 10;window.setTimeout(function() {if (window[name]) {callback();} else {whenAvailable(name, callback);}}, interval);}whenAvailable(\"JBridge\",() => {window.__OS = 'IOS';window.DUIGatekeeper = window.JBridge;window.loadBundle = function () {newScript.src = 'http://192.168.1.6:8091/payments-com.visa.rewards-v1-index_bundle.js';newScript.onload = function(){window.JBridge.runInJuspayBrowser('onMicroAppLoaded', null, null);};headID.appendChild(newScript);};window.loadBundle()});window.onerror = function (event, src, lineNo, colNo, error) {/* TODO: Error handling */};</script></body></html>";

    self.hyperServices = [[HyperServices alloc] initWithTenantParams:tenantParams];
}

- (NSDictionary *)updatedPayload:(NSDictionary *)sdkPayload action:(NSString *)action {
    VB_LOG(@"updatedPayload: Building payload for action='%@'", action);
    
    NSMutableDictionary *mutablePayload = [sdkPayload mutableCopy];

    mutablePayload[@"clientId"] = self.clientId;
    
    NSString *originalAction = sdkPayload[@"action"];
    if (originalAction && originalAction.length > 0) {
        VB_LOG(@"updatedPayload: Preserving original action from payload: %@", originalAction);
    } else {
        mutablePayload[@"action"] = action;
    }
    
    if (mutablePayload[@"fragmentViewGroups"]) {
        VB_LOG(@"updatedPayload: Keeping fragmentViewGroups in payload: %@", mutablePayload[@"fragmentViewGroups"]);
    }
    
    mutablePayload[@"wrapper_sdk_version"] = [VisaBenefitsUtils sdkVersion];
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

- (void)initiate:(UIViewController *)viewController payload:(NSDictionary *)sdkPayload callback:(VisaBenefitsCallback)callback {
    self.storedViewController = viewController;
    self.merchantCallback = callback;
    
    [self initHyperServicesWithPayload:sdkPayload];
    
    NSDictionary *initSDKPayload = [self updatedPayload:sdkPayload action:@"initiate"];
    [self.hyperServices initiate:viewController payload:initSDKPayload callback:callback];
}

- (void)process:(NSDictionary *)sdkPayload {
    if (!self.storedViewController || !self.hyperServices) {
        VB_LOG(@"ERROR: initiate must be called before process!");
        VB_LOG(@"  - storedViewController: %@", self.storedViewController ? @"EXISTS" : @"NIL");
        VB_LOG(@"  - hyperServices: %@", self.hyperServices ? @"EXISTS" : @"NIL");
        return;
    }

    NSDictionary *processSDKPayload = [self updatedPayload:sdkPayload action:@"process"];
    VB_LOG(@"Final Process Payload to HyperServices: %@", processSDKPayload);
    VB_LOG(@"Action in payload: %@", processSDKPayload[@"payload"][@"action"]);

    [self.hyperServices process:self.storedViewController processPayload:processSDKPayload];
    
}

- (void)show:(UIViewController *)viewController payload:(NSDictionary *)sdkPayload callback:(VisaBenefitsCallback)callback {
    self.storedViewController = viewController;
    self.merchantCallback = callback;

    [self initHyperServicesWithPayload:sdkPayload];

    NSDictionary *initSDKPayload = [self updatedPayload:sdkPayload action:@"initiate"];
    [self.hyperServices initiate:viewController payload:initSDKPayload callback:callback];

    NSDictionary *processSDKPayload = [self updatedPayload:sdkPayload action:@"process"];
    [self.hyperServices process:viewController processPayload:processSDKPayload];
}

- (VisaBenefitsEventsCallback)merchantEvent {
    return [self.hyperServices merchantEvent];
}

- (void)setDelegate:(id<VisaBenefitsDelegate>)delegate {
    [self.hyperServices setHyperDelegate:delegate];
    _delegate = delegate;
}

- (BOOL)isInitialised {
    return [self.hyperServices isInitialised];
}

- (void)setShouldHideNavigationBarWhenPushed:(BOOL)value {
    self.hyperServices.shouldHideNavigationBarWhenPushed = value;
}

- (BOOL)shouldHideNavigationBarWhenPushed {
    return self.hyperServices.shouldHideNavigationBarWhenPushed;
}

- (void)setShouldUseViewController:(BOOL)value {
    self.hyperServices.shouldUseViewController = value;
}

- (BOOL)shouldUseViewController {
    return self.hyperServices.shouldUseViewController;
}

- (void)terminate {
    self.merchantCallback = nil;
    [self.hyperServices terminate];
    self.hyperServices = nil;
}

@end