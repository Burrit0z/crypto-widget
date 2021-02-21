#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

// please see README for explanation
@protocol MPAWidgetProtocol
@required
- (void)updateWidget;
@optional
- (void)widgetBecameFocused;
- (void)widgetLostFocus;
@end

@interface CRPCryptoWidget : UIView <MPAWidgetProtocol>
@property (nonatomic, assign) BOOL hasImage;
@property (nonatomic, strong) UIImageView *cryptoImage;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceChangeLabel;
@property (nonatomic, strong) UILabel *cryptoNameLabel;
@property (nonatomic, strong) NSString *symbol;
- (UIImage *)getCryptoImageFromURL:(NSString *)url;
- (NSURL *)coinInfoURL;
- (NSURL *)priceInfoURL;
- (NSDictionary *)getDictionaryFromJSONURL:(NSURL *)url;
@end