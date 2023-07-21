import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import React, {useEffect} from 'react';
import {View, Text} from 'react-native';
import codePush from 'react-native-code-push';
import SplashScreenLottie from 'react-native-lottie-splash-screen';

const TestComponent = () => {
  return (
    <View>
      <Text>TestComponent</Text>
    </View>
  );
};

const RootStack = createNativeStackNavigator();

const App = () => {
  useEffect(() => {
    setTimeout(() => {
      SplashScreenLottie.hide();
    }, 3000);
  }, []);
  return (
    <NavigationContainer>
      <RootStack.Navigator
        screenOptions={{
          headerHideBackButton: true,
        }}>
        <RootStack.Screen
          name="Chapter"
          options={{
            title: 'Fabric Example',
            headerShown: false,
          }}
          initialParams={{
            index: 0,
            chapterRoute: 'Chapter',
            afterChapterRoute: 'HeaderDemo',
          }}
          component={TestComponent}
        />
        <RootStack.Screen
          name="HeaderDemo"
          component={TestComponent}
          options={{title: 'Header Demo'}}
        />
      </RootStack.Navigator>
    </NavigationContainer>
  );
};

export default App;

const codePushOptions = {
  checkFrequency: codePush.CheckFrequency.ON_APP_RESUME,
  installMode: codePush.InstallMode.ON_NEXT_RESUME,
  mandatoryInstallMode: codePush.InstallMode.IMMEDIATE,
  minimumBackgroundDuration: 3 * 60 * 60,
};

const AutoUpdateApp = codePush(codePushOptions)(App);

export default AutoUpdateApp;
