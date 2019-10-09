# vs-maintenance-leads

change directories in the docker run statement to suit
```bash
git clone https://github.com/ndxbxrme/vs-maintenance-leads.git
cd vs-maintenance-leads
mkdir data
export ENCRYPTION_KEY=[encryption key]
docker build --build-arg KEY=$ENCRYPTION_KEY -t maintenance-leads -f DockerfileDev .
docker run -v /c/Users/lewis/DEV/vs-maintenance-leads/src:/src -v /c/Users/lewis/DEV/vs-maintenance-leads/data:/data -p 4014:4014 -p 4015:4015 --name maintenance-leads maintenance-leads
```
ctrl-C to exit, the server will keep running  
to stop it run `docker stop maintenance-leads`  
if you add an npm or bower package, stop the container, run `docker rm maintenance-leads` then rebuild  