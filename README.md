A Java to Xtend converter online 
==========

Rational
-------

The aim of this project is to make available online a Java to Xtend converter. 

It uses:

- [OpenShift Online](https://www.openshift.com/products/online): this PAAS platform 
provides a free plan which is enough to set up an online service,
- the Java-to-Xtend converter provided by [Xtend](https://eclipse.org/xtend/) since its version 2.8. 
In fact it uses the project [java2xtend](https://github.com/atao60/java2xtend.git) to hide all the details.

Licenses & credits
------

Licensed under [Eclipse Public License](http://www.eclipse.org/legal/epl-v10.html).

A first attempt to provide an online converter was made by 
[Krzysztof Rzymkowski project](https://github.com/rzymek/java2xtend.webapp). 
This [service](http://www.j2x.cloudbees.net/) is not currently available.

Requirements
-----

This project uses the version 2.9.0.beta3 of *Xtend*.

It requires:

- JDK 1.8
- [Maven](https://maven.apache.org/) 3.3.1 or above

If working under *Eclipse*:

- [Xtend SDK](https://eclipse.org/xtend/download.html) 
- [M2Eclipse](http://eclipse.org/m2e/).

Furthermore it depends on the pop-xtend-contrib-annotations library available  
from [atao60 snapshots repository](https://github.com/atao60/snapshots) on *Github*.

Build, deploy & run
------

This project is store in two git repositories:

- the *OpenShift* one: it's mandatory as it's the mean used by *OpenShift* to 
deploy any application on its platform. But it's a private repository.
- this source code repository on [Github](https://github.com), as a public repository. 
It is configured for continuous integration with [Travis-CI](https://travis-ci.org). 

### Install

Just clone it from *Github*:

    cd <local_git_repo>
    git clone https://github.com/atao60/j2x-on-openshift.git

### Run at home

To run it locally:

    cd <local_git_repo>/j2x-on-openshift
    mvn clean package ant:antrun -Pstandalone
    
Then with your favorite browser, go to http://locahost:8083    

### Run on Internet

As soon as a commit is pushed on the *Github* repository, Openshift will deploy it online:

    cd <local_git_repo>/j2x-on-openshift
    git commit -m "New commit"
    git push
    
To deploy it on your own remote site, you must adapt the configuration files for TravisCI and Openshift 
(or any other CI and PAAS platforms) with your parameters. 

Translation
---------

The project is i18n ready. Only French and English are currently available. If you wish to work with your own language, open a [feature request](https://github.com/atao60/j2x-on-openshift/issues) and provide the appropriate translation of this [file](https://github.com/atao60/j2x-on-openshift/blob/master/src/main/resources/i18n/converter_en.properties).  

       