package org.eclipse.xtend.java2xtend.i18n

import org.eclipse.xtend.lib.macro.declaration.Visibility
import pop.xtend.contrib.annotation.I18n
import pop.xtend.contrib.annotation.I18n.Escaping
import pop.xtend.contrib.annotation.I18n.Provide
import pop.xtend.contrib.annotation.NoArgsConstructor

import static extension org.eclipse.xtend.lib.macro.declaration.Visibility.*
import static extension pop.xtend.contrib.annotation.I18n.Escaping.*
import static extension pop.xtend.contrib.annotation.I18n.Provide.*

@NoArgsConstructor(visibility=Visibility.PRIVATE)
@I18n(folder="i18n", basename="converter", language="en", 
      escaping=Escaping.basic, provide=Provide.tagAndValue,
      sources=#['src/main/resources']
)
class Messages {}