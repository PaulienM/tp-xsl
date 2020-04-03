<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

    <xsl:template match="countries">
        <html>
            <head>
                <title>Les villes</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
                      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
                      crossorigin="anonymous"/>
            </head>
            <body>
                <nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
                    <span class="navbar-brand">Villes les plus peuplées</span>
                </nav>

                <div class="container" style="margin-top: 70px">
                    <h1>Historigramme des villes les plus peuplées</h1>
                    <svg width="800" height="220">
                        <xsl:for-each select="country/city">
                            <xsl:sort order="descending" data-type="number" select="population"/>
                            <xsl:if test="position() &lt;= 10">
                                <g>
                                    <rect width="{population div 20000}"
                                          height="20" y="{(position() - 1) * 22}"
                                          style="fill: #2892D7"/>
                                    <text x="{population div 20000 + 5}" y="{(position() - 1) * 22 + 8}" dy=".5em">
                                        <xsl:value-of select="name"/> (<xsl:value-of
                                            select="format-number(population, '#,###')"/>)
                                    </text>
                                </g>
                            </xsl:if>
                        </xsl:for-each>
                    </svg>
                </div>
            </body>
            <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
                    integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
                    crossorigin="anonymous"/>
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
                    integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
                    crossorigin="anonymous"/>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
                    integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
                    crossorigin="anonymous"/>
        </html>
    </xsl:template>
</xsl:stylesheet>