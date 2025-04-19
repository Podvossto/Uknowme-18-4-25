#!/bin/bash
mongorestore --db Uknowmedatabase --collection courses /data/db/courses.bson
mongorestore --db Uknowmedatabase --collection PrivateKeyAdmin /data/db/PrivateKeyAdmin.bson
mongorestore --db Uknowmedatabase --collection users /data/db/users.bson
mongorestore --db Uknowmedatabase --collection admins /data/db/admins.bson
