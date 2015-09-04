A Java to Xtend converter online 
==========

Rational
-------

The aim of this project is to make available online a Java to Xtend converter. 

It uses:

- [OpenShift Online](https://www.openshift.com/products/online): this PAAS platform provides a free plan which is enough to set up an online service,
- the Java-to-Xtend converter provided by [Xtend](https://eclipse.org/xtend/) since its version 2.8. In fact it uses the project [java2xtend](https://github.com/atao60/java2xtend.git) to hide all the details.

Licenses & credits
------

Licensed under [Eclipse Public License](http://www.eclipse.org/legal/epl-v10.html).

A first attempt to provide an online converter was made by [Krzysztof Rzymkowski project](https://github.com/rzymek/java2xtend.webapp). This [service](http://www.j2x.cloudbees.net/) is not currently available.

Requirements
-----

This project uses the version 2.9.0.beta3 of *Xtend*.

It requires:

- JDK 1.8
- [Maven](https://maven.apache.org/) 3.3.1 or above

If working under *Eclipse*:

- [Xtend SDK](https://eclipse.org/xtend/download.html) 
- [M2Eclipse](http://eclipse.org/m2e/).

Install
-----

This project is store in two git repositories:

- the *OpenShift* one: it's mandatory as it's the mean used by *OpenShift* to deploy any application on its platform. But it's a private repository.
- this source code repository on [Github](https://github.com), as a public repository. It is configured for continuous integration with [Travis-CI](https://travis-ci.org). 

Build & deploy
------

You can clone it on your workstation and use it as a standalone application.
To deploy it on your own remote site, you must replace all the current TravisCI/Openshift configuration by your owns. 

### Standalone

    cd <git_repo>/j2x-on-openshift
    mvn ant:antrun -Pstandalone

### Openshift

The local repository is synchronized with the git repositories. A single command is enough to update both of them:  

    cd <git_repo>/j2x-on-openshift
    git commit -m "New commit"
    git push
    
    

       