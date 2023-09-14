#! /bin/bash

app_name="$1"
old_name="starter_architecture_flutter_firebase"
old_package_name="com.example.$old_name"
new_package_name="com.chtsolutions.$app_name"

if [ -z "$app_name" ]; then
    echo Usage: $(basename $0) app_name
    exit 1
fi

invalid_name=$(echo $app_name | grep [^a-z_])
if [ -n "$invalid_name" ]; then
    echo "Invalid app name \"$app_name\""
    echo "The name must start with lower case letter, and only contain lower case letter and underscore (_)"
    exit 1
fi

grep -rl $old_package_name . | grep -v "^./.git/" | xargs -i@ sed -i "s/$old_package_name/$new_package_name/g" @
grep -rl $old_name . | grep -v "^./.git/" | xargs -i@ sed -i "s/$old_name/$app_name/g" @
sed -i 's/starter-architecture-flutter/cht-debug/g' .firebaserc
set -x
firebase login && flutterfire configure
