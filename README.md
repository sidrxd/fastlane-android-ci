# sidrc/fastlane-android
This Docker image contains the all common packages necessary for building Android apps in GitLab CI (Android SDK, ruby, fastlane)

Use generated public key as gitlab deploy key

`.gitlab-ci.yml` :-

```
image: sidrc/fastlane-android

stages:
- build

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

build:
  stage: build
  script:
  - fastlane "your command here"
```