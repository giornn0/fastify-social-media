const {userSchema, userSchemaPut} = require('../schema/user.schema')
const section = 'Usuarios'
const singular = 'Usuario'
    // {
    //     url:'/users',
    //     method:"POST",
    //     handler:postHandler
    // },
module.exports= async(fastify, options)=>{
    const collection =  fastify.mongo.db.collection('users')
    fastify.route(
         {
            url:'/users',
            preValidation: fastify.authenticate,
            method:"GET",
            handler:async (req,rep)=>{
                const user = await collection.find({})
                return user
            }
        }
    )
    fastify.route(  
        {
            url:'/users/:id',
            preValidation: [fastify.authenticate],
            method:"PUT",
            schema:{
                body:userSchemaPut
            },
            handler:async(req,rep)=>{
                if(req.user.id != req.params.id) return rep.code(403).send({message:`No posee permisos para editar este usuario!`})
                if(req.body.password){
                    const bcrypt = require('bcrypt')
                    const salt = await bcrypt.genSalt(10)
                    req.body.password = await bcrypt.hash(req.body.password,salt) 
                }
                const updUser = await collection.findByIdAndUpdate(req.params.id,req.body,{new:true})
                if(!updUser)return rep.code(404).send({message:`No se pudo actualizar el ${singular}`})
                return rep.code(202).send({updUser,message:`${section} ${updUser.name} ${updUser.name} ha sido actualizado correctamente!`})
            }
        }
    )
    fastify.route(
        {
            url:'/users/:id',
            preValidation: [fastify.authenticate],
            method:"GET",
            handler:async(req,rep)=>{
                const user = await collection.findByUd(req.params.id)
                return user
            }
        },
        )
    fastify.route(
        {
            url:'/users/:id',
            preValidation: [fastify.authenticate],
            method:"DELETE",
            handler:async(req,rep)=>{
                if(req.user.id != req.params.id) return rep.code(403).send({message:`No posee permisos para editar este usuario!`})
                await collection.findByIdAndDelete(req.params.id)
                return rep.code(204).send({message:`${singular} ha sido eliminado correctamente!`});
            }
        }
    )
}