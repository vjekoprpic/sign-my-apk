#!/usr/bin/env bash
set -euo pipefail

# Configurable names
DECODED_DIR=${DECODED_DIR:-APP_ZA_TEST}
BUILT_APK=${BUILT_APK:-apk_built.apk}
ALIGNED_APK=${ALIGNED_APK:-apk_aligned.apk}
SIGNED_APK=${SIGNED_APK:-apk_signed.apk}
KEYSTORE=${KEYSTORE:-my.keystore}
ALIAS=${ALIAS:-app}
KS_PASS=${KS_PASS:-password}
KEY_PASS=${KEY_PASS:-$KS_PASS}
VALIDITY_DAYS=${VALIDITY_DAYS:-10000}

echo "==> Building APK with apktool"
apktool b -r -f "$DECODED_DIR" -o "$BUILT_APK"

if [ ! -f "$KEYSTORE" ]; then
  echo "==> Generating keystore ($KEYSTORE)"
  keytool -genkey -v \
    -keystore "$KEYSTORE" \
    -storepass "$KS_PASS" \
    -keypass "$KEY_PASS" \
    -keyalg RSA -keysize 2048 -validity "$VALIDITY_DAYS" \
    -alias "$ALIAS" \
    -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, S=Unknown, C=US"
fi

echo "==> Zipaligning"
zipalign -p 4 "$BUILT_APK" "$ALIGNED_APK"

echo "==> Signing"
apksigner sign \
  --ks "$KEYSTORE" \
  --ks-pass pass:"$KS_PASS" \
  --key-pass pass:"$KEY_PASS" \
  --out "$SIGNED_APK" \
  "$ALIGNED_APK"

echo "==> Done! Output: $SIGNED_APK"

