#!/bin/sh

mkdir "$XDG_CONFIG_HOME/pg" && mkdir "$XDG_CACHE_HOME/pg
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      https://maven.apache.org/xsd/settings-1.0.0.xsd">
  ...
  <localRepository>${env.XDG_CACHE_HOME}/maven/repository</localRepository>
  ...
</settings>
