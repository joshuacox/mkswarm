# mkSwarm
Make a docker swarm quickly

This was built while I followed along with the official [walkthrough](https://docs.docker.com/swarm/install-w-machine/ “Swarm Install with Machine”)

## Requirements
make
virtuabox
docker-machine

## Usage
To build a local swarm simply:
```
make build
```

try out the hello world:
```
make helloworld
```

show the environment variables necessary to login to the swarm
```
make env
```

show the environment variables necessary to login to the docker in a local VM
```
make localenv
```

then when you are finished:
```
make clean
```
## Benchmark it!
care to see how fast your machine is at doing these tasks?
```
make benchmark
```

My laptop just pulled a 4:09, feel free to post to this [issue](https://github.com/joshuacox/mkswarm/issues/1 “boasting issue”) boasting your amazing times and what storage medium your were using etc
```
Elapsed (wall clock) time (h:mm:ss or m:ss): 4:09.64
```

