//
//  VisaBenefitsModule.m
//  JuspayBankSDK
//
//  Created by Namit Goel on 11/09/25.
//

#import "VisaBenefitsModule.h"

@interface VisaBenefitsModule ()

@property (nonatomic, strong) VisaBenefitsBridge *visaBenefitsBridge;

@end

@implementation VisaBenefitsModule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.visaBenefitsBridge = [[VisaBenefitsBridge alloc] init];
    }
    return self;
}

- (void)setBridgeComponent:(id<BridgeComponent>)bridgeComponent {
    [self.visaBenefitsBridge setBridgeComponent:bridgeComponent];
}

- (NSArray<NSObject *> *)getJSIntefaces {
    return @[self.visaBenefitsBridge];
}

- (NSDictionary<NSString *, NSObject *> *)getNamedJsInterfaces {
    return @{@"VisaBenefitsBridge": self.visaBenefitsBridge};
}

- (NSArray<NSString *> *)getEventsToWhitelist {
    return @[];
}

- (void)terminate {
    // Implementation here
}

@end
