count=1

base_url="http://www.karuta.org/images/fuda_original"

while [ 1 ] ;
do
    fn=$(printf "%03d" $count).png
    url=$base_url/$fn

    curl $url > $fn

    if [ $count -ge 100 ]; then
	break
    fi
    let count=$count+1
done
