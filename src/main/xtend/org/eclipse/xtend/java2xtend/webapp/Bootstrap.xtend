package org.eclipse.xtend.java2xtend.webapp

import java.util.Locale

import static extension org.eclipse.xtend.java2xtend.i18n.Messages.*

class Bootstrap extends ConverterWebApplication {

    static val JAVA_CODE_TAG = "java-code"
    static val XTEND_CODE_TAG = "xtend-code"

    static val JAVA_CODE_TPL_TAG = "javaCode"
    static val XTEND_CODE_TPL_TAG = "xtendCode"
    static val ACTION_ROUTE_TPL_TAG = "actionRoute"
    static val LABELS_TPL_TAG = "i18n"

    static val BASE_ROUTE = "/"
    static val DEFAULT_ROUTE = "*"
    
    def static void main(String[] args) {
        new Bootstrap().initWebConfig.initI18nConfig.initConverter.initTemplateEngine.mapping
    }

    protected override mapping() {
        super.mapping
        
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
    
    private def get404Labels(Locale it) {
        val pairs = new I18nMap(
            TITLE_404,
            MESSAGE_404(BASE_ROUTE))
        pairs.putAll(it.getLayoutLabels)
        pairs.map
    }
        
    private def getConvertFormLabels(Locale it) {
        val pairs = new I18nMap(
            TITLE,
            CONVERT_COMMAND,
            PASTE_JAVA_PLACE_HOLDER,
            GENERATED_CODE_PLACE_HOLDER,
            CREDITS,
            XTEND_CONTACT,
            I18N_READY,
            J2X_ISSUE)
        pairs.putAll(it.getLayoutLabels)
        pairs.map
    }

    private def getLayoutLabels(Locale it) {
        new I18nMap(
            LAYOUT_HEAD_TITLE,
            WELCOME_HOME_MENU,
            GO_TO_XTEND_MENU,
            FORK_ME_ON_GITHUB,
            LANGUAGE
        ).map
    }
    
}