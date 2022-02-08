if [ -z "$DEVPOD_NAME" ]; then
  if [ $(uname -s) = "Darwin" ]; then
    unset JAVA_HOME
    export JDK_16="$(/usr/libexec/java_home -v1.6)"
    export JDK_17="$(/usr/libexec/java_home -v1.7)"
    export JDK_18="$(/usr/libexec/java_home -v1.8)"
    export JDK_9="$(/usr/libexec/java_home -v9)"
    export JDK_11="$(/usr/libexec/java_home -v11)"
    export JAVA_HOME=$JDK_11
  else
    export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  fi
  export ANDROID_HOME=~/android-sdk
  export ANDROID_NDK=~/android-ndk
  export ANDROID_NDK_HOME=~/android-ndk

  export PATH=$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:~/.local/bin:$ANDROID_HOME/platform-tools:$PATH
fi