
const plugin = require('fastify-plugin')
const http = require('http')

function handle (conn, req) {
    conn.pipe(conn) // creates an echo server
  }

//   const wsServer = new WebSocket.Server()

module.exports = plugin(async(fastify,options)=>{
    fastify.register(require('fastify-websocket'),{
        handle,
        options:{
            clientTracking:true,
        }
    })
})