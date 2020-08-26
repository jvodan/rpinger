#!/bin/sh

if ! test -f conf/config.yaml
 then
  cp config.yaml conf
fi

exec thin -p 8181 start 

