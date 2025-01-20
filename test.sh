!#/bin/bash
latestTag=deploy__DEV__V1.0.0
version_check=`echo $latestTag | cut -f2 -d"-"`
echo "version_check : $version_check"
if [[ $version_check == $latestTag ]];
then
	version=0
else
	version=`echo $latestTag | cut -f2 -d"-"`
fi
echo "version: $version"
newTagVersion=`expr $version + 1`
echo "newTag: deploy__DEV__V1.0.0-$newTagVersion"
