<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">

    <xsl:template match="countries">
        <html>
            <head>
                <title>Les pays</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
                      integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
                      crossorigin="anonymous"/>
            </head>
            <body>
                <nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
                    <div class="collapse navbar-collapse" id="navbarNav">
                        <ul class="navbar-nav">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Ordre alphabetique
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <xsl:apply-templates mode="dropdown" select="country"/>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Population
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <xsl:apply-templates mode="dropdown">
                                        <xsl:sort select="@population" order="descending" data-type="number"/>
                                    </xsl:apply-templates>
                                </div>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    Superficie
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <xsl:apply-templates mode="dropdown">
                                        <xsl:sort select="@area" order="descending" data-type="number"/>
                                    </xsl:apply-templates>
                                </div>
                            </li>
                        </ul>
                    </div>
                </nav>
                <div class="container" style="margin-top: 70px">
                    <h1>Liste des pays</h1>
                    <xsl:apply-templates/>
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

    <!-- //////////////////////////////////// Template dropdown /////////////////////////// -->

    <xsl:template match="country" mode="dropdown">
        <xsl:if test="position() &lt;= 10">
            <a class="dropdown-item" href="#{@name}">
                <xsl:value-of select="@name"/>
            </a>
        </xsl:if>
    </xsl:template>

    <!-- //////////////////////////////////// Info pays ////////////////////////////// -->

    <xsl:template match="country">
        <div class="jumbotron" id="{@name}">
            <h2>
                <xsl:value-of select="@name"/>
            </h2>
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Population</th>
                        <th scope="col">Superficie</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <xsl:value-of select="format-number(@population, '#,###')"/>
                        </td>
                        <td>
                            <xsl:value-of select="format-number(@area, '#,###')"/> km²
                        </td>
                    </tr>
                </tbody>
            </table>
            <xsl:if test="city">
                <button class="btn btn-secondary mb-2" type="button" data-toggle="collapse"
                        data-target="#ville-{@name}">
                    Les villes
                </button>
                <div class="collapse" id="ville-{@name}">
                    <div class="card card-body">
                        <h3>Villes principales</h3>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th scope="col">Ville</th>
                                    <th scope="col">Population</th>
                                    <th scope="col">Part de la population</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:apply-templates select="city"/>
                            </tbody>
                        </table>
                        <xsl:call-template name="histogram"/>
                    </div>
                </div>
            </xsl:if>
            <xsl:if test="language">
                <h3>Langues parlées</h3>
                <table class="table table-borderless">
                    <tbody>
                        <xsl:apply-templates select="language">
                            <xsl:sort order="descending" data-type="number" select="@percentage"/>
                        </xsl:apply-templates>
                    </tbody>
                </table>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template match="city">
        <tr>
            <td>
                <xsl:value-of select="name"/>
            </td>
            <td>
                <xsl:value-of select="format-number(population, '#,###')"/>
            </td>
            <td>
                <xsl:value-of select="format-number(population div ../@population, '#.0%')"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="histogram">
        <xsl:variable name="height">300</xsl:variable>
        <xsl:variable name="width" select="count(city) * 30"/>
        <svg height="{$height}" width="{$width}">
            <!-- axe ordonnees -->
            <line x1="0" y1="{$height}" x2="0" y2="0" style="stroke: grey"/>
            <!-- axe abscisse -->
            <line x1="0" y1="{$height}" x2="{$width}" y2="{$height}" style="stroke: grey"/>
            <!-- graduations -->
            <line x1="0" y1="{$height div 4}" x2="10" y2="{$height div 4}" style="stroke: grey"/>
            <line x1="0" y1="{$height div 2}" x2="10" y2="{$height div 2}" style="stroke: grey"/>
            <line x1="0" y1="{$height div 4 * 3}" x2="10" y2="{$height div 4 * 3}" style="stroke: grey"/>
            <line x1="0" y1="{0}" x2="10" y2="{0}" style="stroke: grey"/>
            <text x="4" y="20">100%</text>
            <xsl:apply-templates mode="histogram-city">
                <xsl:sort select="population" order="descending" data-type="number"/>
            </xsl:apply-templates>
        </svg>
    </xsl:template>

    <xsl:template match="city" mode="histogram-city">
        <xsl:variable name="pop" select="population div ../@population"/>
        <xsl:variable name="height">300</xsl:variable>
        <rect width="20" height="{$pop * $height}" x="{(position() - 1) * 30}" y="{$height - ($pop * $height)}"
              style="fill: #2892D7; stroke: grey">
            <title><xsl:value-of select="name"/></title>
        </rect>
    </xsl:template>

    <xsl:template match="language">
        <tr>
            <td>
                <xsl:apply-templates/>
            </td>
            <td>
                <svg height="10" width="200">
                    <rect height="10" width="{@percentage * 2}"
                          style="fill: #2892D7"/>
                    <rect height="10" width="200"
                          style="fill-opacity: 0; stroke: grey"/>
                </svg>
            </td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
