#!/bin/bash
autopep8 -ri pdsl 
pytest 
pytype ./
