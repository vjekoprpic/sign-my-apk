# sign-my-apk (Dockerized)

Rebuild, zipalign, and sign an Android APK entirely inside a Docker container using **apktool**, **zipalign**, and **apksigner**—no local Android SDK setup needed.
## Layout
```
.  
├── APP_ZA_TEST/ # decoded apktool folder (output of `apktool d -r -f APP_ZA_TEST.apk`)  
├── Dockerfile  
├── build.sh  
└── README.md

````

---

## Quick Start

```bash

git clone https://github.com/vjekoprpic/sign-my-apk.git

cd sign-my-apk

docker build -t sign-my-apk .

docker run --rm -v "$PWD":/work sign-my-apk
````

Outputs (by default):

- `apk_built.apk`
    
- `apk_aligned.apk`
    
- `apk_signed.apk`
    
- `my.keystore` (created if it doesn’t exist)

---

## 🔧 Configuration (Env Vars)

You can override defaults by passing `-e VAR=value` to `docker run`.

| Var             | Default           | Purpose                            |
| --------------- | ----------------- | ---------------------------------- |
| `DECODED_DIR`   | `APP_ZA_TEST`     | Folder produced by `apktool d`     |
| `BUILT_APK`     | `apk_built.apk`   | Unsigned, unaligned build output   |
| `ALIGNED_APK`   | `apk_aligned.apk` | Zipaligned APK                     |
| `SIGNED_APK`    | `apk_signed.apk`  | Final signed APK                   |
| `KEYSTORE`      | `my.keystore`     | Keystore path                      |
| `ALIAS`         | `app`             | Keystore alias                     |
| `KS_PASS`       | `password`        | Keystore password                  |
| `KEY_PASS`      | `KS_PASS`         | Key password (defaults to KS_PASS) |
| `VALIDITY_DAYS` | `10000`           | Keystore validity                  |

**Example:**

```bash
docker run --rm -v "$PWD":/work \
  -e DECODED_DIR=APP_ZA_TEST \
  -e KS_PASS=supersecret \
  sign-my-apk
```

---

## Verifying the Signature

```bash
apksigner verify --print-certs apk_signed.apk
```

