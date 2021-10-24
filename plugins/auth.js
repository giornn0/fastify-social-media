
const plugin = require('fastify-plugin')

module.exports = plugin(async function(fastify,options){
    fastify.decorate("authenticate",async function(req,rep){
        const token = req.headers.authorization&&req.headers.authorization.split(' ').length?req.headers.authorization.split(' ')[1] : null
        if(!token) rep.code(401).send({message:`Token inexistente!`})
        const peat = fastify.mongo.db.collection('personalaccesstokens')
        const access = await peat.findOne({tokenR:token})
        try {
            fastify.jwt.verify(token)
            if(access.tokenR != token){
                return rep.code(401).send({message:`Sesion iniciada en otro dispositivo, inicie sesion nuevamente!`})
            }
            req.user = fastify.jwt.decode(token)
            return
        } catch (error) {
            console.log(error)
            // peat.deleteMany({tokenR:token})
            if(!access){
                return rep.code(403).send({message:`Token invalido, favor iniciar nuevamente la sesion!`});
            }
            try {
                fastify.jwt.verify(access.tokenA)
                return rep.code(419).send({message:`Posibilidad de revalidar Credenciales!`})
                
            } catch (errr) {
                console.log(errr)
                return rep.code(401).send({message:`Credenciales vencidas, favor de iniciar sesion nuevamente!`})
                
            }
        }
    })
})