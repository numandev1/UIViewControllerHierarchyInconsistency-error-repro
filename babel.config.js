module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: [
      [
        'module-resolver',
        {
          root: ['./src'],
          alias: {
            '@containers': './src/Containers',
            '@components': './src/Components',
            '@redux': './src/Stores/redux',
            '@hooks': './src/Hooks',
            '@services': './src/Services',
            '@entities': './src/Entities',
            '@assets': './src/Assets',
            '@helpers': './src/Helpers',
            '@elements': './src/Elements',
            '@theme': './src/Theme',
          },
          cwd: 'packagejson',
        },
      ],
      'react-native-reanimated/plugin',
    ],
  };
};
