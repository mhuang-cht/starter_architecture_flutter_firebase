#! /bin/bash

app_name="$1"
firebase_project_name="$2"

old_name="starter_architecture_flutter_firebase"

old_package_name="com.example.$old_name"
new_package_name="com.chtsolutions.$app_name"

app_name_camel=$(sed -r 's/(_)(\w)/\U\2/g' <<<"$app_name")
old_name_camel=$(sed -r 's/(_)(\w)/\U\2/g' <<<"$old_name")
old_package_name_camel="com.example.$old_name_camel"
new_package_name_camel="com.chtsolutions.$app_name_camel"

if [ -z "$app_name" ]; then
    echo Usage: $(basename $0) app_name [firebase_project_name]
    exit 1
fi

if [ -z "$firebase_project_name" ]; then
    firebase_project_name="cht-debug"
fi

invalid_name=$(echo $app_name | grep [^a-z0-9_])
if [ -n "$invalid_name" ]; then
    echo "Invalid app name \"$app_name\""
    echo "The name must start with lower case letter, and only contain lower case letter, numbers and underscore (_)"
    exit 1
fi

grep -rl $old_package_name . | grep -v "^./.git/" | grep -v "change-app-name.sh" | xargs -i@ sed -i "s/$old_package_name/$new_package_name/g" @
grep -rl $old_package_name_camel . | grep -v "^./.git/" | grep -v "change-app-name.sh" | xargs -i@ sed -i "s/$old_package_name_camel/$new_package_name_camel/g" @
grep -rl $old_name . | grep -v "^./.git/" | grep -v "change-app-name.sh" | xargs -i@ sed -i "s/$old_name/$app_name/g" @
grep -rl $old_name_camel . | grep -v "^./.git/" | grep -v "change-app-name.sh" | xargs -i@ sed -i "s/$old_name_camel/$app_name_camel/g" @

# remove all platforms
rm -fr android ios macos web

# re-create android and ios platforms
flutter create --platforms android,ios .

# re-link to firebase
sed -i "s/starter-architecture-flutter/$firebase_project_name/g" .firebaserc
sed -i '/Firebase configuration files/,$d' .gitignore

set -x
firebase login && flutterfire configure --yes 
