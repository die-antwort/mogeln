server = require("restify").createServer()

server.get "/api", (req, res, next) ->
  res.send "Hello, API!"
  next()
  
  
server.listen 1337, ->
  console.log "Mogeln API-Server is listening on port 1337"