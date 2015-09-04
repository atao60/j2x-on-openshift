package org.eclipse.xtend.java2xtend.webapp

import static extension org.eclipse.xtend.java2xtend.i18n.Messages.*

import freemarker.template.Configuration
import java.util.Arrays
import java.util.HashMap
import java.util.Locale
import java.util.Map
import org.eclipse.xtend.core.XtendStandaloneSetup
import org.eclipse.xtend.java2xtend.converter.DefaultConvertConfig
import org.eclipse.xtend.java2xtend.converter.DefaultStringConverter
import org.eclipse.xtend.java2xtend.converter.StringConverter
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.lib.Functions.Function2
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import spark.ModelAndView
import spark.Request
import spark.Response
import spark.Spark
import spark.template.freemarker.FreeMarkerEngine

import static spark.SparkBase.*

class Bootstrap {

    public static val PORT_TAG = "PORT"
    public static val IP_ADDRESS_TAG = "IP_ADDRESS"

    static val JAVA_CODE_TAG = "java-code"
    static val XTEND_CODE_TAG = "xtend-code"

    static val JAVA_CODE_TPL_TAG = "javaCode"
    static val XTEND_CODE_TPL_TAG = "xtendCode"
    static val ACTION_ROUTE_TPL_TAG = "actionRoute"
    static val CONTENT_NAME_TPL_TAG = "templateName"
    static val LABELS_TPL_TAG = "i18n"
    static val FREEMARKER_FILE_EXTENTION = ".ftl"

    static val DEFAULT_PORT = "8080"
    static val DEFAULT_IP_ADDRESS = "localhost"
    static val BASE_ROUTE = "/"
    static val DEFAULT_ROUTE = "*"

    static val LANGUAGE_TAG = "language"
    static val COUNTRY_TAG = "country"
    
    static val extension Logger LOGGER = LoggerFactory.getLogger(Bootstrap)

    extension StringConverter j2xConverter
    FreeMarkerEngine freeMarkerEngine
    Locale forcedlocale = null

    def static void main(String[] args) {
        
        new Bootstrap() => [
            initConverter
            initWebConfig
            initI18nConfig
            initTemplateEngine
            mapping
        ]
    }

    private def mapping() {
        get(BASE_ROUTE, "convertForm", [ req, res | 
            var locale = req.locale

            return <String, Object>newHashMap(
                JAVA_CODE_TPL_TAG -> JAVA_CODE_TAG,
                XTEND_CODE_TPL_TAG -> XTEND_CODE_TAG,
                ACTION_ROUTE_TPL_TAG -> BASE_ROUTE,
                LABELS_TPL_TAG -> locale.convertFormLabels
            )
        ])

        post(BASE_ROUTE, "convertForm", [ extension req, res |
            var locale = req.locale

            val javaCode = JAVA_CODE_TAG.queryParams
            val xtendCode = javaCode(javaCode).xtendCode

            return <String, Object>newHashMap(
                "javaContent" -> javaCode,
                "xtendContent" -> xtendCode,
                JAVA_CODE_TPL_TAG -> JAVA_CODE_TAG,
                XTEND_CODE_TPL_TAG -> XTEND_CODE_TAG,
                ACTION_ROUTE_TPL_TAG -> BASE_ROUTE,
                LABELS_TPL_TAG -> locale.convertFormLabels
            )
        ])

        /* Spark java doesn't really help with 404 page: this workaround only works
         * as long as no images, static files, ... are used.
         */
        get(DEFAULT_ROUTE, "404", [ req, res | 
            var locale = req.locale

            return <String, Object>newHashMap(
                LABELS_TPL_TAG -> locale.get404Labels
            )
        ])

    }
    
    private def getLocale(Request req) {
        forcedlocale?: req.userAgentLocale
    }
   
    private def get404Labels(Locale locale) {
        (new I18nMap(
            locale.TITLE_404,
            locale.MESSAGE_404(BASE_ROUTE)) => [
                putAll(locale.getLayoutLabels)
            ]).map
    }
        
    private def getConvertFormLabels(Locale locale) {
        (new I18nMap(
            locale.TITLE,
            locale.CONVERT_COMMAND,
            locale.PASTE_JAVA_PLACE_HOLDER,
            locale.GENERATED_CODE_PLACE_HOLDER,
            locale.CREDITS,
            locale.XTEND_CONTACT,
            locale.I18N_READY,
            locale.J2X_ISSUE) => [
                putAll(locale.getLayoutLabels)
            ]).map
    }

    private def getLayoutLabels(Locale locale) {
        new I18nMap(
            locale.LAYOUT_HEAD_TITLE,
            locale.WELCOME_HOME_MENU,
            locale.GO_TO_XTEND_MENU,
            locale.FORK_ME_ON_GITHUB,
            locale.LANGUAGE
        ).map
    }
    
    @Accessors
    private static class I18nMap {
        val map = <String, String>newHashMap
        
        new(Map.Entry<String, String> ...entries) {
            entries.forEach[put]
        }
        
        def put(Map.Entry<String, String> entry) {
            map.put(entry.key, entry.value)
        }
        
        def putAll(Map<String, String> entries) {
            entries.entrySet.forEach[put]
        }
        
    }

    private def get(String path, String viewname, Function2<Request, Response, Map<String, Object>> modelhandler) {
        val mh = [ Request req, Response res |
            val model = modelhandler.apply(req, res)
            insertContentTemplate(viewname, model)
        ]
        val rh = [Request req, Response res | new ModelAndView(mh.apply(req, res), "layout.ftl")]
        Spark.get(path, rh, freeMarkerEngine)
    }

    private def post(String path, String viewname, Function2<Request, Response, Map<String, Object>> modelhandler) {
        val mh = [ Request req, Response res |
            val model = modelhandler.apply(req, res)
            insertContentTemplate(viewname, model)
        ]
        val rh = [Request req, Response res | new ModelAndView(mh.apply(req, res), "layout.ftl")]
        Spark.post(path, rh, freeMarkerEngine)
    }

    private static def insertContentTemplate(String viewname, Map<String, Object> model) {
        val vn = if(viewname.endsWith(FREEMARKER_FILE_EXTENTION)) viewname else viewname + FREEMARKER_FILE_EXTENTION
        val m = if(model !== null) new HashMap(model) else <String, Object>newHashMap
        m.put(CONTENT_NAME_TPL_TAG, vn)
        m
    }

    private def initTemplateEngine() {
        freeMarkerEngine = new FreeMarkerEngine(new Configuration(Configuration.VERSION_2_3_23) => [
            tagSyntax = Configuration.SQUARE_BRACKET_TAG_SYNTAX
            setClassForTemplateLoading(FreeMarkerEngine, "")
        ])
    }
    
    private def initConverter() {
        val injector = new XtendStandaloneSetup().createInjectorAndDoEMFRegistration
        j2xConverter = injector.getInstance(DefaultStringConverter).configure(new DefaultConvertConfig)
    }

    private def initI18nConfig() {
        val languageParam = System.getenv(LANGUAGE_TAG) ?: System.getProperty(LANGUAGE_TAG)
        val regionParam = System.getenv(COUNTRY_TAG) ?: System.getProperty(COUNTRY_TAG)
        if (languageParam === null) {
            if (regionParam !== null) {
                warn("A region is required but no language is specified: user agent locale will be used.")
            }
            return
        }
        
        val locale = new Locale.Builder().setLanguage(languageParam).setRegion(regionParam).build
        if (! isLocaleAvailable(locale)) {
            warn('''The required locale («locale.language») is not available: user agent locale will be used.''')
            return
        }
        forcedlocale = locale
    }
    
    private static def getUserAgentLocale(Request req) {
        val language = Locale.LanguageRange.parse(req.headers("Accept-Language")).get(0).range
        Locale.forLanguageTag(language)
    }

    private static def initWebConfig() {
        port(Integer.parseInt(System.getenv(PORT_TAG) ?: System.getProperty(PORT_TAG) ?: DEFAULT_PORT))
        ipAddress(System.getenv(IP_ADDRESS_TAG) ?: System.getProperty(IP_ADDRESS_TAG) ?: DEFAULT_IP_ADDRESS)

    }

    private static def isLocaleAvailable(Locale locale) {
        Arrays.asList(Locale.getAvailableLocales()).contains(locale)
    }

}