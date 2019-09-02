<!DOCTYPE html>
<#-- @ftlvariable name="" type="com.tim.usong.view.StatusView" -->
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=0.15"/>
    <link rel="shortcut icon" href="/assets/favicon.ico">
    <link rel="stylesheet" href="/assets/css/status.css">
    <title>${messages.getString("status")}</title>
    <script>
        const connectToWebSocket = function () {
            const errorElement = document.getElementById("errorBox");
            const ws = new WebSocket("ws://" + location.host + "/song/ws?status=true");
            ws.onopen = function () {
                errorElement.style.display = "none";
                window.onbeforeunload = function () {
                    ws.onclose = function () {
                    };
                    ws.close();
                };
            };
            ws.onmessage = function () {
                location.reload(true);
            };
            ws.onclose = function (ev) {
                setTimeout(connectToWebSocket, 500);
                console.error("ws closed" + ev.reason);
                errorElement.style.display = "block";
            };
        }
    </script>
</head>
<body onload="connectToWebSocket()">

<main>
    <h1 id="title">${messages.getString("status")}</h1>

    <table>
        <tr>
            <th>${messages.getString("version")}</th>
            <td>
                <#if status.version??>
                    ${status.version}
                <#else>
                    ${messages.getString("unknown")}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("autostart")}</th>
            <td>
                <#if status.startWithWindows>
                    ${messages.getString("yes")}
                <#else>
                    ${messages.getString("no")}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("activeClientsCount")}</th>
            <td>
                <#if status.clientCount == 0 || (status.clientCount == 1 && status.preview)>
                    <span class="negative">#{status.clientCount}</span>
                <#else>
                    ${status.clientCount}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("hostname")}</th>
            <td>${status.hostname}</td>
        </tr>
        <tr>
            <th>${messages.getString("ipAddress")}</th>
            <td>${status.ipAddress}</td>
        </tr>
    </table>

    <table>
        <tr>
            <th>${messages.getString("songbeamerVersion")}</th>
            <td>${status.sbVersion}</td>
        </tr>
        <tr>
            <th>${messages.getString("songbeamerSender")}</th>
            <td>
                <#if !status.connected>
                    <span class="negative">${messages.getString("notConnected")}</span>
                <#else >
                    <span class="positive">${messages.getString("connected")}</span>
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("songDir")}</th>
            <td>
                <#if status.songCount == 0>
                    <span class="negative"> ${status.songDir} </span>
                <#else>
                    ${status.songDir}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("songCount")}</th>
            <td>
                <#if status.songCount == 0>
                    <span class="negative"> ${status.songCount} </span>
                <#else>
                    ${status.songCount}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("titleHasOwnPage")}</th>
            <td>
                <#if status.titelHasOwnPage>
                    ${messages.getString("yes")}
                <#else>
                    ${messages.getString("no")}
                </#if>
            </td>
        </tr>
        <tr>
            <th>${messages.getString("maxLinesPerPage")}</th>
            <#if (status.maxLinesPerPage > 0) >
                <td>${status.maxLinesPerPage}</td>
            <#else>
                <td>${messages.getString("unlimited")}</td>
            </#if>
        </tr>
    </table>

    <table>
        <#if (status.fullscreenDisplay >= 0) >
            <tr>
                <th>${messages.getString("fullscreenMode")}</th>
                <td>${messages.getString("display")} ${status.fullscreenDisplay +1}</td>
            </tr>
        </#if>
        <tr>
            <th>${messages.getString("currentSong")}</th>
            <td>${status.songTitle}</td>
        </tr>
        <#if status.currentSection?? >
            <tr>
                <th>${messages.getString("currentSection")}</th>
                <td>${status.currentSection}</td>
            </tr>
        </#if>
        <tr>
            <th>${messages.getString("currentPage")}</th>
            <td><#if status.currentPage == -1>-<#else>${status.currentPage +1}</#if></td>
        </tr>
        <#if (status.langCount > 1)>
            <tr>
                <th>${messages.getString("currentLang")}</th>
                <td>${status.lang} / ${status.langCount}</td>
            </tr>
        </#if>
        <tr>
            <th>${messages.getString("songHasChords")}</th>
            <td>
                <#if status.songHasChords>
                    ${messages.getString("yes")}
                <#else>
                    ${messages.getString("no")}
                </#if>
            </td>
        </tr>
    </table>
</main>

<div id="errorBox">
    &#9888; ${messages.getString("connectionLost")}
</div>

</body>
</html>
