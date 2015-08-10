package org.eclipse.xtend.java2xtend.webapp.i18n

import java.io.IOException
import java.util.Locale

import javax.inject.Provider

import freemarker.template.Configuration
import freemarker.template.Template

/*
 * https://github.com/oehme/freemarker-I18n/blob/master/src/main/java/de/oehme/examples/freemarkerI18n/easyway/configuration/Config.java
 * 
 */
class Config {

    static Configuration config
    Provider<Locale> localeProvider

    new(Provider<Locale> localeProvider) {
        config = new Configuration();
        config.setTagSyntax(Configuration.SQUARE_BRACKET_TAG_SYNTAX);
//        config.setClassForTemplateLoading(getClass(), "../");
//        config.setObjectWrapper(new LocalizingWrapper(localeProvider));
        this.localeProvider = localeProvider;
    }

    def getTemplate(String name) throws IOException {
        config.getTemplate(name, localeProvider.get)
    }

}
