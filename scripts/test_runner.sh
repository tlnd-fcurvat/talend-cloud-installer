CHANGED=$(git diff --name-status origin/development.. | tr -d "A\t" | grep "^modules/" | cut -d"/" -f2 | uniq)
RAKE=`which rake`
BUNDLER=`which bundle`
UPSTREAM_EXCLUDES='datacat ssh archive jenkins cassandra'

test_module() {
	cd  $1
	echo "INFO: testing $1"
	$RAKE syntax spec 
	if [ $? != 0 ]; then
		exit 1
	fi
	cd ../..
}

if [ -d "./site" ]; then
	MODULE_HOME="./site"
else
	exit 1
fi
for i in `find site -maxdepth 1 -mindepth 1 -type d`;
do
	if [[ $UPSTREAM_EXCLUDES =~ ${i#*/} ]]
	then
		echo "Skip upstream $i"
	else
		test_module $i
	fi
done


