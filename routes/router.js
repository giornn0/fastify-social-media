
module.exports= async (fastify, options)=>{
    // fastify.addHook('preHandler',(req,rep,done)=>{require('../functions/authenticated')(req,rep,done)})

    // //Routes for login/logout
    // fastify.register(require('./auth.routes'))
    // //Routes of teh project
    // fastify.register(require('./users.routes'))
    // fastify.register(require('./messages.routes'))
    //Testing Routes
    fastify.register(require('./testing.routes'))

    fastify.after(err=>{
        if(err) fastify.log.info(err)
    })

    fastify.ready();
}