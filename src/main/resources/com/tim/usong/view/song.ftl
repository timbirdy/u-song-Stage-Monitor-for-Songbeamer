<#ftl encoding='UTF-8'>
<!DOCTYPE html>
<#-- @ftlvariable name="" type="com.tim.usong.view.SongView" -->
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=0.15, maximum-scale=0.15, user-scalable=0"/>
    <meta charset="UTF-8">
    <link rel="shortcut icon" href="/assets/favicon.ico">
    <link rel="stylesheet" href="/assets/css/song.css">
    <link rel="stylesheet" href="/assets2/css/song2.css">
    <#if admin>
        <link rel="stylesheet" href="/assets/css/admin.css">
    </#if>
    <script src="/assets/js/zenscroll.js"></script>
    <script src="/assets/js/main.js"></script>
    <title>${song.getTitle()}</title>
</head>

<body onload="backend = main(); backend.connectToWebSocket(); " class="notranslate">

<main>
    <header>
        <h1 unselectable="on" id="title" <#if song.type.name() == "ERROR"> class="negative" </#if>
            data-songId="#{song.hashCode()}"
                <#if (song.sections?size == 0)>
                    style="min-height: 2.3em;"
                </#if>
            data-type="${song.type.name()}">

            ${song.title?replace("\n", "\n<br>")}
            <#if isChords() && song.hasChords() && song.keyChord??>
                <span unselectable="on" class="chord">${messages.getString("key")} ${song.keyChord.toHtml()}</span>
            </#if>
        </h1>
    </header>

    <#assign pageCounter = 1>

    <#list song.sections as section>

        <section class="${section.type}">
            <#if section.name??>
                <div unselectable="on" class="sectionName">${section.name}</div>
            </#if>
            <#list section.pages as page>
                <div class="page">
                    <#if showPageNumbers>
                    <div class="pageNumber">
                        ${pageCounter}
                        <#assign pageCounter++>
                    </div>
                    </#if>
                    <#if (page.linesCount > 0)>
                        <div unselectable="on" class="pageContent">
                            <#noautoesc>
                                <#if song.hasChords() && isChords()>
                                    ${page.toHtmlWithCords()}
                                <#else>
                                    ${page.toHtml()}
                                </#if>
                            </#noautoesc>
                        </div>
                    </#if>
                </div>
            </#list>
        </section>
    </#list>

    <#if (song.sections?size == 0) >
        <#include "clock.ftl" >
    <#else>
        <#if isShowClockInSong()>
            <div id="clockInSong">
                <#include "clock.ftl">
            </div>
        </#if>
    </#if>
</main>

<div id="bottomSpacer"></div>

<#if admin>
    <footer unselectable="on" id="controlsWrapper">
        <button id="activeClients" class="circleButton" disabled>-</button>
        <#if (song.pageCount > 1)>
            <button type="button" class="circleButton" id="upButton" onclick="backend.pageUp()">&#9650;</button>
            <button type="button" class="circleButton" id="downButton" onclick="backend.pageDown()">&#9660;</button>
        </#if>
        <#if (song.langCount > 1)>
            <button id="lang" onclick="backend.setLang(${(song.lang % song.langCount) + 1})">
                ${messages.getString("language")} &#8644
            </button>
        </#if>
        <#if song.hasChords()>
            <button type="button" id="chord"
                    <#if isChords()> class="deactivate circleButton" onclick="backend.setChords(false);"
            <#else>class="circleButton" onclick="backend.setChords(true);"</#if>>&#9835;
            </button>
        </#if>
        <button class="circleButton" type="button" id="clock">&#128340;</button>
    </footer>
</#if>

<div unselectable="on" id="errorBox">
    &#9888; ${messages.getString("connectionLost")}
</div>

<script>
    <#if song.hasChords() && isChords()>
    fixOverlappingChords();
    </#if>
    window.onerror = function (e) {
        document.getElementById("errorBox").style.display = 'block';
        console.error(e);
    };
</script>

</body>
</html>
