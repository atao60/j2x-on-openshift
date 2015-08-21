package org.eclipse.xtend.java2xtend.i18n

import ch.qos.cal10n.BaseName
import ch.qos.cal10n.Locale
import ch.qos.cal10n.LocaleData

@BaseName("i18n.converter")
@LocaleData(value = #[@Locale("fr"), @Locale("en")], defaultCharset = "ISO8859_1")
public enum Messages {
    LANGUAGE,
    
    LAYOUT_HEAD_TITLE,
    WELCOME_HOME_MENU,
    GO_TO_XTEND_MENU,
    FORK_ME_ON_GITHUB,
    
    TITLE,
    CONVERT_COMMAND,
    PASTE_JAVA_PLACE_HOLDER,
    GENERATED_CODE_PLACE_HOLDER,
    CREDITS,
    XTEND_CONTACT,
    J2X_ISSUE,
    I18N_READY,
    
    TITLE_404,
    MESSAGE_404
    
}