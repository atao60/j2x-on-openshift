#!/bin/bash
sed -i -e '\|<id>standard-with-extra-repos</id>|,\|</repositories>| {\|</repositories>| i\
                <repository>\
                    <id>atao60-snapshot-repo</id>\
                    <name>atao60'\''s snapshot Maven repository on Github</name>\
                    <releases>\
                        <enabled>false</enabled>\
                        <updatePolicy>always</updatePolicy>\
                        <checksumPolicy>warn</checksumPolicy>\
                    </releases>\
                    <snapshots>\
                        <enabled>true</enabled>\
                        <updatePolicy>never</updatePolicy>\
                        <checksumPolicy>fail</checksumPolicy>\
                    </snapshots>\
                    <url>https://github.com/atao60/snapshots/raw/master/</url>\
                </repository>
' -e '}' settings.xml
