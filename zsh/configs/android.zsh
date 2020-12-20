if [ $(uname -s) = "Darwin" ]; then
  export JAVA_HOME="$(/usr/libexec/java_home -v1.8)"
else
  export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
fi
export ANDROID_HOME=~/android-sdk
export ANDROID_NDK=~/android-ndk
export ANDROID_NDK_HOME=~/android-ndk

export PATH=$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:~/.local/bin:$ANDROID_HOME/platform-tools:$PATH
