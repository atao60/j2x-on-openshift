<h4>Don't waste your time to translate yourself your Java code, 
    let the <a id='xtend' href='https://eclipse.org/xtend'>Xtend</a> converter do it!</h4>

<div class='starter-template'>
    <form class='form-horizontal'
          role='form' 
          id='j2x-convert-form' 
          method='POST' 
          action='${actionRoute}'>
          
   <input type='submit' 
           value='Convert from Java to Xtend' 
           class='btn btn-primary' 
           form='j2x-convert-form' />
    
    <div class='row form-group'>
    <div class='col-xs-6'>
    <label class='control-label' for='javacode'>Java</label>
    <textarea class='form-control' 
              name='${javaCode}' 
              id='javacode' 
              form='j2x-convert-form'
              rows='20'
              autofocus='true'
              draggable='false'
              style='resize: none;'
              placeholder='Paste your Java code here'>${javaContent!}</textarea>
    </div>
    
    <div class='col-xs-6'>
    <label for='xtendcode'>Xtend</label>
    <textarea class='form-control' 
              name='${xtendCode}' 
              id='xtendcode' 
              form='j2x-convert-form' 
              rows='20' 
              readonly='true'
              draggable='false'
              style='resize: none;'
              placeholder='No generated Xtend code yet'>${xtendContent!}</textarea>
    </div>
    </div>

    </form>

    <div>
    <p>This service uses the Java to Xtend 
    <a id='xtendJavaConverter' href="https://github.com/eclipse/xtext/blob/2.9.0.beta3/plugins/org.eclipse.xtend.core/src/org/eclipse/xtend/core/javaconverter/JavaConverter.xtend">
    converter</a> provided by Xtend itself since its version 2.8. The version used is the 2.9.0 Beta3.
    </p>
    </div>
    <div style='margin-top: 2em;'>
    <p>For any question about Xtend or the Xtend generated code, 
       see <a id='xtendDoc' href='https://eclipse.org/xtend/community.html'>here</a>.</p>
    <p>About any issue on this online service itself, you can report it 
       <a id='reportBug' href='https://github.com/atao60/j2x-on-openshift/issues'>here</a>.</p>
    </div>
</div>