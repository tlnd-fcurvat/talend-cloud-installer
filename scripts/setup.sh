#!/bin/bash
if which bundle > /dev/null
then
    BUNDLER=`which bundle`
fi

if which r10k > /dev/null
then
    R10K=`which r10k`
fi

if which puppet > /dev/null
then
    PUPPET=`which puppet`
fi


if [ -n $BUNDLER ]
then
	$BUNDLER install --path=vendor/bundler > /dev/null
else
	echo 'Error bundler gem not installed'
	exit 1
fi

if [ -n $R10K ]
then
	$R10K puppetfile install  > /dev/null
else
	echo 'Error r10k gem  not installed'
	exit 1
fi

if [ -n $PUPPET ]
then
	$PUPPET apply --verbose \
		--noop \
		--modulepath=site:modules \
		--hiera_config=hiera.yaml manifests/site.pp  > /dev/null
else
	echo 'Error puppet not installed'
	exit 1
fi
