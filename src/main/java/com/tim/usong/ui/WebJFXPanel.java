package com.tim.usong.ui;

import com.tim.usong.USongApplication;
import com.tim.usong.util.Browser;
import javafx.application.Platform;
import javafx.embed.swing.JFXPanel;
import javafx.scene.Scene;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.MenuItem;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyCodeCombination;
import javafx.scene.input.KeyCombination;
import javafx.scene.web.WebEngine;
import javafx.scene.web.WebView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.awt.*;
import java.util.ResourceBundle;

class WebJFXPanel extends JFXPanel {
    private final Logger logger = LoggerFactory.getLogger(WebJFXPanel.class);
    private final KeyCombination increaseZoom = new KeyCodeCombination(KeyCode.PLUS, KeyCombination.CONTROL_DOWN);
    private final KeyCombination increaseZoom2 = new KeyCodeCombination(KeyCode.ADD, KeyCombination.CONTROL_DOWN);
    private final KeyCombination decreaseZoom = new KeyCodeCombination(KeyCode.SUBTRACT, KeyCombination.CONTROL_DOWN);
    private final KeyCombination decreaseZoom2 = new KeyCodeCombination(KeyCode.MINUS, KeyCombination.CONTROL_DOWN);
    private WebView webView;

    WebJFXPanel(double zoom, final String url, Runnable closeAction) {
        // Prevent that some important jfx thread dies
        // If that would happen we could not create any more jfx panels
        Platform.setImplicitExit(false);

        Platform.runLater(() -> init(url, zoom, closeAction));
    }

    private void init(String url, double zoom, Runnable closeAction) {
        final ResourceBundle messages = ResourceBundle.getBundle("MessagesBundle");
        setBackground(Color.BLACK);
        webView = new WebView();
        webView.setZoom(zoom);
        WebEngine webEngine = webView.getEngine();
        webEngine.load(url);

        webEngine.setCreatePopupHandler(config -> {
            // grab the last hyperlink that has :hover pseudoclass
            Object o = webEngine.executeScript("var list = document.querySelectorAll( ':hover' );"
                    + "for (i=list.length-1; i>-1; i--) "
                    + "{ if ( list.item(i).getAttribute('href') ) "
                    + "{ list.item(i).getAttribute('href'); break; } }");
            if (o != null) {
                Browser.open(o.toString());
            }
            return null; // prevent from opening in webView
        });
        webEngine.setOnError(event -> logger.error(event.getMessage()));

        MenuItem plus = new MenuItem(messages.getString("zoomIncrease"));
        MenuItem minus = new MenuItem(messages.getString("zoomDecrease"));
        MenuItem reload = new MenuItem(messages.getString("reload"));
        MenuItem openInBrowser = new MenuItem(messages.getString("openInBrowser"));
        MenuItem close = new MenuItem(messages.getString("close"));
        plus.setOnAction(e -> webView.setZoom(webView.getZoom() + 0.02));
        minus.setOnAction(e -> webView.setZoom(webView.getZoom() - 0.02));
        reload.setOnAction(e -> webEngine.reload());
        openInBrowser.setOnAction(e -> Browser.open(url));
        close.setOnAction(e -> closeAction.run());

        ContextMenu contextMenu = new ContextMenu();
        contextMenu.getItems().addAll(plus, minus, reload, openInBrowser, close);

        webView.setContextMenuEnabled(false);
        webView.setOnContextMenuRequested(event -> {
            event.consume();
            contextMenu.show(webView, event.getScreenX(), event.getScreenY());
        });
        webView.setOnKeyPressed(event -> {
            if (increaseZoom.match(event) || increaseZoom2.match(event)) {
                webView.setZoom(webView.getZoom() + 0.02);
            } else if (decreaseZoom.match(event) || decreaseZoom2.match(event)) {
                webView.setZoom(webView.getZoom() - 0.02);
            } else if (event.getCode() == KeyCode.F5) {
                webEngine.reload();
            }
        });
        webEngine.setOnAlert(e -> USongApplication.showErrorDialogAsync(e.getData(), null));

        setScene(new Scene(webView));
    }

    void load(String url) {
        Platform.runLater(() -> webView.getEngine().load(url));
    }

    double getZoom() {
        return webView.getZoom();
    }

    void stopWebEngine() {
        Platform.runLater(() -> webView.getEngine().load(null));
    }
}
