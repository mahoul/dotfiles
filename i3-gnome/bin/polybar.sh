#!/bin/bash

pgrep -f "polybar example"  | xargs kill -9

polybar example

