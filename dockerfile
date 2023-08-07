FROM haskell:7.8 

COPY . .

docker run -it -v /Users/olga/Documents/github/haskell:/root/ --rm haskell:7.8 

docker run -it -v /Users/olga/Documents/github/haskell:/root/ alanz/haskell-ghc-7.8-64

https://hub.docker.com/r/alanz/haskell-ghc-7.8-64/dockerfile
