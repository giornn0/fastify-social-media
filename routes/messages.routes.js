module.exports= async(fastify, options)=>{
    fastify.route({
        method: 'GET',
        url: '/',
        handler: (req, reply) => {
          return ({ hello: 'world' })
        },
        wsHandler: (conn, req) => {
            conn.setEncoding('utf8')
            conn.socket.on('message',async (message)=>{
                fastify.websocketServer.clients.forEach(function each(client){
                    if(client===conn.socket) client.send(message.toString()+'-')
                    else client.send('-'+message.toString())
                })
            })
            conn.socket.send('Hello User, conection established!')
        }
    })    
}