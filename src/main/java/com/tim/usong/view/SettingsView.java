package com.tim.usong.view;

import com.tim.usong.GlobalPreferences;
import com.tim.usong.core.SongParser;
import com.tim.usong.core.SongbeamerSettings;
import com.tim.usong.util.AutoStart;
import io.dropwizard.views.View;

import java.awt.*;
import java.util.Locale;
import java.util.ResourceBundle;

public class SettingsView extends View {
    private final ResourceBundle messages;
    private final SongParser songParser;
    private final SongbeamerSettings sbSettings;
    private final int screensCount;

    public SettingsView(Locale locale, SongbeamerSettings sbSettings, SongParser songParser) {
        super("settings.ftl");
        this.messages = ResourceBundle.getBundle("MessagesBundle", locale);
        this.sbSettings = sbSettings;
        this.songParser = songParser;
        screensCount = GraphicsEnvironment.getLocalGraphicsEnvironment().getScreenDevices().length;
    }

    public boolean isAutostartEnabled() {
        return AutoStart.isAutostartEnabled();
    }

    public boolean isShowSplash() {
        return GlobalPreferences.isShowSplashScreen();
    }

    public boolean isNotifyUpdates() {
        return GlobalPreferences.isNotifyUpdates();
    }

    public boolean isNotifySongbeamerUpdates() {
        return GlobalPreferences.isNotifySongbeamerUpdates();
    }

    public String getSongDir() {
        return songParser.getSongDirPath();
    }

    public boolean isTitleOwnPage() {
        return songParser.isTitleHasOwnPage();
    }

    public int getMaxLinesPage() {
        return songParser.getMaxLinesPerPage();
    }

    public ResourceBundle getMessages() {
        return messages;
    }

    public boolean showNotifyUpdatesSongbeamer() {
        return sbSettings.version != null;
    }

    public boolean isAllowSetSongDir() {
        return sbSettings.songDir == null;
    }

    public boolean isAllowSetTitleHasOwnPage() {
        return sbSettings.titleHasOwnPage == null;
    }

    public boolean isAllowSetMaxLinesPerPage() {
        return sbSettings.maxLinesPerPage == null;
    }

    public boolean isShowClockInSong() {
        return GlobalPreferences.isShowClockInSong();
    }

    public int getFullscreenDisplay() {
        return GlobalPreferences.getFullscreenDisplay();
    }

    public boolean isShowChords() {
        return GlobalPreferences.getShowChords();
    }

    public int getScreensCount() {
        return screensCount;
    }
}