$REGISTRY="<replace with your Docker Hub registry name>"

# build the image

docker build --rm -t backend-api:1.0 .

# tag the image

docker tag backend-api:1.0 $REGISTRY/backend-api:1.0

# login to Docker Hub

docker login

# push the image to Docker Hub

docker push $REGISTRY/backend-api:1.0