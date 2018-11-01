#export PORT=$1
#export BASE_URL=$2
if [[ -z $PORT ]]; then
	echo "PORT does not exist, it will be set PORT=3333"
	export PORT="3333"
else 
	echo "PORT does value = $PORT"
fi

if [[ -z $BASE_URL ]]; then
	echo "BASE_URL does not exist"
	export BASE_URL=""
else 
	echo "BASE_URL does value = $BASE_URL"
fi

echo docker run -p $PORT:$PORT --rm -e PORT=${PORT} -e BASE_URL=${BASE_URL} node-web-app
docker run -p $PORT:$PORT --rm -e PORT=${PORT} -e BASE_URL=${BASE_URL} nselem/node-web-app
