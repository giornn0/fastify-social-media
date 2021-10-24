const mongod = require('mongoose')

const messageSchema = new mongod.Schema(
    {
        from_user_id:{
            type:String,
            required:true
        },
        to_user_id:{
            type:String,
            required:true
        },
        content:{
            type:String,
            required:true
        },
        saw_confirmation:{
            type:Boolean,
            default:false
        },
        send_timestamp:{
            type:Date,
            default:new Date
        },
        saw_timestamp:{
            type:Date,
        }
    }
)
const message = mongod.model("Messages",messageSchema)
async function runSchema(){
    const test = await new message({from_user_id:'asd',to_user_id:'asd',content:'qwee'}).save()
    await message.findByIdAndDelete(test['_id'])
}
module.exports =runSchema()