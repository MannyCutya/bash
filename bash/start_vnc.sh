#!/bin/bash

x11vnc -display :0 -usepw -auth guess -rfbport 5900 -forever -shared -bg
