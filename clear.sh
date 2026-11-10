#!/system/bin/sh

PKGS="
com.google.android.gms
com.android.vending
com.google.android.gsf
com.google.android.setupwizard
com.google.android.packageinstaller
com.google.android.soundpicker
com.google.android.configupdater
com.google.android.apps.restore
com.google.android.partnersetup
com.google.android.gms.location.history
com.google.android.apps.wallpaper
com.google.android.apps.wallpaper.overlay
com.google.android.apps.emojiwallpaper
com.google.android.apps.customization.pixel
com.google.android.apps.magicportrait
com.google.android.apps.wellbeing
com.google.android.printservice.recommendation
com.google.android.overlay.gmsconfig.common
com.google.android.overlay.gmsconfig.comms
com.google.android.overlay.gmsconfig.geotz
com.google.android.overlay.gmsconfig.asi
com.google.android.overlay.gmsconfig.gsa
com.google.android.ext.shared
com.android.providers.settings.gms.overlay
com.android.providers.contacts.gms.overlay
com.android.frameworks.gms.overlay
com.android.systemui.gms.overlay
com.google.android.trichromelibrary_699813533
com.google.android.deskclock
com.google.android.inputmethod.latin
com.google.android.calculator
com.google.android.marvin.talkback
com.google.android.tts
com.google.android.gm
com.google.android.googlequicksearchbox
com.google.android.markup
com.google.android.apps.messaging
com.google.android.projection.gearhead
com.google.android.apps.googlecamera.fishfood
com.google.ar.core
com.google.android.safetycore
com.google.android.webview
com.android.hotwordenrollment.okgoogle
com.android.hotwordenrollment.xgoogle
com.google.android.contacts
com.google.android.dialer
"

for p in $PKGS; do
    if pm list packages | grep -q "^package:$p$"; then
        echo "== $p =="
        pm uninstall "$p" 2>&1
    else
        echo "-- $p (not installed) --"
    fi
done

echo "Done."
