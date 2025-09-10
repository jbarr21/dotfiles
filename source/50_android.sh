if [ -z "$DEVPOD_NAME" ]; then
  if [ $(uname -s) = "Darwin" ]; then
    unset JAVA_HOME
    export JDK_16="$(/usr/libexec/java_home -v1.6)"
    export JDK_18="$(/usr/libexec/java_home -v1.8)"
    export JDK_9="$(/usr/libexec/java_home -v9)"
    export JDK_11="$(/usr/libexec/java_home -v11)"
    export JDK_17="$(/usr/libexec/java_home -v17)"
    export JDK_21="$(/usr/libexec/java_home -v21)"
    export JAVA_HOME=$JDK_17
  else
    export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
  fi
  export ANDROID_HOME=~/android-sdk
  export ANDROID_NDK=~/android-ndk
  export ANDROID_NDK_HOME=~/android-ndk

  export PATH=$JAVA_HOME/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:~/.local/bin:$ANDROID_HOME/platform-tools:$PATH
else
  export JAVA_HOME="/opt/jvm/jdk-17"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

function bkw() {
  NO_MOTD=1 ./buckw "$@";
};

# mount the android file image
function mountAndroid { hdiutil attach ~/android.dmg.sparseimage -mountpoint /Volumes/android; }

# unmount the android file image
function umountAndroid() { hdiutil detach /Volumes/android; }

function prepend() { while read line; do echo "${1}${line}"; done; }
madb(){ for SERIAL in `adb devices | sed '1d;$d' | cut -f 1`; do adb -s $SERIAL "$@" | prepend "[$SERIAL] "; done; }
madbe(){ for SERIAL in `adb devices | sed '1d;$d' | cut -f 1`; do adbe -s $SERIAL "$@" | prepend "[$SERIAL] "; done; }

function heapdump(){
  jmap -dump:live,format=b,file=$1 $2
}

function le(){
  find "$1" -type f -name 'lint-results.xml' -not -path '*/sample*' -not -path '*/*-sample/*' | xargs sed -E 's/(\<\?xml.*\?\>|\<\/?issues.*\>)//' | xml2json | jq '[.issue] | flatten | .[] | select(.severity=="Error")' | jq -s 'group_by(.id) | .[] | {"id":.[0].id, "issues":.}'
};

# AOSP

export PATH=~/bin:$PATH
function repo() {
  command python3 ~/bin/repo $@
}
