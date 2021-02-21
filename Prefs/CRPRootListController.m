#include "CRPRootListController.h"

@implementation CRPRootListController

- (NSArray *)specifiers {
    if(!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    return _specifiers;
}

- (void)byeeeKeyboard {
    [self.view endEditing:YES];
}

@end
