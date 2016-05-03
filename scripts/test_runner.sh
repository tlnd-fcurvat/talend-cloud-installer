#!/usr/bin/env bash
CHANGED=$(git diff --name-status origin/master.. | tr -d "A\t" | grep "^modules/" | cut -d"/" -f2 | uniq)
RAKE=`which rake`
BUNDLER=`which bundle`
UPSTREAM_EXCLUDES='datacat ssh archive jenkins cassandra'

test_module() {
	cd  $1
	echo "INFO: Testing $1"
	$BUNDLER exec rake lint syntax spec 
	if [ $? != 0 ]; then
		exit 1
	fi
	cd ../..
}

run_bundler() {
  BUNDLER=$(which bundle)
  if [ -n $BUNDLER ]; then
    $BUNDLER install --path=vendor/bundle
  else
	echo 'ERROR: bundler gem not installed'
	exit 1
  fi
}

if [ -d "./site" ]; then
	MODULE_HOME="./site"
	run_bundler
else
	exit 1
fi

for i in `find site -maxdepth 1 -mindepth 1 -type d`;
do
	if [[ $UPSTREAM_EXCLUDES =~ ${i#*/} ]]
	then
		echo "INFO: Exclude upstream $i"
	else
		test_module $i
	fi
done


