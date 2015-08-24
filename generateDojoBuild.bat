echo 'Creating Build'
cd C:\dojo-release-1.4.3-src\dojo-release-1.4.3-src\util\buildscripts
build version=0.3 xdDojoPath=http://comendobemapp.appspot.com/scripts/dj/dojo localeList=pt action=release profileFile="C:/Documents and Settings/Administrator/gapp/ComendoBem/war/scripts/dj/cb.profile.js" removeDefaultNameSpaces=true
cd C:\dojo-release-1.4.3-src\dojo-release-1.4.3-src\release\dojo\com
xcopy /Y /E . "C:\Documents and Settings\Administrator\gapp\ComendoBem\war\scripts\dj\com"