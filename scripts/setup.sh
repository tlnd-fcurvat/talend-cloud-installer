#!/bin/bash

BUNDLER=`which bundle`

if [ -n $BUNDLER ]; then
	$BUNDLER install --path=vendor/bundler --without=development
else
  echo "ERROR: No Bundler installed "
  exit 1
fi

bundle exec r10k puppetfile install


bundle exec puppet apply --verbose \
		--noop \
		--modulepath=site:modules \
		--hiera_config=hiera.yaml manifests/site.pp

