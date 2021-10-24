module.exports = async(fastify,options)=>{
    const collection =  fastify.mongo.db.collection('messages')
    fastify.route({
        url:'/hello',
        method:'GET',
        schema:{
            response:{
                200:{
                    data:{
                        type:'object',
                        // properties:{

                        // }
                    }
                }
            }
        },
        handler:async (req,rep)=>{
            const messages = await collection.find()
            // fastify.log.info(message, messages)
            return {data:messages}
        }
    })
}