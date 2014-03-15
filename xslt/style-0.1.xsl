<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:variable name="xslversion" select="'0.1'" />

  <xsl:template match="/report">
    <html>
      <head>
        <meta charset="utf-8" />
        <title>iodog report: </title>
        <style type="text/css">
          <xsl:text>
          * {
            margin: 0;
            padding: 0;
          }

          a {
            color: #2980b9;
          }

          body {
            background: #ddd;
            font-family: sans-serif;
            font-size: small;
            color: #333;
          }

          h1 {
            font-family: Georgia, serif;
            font-style: italic;
            font-weight: normal;
            margin-bottom: 10px;
          }

          .wrapper {
            background: white;
            box-shadow: 0 0 4px rgba(0, 0, 0, 0.5);
            margin: 20px;
            padding-bottom: 0;
            position: relative;
            overflow: hidden;
          }

          .footer {
            color: gray;
            text-align: center;
          }

          table.properties {
            font-size: small;
            table-layout: fixed;
          }

          table.properties th, table.properties td {
            padding-right: 10px;
            padding-top: 10px;
          }

          table.properties th {
            text-align: left;
          }

          .logo {
            width: 100px;
            height: 150px;
            opacity: 0.3;
            float: right;
          }

          .shy {
            color: #aaa;
          }

          time:hover .shy {
            color: inherit;
          }

          .header {
            padding: 20px;
          }

          .events {
            clear: both;
            overflow: hidden;
            border-top: 1px solid #bbb;
          }

          .sidebar {
            width: 170px;
            float: left;
            margin-right: 10px;
          }

          .tabs {
            overflow: hidden;
          }

          #nav {
            border-right: 1px solid #bbb;
            padding-top: 20px;
            padding-bottom: 20px;
            padding-left: 20px;
          }

          #nav a {
            color: inherit;
            text-decoration: none;
            display: block;
            outline: 0;
            background: white;
            padding: 8px;
            background: #eee;
            border: 1px solid #eee;
          }

          #nav a:target {
            border: 1px solid #bbb;
            border-right: 1px solid white;
            margin-right: -1px;
            background: white;
            font-weight: bold;
          }

          .decor {
            font-size: 180px;
            position: absolute;
            right: -60px;
            top: -60px;
            color: #ccc;
          }

          .harmless { color: #95a5a6; }
          .interesting { color: #333; }
          .suspicious { color: #2980b9; }
          .risky { color: #d35400; }
          .bad { color: #c0392b; }
          </xsl:text>
        </style>

        <script>
          <xsl:text>
            function show_events(filterfunc) {
              events.forEach(function(ev){
                if (filterfunc(ev)) {
                  console.log(ev);
                }
              });
            }

            function tab(id, name, func) {
              var tag = document.createElement("a");
              tag.id = id;
              tag.appendChild(document.createTextNode(name));
              tag.href = "#" + id;
              tag.addEventListener('click', function(){show_events(func)});
              return tag;
            }

            function make_tabs() {
              var ul = document.getElementById("nav");
              ul.appendChild(tab("all", "All events", function(ev){ return true; }));
            }

            function interactivate() {
              make_tabs();
            }
          </xsl:text>
        </script>

        <script>
          var events = [<xsl:apply-templates select="events" />];
        </script>
      </head>
      <body onload="interactivate()">
        <div class="wrapper">
          <div class="decor">⚠</div>
          <div class="header">
            <h1><xsl:value-of select="file" /></h1>

            <table class="properties">
              <tr>
                <th>File</th>
                <td><xsl:value-of select="file" /></td>
                <th>Process</th>
                <td><xsl:value-of select="process" /></td>
              </tr>
              <tr>
                <th>Created</th>
                <td>
                  <time>
                    <xsl:attribute name="datetime"><xsl:value-of select="created" /></xsl:attribute>

                    <xsl:value-of select="substring(created, 0, 11)" />
                    <span class="shy">T</span>
                    <xsl:value-of select="substring(created, 12, 8)" />
                    <span class="shy"><xsl:value-of select="substring(created, 20, 5)" /></span>
                  </time>
                </td>

                <th>User</th>
                <td>
                  <xsl:value-of select="user" />
                  <xsl:text> </xsl:text>

                  <xsl:if test="user = 'http'">
                    <span class="shy">(Apache HTTP Server)</span>
                  </xsl:if>
                </td>
              </tr>
              <tr>
                <th>Rulesets</th>
                <td colspan="3">
                  <xsl:for-each select="rulesets/ruleset">
                    <a>
                      <xsl:attribute name="href">https://github.com/wandernauta/iodog/wiki/Ruleset-<xsl:value-of select="substring-after(., 'rules.')" /></xsl:attribute>
                      <xsl:value-of select="." />
                    </a>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <th>Events</th>
                <td colspan="3">
                  <strong><xsl:value-of select="count(events/event)" /></strong> total,
                  <strong class="harmless"><xsl:value-of select="count(events/event[level='harmless'])" /></strong> harmless,
                  <strong class="interesting"><xsl:value-of select="count(events/event[level='interesting'])" /></strong> interesting,
                  <strong class="suspicious"><xsl:value-of select="count(events/event[level='suspicious'])" /></strong> suspicious,
                  <strong class="risky"><xsl:value-of select="count(events/event[level='risky'])" /></strong> risky,
                  <strong class="bad"><xsl:value-of select="count(events/event[level='bad'])" /></strong> bad
                </td>
              </tr>
            </table>
          </div>

          <div class="events">
            <div class="sidebar">
              <div id="nav">
              </div>
            </div>
            <div class="tabs">
            </div>
          </div>
        </div>

        <div class="footer">
          This report was generated by 
          <xsl:value-of select="generator" />
          and formatted using iodog stylesheet version
          <xsl:value-of select="$xslversion" />.
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="event">
    {
      "t": "<xsl:value-of select="@t" />",
      "call": "<xsl:value-of select="@call" />",
      "level": "<xsl:value-of select="@level" />",

      "args": [
        <xsl:for-each select="args/arg">
          {
          "type": "<xsl:value-of select="@type" />",
          "val": "<xsl:value-of select="." />",
          },
        </xsl:for-each>
      ]
    },
  </xsl:template>
</xsl:stylesheet>
<!--
vim: et:ts=2:sw=2:nowrap:
-->
