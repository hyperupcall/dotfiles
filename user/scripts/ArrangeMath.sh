#!/usr/bin/env bash

# Monitor Setup

# Alfa    Bravo   Charlie
# Delta   Echo    Foxtrot

deltaStartX=0
deltaStartY=1080

bravoStartX=1920
bravoStartY=0

echoStartX=1920
echoStartY=1080

windowWidth=1920
windowHeight=1080

wmctrl -r :ACTIVE: -e 0,$((echoStartX + windowWidth / 2)),$echoStartY,$((windowWidth / 2)),$((windowHeight))
