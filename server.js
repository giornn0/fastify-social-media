//Libraries needed for creating multiple server instances 
const cluster = require('cluster')
const {cpus} = require('os')
//Instance of Fastify
const fastify =  require('fastify')(
    {logger:   
         {
        prettyPrint:true
        }
    }
)

// fastify.register(require('fastify-cors'),{

// })

//Functional plugins
// fastify.register(require('./plugins/connection'));
// fastify.register(require('./plugins/jwt-plugin'));
// //Authentication plugin
// fastify.register(require('./plugins/auth'));
//Router
fastify.register(require('./routes/router'));
//WS   
fastify.register(require('./plugins/web-socket'))


//Serving up function!
const start = async()=>{    
    await fastify.listen(process.env.PORT || 5000,'localhost',(err,address)=>{
        if(err){
            fastify.log.error(err)
            process.exit(1)
        }
    })
}
//Create multiple instances of the API Server
//One for each cpu available in the system or put a number
// const numCPUs = cpus().length;

// if(cluster.isPrimary){
//     for(let i = 0; i<; i++){
//         cluster.fork()
//   }
//   cluster.on('exit',(worker,code,signal)=>{
    // fastify.info.log(`Worker ${worker.process.pid} died`)
// })
// }else{
    start().catch(err=>{fastify.log.error(err);process.exit(1)})
// }