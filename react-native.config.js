module.exports = {
  project: {
    ios: {},
    android: {
      unstable_reactLegacyComponentNames: [
        'LottieAnimationView',
        'BVLinearGradient',
        'AIRMap',
        'AIRMapLite',
        'AIRGoogleMap',
        'RNShimmeringView',
        'CardScannerView',
        'RNCMaskedView',
      ],
    },
  },
  assets: ['./assets/fonts/'],
};
