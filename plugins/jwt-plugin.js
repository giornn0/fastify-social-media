const plugin = require('fastify-plugin')

if(!process.env.PRODUCTION){
    dotenv = require('dotenv');
    dotenv.config()
}

module.exports= plugin(async function(fastify,option){
    fastify.register(require('fastify-jwt'),{secret: process.env.JWT_REF})
})