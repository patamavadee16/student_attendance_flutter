# student_attendance
Flutter project.
## Getting Started
- new folder assets and upload model , lable file
- upload file install_tflite.bat and run this file 
- edit file pubspec.yaml  (dependencies) and assets file
- creat android app on firebase project  and follow the steps
- add these in android/app/build.gradle like this <br />
```
   android { 
      compileSdkVersion 33
      defaultConfig { 
      minSdkVersion 21 
      targetSdkVersion 30 
    } 
  } <br />
    dependencies { 
      implementation 'org.tensorflow:tensorflow-lite:0.0.0-nightly-SNAPSHOT' 
      implementation 'org.tensorflow:tensorflow-lite-select-tf-ops:0.0.0-nightly-SNAPSHOT' 
    }
```
-  setup file gradle.properties like this <br />
```
    android.useAndroidX=true
    android.enableJetifier=true
    org.gradle.jvmargs=-Xmx4608m

```
- edit these in android/build.gradle like this <br />
```
   dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
```
- add these in android/app/src/AndroidManifest.xml like this <br />
```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
      package="com.example.student_attendance">
      <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" _/> 
      <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/> 
      <application <br />
       android:requestLegacyExternalStorage="true">
```
