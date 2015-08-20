package org.eclipse.xtend.java2xtend.webapp

import ch.qos.cal10n.MessageParameterObj
import freemarker.template.Configuration
import java.util.Arrays
import java.util.HashMap
import java.util.List
import java.util.Locale
import java.util.Map
import javax.inject.Provider
import org.eclipse.xtend.core.XtendStandaloneSetup
import org.eclipse.xtend.java2xtend.config.I18nWrapper
import org.eclipse.xtend.java2xtend.converter.DefaultConvertConfig
import org.eclipse.xtend.java2xtend.converter.DefaultStringConverter
import org.eclipse.xtend.java2xtend.converter.StringConverter
import org.eclipse.xtend.java2xtend.i18n.Messages
import org.eclipse.xtext.xbase.lib.Functions.Function2
import spark.ModelAndView
import spark.Request
import spark.Response
import spark.Spark
import spark.template.freemarker.FreeMarkerEngine

import static spark.SparkBase.*
import org.slf4j.LoggerFactory
import org.slf4j.Logger

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

    static val DEFAULT_LOCALE = Locale.US
    static val LANGUAGE_TAG = "language"
    static val COUNTRY_TAG = "country"
    
    static val extension Logger LOGGER = LoggerFactory.getLogger(Bootstrap)

    extension StringConverter j2xConverter
    FreeMarkerEngine freeMarkerEngine
    Locale locale

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
            locale = req.userAgentLocale

            return <String, Object>newHashMap(
                JAVA_CODE_TPL_TAG -> JAVA_CODE_TAG,
                XTEND_CODE_TPL_TAG -> XTEND_CODE_TAG,
                ACTION_ROUTE_TPL_TAG -> BASE_ROUTE,
                LABELS_TPL_TAG -> convertFormLabels
            )
        ])

        post(BASE_ROUTE, "convertForm", [ extension req, res |
            locale = req.userAgentLocale

            val javaCode = JAVA_CODE_TAG.queryParams
            val xtendCode = javaCode(javaCode).xtendCode

            return <String, Object>newHashMap(
                "javaContent" -> javaCode,
                "xtendContent" -> xtendCode,
                JAVA_CODE_TPL_TAG -> JAVA_CODE_TAG,
                XTEND_CODE_TPL_TAG -> XTEND_CODE_TAG,
                ACTION_ROUTE_TPL_TAG -> BASE_ROUTE,
                LABELS_TPL_TAG -> convertFormLabels
            )
        ])

        /* Spark java doesn't really help with 404 page: this workaround only works
         * as long as no images, static files, ... are used.
         */
        get(DEFAULT_ROUTE, "404", [ req, res | 
            locale = req.userAgentLocale

            return <String, Object>newHashMap(
                LABELS_TPL_TAG -> get404Labels
            )
        ])

    }
   
    private def getLayoutLables() {
        val labels = <Messages, List<Object>>newHashMap(
//            Messages.LANGUAGE -> #[],
            Messages.LAYOUT_HEAD_TITLE -> #[],
            Messages.WELCOME_HOME_MENU -> #[],
            Messages.GO_TO_XTEND_MENU -> #[],
            Messages.FORK_ME_ON_GITHUB -> #[]
          ).labels
          
        labels.put(Messages.LANGUAGE.name, locale.language)  
        labels
    }
    
    private def get404Labels() {
        val labels = layoutLables
        labels.putAll(newHashMap(
            Messages.TITLE_404 -> #[],
            Messages.MESSAGE_404 -> #[BASE_ROUTE as Object]
          ).labels)
        labels
    }
    
    private def getConvertFormLabels() {
        val labels = layoutLables
        labels.putAll(newHashMap(
            Messages.TITLE -> #[],
            Messages.CONVERT_COMMAND -> #[],
            Messages.PASTE_JAVA_PLACE_HOLDER -> #[],
            Messages.GENERATED_CODE_PLACE_HOLDER -> #[],
            Messages.CREDITS -> #[],
            Messages.XTEND_CONTACT -> #[],
            Messages.J2X_ISSUE -> #[]
          ).labels)
        labels
    }

    private def getLabels(Map<Messages, List<Object>> tags) {
        <String, Object>newHashMap => [
            for (pair : tags.entrySet) {
                put(pair.key.name, new MessageParameterObj(pair.key, pair.value.toArray))
            }
        ]
    }

//    private def get(String path, String viewname, Map<String, Object> model) {
//        val m = insertContentTemplate(viewname, model)
//        val rh = [Request req, Response res | new ModelAndView(m, "layout.ftl")]
//        Spark.get(path, rh, freeMarkerEngine)
//    }

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
            objectWrapper = new I18nWrapper(localeProvider)
        ])
    }
    
    private def Provider<Locale> getLocaleProvider() {
        new Provider<Locale>() {
            override get() {
                return locale
            }
        }
    }

    private def initConverter() {
        val injector = new XtendStandaloneSetup().createInjectorAndDoEMFRegistration
        j2xConverter = injector.getInstance(DefaultStringConverter).configure(new DefaultConvertConfig)
    }

    private def initI18nConfig() {
        val languageParam = System.getenv(LANGUAGE_TAG) ?: System.getProperty(LANGUAGE_TAG) ?: DEFAULT_LOCALE.language
        val countryParam = System.getenv(COUNTRY_TAG) ?: System.getProperty(COUNTRY_TAG) ?: DEFAULT_LOCALE.country
        locale = new Locale.Builder().setLanguage(languageParam).setLanguage(countryParam).build
        if (! isLocaleAvailable(locale)) {
            warn('''The required local («locale.language») is not available: «DEFAULT_LOCALE.language» will be used by default.''')
            locale = DEFAULT_LOCALE
        }
    }
    
    private def getUserAgentLocale(Request req) {
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