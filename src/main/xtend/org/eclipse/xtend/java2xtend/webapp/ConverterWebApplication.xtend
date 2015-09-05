package org.eclipse.xtend.java2xtend.webapp

import static spark.SparkBase.*

import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.lib.Functions.Function2
import spark.ModelAndView
import spark.Request
import spark.Response
import spark.Spark
import spark.template.freemarker.FreeMarkerEngine
import freemarker.template.Configuration
import org.eclipse.xtend.core.XtendStandaloneSetup
import org.eclipse.xtend.java2xtend.converter.DefaultStringConverter
import org.eclipse.xtend.java2xtend.converter.StringConverter
import org.eclipse.xtend.java2xtend.converter.DefaultConvertConfig
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.util.Locale
import java.util.Arrays

/**
 * Wrap together a converter (Java2Xtend), a template engine (Freemarker) and a web server (Jetty with Spark).
 * 
 * This class is kept abstract as the mapping stays to be done.
 */
abstract class  ConverterWebApplication {
    
    protected static val extension Logger LOGGER = LoggerFactory.getLogger(Bootstrap)

    public static val PORT_TAG = "PORT"
    public static val IP_ADDRESS_TAG = "IP_ADDRESS"

    static val DEFAULT_PORT = "8080"
    static val DEFAULT_IP_ADDRESS = "localhost"
    static val CONTENT_NAME_TPL_TAG = "templateName"
    static val FREEMARKER_FILE_EXTENTION = ".ftl"

    static val LANGUAGE_TAG = "language"
    static val COUNTRY_TAG = "country"

    protected extension StringConverter j2xConverter
    FreeMarkerEngine freeMarkerEngine
    Locale forcedlocale = null
    
    @Accessors
    protected static class I18nMap {
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
    
    /**
     * This method must be overriden to set up the mapping of web links with templates.
     * 
     */
    protected def void mapping() {
        if(j2xConverter === null)
            throw new IllegalStateException("The Java to Xtend converter should have been initialized.")
        if(freeMarkerEngine === null)
            throw new IllegalStateException("The FreeMarker engine should have been initialized.")
    }
    
    protected def initI18nConfig() {
        val languageParam = System.getenv(LANGUAGE_TAG) ?: System.getProperty(LANGUAGE_TAG)
        val regionParam = System.getenv(COUNTRY_TAG) ?: System.getProperty(COUNTRY_TAG)
        if (languageParam === null) {
            if (regionParam !== null) {
                warn("A region is required but no language is specified: user agent locale will be used.")
            }
            return this
        }
        
        val locale = new Locale.Builder().setLanguage(languageParam).setRegion(regionParam).build
        if (! isLocaleAvailable(locale)) {
            warn('''The required locale («locale.language») is not available: user agent locale will be used.''')
            return this
        }
        forcedlocale = locale
        
        return this
    }
    
    private static def isLocaleAvailable(Locale locale) {
        Arrays.asList(Locale.getAvailableLocales()).contains(locale)
    }

    protected def getLocale(Request req) {
        forcedlocale?: req.userAgentLocale
    }
   
    private static def getUserAgentLocale(Request req) {
        val language = Locale.LanguageRange.parse(req.headers("Accept-Language")).get(0).range
        Locale.forLanguageTag(language)
    }

    protected def initWebConfig() {
        port(Integer.parseInt(System.getenv(PORT_TAG) ?: System.getProperty(PORT_TAG) ?: DEFAULT_PORT))
        ipAddress(System.getenv(IP_ADDRESS_TAG) ?: System.getProperty(IP_ADDRESS_TAG) ?: DEFAULT_IP_ADDRESS)
        this
    }

    protected def initConverter() {
        val injector = new XtendStandaloneSetup().createInjectorAndDoEMFRegistration
        j2xConverter = injector.getInstance(DefaultStringConverter).configure(new DefaultConvertConfig)
        this
    }

    protected def get(String path, String viewname, Function2<Request, Response, Map<String, Object>> modelhandler) {
        val mh = [ Request req, Response res |
            val model = modelhandler.apply(req, res)
            insertContentTemplate(viewname, model)
        ]
        val rh = [Request req, Response res | new ModelAndView(mh.apply(req, res), "layout.ftl")]
        Spark.get(path, rh, freeMarkerEngine)
    }

    protected def post(String path, String viewname, Function2<Request, Response, Map<String, Object>> modelhandler) {
        val mh = [ Request req, Response res |
            val model = modelhandler.apply(req, res)
            insertContentTemplate(viewname, model)
        ]
        val rh = [Request req, Response res | new ModelAndView(mh.apply(req, res), "layout.ftl")]
        Spark.post(path, rh, freeMarkerEngine)
    }

    protected static def insertContentTemplate(String viewname, Map<String, Object> model) {
        val vn = if(viewname.endsWith(FREEMARKER_FILE_EXTENTION)) viewname else viewname + FREEMARKER_FILE_EXTENTION
        val m = if(model !== null) new HashMap(model) else <String, Object>newHashMap
        m.put(CONTENT_NAME_TPL_TAG, vn)
        m
    }

    protected def ConverterWebApplication initTemplateEngine() {
        freeMarkerEngine = new FreeMarkerEngine(new Configuration(Configuration.VERSION_2_3_23) => [
            tagSyntax = Configuration.SQUARE_BRACKET_TAG_SYNTAX
            setClassForTemplateLoading(FreeMarkerEngine, "")
        ])
        this
    }
    
}