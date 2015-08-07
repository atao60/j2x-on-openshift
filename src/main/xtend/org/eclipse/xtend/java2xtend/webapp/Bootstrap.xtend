package org.eclipse.xtend.java2xtend.webapp

import org.eclipse.xtend.core.XtendStandaloneSetup
import org.eclipse.xtend.java2xtend.converter.Convert
import spark.ModelAndView
import spark.template.freemarker.FreeMarkerEngine

import static spark.Spark.get
import static spark.Spark.post
import static spark.SparkBase.*
import org.eclipse.xtend.java2xtend.converter.DefaultConvertConfig

class Bootstrap {

    static val JAVA_CODE_TAG = "java-code"
    static val XTEND_CODE_TAG = "xtend-code"
    
    static val JAVA_CODE_FTL = "javaCode"
    static val XTEND_CODE_FTL = "xtendCode"
    static val ACTION_ROUTE_FTL = "actionRoute"
    static val SUB_TEMPLATE_NAME_FTL = "templateName"

    static val BASE_ROUTE = "/"
    
    def static void main(String[] args) {
        
        val injector = new XtendStandaloneSetup().createInjectorAndDoEMFRegistration
        extension val j2xConverter = injector.getInstance(Convert).configure(new DefaultConvertConfig)
        
        // cf. https://github.com/shekhargulati/todoapp-spark/blob/master/src/main/java/com/todoapp/Bootstrap.java
        // pour un ex. de récupération d'adresse ip et de port avec openshift
        
        // ipAddress(IP_ADDRESS)
        port(8082)
        
        val freeMarkerEngine = new FreeMarkerEngine

        get(BASE_ROUTE, [res, req | 
            extension val attributes = <String, Object>newHashMap
            put(JAVA_CODE_FTL, JAVA_CODE_TAG)
            put(XTEND_CODE_FTL, XTEND_CODE_TAG)
            put(ACTION_ROUTE_FTL, BASE_ROUTE)
            put(SUB_TEMPLATE_NAME_FTL, "convertForm.ftl")
            new ModelAndView(attributes, "layout.ftl")
            ], freeMarkerEngine)
        
        post(BASE_ROUTE, [extension req, extension res | 
            extension val attributes = <String, Object>newHashMap
            val javaCode = JAVA_CODE_TAG.queryParams
            val xtendCode = javaCode(javaCode).xtendCode
            put("javaContent", javaCode)
            put("xtendContent", xtendCode)
            put(JAVA_CODE_FTL, JAVA_CODE_TAG)
            put(XTEND_CODE_FTL, XTEND_CODE_TAG)
            put(ACTION_ROUTE_FTL, BASE_ROUTE)
            put(SUB_TEMPLATE_NAME_FTL, "convertForm.ftl")
            new ModelAndView(attributes, "layout.ftl")
            ], freeMarkerEngine)
        
    }
}