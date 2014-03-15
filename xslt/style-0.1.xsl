<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!--
       This is style-0.1.xsl, the main style sheet for iodog report files. It
       contains XSLT, CSS and JavaScript code that together turn the XML report
       format into a browsable HTML interface.

       ***

       Copyright (c) 2014 Wander Nauta

       Permission is hereby granted, free of charge, to any person obtaining a copy
       of this software and associated documentation files (the "Software"), to deal
       in the Software without restriction, including without limitation the rights
       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
       copies of the Software, and to permit persons to whom the Software is
       furnished to do so, subject to the following conditions:

       The above copyright notice and this permission notice shall be included in
       all copies or substantial portions of the Software.

       the software is provided "as is", without warranty of any kind, express or
       implied, including but not limited to the warranties of merchantability,
       fitness for a particular purpose and noninfringement. in no event shall the
       authors or copyright holders be liable for any claim, damages or other
       liability, whether in an action of contract, tort or otherwise, arising from,
       out of or in connection with the software or the use or other dealings in
       the software.
  -->
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
            text-decoration: none;
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
            padding-bottom: 20px;
          }

          table {
            font-size: small;
          }

          table th, table td {
            padding: 7px;
            vertical-align: top;
          }

          table th {
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

          .id {
            color: #aaa;
            padding-left: 20px;
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
          }

          #main {
            overflow: hidden;
            border-left: 1px solid #bbb;
          }

          #nav {
            border-right: 1px solid #bbb;
            padding-top: 35px;
            padding-bottom: 20px;
            padding-left: 20px;
            margin-right: -1px;
          }

          #nav a {
            color: inherit;
            text-decoration: none;
            display: block;
            outline: 0;
            padding: 8px;
            margin-bottom: 6px;
            border: 1px solid #eee;
          }

          #nav a.active {
            border: 1px solid #bbb;
            border-right: 1px solid white;
            margin-right: -1px;
            background: white;
            font-weight: bold;
          }

          #nav div {
            height: 21px;
          }

          .harmless { color: #95a5a6; }
          .interesting { color: #333; }
          .suspicious { color: #2980b9; }
          .risky { color: #d35400; }
          .bad { color: #c0392b; }

          .frametbl {
            margin-top: 10px;
            margin-bottom: 10px;
            border: 1px solid white;
          }

          .frametbl td, .calllink {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }

          .calllink {
            display: block;
          }


          #maintable th {
            font-weight: normal;
            font-style: italic;
          }

          #maintable, .frametbl {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
          }

          #maintable tr:nth-child(odd) > td {
            background: #eee;
          }

          #maintable tr:nth-child(even) > td {
            background: white;
          }

          .details {
            display: none;
          }

          tr.expanded .details {
            display: block;
          }
          </xsl:text>
        </style>

        <script>
            var filters = {
              "all": function(ev) { return true; },
              "flagged": function(ev) { return ev.flagged; },

              "unknown": function(ev) { return level(ev.level) >= 0; },
              "harmless": function(ev) { return level(ev.level) >= 1; },
              "interesting": function(ev) { return level(ev.level) >= 2; },
              "suspicious": function(ev) { return level(ev.level) >= 3; },
              "risky": function(ev) { return level(ev.level) >= 4; },
              "bad": function(ev) { return level(ev.level) >= 5; },
            }

            var current_filter = "all";

            function level(levelstr) {
              switch (levelstr) {
                case "unknown": return 0;
                case "harmless": return 1;
                case "interesting": return 2;
                case "suspicious": return 3;
                case "risky": return 4;
                case "bad": return 5;
                default: console.log("Don't know " + levelstr);
              }
            }

            function toggle_flag(elem, id) {
              events[id].flagged = !events[id].flagged;
              elem.innerHTML = events[id].flagged ? 'Unflag' : 'Flag';

              console.log("Set " + id + " to " + events[id].flagged);

              update_table();
            }

            function toggle_exp(elem, tr) {
              if (tr.className == "expanded") {
                tr.className = "";
                elem.innerHTML = "Expand";
              } else {
                tr.className = "expanded";
                elem.innerHTML = "Collapse";
              }
            }

            function update_table() {
              show_events(filters[current_filter]);
            }

            function elem(tag, contents) {
              var element = document.createElement(tag);

              if (!contents) {
                /* Do nothing */
              } else if (contents instanceof Node) {
                element.appendChild(contents);
              } else {
                element.innerHTML = contents;
              }

              return element;
            }

            function show_events(filterfunc) {
              var tbl = document.getElementById('tablecontents');
              tbl.innerHTML = '';

              events.forEach(function(ev, i){
                if (filterfunc(ev)) {
                  var tr = elem("tr");

                  var idcell = elem("td", "" + (i+1) + ".");
                  idcell.className = "id";

                  var event_t = new Date(ev.t).getTime();
                  var start_t = new Date("<xsl:value-of select="created" />").getTime();
                  var tcell = elem("td", "" + (event_t - start_t) + "ms");
                  tcell.title = ev.t;

                  var frametbl = elem("table");
                  frametbl.className = "frametbl";

                  ev.frames.forEach(function(frm, j){
                    var ftr = elem("tr");
                    var frmid = elem("td", j+1);
                    frmid.style.width = "30px";
                    ftr.appendChild(frmid);

                    var lbl = "" + frm.where + " (in " + frm.filename + ":" + frm.lineno + ")";
                    var frtd = elem("td", lbl);
                    frtd.title = lbl;
                    ftr.appendChild(frtd);
                    frametbl.appendChild(ftr);
                  });

                  var lt = String.fromCharCode(60);

                  var call = "";
                  call += lt + "strong>";
                  call += ev.call;
                  call += lt + "/strong>";
                  call += "('";
                  call += ev.args.join("', '");
                  call += "')";

                  var title = ev.call + "('" + ev.args.join("', '") + "')";

                  var tags = elem("div", "Tags: " + ev.tags.join(", "));

                  var calllink = elem("a", call);
                  calllink.href = "javascript:void(0)";
                  calllink.addEventListener('click', function(){toggle_exp(expandlink, tr);});
                  calllink.className = "calllink " + ev.level;
                  calllink.title = title;
                  var callcell = elem("td");
                  var details = elem("div");
                  details.className = "details";
                  details.appendChild(frametbl);
                  details.appendChild(tags);
                  callcell.appendChild(calllink);
                  callcell.appendChild(details);

                  var flaglink = elem("a", ev.flagged ? "Unflag" : "Flag");
                  flaglink.href = "javascript:void(0)";
                  flaglink.addEventListener('click', function(){toggle_flag(flaglink, i);});

                  var expandlink = elem("a", "Expand");
                  expandlink.href = "javascript:void(0)";
                  expandlink.addEventListener('click', function(){toggle_exp(expandlink, tr);});

                  var actcell = elem("td");
                  actcell.appendChild(expandlink);
                  actcell.appendChild(document.createTextNode(' '));
                  actcell.appendChild(flaglink);

                  tr.appendChild(idcell);
                  tr.appendChild(tcell);
                  tr.appendChild(callcell);
                  tr.appendChild(actcell);
                  tbl.appendChild(tr);
                }
              });
            }

            function tab(id, name) {
              var tag = elem("a", name);
              tag.id = id;
              tag.href = "javascript:void(0)";
              tag.addEventListener('click', function(){
                if (cur_tab = document.getElementById(current_filter)) { cur_tab.className = ""; } 

                current_filter = id;

                if (new_tab = document.getElementById(id)) { new_tab.className = "active"; }
                update_table();
              });
              return tag;
            }

            function spacer() { return elem("div"); }

            function make_tabs() {
              var ul = document.getElementById("nav");
              ul.appendChild(tab("all", "All events"));
              ul.appendChild(tab("flagged", "Flagged events"));

              ul.appendChild(spacer());

              ul.appendChild(tab("interesting", "Interesting"));
              ul.appendChild(tab("suspicious", "Suspicious"));
              ul.appendChild(tab("risky", "Risky"));
              ul.appendChild(tab("bad", "Bad"));

              ul.appendChild(spacer());

              var tags = Object.create(null); // i.e. a set

              events.forEach(function(ev) {
                ev.tags.forEach(function(t) {
                  if (t in tags) {
                  } else {
                  filters[t] = function(ev) { return ev.tags.indexOf(t) > -1; };
                    tags[t] = true;
                    ul.appendChild(tab(t, t));
                  }
                });
              });

              document.getElementById("all").className="active";
            }

            function interactivate() {
              make_tabs();
              update_table();
            }
        </script>

        <script>
          var events = [<xsl:apply-templates select="events" />];
        </script>
      </head>
      <body onload="interactivate()">
        <div class="wrapper">
          <div class="header">
            <h1><a href=""><xsl:value-of select="substring-after(file,'file://')" /></a></h1>

            <table class="properties">
              <tr>
                <th>File</th>
                <td>
                  <a>
                    <xsl:attribute name="href"><xsl:value-of select="file" /></xsl:attribute>
                    <xsl:value-of select="substring-after(file, 'file://')" />
                  </a>
                </td>
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
            <div id="main">
              <table id="maintable">
                <thead>
                  <tr>
                    <th width="50">&#160;</th>
                    <th width="50" title="Time in milliseconds after the start time of the script.">t (ms)</th>
                    <th>Call and context</th>
                    <th width="100">Actions</th>
                  </tr>
                </thead>
                <tbody id="tablecontents">
                </tbody>
              </table>
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
      "level": "<xsl:value-of select="level" />",

      "args": [
        <xsl:for-each select="args/arg">
        "<xsl:value-of select="normalize-space(.)" />",
        </xsl:for-each>
      ],

      "frames": [
        <xsl:for-each select="frames/stack">
          {
          "type": "<xsl:value-of select="@type" />",
          "filename": "<xsl:value-of select="@filename" />",
          "lineno": "<xsl:value-of select="@lineno" />",
          "where": "<xsl:value-of select="@where" />",
          },
        </xsl:for-each>
      ],

      "tags": [
        <xsl:for-each select="tag">
        "<xsl:value-of select="." />",
        </xsl:for-each>
      ],

      "flagged": false,
    },
  </xsl:template>
</xsl:stylesheet>
<!--
vim: et:ts=2:sw=2:nowrap:
-->
