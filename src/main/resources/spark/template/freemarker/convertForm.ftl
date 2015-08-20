<h4>${i18n.TITLE}</h4>

<div class='starter-template'>
    <form class='form-horizontal'
          role='form' 
          id='j2x-convert-form' 
          method='POST' 
          action='${actionRoute}'>
          
   <input type='submit' 
           value='${i18n.CONVERT_COMMAND}' 
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
              placeholder='${i18n.PASTE_JAVA_PLACE_HOLDER}'>${javaContent!}</textarea>
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
              placeholder='${i18n.GENERATED_CODE_PLACE_HOLDER}'>${xtendContent!}</textarea>
    </div>
    </div>

    </form>

    <div>
    <p>${i18n.CREDITS}</p>
    </div>
    <div style='margin-top: 2em;'>
    <p>${i18n.XTEND_CONTACT}</p>
    <p>${i18n.J2X_ISSUE}</p>
    </div>
</div>