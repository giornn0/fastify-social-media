
const bcrypt = require('bcrypt')
const { userSchema } = require('../schema/user.schema');

if(!process.env.PRODUCTION){
    dotenv = require('dotenv');
    dotenv.config()
}
module.exports= async(fastify,options)=>{
    const collection = fastify.mongo.db.collection('users')
    const personalAccessTokens = fastify.mongo.db.collection('personalaccesstokens')

    fastify.route({
        url:'/login',
        method:'POST',
        handler:  async(req,rep)=>{
            let searcher = {}
            const loginWith =  req.body.user.includes('@')?'email':'username'
            searcher[loginWith] = req.body.user
            const user = await collection.findOne(searcher)
            if(!user)return rep.code(404).send({message:`Usuario no encontrado`})
            const validPassword = await bcrypt.compare(req.body.password, user.password)
            if(!validPassword) return rep.code(400).send({message:`Contraseña errónea!`})
            const token =  fastify.jwt.sign({id:user['_id']},{expiresIn:'4h'})
            const token_use =  fastify.jwt.sign({id:user['_id'],admin:user.isAdmin},{expiresIn:'1h'})
            await personalAccessTokens.deleteMany({tokenable_id:user['_id']});
            await personalAccessTokens.insertOne({
                tokenable_id:user['_id'],
                tokenA:token,
                tokenR:token_use,
            })
            return {aut:token,ref:token_use,message:`Bienvenido ${user.name} ${user.last_name}!`}
        }
    })
    
    fastify.route({
        url:'/register',
        schema :{
            body:userSchema
        },
        method:'POST',
        handler:async(req,rep)=>{
            const salt = await bcrypt.genSalt(10)
            req.body.password = await bcrypt.hash(req.body.password,salt)
            const newUser = await collection.insertOne(req.body)
            // await collection.findByIdAndDelete(newUser['_id'])
            return rep.code(201).send({newUser,message:`Bienvenido ${req.body.name} ${req.body.last_name} !`})
        }
    })

    fastify.route({
        url:'/login',
        method:'DELETE',
        handler:async (req,rep)=>{
            const token = req.headers.authorization && req.headers.authorization.split(' ')[1]?req.headers.authorization.split(' ')[1] : null
            if(!token) rep.code(401).send({message:`Token inexistente, imposible borrar la sesión!`})
            await personalAccessTokens.deleteMany({tokenR:token})
            return rep.code(200).send({message:`Hasta pronto!`})
        }
    })
}