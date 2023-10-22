# !/bin/bash
docker run -d --rm -p 27017:27017 -m 1024mb --cpus=1 --name mongo1 --network mongoCluster mongo mongod --replSet rs0 --bind_ip localhost,mongo1
sleep 1
docker run -d --rm -p 27018:27017 -m 1024mb --cpus=1 --name mongo2 --network mongoCluster mongo mongod --replSet rs0 --bind_ip localhost,mongo2
docker run -d --rm -p 27019:27017 -m 1024mb --cpus=1 --name mongo3 --network mongoCluster mongo mongod --replSet rs0 --bind_ip localhost,mongo3
sleep 5
docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: "rs0",
 members: [
   {_id: 0, host: "mongo1", priority: 2},
   {_id: 1, host: "mongo2", priority: 1},
   {_id: 2, host: "mongo3", priority: 1}
 ]
})"
