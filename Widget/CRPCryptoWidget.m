#import "CRPCryptoWidget.h"

@implementation CRPCryptoWidget

- (instancetype)initWithFrame:(CGRect)arg1 {
    self = [super initWithFrame:arg1];

    if(self) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.burritoz.cryptowidgetprefs"];

        self.cryptoName = [defaults objectForKey:@"symbol"] ?: @"nano";
    }

    return self;
}

- (void)updateWidget {
}

@end