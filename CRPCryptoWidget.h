#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// please see README for explanation
@protocol MPAWidgetProtocol
@required
- (void)updateWidget;
@optional
- (void)widgetBecameFocused;
- (void)widgetLostFocus;
@end

@interface CRPCryptoWidget : UIView <MPAWidgetProtocol>
@property (nonatomic, strong) UIImageView *cryptoImage;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *cryptoNameLabel;
@property (nonatomic, strong) NSString *cryptoName;
@end