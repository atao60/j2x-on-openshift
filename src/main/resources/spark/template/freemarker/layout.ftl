<!DOCTYPE html>
<html lang="${i18n.LANGUAGE}">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta http-equiv="Content-Language" content="${i18n.LANGUAGE}">
        <meta name="description" content="Java2Xtend, an online converter to get a first idea of Xtend.">
        <meta name="keywords" content="Java2Xtend, online, converter, Java, Xtend">        
        <title>${i18n.LAYOUT_HEAD_TITLE}</title>
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.css">
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.css">
        <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/font-awesome.css">
        <link rel="stylesheet" href="http://getbootstrap.com/examples/starter-template/starter-template.css">
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/github-fork-ribbon-css/0.1.1/gh-fork-ribbon.min.css" />
         <style>
            .github-fork-ribbon {
                background-color: #090;
            } 
            .github-fork-ribbon a, .github-fork-ribbon a:hover {
                width: 240px;
            } 
            .github-fork-ribbon-wrapper {
                width: 180px;
                height: 180px;
            }  
            .github-fork-ribbon-wrapper.right .github-fork-ribbon {
                top: 58px;
                right: -48px;
            }    
         </style>
        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/github-fork-ribbon-css/0.1.1/gh-fork-ribbon.ie.min.css" />
        <script src="http://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.2/html5shiv.js"></script>
        <script src="http://cdnjs.cloudflare.com/ajax/libs/respond/1.4.2/respond.js"></script>
        <![endif]-->
    </head>
    <body>
        <div class="github-fork-ribbon-wrapper right">
            <div class="github-fork-ribbon">
                <a href="https://github.com/atao60/j2x-on-openshift">${i18n.FORK_ME_ON_GITHUB}</a>
            </div>
        </div>
        <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/"><span class="glyphicon glyphicon-home"></span>${i18n.WELCOME_HOME_MENU}</a>
                </div>
                <div class="collapse navbar-collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="https://eclipse.org/xtend/"><span class="glyphicon glyphicon-cog">${i18n.GO_TO_XTEND_MENU}</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="container">
            [#include "${templateName}"]
        </div>
        
        <!-- Placed at the end of the document so the pages load faster -->
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.11.3/jquery.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.js"></script>
        
        <script>
            (function(i,s,o,g,r,a,m){
                i['GoogleAnalyticsObject']=r;
                i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
                a=s.createElement(o),
                m=s.getElementsByTagName(o)[0];
                a.async=1;
                a.src=g;
                m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

            ga('create', 'UA-66548285-1', 'auto');
            ga('send', 'pageview');
        </script>
        
    </body>
</html>
