package org.eclipse.xtend.java2xtend.config

import ch.qos.cal10n.MessageConveyor
import ch.qos.cal10n.MessageParameterObj
import freemarker.ext.beans.BeansWrapper
import java.util.Locale
import javax.inject.Provider

class I18nWrapper extends BeansWrapper {

    Provider<Locale> localeProvider

    new(Provider<Locale> localeProvider) {
        this.localeProvider = localeProvider
    }

    override wrap(Object object) {
        if (object instanceof MessageParameterObj) {
            return super.wrap(lookUp(object as MessageParameterObj))
        }
        super.wrap(object)
    }
    
    private def lookUp(MessageParameterObj object) {
        dictionary.getMessage(object)
    }
    
    def MessageConveyor getDictionary() {
        new MessageConveyor(localeProvider.get)
    }

}