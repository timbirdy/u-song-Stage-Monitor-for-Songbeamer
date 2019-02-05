package com.tim.usong;

import java.util.prefs.Preferences;

public class GlobalPreferences {
    private static final Preferences preferences =
            Preferences.userNodeForPackage(GlobalPreferences.class).node("preferences");

    private GlobalPreferences() {
    }

    public static void setShowSplashScreen(boolean show) {
        preferences.putBoolean("splashScreen", show);
    }

    public static boolean isShowSplashScreen() {
        return preferences.getBoolean("splashScreen", true);
    }

    public static void setNotifyUpdates(boolean notify) {
        preferences.putBoolean("notifyUpdates", notify);
    }

    public static boolean isNotifyUpdates() {
        return preferences.getBoolean("notifyUpdates", true);
    }

    public static void setSongDir(String songDir) {
        preferences.put("songDir", songDir);
    }

    public static String getSongDir() {
        return preferences.get("songDir", null);
    }

    public static void setTitleHasPage(boolean titleOwnPage) {
        preferences.putBoolean("titleHasPage", titleOwnPage);
    }

    public static boolean hasTitlePage() {
        return preferences.getBoolean("titleHasPage", false);
    }

    public static void setMaxLinesPage(int maxLines) {
        preferences.putInt("maxLinesPage", maxLines);
    }

    public static int getMaxLinesPage() {
        return preferences.getInt("maxLinesPage", 0);
    }
}