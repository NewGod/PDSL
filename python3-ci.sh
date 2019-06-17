#!/bin/bash
autopep8 -ri ./
pytest 
pytype ./
