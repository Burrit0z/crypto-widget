#import "CRPCryptoWidget.h"

@implementation CRPCryptoWidget

- (instancetype)initWithFrame:(CGRect)arg1 {
    self = [super initWithFrame:arg1];

    if(self) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.burritoz.cryptowidgetprefs"];
        self.symbol = [defaults objectForKey:@"symbol"] ?: @"nano";

        // Our image view
        _cryptoImage = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"questionmark.circle.fill"]];
        [self addSubview:_cryptoImage];
        _cryptoImage.translatesAutoresizingMaskIntoConstraints = NO;

        [NSLayoutConstraint activateConstraints:@[
            [_cryptoImage.heightAnchor constraintEqualToAnchor:self.heightAnchor
                                                      constant:-30],
            [_cryptoImage.leftAnchor constraintEqualToAnchor:self.leftAnchor
                                                    constant:15],
            [_cryptoImage.widthAnchor constraintEqualToAnchor:_cryptoImage.heightAnchor],
            [_cryptoImage.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        ]];

        // Add a shadow effect to the layer
        [_cryptoImage.layer setShadowColor:[UIColor blackColor].CGColor];
        [_cryptoImage.layer setShadowOpacity:0.8];
        [_cryptoImage.layer setShadowRadius:3.0];
        [_cryptoImage.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

        // Price
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        _priceLabel.text = @"...";
        _priceLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
        _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [NSLayoutConstraint activateConstraints:@[
            [_priceLabel.heightAnchor constraintEqualToConstant:30],
            [_priceLabel.leftAnchor constraintEqualToAnchor:_cryptoImage.rightAnchor
                                                   constant:15],
            [_priceLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor
                                                    constant:-15],
            [_priceLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        ]];

        // Price change
        _priceChangeLabel = [[UILabel alloc] init];
        [self addSubview:_priceChangeLabel];
        _priceChangeLabel.text = @"--%";
        _priceChangeLabel.font = [UIFont systemFontOfSize:15];
        _priceChangeLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [NSLayoutConstraint activateConstraints:@[
            [_priceChangeLabel.heightAnchor constraintEqualToConstant:20],
            [_priceChangeLabel.leftAnchor constraintEqualToAnchor:_cryptoImage.rightAnchor
                                                         constant:15],
            [_priceChangeLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor
                                                          constant:-15],
            [_priceChangeLabel.topAnchor constraintEqualToAnchor:_priceLabel.bottomAnchor
                                                        constant:5],
        ]];

        // Label
        _cryptoNameLabel = [[UILabel alloc] init];
        [self addSubview:_cryptoNameLabel];
        _cryptoNameLabel.text = @"Loading...";
        _cryptoNameLabel.font = [UIFont systemFontOfSize:17.5 weight:UIFontWeightMedium];
        _cryptoNameLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [NSLayoutConstraint activateConstraints:@[
            [_cryptoNameLabel.heightAnchor constraintEqualToConstant:17.5],
            [_cryptoNameLabel.leftAnchor constraintEqualToAnchor:_cryptoImage.rightAnchor
                                                        constant:15],
            [_cryptoNameLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor
                                                         constant:-15],
            [_cryptoNameLabel.bottomAnchor constraintEqualToAnchor:_priceLabel.topAnchor
                                                          constant:-5],
        ]];
    }

    // Let's update once so the user doesn't see a blank widget when switching for the first time.
    [self updateWidget];

    return self;
}

- (void)updateWidget {
    // Network request moment
    dispatch_async(dispatch_queue_create("com.burritoz.cryptowidget.update", NULL), ^{
        NSDictionary *response = [self getDictionaryFromJSONURL:[self coinInfoURL]];
        if(!response) return;

        // Set image if we don't have it
        if(!self.hasImage) {
            NSString *URLString = response[@"image"][@"large"];
            __block UIImage *cryptoImage = [self getCryptoImageFromURL:URLString];
            if(cryptoImage) {
                // Go back to main thread for UI Updates
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cryptoImage.image = cryptoImage;
                });

                self.hasImage = YES;
            }
        }

        // Same with name from symbol, except update it everytime since we don't have to make a
        // network request, like we do to get the image.
        __block NSString *cryptoName = response[@"name"];

        // Go back to main thread for UI Updates
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cryptoNameLabel.text = cryptoName;
        });

        // Now set the price info
        NSDictionary *priceInfo = [self getDictionaryFromJSONURL:[self priceInfoURL]];
        __block NSString *price = priceInfo[self.symbol][@"usd"];
        NSNumber *num = priceInfo[self.symbol][@"usd_24h_change"];
        __block float change = num ? [num floatValue] : 0.0f;

        if(price) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.priceLabel.text = [NSString stringWithFormat:@"%@ USD", price];

                // Comes in a format like "-6.498375810606856". We only care about the first 4 characters
                self.priceChangeLabel.text = [NSString stringWithFormat:@"%0.2f%% (24h)", change];

                // Set color
                self.priceChangeLabel.textColor = change < 0 ? [UIColor redColor] : [UIColor greenColor];
            });
        }
    });
}

- (UIImage *)getCryptoImageFromURL:(NSString *)url {
    NSURL *endpoint = [NSURL URLWithString:url];
    return [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:endpoint]];
}

- (NSDictionary *)getDictionaryFromJSONURL:(NSURL *)url {
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if(!urlData) return nil;

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:nil];
    return dict;
}

- (NSURL *)coinInfoURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.coingecko.com/api/v3/coins/%@?tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false", self.symbol]];
}

- (NSURL *)priceInfoURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.coingecko.com/api/v3/simple/price?ids=%@&vs_currencies=usd&include_market_cap=false&include_24hr_vol=true&include_24hr_change=true", self.symbol]];
}

@end