package org.eclipse.xtend.java2xtend.webapp

import org.eclipse.xtend.core.XtendStandaloneSetup
import spark.ModelAndView
import spark.template.freemarker.FreeMarkerEngine

import static spark.Spark.get
import static spark.Spark.post
import static spark.SparkBase.*
import org.eclipse.xtend.java2xtend.converter.DefaultConvertConfig
import java.util.Locale
import java.util.Arrays
import org.eclipse.xtend.java2xtend.converter.StringConverter
import org.eclipse.xtend.java2xtend.converter.DefaultStringConverter

class Bootstrap { 
    
    static val PORT_TAG = "PORT"
    static val IP_ADDRESS_TAG = "IP_ADDRESS"

    static val JAVA_CODE_TAG = "java-code"
    static val XTEND_CODE_TAG = "xtend-code"
    
    static val JAVA_CODE_FTL = "javaCode"
    static val XTEND_CODE_FTL = "xtendCode"
    static val ACTION_ROUTE_FTL = "actionRoute"
    static val SUB_TEMPLATE_NAME_FTL = "templateName"

    static val BASE_ROUTE = "/"
    static val DEFAULT_ROUTE = "*"
    
    static val DEFAULT_LOCALE = Locale.US
    static val LANGUAGE_TAG = "language"
    static val COUNTRY_TAG = "country"
    
    extension StringConverter j2xConverter
    FreeMarkerEngine freeMarkerEngine 
    
    def static void main(String[] args) {
        
        new Bootstrap() => [
            initConverter
            initWebConfig
            initI18nConfig
            initTemplateEngine
            mapRoutes
        ]

    }
    
    private def mapRoutes() {
        get(BASE_ROUTE, [res, req | 
            extension val attributes = <String, Object>newHashMap
            put(JAVA_CODE_FTL, JAVA_CODE_TAG)
            put(XTEND_CODE_FTL, XTEND_CODE_TAG)
            put(ACTION_ROUTE_FTL, BASE_ROUTE)
            put(SUB_TEMPLATE_NAME_FTL, "convertForm.ftl")
            new ModelAndView(attributes, "layout.ftl")
            ], freeMarkerEngine)
        
        post(BASE_ROUTE, [extension req, extension res | 
            val javaCode = JAVA_CODE_TAG.queryParams
            val xtendCode = javaCode(javaCode).xtendCode

            extension val attributes = <String, Object>newHashMap
            put("javaContent", javaCode)
            put("xtendContent", xtendCode)
            put(JAVA_CODE_FTL, JAVA_CODE_TAG)
            put(XTEND_CODE_FTL, XTEND_CODE_TAG)
            put(ACTION_ROUTE_FTL, BASE_ROUTE)
            put(SUB_TEMPLATE_NAME_FTL, "convertForm.ftl")
            new ModelAndView(attributes, "layout.ftl")
            ], freeMarkerEngine)
        
        /* Spark java doesn't really help with 404 page: this workaround only works
         * as long as no images, static files, ... are used.
         */
        get(DEFAULT_ROUTE, [res, req | 
            extension val attributes = <String, Object>newHashMap
            put(SUB_TEMPLATE_NAME_FTL, "404.ftl")
            new ModelAndView(attributes, "layout.ftl")
            ], freeMarkerEngine)
        
    }
    
    private def initTemplateEngine() {
        freeMarkerEngine = new FreeMarkerEngine
    }
    
    private def initConverter() {
        val injector = new XtendStandaloneSetup().createInjectorAndDoEMFRegistration
        j2xConverter = injector.getInstance(DefaultStringConverter).configure(new DefaultConvertConfig)
    }
    
    private static def initI18nConfig() {
        val languageParam = System.getenv(LANGUAGE_TAG)?: System.getProperty(LANGUAGE_TAG)?: DEFAULT_LOCALE.language
        val countryParam = System.getenv(COUNTRY_TAG)?: System.getProperty(COUNTRY_TAG)?: DEFAULT_LOCALE.country
        var currentLocale = new Locale.Builder().setLanguage(languageParam).setLanguage(countryParam).build
        if (isLocaleAvailable(currentLocale))
        {
            currentLocale = DEFAULT_LOCALE
        }
    }
    
    private static def initWebConfig() {
        port(Integer.parseInt(System.getenv(PORT_TAG)?: System.getProperty(PORT_TAG)?: "8080"))
        ipAddress(System.getenv(IP_ADDRESS_TAG)?: System.getProperty(IP_ADDRESS_TAG)?: "localhost")
        
    }
    
    private static def isLocaleAvailable(Locale locale) {
        Arrays.asList(Locale.getAvailableLocales()).contains(locale)
    }
    
}