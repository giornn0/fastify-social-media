const plugin = require('fastify-plugin')

if(!process.env.PRODUCTION){
    dotenv = require('dotenv');
    dotenv.config()
}

async function dbConnector (fastify,options){
        fastify.register(require('fastify-mongodb'), {
            forceClose: true,
            url:process.env.MONGO_URL
        })
}

module.exports = plugin(dbConnector);