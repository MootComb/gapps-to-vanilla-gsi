<h1 align="center">gapps-to-vanilla gsi</h1>

A recovery script that removes all Google apps (GAPPS) from a GSI firmware and replaces them with AOSP versions. The result is a "vanilla" system without Google services, but with AOSP equivalents.

It works by comparing the GAPPS image and the VANILLA image of the same GSI build: everything that exists only in GAPPS is deleted, everything that exists only in VANILLA is restored, and differing files are replaced.

---

## Requirements

- **Recovery:** TWRP, PBRP, or OrangeFox.
- **Partitions:** `system`, `system_ext`, `product` in **ext4** or **f2fs** format (for other file systems, see this repository: https://github.com/MootComb/gapps-to-vanilla-device).
- A GSI firmware for which a **GAPPS** and **VANILLA** pair of the same version exists (used to generate the ZIP).

---

## Installation Methods

### Method 1 — Ready-made ZIP from Releases

1. Find your firmware version in [Releases](../../releases). If the version matches, download the corresponding ZIP.
2. In recovery, go to **Mount** and check the `system`, `system_ext`, and `product` partitions.
3. In recovery, go to **Settings → General** and **uncheck** **"Unmount system before installing a ZIP"**.
4. Flash the ZIP via **ADB Sideload** or directly from recovery.
5. Wipe **data**, **cache**, **dalvik-cache**, and format data (clean install). If you don't want to touch the **data** partition, you will need to run the additional [`clear.sh`](clear.sh) script in adb shell.

### Method 2 — Generate the ZIP yourself via GitHub Actions

1. Fork the repository. Go to **Actions** and click **"I understand my workflows, go ahead and enable them"**.
2. Go to **Actions → release → Run workflow**. In the window that opens:
   - in the **GitHub API URL** field, paste the URL of the repository containing the GSI firmware — it must have releases with **both GAPPS and VANILLA**;
   - in the **Number of unique versions** field, specify how many versions back to go (if you have an old version, set a higher number).
3. Click **Run workflow**, wait for it to finish, then go to **Releases** and download the ZIP.
4. Then follow Method 1, steps 2–5:
   - in recovery **Mount** → check `system`, `system_ext`, `product`;
   - **Settings → General** → uncheck **"Unmount system before installing a ZIP"**;
   - flash the ZIP via **ADB Sideload** or from recovery;
   - wipe **data**, **cache**, **dalvik-cache**, and format data (clean install). If you don't want to touch the **data** partition, you will need to run the additional [`clear.sh`](clear.sh) script in adb shell.

---

## After Installation: Replacing GMS

To make apps that depend on Google services work, install MicroG:

- [GmsCore](https://github.com/microg/GmsCore/releases) — packages `gms` and `vending`;
- [GsfProxy](https://github.com/MootComb/GsfProxy/releases) — package `gsf`.

---

## How It Works

1. The script locates the `system`, `product`, and `system_ext` partitions (supports both separate mount points and subdirectories under `/system_root/system/...`).
2. It mounts them in RW mode.
3. It reads `delete.list` from the ZIP and deletes the listed paths.
4. It unpacks `system/`, `product/`, and `system_ext/` from the ZIP and restores the files to the corresponding partitions.
5. If there is not enough space in the target partition, it moves the file to another partition (with limitations, see above).
6. It remounts `product` and `system_ext` as RO and runs `sync`.

## What It Specifically Does

1. Removes GAPPS apps and their configs:
   - `GmsCore`, `Phonesky`, `GoogleServicesFramework`, `SetupWizard`, `ConfigUpdater`, `GoogleRestore`, `GooglePartnerSetup`, `GoogleOneTimeInitializer`, `AndroidAutoStub`, `WallpaperPickerGoogleRelease`, `MagicPortraitWallpapers`, etc.
   - Google overlays (`GmsConfigOverlay*`, `GmsFrameworksOverlay`, `GmsSettingsOverlay`, etc.).
   - Google permissions (`privapp-permissions-google-*.xml`, `split-permissions-google.xml`, `default-permissions-google.xml`).
   - Google sysconfig (`google.xml`, `wellbeing.xml`, `personal_safety.xml`, etc.).
   - Google media (ringtones, notifications, alarms).
2. Restores AOSP versions:
   - `PackageInstaller`, `PrintRecommendationService`, `ExactCalculator`, `WebView`, `LatinIME`, `ThemePicker`, `Provision`, `StatementService`, `aconfig` files, etc.
3. Supports fallback: if there is not enough space in the target partition, the file is moved to another partition (only for `app/`, `priv-app/`, `overlay/`, `media/`, `fonts/`, `usr/`, `etc/`)

Installation logs:
- `/tmp/gapps-to-vanilla.log` — full log.
- `/tmp/gapps-deleted.log` — what was deleted.
- `/tmp/gapps-restored.log` — what was restored.

---

## Limitations

- Only **ext4** or **f2fs**. (For other file systems, see this repository: https://github.com/MootComb/gapps-to-vanilla-device)
- Requires a **GAPPS** and **VANILLA** pair of the same GSI version to generate the ZIP.

---

## License

GPL-3.0. See [LICENSE](LICENSE).
