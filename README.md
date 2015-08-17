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

Licenced under [Eclipse Public License](http://www.eclipse.org/legal/epl-v10.html).

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

Build & deploy
------

This project is store in two git repositories:

- the *OpenShift* one: it's mandatory as it's the mean used by *OpenShift* to deploy any application on its platform.
- this source code repository on [Github](https://github.com) as a public one since the *OpenShift* repository is private.

The local repository is synchronized with both the git repositories. A single command is enough to update them:  

    cd <local workspace path>j2x-on-openshift
    git commit -m "New commit"
    git push

       