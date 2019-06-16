#!/bin/bash
autopep8 -ri python
pytest 
pytype ./
